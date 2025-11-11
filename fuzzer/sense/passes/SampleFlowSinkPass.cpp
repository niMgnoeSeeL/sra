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
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"

using namespace llvm;

constexpr unsigned TargetLine = 10;
constexpr unsigned ColStart = 7;
constexpr unsigned ColEnd = 8;

static cl::opt<unsigned> LineOpt("sink-line", cl::desc("Target line"),
                                 cl::init(TargetLine));
static cl::opt<unsigned> ColStartOpt("sink-col-start", cl::desc("Column start"),
                                     cl::init(ColStart));
static cl::opt<unsigned> ColEndOpt("sink-col-end", cl::desc("Column end"),
                                   cl::init(ColEnd));
static cl::opt<std::string>
    FileNameOpt("sink-file",
                cl::desc("Target file path for disambiguation (e.g., "
                         "'src/main.c' or '/path/to/file.c')"),
                cl::init(""));
static cl::opt<std::string>
    VarNameOpt("sink-var-name",
               cl::desc("Target variable name (e.g., 'x' from 'log(x)')"),
               cl::init(""));
static cl::opt<int> SinkIDOpt("sink-id", cl::desc("Sink ID for flow tracking"),
                              cl::init(-1));

namespace {

struct SampleFlowSinkPass : public PassInfoMixin<SampleFlowSinkPass> {

  // === Helper: check whether instruction is in same statement ===
  static bool sameStatement(const DebugLoc &A, const DebugLoc &B) {
    return A.getLine() == B.getLine() && A.getScope() == B.getScope() &&
           A.getInlinedAt() == B.getInlinedAt();
  }

