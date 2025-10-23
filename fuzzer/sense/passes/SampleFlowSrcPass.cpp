/**
 *===----------------------------------------------------------------------===//
 * SampleFlowSrcPass: Insert Sampling Call After First Taint Definition
 *===----------------------------------------------------------------------===//
 *
 *  Overview:
 *  ----------
 *  This pass instruments taint sources by inserting sampling calls immediately
 *  after the first taint definition. It supports two modes of operation:
 *
 *  1. **Variable Name Mode** (recommended): Uses DILocalVariable debug info
 *     to identify the target variable by name.
 *  2. **Line:Column Mode** (fallback): Uses source location spans from static
 *     analysis reports (e.g., CodeQL).
 *
 *  The pass supports multiple data types:
 *    • Scalar integers (i32) → sample_int(i32) returns i32
 *    • Scalar floats (double) → sample_double(double) returns double
 *    • Arrays/buffers → sample_bytes(ptr, i32) overwrites in-place
 *
 *  Workflow:
 *  ---------
 *  1. **Locate the variable**:
 *     - Variable name mode: Search for DILocalVariable matching the name
 *     - Line:col mode: Find instruction at the specified source location
 *
 *  2. **Identify the base allocation**: Map the variable to its alloca using
 *     debug metadata (DbgVariableRecord) or getUnderlyingObjects().
 *
 *  3. **Find the taint source**: Locate the instruction that first writes to
 *     the variable on the target line:
 *     - For buffers: CallBase with variable as argument (e.g., fgets)
 *     - For scalars: StoreInst that writes to the variable
 *
 *  4. **Build statement slice**: Collect all instructions on the same source
 *     line and lexical scope to identify the complete statement.
 *
 *  5. **Insert sampling instrumentation**:
 *     - For scalars: Load → Sample → Store (replaces value in-place)
 *     - For buffers: sample_bytes(ptr, size) after the taint source
 *
 *  Usage:
 *  ------
 *      opt -load-pass-plugin ./libSampleFlowSrcPass.so \
 *          -passes=sample-flow-src-pass \
 *          -sample-line=7 -sample-col-start=9 -sample-col-end=12 \
 *          flow_simple.ll -S -o flow_simple_sampled.ll
 *
 *  Notes:
 *  ------
 *    • The pass requires debug info (`-g`) to be present in the IR.
 *    • The sampling function `@sample_bytes(ptr, i32)` is declared if not
 *      already available.
 *    • The safe insertion point is determined conservatively:
 *         – last store or call that may modify the base object.
 *         – if none found, insertion happens at the end of the statement.
 *    • This implementation hardcodes “fgets” as a known modifier for
 *      demonstration.  In production, use TargetLibraryInfo or a JSON table
 *      of known source functions and out-parameters.
 *
 *  Extensions:
 *  -----------
 *    • Integrate with MemorySSA for provably correct clobber identification.
 *    • Support globals (`DIGlobalVariableExpression`) and by-ref parameters.
 *    • Support multiple spans or a SARIF path list as input.
 *
 *  Example Result:
 *  ---------------
 *  Before:
 *      %6 = call ptr @fgets(ptr %4, i32 16, ptr %5)
 *
 *  After:
 *      %6 = call ptr @fgets(ptr %4, i32 16, ptr %5)
 *      call void @sample_bytes(ptr %4, i32 16)
 *
 *
 *===----------------------------------------------------------------------===//
 */

#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DebugProgramInstruction.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/CommandLine.h"

using namespace llvm;

// TODO: refactor SampleFlowSrcPass::run

constexpr unsigned TargetLine = 7;
constexpr unsigned ColStart = 9;
constexpr unsigned ColEnd = 12;

static cl::opt<unsigned> LineOpt("sample-line", cl::desc("Target line"),
                                 cl::init(TargetLine));
static cl::opt<unsigned> ColStartOpt("sample-col-start",
                                     cl::desc("Column start"),
                                     cl::init(ColStart));
static cl::opt<unsigned> ColEndOpt("sample-col-end", cl::desc("Column end"),
                                   cl::init(ColEnd));
static cl::opt<std::string>
    VarNameOpt("sample-var-name",
               cl::desc("Target variable name (e.g., 'x' from '&x')"),
               cl::init(""));
namespace {

struct SampleFlowSrcPass : public PassInfoMixin<SampleFlowSrcPass> {

  // === Helper: check whether instruction is in same statement ===
  static bool sameStatement(const DebugLoc &A, const DebugLoc &B) {
    return A.getLine() == B.getLine() && A.getScope() == B.getScope() &&
           A.getInlinedAt() == B.getInlinedAt();
  }

