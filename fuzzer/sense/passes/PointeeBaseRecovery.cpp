//===- PointeeBaseRecovery.cpp - Recover pointer bases via MemorySSA -----===//
//
// Implementation of PointeeBaseRecoverer for tracing pointer values through
// memory using MemorySSA and alias analysis.
//
//===----------------------------------------------------------------------===//

#include "PointeeBaseRecovery.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

void PointeeBaseRecoverer::recoverBases(Value *V, Instruction *Ctx,
                                        SmallPtrSetImpl<const Value *> &Out) {
  VisitedVals.clear();
  VisitedMemAcc.clear();
  recoverBasesImpl(V, Ctx, Out, /*Depth=*/0);
}

void PointeeBaseRecoverer::recoverBasesImpl(Value *V, Instruction *Ctx,
                                            SmallPtrSetImpl<const Value *> &Out,
                                            unsigned Depth) {
  if (Config.VerboseDebug) {
    errs() << "[DEBUG] recoverBasesImpl depth=" << Depth << " value: ";
    if (V)
      V->print(errs());
    else
      errs() << "<null>";
    errs() << "\n";
  }

  if (!V || !V->getType()->isPointerTy())
    return;
  if (Depth > Config.MaxDepth)
    return;

  // Avoid infinite recursion through cycles.
  if (!VisitedVals.insert(V).second)
    return;

  // Peel off trivial wrappers first (casts, GEP).
  V = const_cast<Value *>(V->stripPointerCasts());
  if (auto *GEP = dyn_cast<GetElementPtrInst>(V)) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> GEP, following pointer operand\n";
    recoverBasesImpl(GEP->getPointerOperand(), Ctx, Out, Depth + 1);
    return;
  }
  if (auto *ASC = dyn_cast<AddrSpaceCastInst>(V)) {
    recoverBasesImpl(ASC->getOperand(0), Ctx, Out, Depth + 1);
    return;
  }

  // Split control merges.
  if (auto *PN = dyn_cast<PHINode>(V)) {
    for (unsigned i = 0; i < PN->getNumIncomingValues(); ++i)
      recoverBasesImpl(PN->getIncomingValue(i), Ctx, Out, Depth + 1);
    return;
  }
  if (auto *Sel = dyn_cast<SelectInst>(V)) {
    recoverBasesImpl(Sel->getTrueValue(), Ctx, Out, Depth + 1);
    recoverBasesImpl(Sel->getFalseValue(), Ctx, Out, Depth + 1);
    return;
  }

  // If the pointer value comes from memory: %p = load ptr, ptr %addr
  // We want to chase the reaching store(s) that define that loaded value.
  if (auto *LI = dyn_cast<LoadInst>(V)) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> LoadInst, entering MemorySSA recovery\n";
    recoverFromLoad(*LI, Ctx, Out, Depth + 1);
    return;
  }

  // If this is already some "base-ish" producer, record it.
  if (isa<AllocaInst>(V) || isa<GlobalValue>(V) || isa<Argument>(V) ||
      isa<CallBase>(V)) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> Found base object: " << *V << "\n";
    Out.insert(V);
    return;
  }

  // Fallback for SSA pointer expressions we didn't explicitly model:
  // ask LLVM's local base-object helper (phi/select already handled above).
  SmallVector<const Value *, 8> Objects;
  getUnderlyingObjects(V, Objects, /*LI=*/nullptr, /*MaxLookup=*/6);
  for (const Value *Obj : Objects)
    Out.insert(Obj);
}

void PointeeBaseRecoverer::recoverFromLoad(LoadInst &LI, Instruction *Ctx,
                                           SmallPtrSetImpl<const Value *> &Out,
                                           unsigned Depth) {
  if (Depth > Config.MaxDepth)
    return;

  if (Config.VerboseDebug) {
    errs() << "[DEBUG] recoverFromLoad: " << LI << "\n";
  }

  MemoryAccess *MA = MSSA.getMemoryAccess(&LI);
  auto *Use = dyn_cast_or_null<MemoryUse>(MA);
  if (!Use) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   No MemoryUse found, stopping at load\n";
    // Can't reason via MemorySSA; stop at the load as an unknown root.
    Out.insert(&LI);
    return;
  }

  // Use getOptimized() instead of getDefiningAccess() to get the
  // alias-analysis-optimized definition (skips NoAlias stores automatically)
  MemoryAccess *DefAcc =
      Use->getOptimized() ? Use->getOptimized() : Use->getDefiningAccess();
  if (Config.VerboseDebug) {
    errs() << "[DEBUG]   MemoryUse found, use: ";
    Use->print(errs());
    errs() << "   defining access: ";
    DefAcc->print(errs());
    errs() << "\n";
  }

  // Pass the LoadInst to recoverFromMemoryDef so it can check aliasing
  recoverFromMemoryDef(DefAcc, &LI, Ctx, Out, Depth + 1,
                       /*FanoutBudget=*/Config.MaxMemPhiFanout);
}

