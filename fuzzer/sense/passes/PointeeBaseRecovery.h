//===- PointeeBaseRecovery.h - Recover pointer base objects via MemorySSA ===//
//
// LLVM 20 utility: Advanced pointer base recovery using MemorySSA
//
// PURPOSE:
//  Provides a reusable PointeeBaseRecoverer class that traces pointer values
//  back to their ultimate base objects, crossing load/store boundaries that
//  getUnderlyingObjects() cannot handle.
//
// KEY FEATURES:
//  - Uses MemorySSA with optimized alias analysis for precise tracking
//  - Handles loads from memory (traces through stores)
//  - Splits phi/select nodes
//  - Configurable recursion depth and MemoryPhi fanout limits
//  - Optional verbose debugging
//
// USAGE:
//  ```cpp
//  auto &AA = FAM.getResult<AAManager>(F);
//  auto &MSSA = FAM.getResult<MemorySSAAnalysis>(F).getMSSA();
//  MSSA.ensureOptimizedUses();  // Enable AA-optimized MemorySSA
//
//  PointeeBaseRecoverer Recoverer(F, AA, MSSA);
//  SmallPtrSet<const Value *, 16> Bases;
//  Recoverer.recoverBases(PointerValue, CtxInstruction, Bases);
//  ```
//
// COMPARISON TO getUnderlyingObjects():
//  - getUnderlyingObjects() stops at LoadInst
//  - PointeeBaseRecoverer traces through loads via MemorySSA
//  - Example: For `%p = load ptr, ptr %var`, getUnderlyingObjects returns
//    {%p}, but PointeeBaseRecoverer finds the actual stored value
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_POINTEE_BASE_RECOVERY_H
#define LLVM_POINTEE_BASE_RECOVERY_H

#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"

namespace llvm {

/// Configuration for PointeeBaseRecoverer behavior
struct PointeeRecoveryConfig {
  /// Maximum recursion depth when chasing through memory/phi/select
  unsigned MaxDepth = 16;

  /// Cap on number of MemoryPhi incomings to explore (0 = unlimited)
  unsigned MaxMemPhiFanout = 64;

  /// Enable verbose debug output for debugging recovery process
  bool VerboseDebug = false;

  PointeeRecoveryConfig() = default;

  PointeeRecoveryConfig(unsigned MaxDepth, unsigned MaxMemPhiFanout,
                        bool VerboseDebug = false)
      : MaxDepth(MaxDepth), MaxMemPhiFanout(MaxMemPhiFanout),
        VerboseDebug(VerboseDebug) {}
};

/// Recovers "base objects" a pointer value may ultimately derive from,
/// crossing load/store boundaries using MemorySSA.
///
/// This is NOT a full points-to analysis. It's a pragmatic recovery that:
///   - Strips casts/GEP
///   - Splits phi/select nodes
///   - Traces loads through MemorySSA to find defining stores
///   - Uses alias analysis to filter out unrelated memory operations
///   - Falls back to getUnderlyingObjects for SSA pointer expressions
///
/// LIMITATIONS:
///  - Not a full points-to analysis (doesn't model all memory effects)
///  - Fanout limits on MemoryPhi exploration (configurable)
///  - Treats external calls as opaque memory writers
///  - Requires MemorySSA and AAResults to be available
class PointeeBaseRecoverer {
public:
  PointeeBaseRecoverer(Function &F, AAResults &AA, MemorySSA &MSSA,
                       const PointeeRecoveryConfig &Config = {})
      : F(F), AA(AA), MSSA(MSSA), Config(Config) {}

  /// Recover base objects for a pointer-typed Value V at instruction Ctx.
  ///
  /// \param V The pointer value to trace back to its bases
  /// \param Ctx The instruction context (for MemorySSA queries)
  /// \param Out Output set to populate with recovered base objects
  ///
  /// Note: Clears internal visited sets before recovery.
  void recoverBases(Value *V, Instruction *Ctx,
                    SmallPtrSetImpl<const Value *> &Out);

private:
  Function &F;
  AAResults &AA;
  MemorySSA &MSSA;
  PointeeRecoveryConfig Config;

  SmallPtrSet<const Value *, 32> VisitedVals;
  SmallPtrSet<const MemoryAccess *, 32> VisitedMemAcc;

  void recoverBasesImpl(Value *V, Instruction *Ctx,
                        SmallPtrSetImpl<const Value *> &Out, unsigned Depth);

  void recoverFromLoad(LoadInst &LI, Instruction *Ctx,
                       SmallPtrSetImpl<const Value *> &Out, unsigned Depth);

  void recoverFromMemoryDef(MemoryAccess *Acc, LoadInst *OrigLoad,
                            Instruction *Ctx,
                            SmallPtrSetImpl<const Value *> &Out, unsigned Depth,
                            unsigned FanoutBudget);
};

} // namespace llvm

#endif // LLVM_POINTEE_BASE_RECOVERY_H