  // === Helper: strip to base object ===
  static Value *getBaseObject(Value *V, const DataLayout &DL) {
    SmallVector<const Value *, 4> Objects;
    getUnderlyingObjects(V, Objects);
    // Return first object found, or V itself if none found
    return const_cast<Value *>(Objects.empty() ? V : Objects[0]);
  }

  // === Helper: find variable by name using debug info ===
  static Value *findVariableByName(Function &F, StringRef VarName,
                                   unsigned TaintLine) {
    // In LLVM 20+, debug info can be in debug records (#dbg_declare) or
    // intrinsics. Debug records are attached to instructions (often the one
    // after the alloca), so we need to search all instructions.

    errs() << "[sample-flow-src] Searching for variable '" << VarName << "'\n";

    // Search all instructions for debug records
    for (Instruction &I : instructions(F)) {
      // Method 1: Check new-style debug records (#dbg_declare)
      for (DbgRecord &DR : I.getDbgRecordRange()) {
        if (auto *DVR = dyn_cast<DbgVariableRecord>(&DR)) {
          if (DVR->getType() == DbgVariableRecord::LocationType::Declare) {
            if (auto *DIVar = DVR->getVariable()) {
              errs() << "[sample-flow-src]   DbgRecord on " << I.getOpcodeName()
                     << ": " << DIVar->getName() << "\n";
              if (DIVar->getName() == VarName) {
                // The address is the first operand of the dbg_declare
                Value *Address = DVR->getVariableLocationOp(0);
                errs() << "[sample-flow-src] Found variable '" << VarName
                       << "' via DbgRecord, address: " << *Address << "\n";
                return Address;
              }
            }
          }
        }
      }
    }

    // Method 2: Check old-style intrinsics (fallback)
    for (Instruction &I : instructions(F)) {
      if (auto *AI = dyn_cast<AllocaInst>(&I)) {
        auto Declares = llvm::findDbgDeclares(AI);
        for (auto *DDI : Declares) {
          if (auto *DIVar = DDI->getVariable()) {
            errs() << "[sample-flow-src]   Intrinsic variable: "
                   << DIVar->getName() << "\n";
            if (DIVar->getName() == VarName) {
              errs() << "[sample-flow-src] Found variable '" << VarName
                     << "' via intrinsic\n";
              return AI;
            }
          }
        }
      }
    }

    errs() << "[sample-flow-src] Variable '" << VarName << "' not found\n";
    return nullptr;
  }

  // === Core pass logic ===
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    errs() << "=== SampleFlowSrcPass::run called on function: " << F.getName()
           << " ===\n";

    Module &M = *F.getParent();
    const DataLayout &DL = M.getDataLayout();
    LLVMContext &Ctx = M.getContext();

    auto &AA = FAM.getResult<AAManager>(F);

    // Declare all possible sampling functions
    Function *SampleInt = nullptr, *SampleDouble = nullptr,
             *SampleBytes = nullptr;

    // sample_int: i32 sample_int(i32)
    SampleInt = cast<Function>(
        M.getOrInsertFunction("sample_int",
                              FunctionType::get(Type::getInt32Ty(Ctx),
                                                {Type::getInt32Ty(Ctx)}, false))
            .getCallee());

    // sample_double: double sample_double(double)
    SampleDouble =
        cast<Function>(M.getOrInsertFunction(
                            "sample_double",
                            FunctionType::get(Type::getDoubleTy(Ctx),
                                              {Type::getDoubleTy(Ctx)}, false))
                           .getCallee());

    // sample_bytes: void sample_bytes(ptr, i32)
    FunctionCallee SampleBytesFn = M.getOrInsertFunction(
        "sample_bytes",
        FunctionType::get(Type::getVoidTy(Ctx),
                          {PointerType::getUnqual(Ctx), Type::getInt32Ty(Ctx)},
                          false));
    SampleBytes = cast<Function>(SampleBytesFn.getCallee());

    Instruction *Anchor = nullptr;
    Value *Base = nullptr;