  // === Helper: check if debug location matches file path filter ===
  static bool matchesFilename(const DebugLoc &DL,
                              const std::string &FilePathFilter) {
    if (FilePathFilter.empty())
      return true; // No filter specified, match all files

    DILocation *Loc = DL.get();
    if (!Loc)
      return false;

    // Construct full path from directory + filename
    std::string DebugFilePath;
    if (!Loc->getDirectory().empty()) {
      DebugFilePath = Loc->getDirectory().str();
      if (DebugFilePath.back() != '/')
        DebugFilePath += '/';
    }
    DebugFilePath += Loc->getFilename().str();

    // Resolve both paths to canonical form (resolving .., ., symlinks)
    std::error_code EC;

    // Resolve the debug info path (may contain ../)
    llvm::SmallString<256> ResolvedDebugPath;
    EC = llvm::sys::fs::real_path(DebugFilePath, ResolvedDebugPath);
    if (EC) {
      // If real_path fails (file doesn't exist), try manual resolution
      llvm::SmallString<256> AbsDebugPath(DebugFilePath);
      if (llvm::sys::fs::make_absolute(AbsDebugPath)) {
        // If make_absolute fails, use as-is
        ResolvedDebugPath = DebugFilePath;
      } else {
        llvm::sys::path::remove_dots(AbsDebugPath, /*remove_dot_dot=*/true);
        ResolvedDebugPath = AbsDebugPath;
      }
    }

    // Resolve the filter path (may be relative or contain ../)
    llvm::SmallString<256> ResolvedFilterPath;
    EC = llvm::sys::fs::real_path(FilePathFilter, ResolvedFilterPath);
    if (EC) {
      // If real_path fails, make it absolute (relative to current working dir)
      // and remove dots
      llvm::SmallString<256> AbsFilterPath(FilePathFilter);
      if (llvm::sys::fs::make_absolute(AbsFilterPath)) {
        // If make_absolute fails, use as-is
        ResolvedFilterPath = FilePathFilter;
      } else {
        llvm::sys::path::remove_dots(AbsFilterPath, /*remove_dot_dot=*/true);
        ResolvedFilterPath = AbsFilterPath;
      }
    }

    // Compare the canonical paths
    bool matches = (ResolvedDebugPath == ResolvedFilterPath);

    if (!matches) {
      // Also try suffix match for relative paths
      // e.g., filter "demo/flow_simple.c" should match
      // "/path/to/demo/flow_simple.c"
      StringRef DebugPathRef(ResolvedDebugPath.c_str());
      StringRef FilterPathRef(ResolvedFilterPath.c_str());
      matches = DebugPathRef.ends_with(FilterPathRef);
    }

    return matches;
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
    Module &M = *F.getParent();
    errs() << "[sample-flow-sink] Searching for declaration of variable '"
           << VarName << "' used on line " << TaintLine << "\n";

    SmallVector<std::pair<Value *, DILocalVariable *>, 4> LocalCandidates;
    SmallVector<std::pair<GlobalVariable *, DIGlobalVariable *>, 4>
        GlobalCandidates;

    // === Part 1: Search for LOCAL variables ===
    // Collect all local variables with matching name
    for (Instruction &I : instructions(F)) {
      // Method 1: Check new-style debug records (#dbg_declare)
      for (DbgRecord &DR : I.getDbgRecordRange()) {
        if (auto *DVR = dyn_cast<DbgVariableRecord>(&DR)) {
          if (DVR->getType() == DbgVariableRecord::LocationType::Declare) {
            if (auto *DIVar = DVR->getVariable()) {
              if (DIVar->getName() == VarName) {
                Value *Address = DVR->getVariableLocationOp(0);
                LocalCandidates.push_back({Address, DIVar});
                errs() << "[sample-flow-sink]   Found local candidate: "
                       << *Address << " declared at line " << DIVar->getLine()
                       << "\n";
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
              LocalCandidates.push_back({AI, DIVar});
              errs()
                  << "[sample-flow-sink]   Found local candidate (intrinsic): "
                  << *AI << " declared at line " << DIVar->getLine() << "\n";
            }
          }
        }
      }
    }

    // === Part 2: Search for GLOBAL variables ===
    for (auto &GV : M.globals()) {
      SmallVector<DIGlobalVariableExpression *, 1> GVEs;
      GV.getDebugInfo(GVEs);
      for (auto *GVE : GVEs) {
        if (auto *DIGV = GVE->getVariable()) {
          if (DIGV->getName() == VarName) {
            GlobalCandidates.push_back({&GV, DIGV});
            errs() << "[sample-flow-sink]   Found global candidate: "
                   << GV.getName() << " declared at line " << DIGV->getLine()
                   << "\n";
          }
        }
      }
    }

    // === Part 3: Filter LOCAL candidates - keep only those in scope at
    // TaintLine ===
    Value *BestLocalMatch = nullptr;
    DILocalVariable *BestLocalDIVar = nullptr;

    for (auto [Address, DIVar] : LocalCandidates) {
      if (DIVar->getLine() > TaintLine) {
        errs() << "[sample-flow-sink]   Rejecting local " << *Address
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
        if (!BestLocalMatch || DIVar->getLine() > BestLocalDIVar->getLine()) {
          BestLocalMatch = Address;
          BestLocalDIVar = DIVar;
          errs() << "[sample-flow-sink]   Accepted as best local match: "
                 << *Address << "\n";
        }
      } else {
        errs() << "[sample-flow-sink]   Rejecting local " << *Address
               << " - not used on line " << TaintLine << "\n";
      }
    }

    // === Part 4: Filter GLOBAL candidates - check if used on TaintLine ===
    GlobalVariable *BestGlobalMatch = nullptr;

    for (auto [GV, DIGV] : GlobalCandidates) {
      // Check if this global is used on TaintLine
      bool UsedOnTaintLine = false;

      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == TaintLine) {
            for (Use &U : I.operands()) {
              Value *Op = U.get();

              // Direct use
              if (Op == GV) {
                UsedOnTaintLine = true;
                break;
              }

              // Check through getUnderlyingObjects
              SmallVector<const Value *, 4> Objects;
              getUnderlyingObjects(Op, Objects);
              for (auto *Obj : Objects) {
                if (Obj == GV) {
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
        BestGlobalMatch = GV;
        errs() << "[sample-flow-sink]   Accepted global: " << GV->getName()
               << "\n";
        break;
      } else {
        errs() << "[sample-flow-sink]   Rejecting global " << GV->getName()
               << " - not used on line " << TaintLine << "\n";
      }
    }

    // === Part 5: Return best match (prefer local over global) ===
    if (BestLocalMatch) {
      errs() << "[sample-flow-sink] Selected LOCAL variable '" << VarName
             << "' declared at line " << BestLocalDIVar->getLine()
             << ", address: " << *BestLocalMatch << "\n";
      return BestLocalMatch;
    }

    if (BestGlobalMatch) {
      errs() << "[sample-flow-sink] Selected GLOBAL variable '" << VarName
             << "': " << *BestGlobalMatch << "\n";
      return BestGlobalMatch;
    }

    errs() << "[sample-flow-sink] No variable '" << VarName
           << "' is used on line " << TaintLine << "\n";
    return nullptr;
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
      // Case 1: Argument is a pointer that may alias Base
      if (Arg->getType()->isPointerTy()) {
        SmallVector<const Value *, 4> Objects;
        getUnderlyingObjects(Arg, Objects);
        for (auto *Obj : Objects) {
          if (Obj == Base) {
            errs() << "[sample-flow-sink] Found taint sink call (pointer arg): "
                   << I << "\n";
            return &I;
          }
        }
      }
      // Case 2: Argument is a scalar value that may be derived from Base
      // Example: log(y*2) where y is loaded from Base
      // We need to trace back through def-use chain to find the load
      else {
        // Trace back through SSA def-use chain to find loads
        SmallVector<Value *, 8> Worklist;
        SmallPtrSet<Value *, 8> Visited;
        Worklist.push_back(Arg);

        while (!Worklist.empty()) {
          Value *V = Worklist.pop_back_val();
          if (!Visited.insert(V).second)
            continue;

          // Check if this is a load from Base
          if (auto *Load = dyn_cast<LoadInst>(V)) {
            SmallVector<const Value *, 4> Objects;
            getUnderlyingObjects(Load->getPointerOperand(), Objects);
            for (auto *Obj : Objects) {
              if (Obj == Base) {
                errs() << "[sample-flow-sink] Found taint sink call (scalar "
                          "derived from Base): "
                       << I << "\n";
                return &I;
              }
            }
          }

          // Continue tracing through operands (for instructions like add, mul,
          // cast, etc.)
          if (auto *Inst = dyn_cast<Instruction>(V)) {
            for (Use &U : Inst->operands()) {
              Worklist.push_back(U.get());
            }
          }
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
        if (matchesFilename(DL, FileNameOpt) && DL.getLine() == LineOpt &&
            DL.getCol() >= ColStartOpt && DL.getCol() <= ColEndOpt) {
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
    } else if (auto *Load = dyn_cast<LoadInst>(Anchor)) {
      Base = getBaseObject(Load->getPointerOperand(), DL);
    } else {
      // Generic case: anchor is a computed value in a register
      // Examples: arithmetic (fmul, fsub), casts, phi nodes, etc.

      // Check if the instruction produces a value
      if (Anchor->getType()->isVoidTy()) {
        errs() << "[sample-flow-sink] ERROR: Anchor is void instruction: "
               << *Anchor << "\n";
        goto fallback;
      }

      // Strategy: Allocate temporary stack space and store the value there
      errs() << "[sample-flow-sink] Anchor is computed value - creating "
             << "temporary stack location\n";

      // Create alloca at function entry for the temporary
      IRBuilder<> AllocaBuilder(&F.getEntryBlock(), F.getEntryBlock().begin());
      std::string sink_temp_name = "sink_temp" + std::to_string(SinkIDOpt);
      AllocaInst *TempAlloca = AllocaBuilder.CreateAlloca(
          Anchor->getType(), nullptr, sink_temp_name);

      // Store the computed value to temp location (right after the anchor)
      IRBuilder<> StoreBuilder(Anchor->getNextNode());
      StoreBuilder.CreateStore(Anchor, TempAlloca);

      // Use the temp alloca as our BASE
      Base = TempAlloca;
      errs() << "[sample-flow-sink] Created temporary: " << *TempAlloca << "\n";
    }

  fallback:
    if (!Anchor || !Base) {
      errs() << "[sample-flow-sink] Fallback to using "
                "DILocalVariable/DIGlobalVariable "
                "approach with var name: "
             << VarNameOpt << "\n";

      // Find the variable directly using debug info
      Base = findVariableByName(F, VarNameOpt, LineOpt);

      if (!Base) {
        errs() << "[sample-flow-sink] ERROR: Could not find variable '"
               << VarNameOpt << "' at line " << LineOpt << "\n";
        return PreservedAnalyses::all();
      }

      // Now find the ANCHOR: taint sink instruction (the instruction that reads
      // from Base on target line) This mirrors the SrcPass logic but for
      // readers instead of writers
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == LineOpt) {
            // Case 1: CallBase that reads from Base via an argument (e.g.,
            // log(x))
            if (auto *CB = dyn_cast<CallBase>(&I)) {
              // Check if any argument aliases with Base
              Anchor = verifyCallReadsBase(Base, I, CB);
            }

            // Case 2: Load that reads from Base (e.g., for scalar variables)
            if (!Anchor && isa<LoadInst>(&I)) {
              Anchor = verifyLoadReadsBase(Base, I, AA);
            }
          }
        }
      }

      if (!Anchor) {
        errs() << "[sample-flow-sink] ERROR: Could not find taint sink "
                  "instruction on line "
               << LineOpt << "\n";
        return PreservedAnalyses::all();
      }
    }

    errs() << "[sample-flow-sink] Base object: " << *Base << "\n";

    // === Step 2: build statement slice ===
    SmallVector<Instruction *, 8> Slice = buildStmtSlice(Anchor);

    // === Step 3: find sink operation ===
    Instruction *SinkOp = findSinkOperation(Slice, Base, AA);

    // === Step 4: determine type and insert report call ===
    AllocaInst *AI = dyn_cast<AllocaInst>(Base);
    GlobalVariable *GV = dyn_cast<GlobalVariable>(Base);
    Type *AllocatedType = nullptr;

    if (AI) {
      AllocatedType = AI->getAllocatedType();
      errs() << "[sample-flow-sink] Allocated type (alloca): " << *AllocatedType
             << "\n";
    } else if (GV) {
      AllocatedType = GV->getValueType();
      errs() << "[sample-flow-sink] Allocated type (global): " << *AllocatedType
             << "\n";
    }

    Value *Ptr = nullptr;
    Type *PointedToType = nullptr;

    // Use the Anchor instruction to infer the pointed-to type
    findPointedToType(DL, Anchor, Base, AllocatedType, Ptr, PointedToType);

    // Insert the tracking call BEFORE the sink
    insertReportCall(DL, Ctx, SampleReportSink, Base, SinkOp, AI, Ptr,
                     PointedToType, SinkIDOpt);

    return PreservedAnalyses::none();
  }
};

} // namespace

// === ModulePass wrapper that stops after first successful instrumentation ===
namespace {

struct SampleFlowSinkModulePass
    : public PassInfoMixin<SampleFlowSinkModulePass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
    errs() << "=== SampleFlowSinkModulePass::run called on module ===\n";

