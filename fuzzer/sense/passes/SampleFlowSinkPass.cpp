/**
 *===----------------------------------------------------------------------===//
 * SampleFlowSinkPass: Insert Tracking Call Before Taint Sink
 *===----------------------------------------------------------------------===//
 *
 *  Overview:
 *  ----------
 *  This pass instruments taint sinks by inserting tracking calls immediately
 *  before the sink consumes tainted data. It supports two modes of operation:
 *
 *  1. **Line:Column Mode** (recommended): Uses source location spans from
 *      static analysis reports (e.g., CodeQL), see Workflow 1b.
 *  2. **Variable Name Mode** (fallback): Uses DILocalVariable debug info
 *     to identify the target variable by name, see Workflow 1a).
 *
 *  Unlike SampleFlowSrcPass, this pass does NOT mutate data - it only tracks
 *  when tainted data reaches a dangerous sink.
 *
 *  The pass supports multiple data types:
 *    • Scalar integers (i32)
 *    • Scalar floats (double)
 *    • Arrays/buffers
 *    • Struct fields (field-sensitive tracking)
 *
 *  Workflow:
 *  ---------
 *  1. **Locate the variable**:
 *     - a) Variable name mode: Search for DILocalVariable matching the name
 *     - b) Line:col mode: Find instruction at the specified source location
 *     This step produces a BASE address and an ANCHOR instruction
 *
 *  2. **Build statement slice**: Collect all instructions on the same source
 *     line and lexical scope as the ANCHOR.
 *
 *  3. **Find sink operation**: Within the statement slice, find the operation
 *     that consumes the data (call, ret, etc.). This is where we insert BEFORE.
 *
 *  4. **Insert tracking call**:
 *     - Insert: sample_report_sink(ptr, size, sink_id) BEFORE the sink
 *
 *  Usage:
 *  ------
 *      opt -load-pass-plugin ./libSampleFlowSinkPass.so \
 *          -passes=sample-flow-sink \
 *          -sample-line=10 -sample-col-start=7 -sample-col-end=8 \
 *          -sample-var-name=x -sample-sink-id=1 \
 *          flow_simple.ll -S -o flow_simple_sink.ll
 *
 *  Notes:
 *  ------
 *    • The pass requires debug info (`-g`) to be present in the IR.
 *    • The tracking function is declared if not already available.
 *    • The insertion point is BEFORE the sink operation.
 *
 *  Example Result:
 *  ---------------
 *  Before:
 *      %8 = call i32 @log(i32 noundef %7)
 *
 *  After:
 *      call void @sample_report_sink(ptr %x_addr, i32 4, i32 1)
 *      %8 = call i32 @log(i32 noundef %7)
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

constexpr unsigned TargetLine = 10;
constexpr unsigned ColStart = 7;
constexpr unsigned ColEnd = 8;

static cl::opt<unsigned> LineOpt("sample-line", cl::desc("Target line"),
                                 cl::init(TargetLine));
static cl::opt<unsigned> ColStartOpt("sample-col-start",
                                     cl::desc("Column start"),
                                     cl::init(ColStart));
static cl::opt<unsigned> ColEndOpt("sample-col-end", cl::desc("Column end"),
                                   cl::init(ColEnd));
static cl::opt<std::string>
    VarNameOpt("sample-var-name",
               cl::desc("Target variable name (e.g., 'x' from 'log(x)')"),
               cl::init(""));
static cl::opt<int> SinkIDOpt("sample-sink-id",
                              cl::desc("Sink ID for flow tracking"),
                              cl::init(-1));

namespace {

struct SampleFlowSinkPass : public PassInfoMixin<SampleFlowSinkPass> {

  // === Helper: check whether instruction is in same statement ===
  static bool sameStatement(const DebugLoc &A, const DebugLoc &B) {
    return A.getLine() == B.getLine() && A.getScope() == B.getScope() &&
           A.getInlinedAt() == B.getInlinedAt();
  }

  // === Helper: strip to base object ===
  static Value *getBaseObject(Value *V, const DataLayout &DL) {
    SmallVector<const Value *, 4> Objects;
    getUnderlyingObjects(V, Objects);
    return const_cast<Value *>(Objects.empty() ? V : Objects[0]);
  }

  // === Helper: Infer the type that a GEP instruction points to ===
  static Type *inferGEPPointedType(GetElementPtrInst *GEP,
                                   const DataLayout &DL) {
    Type *SourceType = GEP->getSourceElementType();
    errs() << "[sample-flow-sink]   GEP source type: " << *SourceType << "\n";

    if (SourceType->isArrayTy()) {
      errs() << "[sample-flow-sink]   Array detected - using whole array type: "
             << *SourceType << "\n";
      return SourceType;
    }

    if (SourceType->isStructTy()) {
      Type *CurType = SourceType;
      bool FirstIndex = true;

      for (auto IdxIt = GEP->idx_begin(); IdxIt != GEP->idx_end(); ++IdxIt) {
        if (FirstIndex) {
          FirstIndex = false;
          continue;
        }

        if (auto *StructTy = dyn_cast<StructType>(CurType)) {
          if (auto *CI = dyn_cast<ConstantInt>(*IdxIt)) {
            unsigned FieldIdx = CI->getZExtValue();
            CurType = StructTy->getElementType(FieldIdx);
            errs() << "[sample-flow-sink]   Struct field " << FieldIdx
                   << " type: " << *CurType << "\n";
          }
        } else if (auto *ArrTy = dyn_cast<ArrayType>(CurType)) {
          CurType = ArrTy->getElementType();
          errs() << "[sample-flow-sink]   Nested array element type: "
                 << *CurType << "\n";
        }
      }

      errs() << "[sample-flow-sink]   Struct field inferred type: " << *CurType
             << "\n";
      return CurType;
    }

    if (SourceType->isVectorTy()) {
      errs() << "[sample-flow-sink]   Vector type detected - not implemented\n";
      assert(false && "ERROR: Vector type handling not implemented");
    }

    assert(false && "ERROR: Cannot infer PointedToType from GEP");
  }

  // === Helper: find variable by name using debug info ===
  static Value *findVariableByName(Function &F, StringRef VarName,
                                   unsigned TaintLine) {
    errs() << "[sample-flow-sink] Searching for declaration of variable '"
           << VarName << "' used on line " << TaintLine << "\n";

    SmallVector<std::pair<Value *, DILocalVariable *>, 4> Candidates;

    // Collect all variables with matching name
    for (Instruction &I : instructions(F)) {
      // Method 1: Check new-style debug records (#dbg_declare)
      for (DbgRecord &DR : I.getDbgRecordRange()) {
        if (auto *DVR = dyn_cast<DbgVariableRecord>(&DR)) {
          if (DVR->getType() == DbgVariableRecord::LocationType::Declare) {
            if (auto *DIVar = DVR->getVariable()) {
              if (DIVar->getName() == VarName) {
                Value *Address = DVR->getVariableLocationOp(0);
                Candidates.push_back({Address, DIVar});
                errs() << "[sample-flow-sink]   Found candidate: " << *Address
                       << " declared at line " << DIVar->getLine() << "\n";
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
            if (DIVar->getName() == VarName) {
              Candidates.push_back({AI, DIVar});
              errs() << "[sample-flow-sink]   Found candidate (intrinsic): "
                     << *AI << " declared at line " << DIVar->getLine() << "\n";
            }
          }
        }
      }
    }

    if (Candidates.empty()) {
      errs() << "[sample-flow-sink] No variables named '" << VarName
             << "' found\n";
      return nullptr;
    }

    // Filter candidates: keep only those that are in scope at TaintLine
    Value *BestMatch = nullptr;
    DILocalVariable *BestDIVar = nullptr;

    for (auto [Address, DIVar] : Candidates) {
      if (DIVar->getLine() > TaintLine) {
        errs() << "[sample-flow-sink]   Rejecting " << *Address
               << " - declared after taint line\n";
        continue;
      }

      // Verify the variable is used on TaintLine
      bool UsedOnTaintLine = false;
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == TaintLine) {
            for (Use &U : I.operands()) {
              Value *Op = U.get();

              if (Op == Address) {
                UsedOnTaintLine = true;
                break;
              }

              SmallVector<const Value *, 4> Objects;
              getUnderlyingObjects(Op, Objects);
              for (auto *Obj : Objects) {
                if (Obj == Address) {
                  UsedOnTaintLine = true;
                  break;
                }
              }
              if (UsedOnTaintLine)
                break;
            }
            if (UsedOnTaintLine)
              break;
          }
        }
      }

      if (UsedOnTaintLine) {
        if (!BestMatch || DIVar->getLine() > BestDIVar->getLine()) {
          BestMatch = Address;
          BestDIVar = DIVar;
          errs() << "[sample-flow-sink]   Accepted as best match: " << *Address
                 << "\n";
        }
      } else {
        errs() << "[sample-flow-sink]   Rejecting " << *Address
               << " - not used on line " << TaintLine << "\n";
      }
    }

    if (BestMatch) {
      errs() << "[sample-flow-sink] Selected variable '" << VarName
             << "' declared at line " << BestDIVar->getLine()
             << ", address: " << *BestMatch << "\n";
    } else {
      errs() << "[sample-flow-sink] No variable '" << VarName
             << "' is used on line " << TaintLine << "\n";
    }

    return BestMatch;
  }

  static void declareReportFunction(Module &M, Function *&SampleReportSink) {
    LLVMContext &Ctx = M.getContext();

    // sample_report_sink: void sample_report_sink(ptr, i32, i32)
    // params: (data_ptr, size, sink_id)
    FunctionCallee SampleReportSinkFn = M.getOrInsertFunction(
        "sample_report_sink",
        FunctionType::get(Type::getVoidTy(Ctx),
                          {PointerType::getUnqual(Ctx), Type::getInt32Ty(Ctx),
                           Type::getInt32Ty(Ctx)},
                          false));
    SampleReportSink = cast<Function>(SampleReportSinkFn.getCallee());
  }

  static SmallVector<Instruction *, 8> buildStmtSlice(Instruction *Anchor) {
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

    errs() << "[sample-flow-sink] Statement slice (" << Slice.size()
           << " instrs):\n";
    for (auto *I : Slice)
      errs() << "  " << *I << "\n";
    return Slice;
  }

  // Find the sink operation (the instruction consuming the data)
  static Instruction *
  findSinkOperation(const SmallVectorImpl<Instruction *> &Slice, Value *Base,
                    AliasAnalysis &AA) {
    Instruction *SinkOp = nullptr;

    for (Instruction *I : Slice) {
      bool Reads = false;

      // Check if this is a call that reads from Base
      if (auto *CB = dyn_cast<CallBase>(I)) {
        // Check arguments for aliasing with Base
        for (auto &Arg : CB->args()) {
          SmallVector<const Value *, 4> Objects;
          getUnderlyingObjects(Arg, Objects);
          for (auto *Obj : Objects) {
            if (Obj == Base) {
              Reads = true;
              break;
            }
          }
          if (Reads)
            break;
        }

        // Also check via alias analysis
        if (!Reads) {
          ModRefInfo MRI = AA.getModRefInfo(
              CB, MemoryLocation(Base, LocationSize::beforeOrAfterPointer()));
          Reads = isRefSet(MRI);
        }
      }
      // Check if this is a load from Base
      else if (auto *Load = dyn_cast<LoadInst>(I)) {
        AliasResult AR = AA.alias(
            MemoryLocation::get(Load),
            MemoryLocation(Base, LocationSize::beforeOrAfterPointer()));
        Reads = (AR != AliasResult::NoAlias);
      }
      // Check if this is a return that uses Base
      else if (auto *Ret = dyn_cast<ReturnInst>(I)) {
        if (Value *RetVal = Ret->getReturnValue()) {
          SmallVector<const Value *, 4> Objects;
          getUnderlyingObjects(RetVal, Objects);
          for (auto *Obj : Objects) {
            if (Obj == Base) {
              Reads = true;
              break;
            }
          }
        }
      }

      if (Reads)
        SinkOp = I;
    }

    if (!SinkOp && !Slice.empty())
      SinkOp = Slice.back();

    errs() << "[sample-flow-sink] Sink operation: " << *SinkOp << "\n";
    return SinkOp;
  }

  // Insert the report call BEFORE the sink operation
  static void insertReportCall(const DataLayout &DL, LLVMContext &Ctx,
                               Function *&SampleReportSink, Value *&Base,
                               Instruction *&SinkOp, AllocaInst *&AI,
                               Value *&Ptr, Type *&PointedToType, int sinkID) {
    if (sinkID < 0 || !SampleReportSink) {
      errs() << "[sample-flow-sink] Skipping report call (no sink ID or "
                "function)\n";
      return;
    }

    // Determine pointer and size
    Value *ReportPtr = Ptr ? Ptr : Base;
    Value *ReportSize = nullptr;

    // Calculate size based on type
    if (PointedToType && PointedToType->isIntegerTy(32)) {
      ReportSize = ConstantInt::get(Type::getInt32Ty(Ctx), 4);
    } else if (PointedToType && PointedToType->isDoubleTy()) {
      ReportSize = ConstantInt::get(Type::getInt32Ty(Ctx), 8);
    } else if (PointedToType && PointedToType->isArrayTy()) {
      uint64_t NumElements = PointedToType->getArrayNumElements();
      uint64_t ElementSize =
          DL.getTypeAllocSize(PointedToType->getArrayElementType());
      uint64_t TotalSize = NumElements * ElementSize;
      ReportSize = ConstantInt::get(Type::getInt32Ty(Ctx), TotalSize);
      errs() << "[sample-flow-sink] Array size: " << TotalSize << " bytes\n";
    } else if (PointedToType && PointedToType->isSized()) {
      uint64_t TypeSize = DL.getTypeAllocSize(PointedToType);
      ReportSize = ConstantInt::get(Type::getInt32Ty(Ctx), TypeSize);
      errs() << "[sample-flow-sink] Type size: " << TypeSize << " bytes\n";
    } else {
      // Default size
      ReportSize = ConstantInt::get(Type::getInt32Ty(Ctx), 16);
      errs() << "[sample-flow-sink] Using default size: 16 bytes\n";
    }

    // Create the report call BEFORE the sink operation
    Value *SinkIDVal = ConstantInt::get(Type::getInt32Ty(Ctx), sinkID);

    IRBuilder<> B(Ctx);
    B.SetInsertPoint(SinkOp);
    CallInst *ReportCall =
        B.CreateCall(SampleReportSink, {ReportPtr, ReportSize, SinkIDVal});

    errs() << "[sample-flow-sink] Inserted sample_report_sink call with "
              "SINK_ID="
           << sinkID << "\n";
    errs() << "[sample-flow-sink]   " << *ReportCall << "\n";
    errs() << "[sample-flow-sink]   immediately before: " << *SinkOp << "\n";
  }

  // Given a base address, find which argument of a call aliases it
  static Value *findFuncArgAliasBase(Value *&Base, llvm::CallBase *&CB) {
    for (auto &Arg : CB->args()) {
      SmallVector<const Value *, 4> Objects;
      getUnderlyingObjects(Arg, Objects);
      for (auto *Obj : Objects) {
        if (Obj == Base) {
          errs() << "[sample-flow-sink] Found argument aliasing with Base: "
                 << *Arg << "\n";
          return Arg;
        }
      }
    }
    return nullptr;
  }

  // Verify the call reads from Base
  static Instruction *verifyCallReadsBase(Value *&Base, Instruction &I,
                                          llvm::CallBase *&CB) {
    for (auto &Arg : CB->args()) {
      SmallVector<const Value *, 4> Objects;
      getUnderlyingObjects(Arg, Objects);
      for (auto *Obj : Objects) {
        if (Obj == Base) {
          errs() << "[sample-flow-sink] Found taint sink call: " << I << "\n";
          return &I;
        }
      }
    }
    return nullptr;
  }

  // Verify the load reads from Base
  static Instruction *verifyLoadReadsBase(Value *&Base, Instruction &I,
                                          AliasAnalysis &AA) {
    auto *Load = cast<LoadInst>(&I);
    SmallVector<const Value *, 4> Objects;
    getUnderlyingObjects(Load->getPointerOperand(), Objects);
    for (auto *Obj : Objects) {
      if (Obj == Base) {
        errs() << "[sample-flow-sink] Found taint sink load: " << I << "\n";
        return &I;
      }
    }
    return nullptr;
  }

  // Find the type pointed to by the pointer in the anchor instruction
  static void findPointedToType(const DataLayout &DL, Instruction *&Anchor,
                                Value *&Base, Type *&AllocatedType, Value *&Ptr,
                                Type *&PointedToType) {
    if (auto *GEP = dyn_cast<GetElementPtrInst>(Anchor)) {
      Ptr = GEP;
      PointedToType = inferGEPPointedType(GEP, DL);
      if (PointedToType) {
        errs() << "[sample-flow-sink] Inferred pointed-to type from GEP: "
               << *PointedToType << "\n";
      }
    } else if (auto *CB = dyn_cast<CallBase>(Anchor)) {
      Ptr = findFuncArgAliasBase(Base, CB);

      if (Ptr) {
        if (auto *ArgGEP = dyn_cast<GetElementPtrInst>(Ptr)) {
          PointedToType = inferGEPPointedType(ArgGEP, DL);
          if (PointedToType) {
            errs() << "[sample-flow-sink] Inferred pointed-to type from arg "
                      "GEP: "
                   << *PointedToType << "\n";
          }
        }
      }
    } else if (auto *Load = dyn_cast<LoadInst>(Anchor)) {
      // For loads, the type is the loaded type
      PointedToType = Load->getType();
      Ptr = Load->getPointerOperand();
      errs() << "[sample-flow-sink] Load type: " << *PointedToType << "\n";
    }

    if (!PointedToType && AllocatedType) {
      PointedToType = AllocatedType;
      errs() << "[sample-flow-sink] Using allocated type as fallback: "
             << *PointedToType << "\n";
    }
  }

  // === Core pass logic ===
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    errs() << "=== SampleFlowSinkPass::run called on function: " << F.getName()
           << " ===\n";

    Module &M = *F.getParent();
    const DataLayout &DL = M.getDataLayout();
    LLVMContext &Ctx = M.getContext();

    auto &AA = FAM.getResult<AAManager>(F);

    // Declare report function
    Function *SampleReportSink = nullptr;
    declareReportFunction(M, SampleReportSink);

    Instruction *Anchor = nullptr;
    Value *Base = nullptr;

    // === Step 1: find anchor instruction matching line:col ===
    errs() << "[sample-flow-sink] Try using line:col matching approach\n";

    for (Instruction &I : instructions(F)) {
      if (DebugLoc DL = I.getDebugLoc()) {
        if (DL.getLine() == LineOpt && DL.getCol() >= ColStartOpt &&
            DL.getCol() <= ColEndOpt) {
          Anchor = &I;
        }
      }
    }

    if (!Anchor)
      goto fallback;

    errs() << "[sample-flow-sink] Found anchor: " << *Anchor << "\n";

    // === Step 1b: identify base object ===
    if (auto *GEP = dyn_cast<GetElementPtrInst>(Anchor))
      Base = getBaseObject(GEP, DL);
    else if (auto *Call = dyn_cast<CallBase>(Anchor)) {
      // Note: For now, for calls, we don't know which argument the line:col
      // spans. Always fallback to varname mode for correct identification.
      Base = nullptr;
      errs() << "[sample-flow-sink] CallBase anchor - forcing varname "
                "fallback\n";
    } else if (auto *Load = dyn_cast<LoadInst>(Anchor))
      Base = getBaseObject(Load->getPointerOperand(), DL);

  fallback:
    LoadInst *LoadFromBase =
        nullptr; // Track the load instruction for type inference

    if (!Anchor || !Base) {
      errs() << "[sample-flow-sink] Fallback to using DILocalVariable "
                "approach with var name: "
             << VarNameOpt << "\n";

      Base = findVariableByName(F, VarNameOpt, LineOpt);

      if (!Base) {
        errs() << "[sample-flow-sink] ERROR: Could not find variable '"
               << VarNameOpt << "' at line " << LineOpt << "\n";
        return PreservedAnalyses::all();
      }

      // Find the ANCHOR: We need to find the load from Base, then trace
      // forward to find the final consumer of that loaded value.
      // Example: log(x) generates:
      //   %5 = load i32, ptr %2    <- reads from Base
      //   %6 = sitofp i32 %5       <- uses %5
      //   %7 = call @log(double %6) <- final consumer (this is the anchor)

      // Step 1: Find load from Base on target line
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == LineOpt) {
            if (auto *Load = dyn_cast<LoadInst>(&I)) {
              SmallVector<const Value *, 4> Objects;
              getUnderlyingObjects(Load->getPointerOperand(), Objects);
              for (auto *Obj : Objects) {
                if (Obj == Base) {
                  LoadFromBase = Load;
                  errs() << "[sample-flow-sink] Found load from Base: " << *Load
                         << "\n";
                  break;
                }
              }
            }
          }
        }
      }

      if (!LoadFromBase) {
        errs()
            << "[sample-flow-sink] ERROR: Could not find load from variable '"
            << VarNameOpt << "' on line " << LineOpt << "\n";
        return PreservedAnalyses::all();
      }

      // Step 2: Find the final consumer of the loaded value on the same line
      // Trace through the use-def chain to find the last instruction that uses
      // the loaded value (directly or transitively)
      Value *CurrentValue = LoadFromBase;
      Instruction *LastConsumer = LoadFromBase;

      // Follow the use chain forward
      SmallVector<Value *, 8> Worklist;
      Worklist.push_back(CurrentValue);
      SmallPtrSet<Value *, 8> Visited;

      while (!Worklist.empty()) {
        Value *V = Worklist.pop_back_val();
        if (!Visited.insert(V).second)
          continue;

        for (User *U : V->users()) {
          if (auto *UserInst = dyn_cast<Instruction>(U)) {
            if (DebugLoc DL = UserInst->getDebugLoc()) {
              if (DL.getLine() == LineOpt) {
                // This user is on the same line - update last consumer
                LastConsumer = UserInst;
                // Continue tracing through this instruction's users
                Worklist.push_back(UserInst);
              }
            }
          }
        }
      }

      Anchor = LastConsumer;
      errs() << "[sample-flow-sink] Found final consumer (anchor): " << *Anchor
             << "\n";
    }

    errs() << "[sample-flow-sink] Base object: " << *Base << "\n";

    // === Step 2: build statement slice ===
    SmallVector<Instruction *, 8> Slice = buildStmtSlice(Anchor);

    // === Step 3: find sink operation ===
    Instruction *SinkOp = findSinkOperation(Slice, Base, AA);

    // === Step 4: determine type and insert report call ===
    AllocaInst *AI = dyn_cast<AllocaInst>(Base);
    Type *AllocatedType = AI ? AI->getAllocatedType() : nullptr;

    if (AllocatedType) {
      errs() << "[sample-flow-sink] Allocated type: " << *AllocatedType << "\n";
    }

    Value *Ptr = nullptr;
    Type *PointedToType = nullptr;

    // In varname fallback mode, we found LoadFromBase - use it to get precise
    // pointer/type In line:col mode, LoadFromBase is null, so we use the Anchor
    Instruction *TypeSource = LoadFromBase ? LoadFromBase : Anchor;
    findPointedToType(DL, TypeSource, Base, AllocatedType, Ptr, PointedToType);

    // Insert the tracking call BEFORE the sink
    insertReportCall(DL, Ctx, SampleReportSink, Base, SinkOp, AI, Ptr,
                     PointedToType, SinkIDOpt);

    return PreservedAnalyses::none();
  }
};

} // namespace

// === Registration boilerplate ===
llvm::PassPluginLibraryInfo getSampleFlowSinkPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "SampleFlowSinkPass", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            errs() << "=== SampleFlowSinkPass PASS PLUGIN LOADED ===\n";
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  errs() << "[SampleFlowSinkPass] Pipeline parsing callback "
                            "called with Name: "
                         << Name << "\n";
                  if (Name == "sample-flow-sink") {
                    errs() << "[SampleFlowSinkPass] Registering "
                              "SampleFlowSinkPass!\n";
                    FPM.addPass(SampleFlowSinkPass());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getSampleFlowSinkPassPluginInfo();
}