    // === Step 1: Find base variable using DILocalVariable (if var name
    // provided) ===
    if (!VarNameOpt.empty()) {
      errs()
          << "[sample-flow-src] Using DILocalVariable approach with var name: "
          << VarNameOpt << "\n";

      // Find the variable directly using debug info
      Base = findVariableByName(F, VarNameOpt, LineOpt);

      if (!Base) {
        errs() << "[sample-flow-src] ERROR: Could not find variable '"
               << VarNameOpt << "' at line " << LineOpt << "\n";
        return PreservedAnalyses::all();
      }

      // Now find the taint source instruction (the last writer on that line)
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == LineOpt) {
            // Case 1: CallBase that writes to Base via an argument (e.g.,
            // fgets)
            if (auto *CB = dyn_cast<CallBase>(&I)) {
              // Check if any argument aliases with Base
              for (auto &Arg : CB->args()) {
                SmallVector<const Value *, 4> Objects;
                getUnderlyingObjects(Arg, Objects);
                for (auto *Obj : Objects) {
                  if (Obj == Base) {
                    Anchor = &I;
                    errs() << "[sample-flow-src] Found taint source call: "
                           << *Anchor << "\n";
                    break;
                  }
                }
                if (Anchor)
                  break;
              }
            }

            // Case 2: Store that writes to Base (e.g., for scalar variables)
            if (!Anchor && isa<StoreInst>(&I)) {
              auto *Store = cast<StoreInst>(&I);
              SmallVector<const Value *, 4> Objects;
              getUnderlyingObjects(Store->getPointerOperand(), Objects);
              for (auto *Obj : Objects) {
                if (Obj == Base) {
                  Anchor = &I;
                  errs() << "[sample-flow-src] Found taint source store: "
                         << *Anchor << "\n";
                  break;
                }
              }
            }
          }
        }
      }

      if (!Anchor) {
        errs() << "[sample-flow-src] ERROR: Could not find taint source "
                  "instruction on line "
               << LineOpt << "\n";
        return PreservedAnalyses::all();
      }

    } else {
      // === Step 1a (fallback): find anchor instruction matching span ===
      errs() << "[sample-flow-src] Using line:col matching approach\n";

      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == LineOpt && DL.getCol() >= ColStartOpt &&
              DL.getCol() <= ColEndOpt) {
            Anchor = &I;
            break;
          }
        }
      }

      if (!Anchor)
        return PreservedAnalyses::all();

      errs() << "[sample-flow-src] Found anchor: " << *Anchor << "\n";

      // === Step 1b: identify base object (alloca/global) ===
      if (auto *GEP = dyn_cast<GetElementPtrInst>(Anchor))
        Base = getBaseObject(GEP, DL);
      else if (auto *Call = dyn_cast<CallBase>(Anchor))
        Base = getBaseObject(Call->getArgOperand(0), DL);
      if (!Base)
        return PreservedAnalyses::all();
    }

    errs() << "[sample-flow-src] Base object: " << *Base << "\n";

    // === Step 3: build statement slice ===
    SmallVector<Instruction *, 8> Slice;
    DebugLoc TargetLoc = Anchor->getDebugLoc();

    Instruction *Start = Anchor;
    while (Start->getPrevNode()) {
      Instruction *Prev = Start->getPrevNode();
      if (!Prev->getDebugLoc() ||
          !sameStatement(Prev->getDebugLoc(), TargetLoc))
        break;
      Start = Prev;
    }

    for (Instruction *I = Start; I; I = I->getNextNode()) {
      if (!I->getDebugLoc() || !sameStatement(I->getDebugLoc(), TargetLoc))
        break;
      Slice.push_back(I);
    }

    errs() << "[sample-flow-src] Statement slice (" << Slice.size()
           << " instrs):\n";
    for (auto *I : Slice)
      errs() << "  " << *I << "\n";

    // === Step 4: find last writer in slice ===
    Instruction *LastWriter = nullptr;
    for (Instruction *I : Slice) {
      bool Writes = false;
      if (auto *Store = dyn_cast<StoreInst>(I)) {
        AliasResult AR = AA.alias(
            MemoryLocation::get(Store),
            MemoryLocation(Base, LocationSize::beforeOrAfterPointer()));
        Writes = (AR != AliasResult::NoAlias);
      } else if (auto *CB = dyn_cast<CallBase>(I)) {
        if (auto *Callee = CB->getCalledFunction()) {
          if (Callee->getName() == "fgets")
            Writes = true;
        }
        if (!Writes) {
          ModRefInfo MRI = AA.getModRefInfo(
              CB, MemoryLocation(Base, LocationSize::beforeOrAfterPointer()));
          Writes = isModSet(MRI);
        }
      }
      if (Writes)
        LastWriter = I;
    }

    if (!LastWriter && !Slice.empty())
      LastWriter = Slice.back();

    errs() << "[sample-flow-src] Last writer: " << *LastWriter << "\n";

    // === Step 5: insert sample call based on type ===
    // Determine the type of the tainted value
    Type *TaintedType = Base->getType();
    if (auto *PtrTy = dyn_cast<PointerType>(TaintedType)) {
      // For pointers, check what they point to
      TaintedType = PtrTy;
    }

    errs() << "[sample-flow-src] Base type: " << *TaintedType << "\n";

    // Strategy: Check if Base is an alloca and what type it allocates
    AllocaInst *AI = dyn_cast<AllocaInst>(Base);
    Type *AllocatedType = AI ? AI->getAllocatedType() : nullptr;

    if (AllocatedType) {
      errs() << "[sample-flow-src] Allocated type: " << *AllocatedType << "\n";
    }

    CallInst *SampleCall = nullptr;

    // Case 1: Scalar integer (i32)
    if (AllocatedType && AllocatedType->isIntegerTy(32)) {
      errs() << "[sample-flow-src] Detected i32 scalar - using sample_int\n";

      // Set insertion point after LastWriter
      IRBuilder<> B(Ctx);
      B.SetInsertPoint(LastWriter->getParent(), ++LastWriter->getIterator());

      // Load current value, sample it, store it back
      LoadInst *OrigValue = B.CreateLoad(AllocatedType, Base);
      CallInst *SampledValue = B.CreateCall(SampleInt, {OrigValue});
      B.CreateStore(SampledValue, Base);

      SampleCall = SampledValue;

      // Case 2: Scalar double
    } else if (AllocatedType && AllocatedType->isDoubleTy()) {
      errs()
          << "[sample-flow-src] Detected double scalar - using sample_double\n";

      // Set insertion point after LastWriter
      IRBuilder<> B(Ctx);
      B.SetInsertPoint(LastWriter->getParent(), ++LastWriter->getIterator());

      // Load current value, sample it, store it back
      LoadInst *OrigValue = B.CreateLoad(AllocatedType, Base);
      CallInst *SampledValue = B.CreateCall(SampleDouble, {OrigValue});
      B.CreateStore(SampledValue, Base);

      SampleCall = SampledValue;

      // Case 3: Array or buffer - use sample_bytes
    } else {
      errs()
          << "[sample-flow-src] Detected array/buffer - using sample_bytes\n";

      // Find the pointer that was used in the taint source
      Value *Ptr = nullptr;
      if (auto *GEP = dyn_cast<GetElementPtrInst>(Anchor)) {
        Ptr = GEP; // Reuse the existing GEP
      } else if (auto *CB = dyn_cast<CallBase>(Anchor)) {
        Ptr = CB->getArgOperand(0);
      } else {
        // Fallback: create GEP from base
        IRBuilder<> B(LastWriter->getParent());
        if (AI) {
          Ptr = B.CreateConstInBoundsGEP2_64(AI->getAllocatedType(), AI, 0, 0);
        } else {
          Ptr = Base;
        }
      }

      // Determine buffer size
      Value *Len = nullptr;
      if (AllocatedType && AllocatedType->isArrayTy()) {
        // For arrays, use the array size
        uint64_t NumElements = AllocatedType->getArrayNumElements();
        uint64_t ElementSize =
            DL.getTypeAllocSize(AllocatedType->getArrayElementType());
        Len =
            ConstantInt::get(Type::getInt32Ty(Ctx), NumElements * ElementSize);
      } else {
        // Default size (TODO: extract from call context)
        Len = ConstantInt::get(Type::getInt32Ty(Ctx), 16);
      }

      // Create and insert the sample_bytes call
      SampleCall = CallInst::Create(SampleBytes, {Ptr, Len});
      SampleCall->insertAfter(LastWriter);
    }

    errs() << "[sample-flow-src] Inserted sample call: " << *SampleCall << "\n";
    errs() << "[sample-flow-src]   immediately after: " << *LastWriter << "\n";

    return PreservedAnalyses::none();
  }
};

} // namespace

// === Registration boilerplate ===
llvm::PassPluginLibraryInfo getSamplePassPluginInfo() {
  return {
      LLVM_PLUGIN_API_VERSION, "SampleFlowSrcPass", LLVM_VERSION_STRING,
      [](PassBuilder &PB) {
        errs() << "=== SampleFlowSrcPass PASS PLUGIN LOADED ===\n";
        PB.registerPipelineParsingCallback(
            [](StringRef Name, FunctionPassManager &FPM,
               ArrayRef<PassBuilder::PipelineElement>) {
              errs() << "[SampleFlowSrcPass] Pipeline parsing callback called "
                        "with Name: "
                     << Name << "\n";
              if (Name == "sample-flow-src") {
                errs()
                    << "[SampleFlowSrcPass] Registering SampleFlowSrcPass!\n";
                FPM.addPass(SampleFlowSrcPass());
                return true;
              }
              return false;
            });
      }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getSamplePassPluginInfo();
}