void PointeeBaseRecoverer::recoverFromMemoryDef(
    MemoryAccess *Acc, LoadInst *OrigLoad, Instruction *Ctx,
    SmallPtrSetImpl<const Value *> &Out, unsigned Depth,
    unsigned FanoutBudget) {
  if (!Acc || Depth > Config.MaxDepth)
    return;

  if (Config.VerboseDebug) {
    errs() << "[DEBUG] recoverFromMemoryDef depth=" << Depth << ": ";
    Acc->print(errs());
    errs() << "\n";
  }

  if (!VisitedMemAcc.insert(Acc).second)
    return;

  if (MSSA.isLiveOnEntryDef(Acc)) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> LiveOnEntry, stopping\n";
    // Value is unknown/external at function entry.
    // For loads, trace the address being loaded from (could be global).
    if (OrigLoad) {
      Value *LoadAddr = OrigLoad->getPointerOperand();
      if (Config.VerboseDebug) {
        errs() << "[DEBUG]      -> Tracing load address: ";
        LoadAddr->print(errs());
        errs() << "\n";
      }
      recoverBasesImpl(LoadAddr, Ctx, Out, Depth + 1);
      return;
    }
    // Otherwise (should never happen in practice), treat as unknown.
    // We cannot insert the MemoryAccess since Out expects Value*.
    if (Config.VerboseDebug)
      errs() << "[DEBUG]      -> Warning: LiveOnEntry without OrigLoad\n";
    return;
  }

  if (auto *Phi = dyn_cast<MemoryPhi>(Acc)) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> MemoryPhi, exploring incomings\n";
    unsigned N = Phi->getNumIncomingValues();
    unsigned Limit = (FanoutBudget == 0) ? N : std::min(N, FanoutBudget);
    for (unsigned i = 0; i < Limit; ++i) {
      recoverFromMemoryDef(Phi->getIncomingValue(i), OrigLoad, Ctx, Out,
                           Depth + 1,
                           (FanoutBudget == 0) ? 0 : (FanoutBudget - 1));
    }
    return;
  }

  auto *Def = dyn_cast<MemoryDef>(Acc);
  if (!Def) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> Not a MemoryDef, stopping\n";
    Out.insert(Acc);
    return;
  }

  Instruction *MemI = Def->getMemoryInst();
  if (!MemI) {
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> No memory instruction, stopping\n";
    Out.insert(Acc);
    return;
  }

  if (Config.VerboseDebug) {
    errs() << "[DEBUG]   -> MemoryDef instruction: " << *MemI << "\n";
  }

  // Strong case: defining store writes the pointer value we want.
  if (auto *SI = dyn_cast<StoreInst>(MemI)) {
    Value *Stored = SI->getValueOperand();
    if (Config.VerboseDebug) {
      errs() << "[DEBUG]   -> StoreInst, stored value type: ";
      Stored->getType()->print(errs());
      errs() << "\n";
    }

    // Check if this store actually writes to the location we're loading from
    if (OrigLoad) {
      auto AR =
          AA.alias(MemoryLocation::get(SI), MemoryLocation::get(OrigLoad));
      if (Config.VerboseDebug) {
        errs() << "[DEBUG]      Alias result: ";
        switch (AR) {
        case AliasResult::NoAlias:
          errs() << "NoAlias";
          break;
        case AliasResult::MayAlias:
          errs() << "MayAlias";
          break;
        case AliasResult::PartialAlias:
          errs() << "PartialAlias";
          break;
        case AliasResult::MustAlias:
          errs() << "MustAlias";
          break;
        }
        errs() << "\n";
      }

      // If they definitely don't alias, this store doesn't define our load
      // Continue searching by walking up the MemorySSA chain
      if (AR == AliasResult::NoAlias) {
        if (Config.VerboseDebug)
          errs() << "[DEBUG]      -> NoAlias, skipping this store and "
                    "continuing up chain\n";
        // Walk up to the previous definition
        recoverFromMemoryDef(Def->getDefiningAccess(), OrigLoad, Ctx, Out,
                             Depth + 1, FanoutBudget);
        return;
      }
    }

    if (Stored->getType()->isPointerTy()) {
      if (Config.VerboseDebug)
        errs() << "[DEBUG]   -> Stored value is pointer, following it\n";
      recoverBasesImpl(Stored, Ctx, Out, Depth + 1);
      return;
    }
    // Stored a non-pointer into a pointer-typed load? Unusual/UB; stop.
    if (Config.VerboseDebug)
      errs() << "[DEBUG]   -> WARNING: Non-pointer store, adding StoreInst "
                "as base (likely wrong!)\n";
    Out.insert(SI);
    return;
  }

  // If definition is a call that may write the slot (memcpy, etc),
  // we don't attempt to model it here.
  if (Config.VerboseDebug)
    errs() << "[DEBUG]   -> Unknown memory-modifying instruction, stopping\n";
  Out.insert(MemI);
}