    auto &FAM =
        MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

    // Try each function until one succeeds
    for (Function &F : M) {
      if (F.isDeclaration())
        continue;

      // TODO:
      // if (F.getFile() != ...)

      errs() << "[sample-flow-sink-module] Trying function: " << F.getName()
             << "\n";

      // Run the function pass
      SampleFlowSinkPass FunctionPass;
      PreservedAnalyses PA = FunctionPass.run(F, FAM);

      // Check if instrumentation succeeded
      // If all analyses are preserved, nothing was modified
      if (!PA.areAllPreserved()) {
        errs()
            << "[sample-flow-sink-module] Successfully instrumented function: "
            << F.getName() << "\n";
        return PreservedAnalyses::none();
      }
    }

    errs() << "[sample-flow-sink-module] No function was instrumented\n";
    return PreservedAnalyses::all();
  }
};

} // namespace

// === Registration boilerplate ===
llvm::PassPluginLibraryInfo getSampleFlowSinkPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "SampleFlowSinkPass", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            errs() << "=== SampleFlowSinkPass PASS PLUGIN LOADED ===\n";

            // Register function pass
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

            // Register module pass
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "sample-flow-sink-module") {
                    errs() << "[SampleFlowSinkPass] Registering "
                              "SampleFlowSinkModulePass!\n";
                    MPM.addPass(SampleFlowSinkModulePass());
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
