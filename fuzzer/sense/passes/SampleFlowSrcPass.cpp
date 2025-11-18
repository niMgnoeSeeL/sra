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
 *  1. **Line:Column Mode** (recommended): Uses source location spans from
 *      static analysis reports (e.g., CodeQL), see Workflow 1b.
 *  2. **Variable Name Mode** (fallback): Uses DILocalVariable debug info
 *     to identify the target variable by name, see Workflow 1a).
 *
 *  The pass supports multiple data types:
 *    • Scalar integers (i32) → sample_int(i32) returns i32
 *    • Scalar floats (double) → sample_double(double) returns double
 *    • Arrays/buffers → sample_bytes(ptr, i32) overwrites in-place
 *    • Struct fields (field-sensitive tainting) → sample_struct(ptr, Type)
 *
 *  Workflow:
 *  ---------
 *  1. **Locate the variable**:
 *     - a) Variable name mode: Search for DILocalVariable matching the name
 *          This is unrecommended due to potential shadowing and aliasing.
 *          It finds the BASE addresses of tainted definition conservatively.
 *     - b) Line:col mode: Find instruction at the specified source location
 *          (Recommended) Directly maps to the addressed that is tainted.
 *          This is more precise, e.g., for array/struct accesses.
 *     This step produces a BASE address and an ANCHOR instruction
 *
 *  2. **Build statement slice**: Collect all instructions on the same source
 *     line and lexical scope as the ANCHOR as a slice.
 *
 *  3. **Find last writer**: Within the statement slice, find the last writer to
 *     the BASE address (using alias analysis). This is the safe insertion point
 *     for the sampling call.
 *
 *  4. **Insert sampling call**:
 *     - For scalars: Load → Sample → Store (replaces value in-place)
 *     - For buffers: sample_bytes(ptr, size) after the taint source
 *     - TODO: For structs: need to implement a sample_struct(ptr, Type)
 *       function in the runtime
 *
 *  Usage:
 *  ------
 *      opt -load-pass-plugin ./libSampleFlowSrcPass.so \
 *          -passes=sample-flow-src \
 *          -sample-line=7 -sample-col-start=9 -sample-col-end=12 \
 *          flow_simple.ll -S -o flow_simple_sampled.ll
 *
 *  Notes:
 *  ------
 *    • The pass requires debug info (`-g`) to be present in the IR.
 *    • The sampling functions are declared if not already available.
 *    • The safe insertion point is determined conservatively:
 *         – last store or call that may modify the base object.
 *         – if none found, insertion happens at the end of the statement.
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
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"

using namespace llvm;

// TODO: refactor SampleFlowSrcPass::run

constexpr unsigned TargetLine = 7;
constexpr unsigned ColStart = 9;
constexpr unsigned ColEnd = 12;

static cl::opt<unsigned> LineOpt("src-line", cl::desc("Target line"),
                                 cl::init(TargetLine));
static cl::opt<unsigned> ColStartOpt("src-col-start", cl::desc("Column start"),
                                     cl::init(ColStart));
static cl::opt<unsigned> ColEndOpt("src-col-end", cl::desc("Column end"),
                                   cl::init(ColEnd));
static cl::opt<std::string>
    FileNameOpt("src-file",
                cl::desc("Target file path for disambiguation (e.g., "
                         "'src/main.c' or '/path/to/file.c')"),
                cl::init(""));
static cl::opt<std::string>
    VarNameOpt("src-var-name",
               cl::desc("Target variable name (e.g., 'x' from '&x')"),
               cl::init(""));
static cl::opt<int> SrcIDOpt("src-id", cl::desc("Source ID for flow tracking"),
                             cl::init(-1));
namespace {

struct SampleFlowSrcPass : public PassInfoMixin<SampleFlowSrcPass> {

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
    // Return first object found, or V itself if none found
    return const_cast<Value *>(Objects.empty() ? V : Objects[0]);
  }

  // === Helper: Infer the type that a GEP instruction points to ===
  // This distinguishes between:
  //   - Arrays: Return the whole array type (conservative taint)
  //   - Structs: Return the specific field type (field-sensitive taint)
  static Type *inferGEPPointedType(GetElementPtrInst *GEP,
                                   const DataLayout &DL) {
    Type *SourceType = GEP->getSourceElementType();
    errs() << "[sample-flow-src]   GEP source type: " << *SourceType << "\n";

    // Case 1: Array - taint the entire array conservatively
    // Example: GEP [16 x i8], ptr %buf, 0, 5 → taint whole [16 x i8]
    // Example: GEP [16 x [16 x i8]], ptr %buf, 0, 1, 3 → taint whole [16 x [16
    // x i8]] because we can't know which element is accessed
    if (SourceType->isArrayTy()) {
      errs() << "[sample-flow-src]   Array detected - using whole array type: "
             << *SourceType << "\n";
      return SourceType; // Return the full array type
    }

    // Case 2: Struct - taint only the specific field (field-sensitive)
    // Example: GEP %struct.Student, ptr %s, 0, 1 → taint only field 1 (age)
    if (SourceType->isStructTy()) {
      Type *CurType = SourceType;
      bool FirstIndex = true;

      for (auto IdxIt = GEP->idx_begin(); IdxIt != GEP->idx_end(); ++IdxIt) {
        if (FirstIndex) {
          FirstIndex = false;
          // Skip first index (pointer arithmetic, always 0 for struct access)
          continue;
        }

        // Apply struct field index
        if (auto *StructTy = dyn_cast<StructType>(CurType)) {
          if (auto *CI = dyn_cast<ConstantInt>(*IdxIt)) {
            unsigned FieldIdx = CI->getZExtValue();
            CurType = StructTy->getElementType(FieldIdx);
            errs() << "[sample-flow-src]   Struct field " << FieldIdx
                   << " type: " << *CurType << "\n";
          }
        } else if (auto *ArrTy = dyn_cast<ArrayType>(CurType)) {
          // Nested array in struct - return element type
          CurType = ArrTy->getElementType();
          errs() << "[sample-flow-src]   Nested array element type: "
                 << *CurType << "\n";
        }
      }

      errs() << "[sample-flow-src]   Struct field inferred type: " << *CurType
             << "\n";
      return CurType;
    }

    // Case 3: Vector
    // See https://llvm.org/docs/LangRef.html#vector-type
    // TODO: implement this
    if (SourceType->isVectorTy()) {
      errs() << "[sample-flow-src]   Vector type detected - not implemented\n";
      assert(false && "ERROR: Vector type handling not implemented");
    }

    // Case 4: Multi-dimensional array
    // Example: GEP [16 x [16 x i8]], ptr %buf, 0, 1 → [16 x i8] (one row)
    // We need to apply indices to see what sub-array we're accessing
    // Note: ndarray seems to go to isArrayTy(), is this needed?
    // So I commented it out for now.

    // Type *CurType = SourceType;
    // bool FirstIndex = true;

    // for (auto IdxIt = GEP->idx_begin(); IdxIt != GEP->idx_end(); ++IdxIt)
    // {
    //   if (FirstIndex) {
    //     FirstIndex = false;
    //     // Skip first index (pointer arithmetic)
    //     continue;
    //   }

    //   // For multi-dimensional arrays, apply the index
    //   if (auto *ArrTy = dyn_cast<ArrayType>(CurType)) {
    //     CurType = ArrTy->getElementType();
    //     errs() << "[sample-flow-src]   Multi-dim array element type: "
    //            << *CurType << "\n";
    //   }
    // }
    assert(false && "ERROR: Cannot infer PointedToType from GEP");
  }

  // === Helper: find variable by name using debug info ===
  static Value *findVariableByName(Function &F, StringRef VarName,
                                   unsigned TaintLine) {
    // Variables can be either:
    // 1. Local variables (DILocalVariable) attached to allocas
    // 2. Global variables (DIGlobalVariableExpression) in the module
    //
    // We need to find the variable that:
    // 1. Has the matching name
    // 2. Is in scope at TaintLine (for locals) or is accessible (for globals)
    // 3. Is actually used/defined on TaintLine

    Module &M = *F.getParent();
    errs() << "[sample-flow-src] Searching for declaration of variable '"
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
                errs() << "[sample-flow-src]   Found local candidate: "
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
                  << "[sample-flow-src]   Found local candidate (intrinsic): "
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
            errs() << "[sample-flow-src]   Found global candidate: "
                   << GV.getName() << " declared at line " << DIGV->getLine()
                   << "\n";
          }
        }
      }
    }

    // === Part 3: Filter LOCAL candidates ===
    Value *BestLocalMatch = nullptr;
    DILocalVariable *BestLocalDIVar = nullptr;

    for (auto [Address, DIVar] : LocalCandidates) {
      // Check 1: Variable must be declared before or at TaintLine
      if (DIVar->getLine() > TaintLine) {
        errs() << "[sample-flow-src]   Rejecting " << *Address
               << " - declared after taint line\n";
        continue;
      }

      // Check 2: Verify the variable (or its alias) is used on TaintLine
      bool UsedOnTaintLine = false;
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == TaintLine) {
            // Check if this instruction uses Address or an alias
            for (Use &U : I.operands()) {
              Value *Op = U.get();

              // Direct use
              if (Op == Address) {
                UsedOnTaintLine = true;
                break;
              }

              // Use through GEP or other pointer operations
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
        // Prefer the candidate with declaration closest to TaintLine
        // (handles shadowing - innermost scope wins)
        if (!BestLocalMatch || DIVar->getLine() > BestLocalDIVar->getLine()) {
          BestLocalMatch = Address;
          BestLocalDIVar = DIVar;
          errs() << "[sample-flow-src]   Accepted as best local match: "
                 << *Address << "\n";
        }
      } else {
        errs() << "[sample-flow-src]   Rejecting " << *Address
               << " - not used on line " << TaintLine << "\n";
      }
    }

    // === Part 4: Filter GLOBAL candidates ===
    GlobalVariable *BestGlobalMatch = nullptr;
    DIGlobalVariable *BestGlobalDIVar = nullptr;

    for (auto [GV, DIGV] : GlobalCandidates) {
      // Check: Verify the global (or its alias) is used on TaintLine
      bool UsedOnTaintLine = false;
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == TaintLine) {
            // Check if this instruction uses the global or an alias
            for (Use &U : I.operands()) {
              Value *Op = U.get();

              // Direct use
              if (Op == GV) {
                UsedOnTaintLine = true;
                break;
              }

              // Use through GEP or other pointer operations
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
        BestGlobalDIVar = DIGV;
        errs() << "[sample-flow-src]   Accepted as best global match: "
               << GV->getName() << "\n";
        break; // Only one global with this name should exist
      } else {
        errs() << "[sample-flow-src]   Rejecting global " << GV->getName()
               << " - not used on line " << TaintLine << "\n";
      }
    }

    // === Part 5: Return best match (prefer local over global for shadowing)
    // ===
    if (BestLocalMatch) {
      errs() << "[sample-flow-src] Selected LOCAL variable '" << VarName
             << "' declared at line " << BestLocalDIVar->getLine()
             << ", address: " << *BestLocalMatch << "\n";
      return BestLocalMatch;
    }

    if (BestGlobalMatch) {
      errs() << "[sample-flow-src] Selected GLOBAL variable '" << VarName
             << "' (" << BestGlobalMatch->getName() << ") declared at line "
             << BestGlobalDIVar->getLine() << "\n";
      return BestGlobalMatch;
    }

    errs() << "[sample-flow-src] No variable '" << VarName
           << "' is used on line " << TaintLine << "\n";
    return nullptr;
  }

  static void declareSamplingFunctions(Module &M, Function *&SampleInt,
                                       Function *&SampleDouble,
                                       Function *&SampleBytes,
                                       Function *&SampleReportSource) {
    LLVMContext &Ctx = M.getContext();

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

    // sample_report_source: void sample_report_source(ptr, i32, i32)
    // params: (data_ptr, size, src_id)
    FunctionCallee SampleReportSourceFn = M.getOrInsertFunction(
        "sample_report_source",
        FunctionType::get(Type::getVoidTy(Ctx),
                          {PointerType::getUnqual(Ctx), Type::getInt32Ty(Ctx),
                           Type::getInt32Ty(Ctx)},
                          false));
    SampleReportSource = cast<Function>(SampleReportSourceFn.getCallee());
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

    errs() << "[sample-flow-src] Statement slice (" << Slice.size()
           << " instrs):\n";
    for (auto *I : Slice)
      errs() << "  " << *I << "\n";
    return Slice;
  }

  static Instruction *
  findLastWriterInSlice(const SmallVectorImpl<Instruction *> &Slice,
                        Value *Base, AliasAnalysis &AA) {
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
    return LastWriter;
  }

  static void insertSampleCalls(const DataLayout &DL, LLVMContext &Ctx,
                                Function *&SampleInt, Function *&SampleDouble,
                                Function *&SampleBytes,
                                Function *&SampleReportSource, Value *&Base,
                                Instruction *&LastWriter, AllocaInst *&AI,
                                GlobalVariable *&GV, Value *&Ptr,
                                Type *&PointedToType, int srcID) {
    // Initialize the sample call instruction pointer
    CallInst *SampleCall = nullptr;
    Value *ReportPtr = nullptr;  // Pointer to report to sample_report_source
    Value *ReportSize = nullptr; // Size to report to sample_report_source

    // Case 1: Scalar integer (i32)
    if (PointedToType && PointedToType->isIntegerTy(32)) {
      errs() << "[sample-flow-src] Detected i32 scalar - using sample_int\n";

      // For scalars, we need to load from the pointer, sample, and store back
      // But the pointer might point to the field, not the base
      IRBuilder<> B(Ctx);
      B.SetInsertPoint(LastWriter->getParent(), ++LastWriter->getIterator());

      // Load current value from the pointer location
      LoadInst *OrigValue = B.CreateLoad(PointedToType, Ptr ? Ptr : Base);
      CallInst *SampledValue = B.CreateCall(SampleInt, {OrigValue});
      B.CreateStore(SampledValue, Ptr ? Ptr : Base);

      SampleCall = SampledValue;

      // Set up for report call
      ReportPtr = Ptr ? Ptr : Base;
      ReportSize = ConstantInt::get(Type::getInt32Ty(Ctx), 4); // sizeof(i32)

      // Case 2: Scalar double
    } else if (PointedToType && PointedToType->isDoubleTy()) {
      errs()
          << "[sample-flow-src] Detected double scalar - using sample_double\n";

      IRBuilder<> B(Ctx);
      B.SetInsertPoint(LastWriter->getParent(), ++LastWriter->getIterator());

      LoadInst *OrigValue = B.CreateLoad(PointedToType, Ptr ? Ptr : Base);
      CallInst *SampledValue = B.CreateCall(SampleDouble, {OrigValue});
      B.CreateStore(SampledValue, Ptr ? Ptr : Base);

      SampleCall = SampledValue;

      // Set up for report call
      ReportPtr = Ptr ? Ptr : Base;
      ReportSize = ConstantInt::get(Type::getInt32Ty(Ctx), 8); // sizeof(double)

      // Case 3: Array or buffer - use sample_bytes
    } else {
      errs()
          << "[sample-flow-src] Detected array/buffer - using sample_bytes\n";

      // Ensure we have a pointer
      if (!Ptr) {
        // Fallback: create GEP from base (works for both allocas and globals)
        IRBuilder<> B(LastWriter->getParent());
        if (AI) {
          Ptr = B.CreateConstInBoundsGEP2_64(AI->getAllocatedType(), AI, 0, 0);
          errs() << "[sample-flow-src] Ptr from alloca fallback: " << *Ptr
                 << "\n";
        } else if (GV) {
          Ptr = B.CreateConstInBoundsGEP2_64(GV->getValueType(), GV, 0, 0);
          errs() << "[sample-flow-src] Ptr from global fallback: " << *Ptr
                 << "\n";
        } else {
          Ptr = Base;
          errs() << "[sample-flow-src] Ptr from base fallback: " << *Ptr
                 << "\n";
        }
      }

      // Calculate size based on the pointed-to type (already inferred above)
      Value *Len = nullptr;
      if (PointedToType && PointedToType->isArrayTy()) {
        // For arrays, use the array size
        uint64_t NumElements = PointedToType->getArrayNumElements();
        uint64_t ElementSize =
            DL.getTypeAllocSize(PointedToType->getArrayElementType());
        uint64_t TotalSize = NumElements * ElementSize;
        Len = ConstantInt::get(Type::getInt32Ty(Ctx), TotalSize);
        errs() << "[sample-flow-src] Array size: " << TotalSize << " bytes\n";
      } else if (PointedToType && PointedToType->isSized()) {
        // For other sized types (structs, primitives, etc.), use the type size
        uint64_t TypeSize = DL.getTypeAllocSize(PointedToType);
        Len = ConstantInt::get(Type::getInt32Ty(Ctx), TypeSize);
        errs() << "[sample-flow-src] Type size: " << TypeSize << " bytes\n";
      } else {
        // Default size (fallback)
        Len = ConstantInt::get(Type::getInt32Ty(Ctx), 16);
        errs() << "[sample-flow-src] Using default size: 16 bytes\n";
      }

      // Insert sample_bytes call (does the actual sampling/mutation)
      SampleCall = CallInst::Create(SampleBytes, {Ptr, Len});
      SampleCall->insertAfter(LastWriter);

      // Set up for report call
      ReportPtr = Ptr;
      ReportSize = Len;
    } // end case 3

    errs() << "[sample-flow-src] Inserted sample call: " << *SampleCall << "\n";
    errs() << "[sample-flow-src]   immediately after: " << *LastWriter << "\n";

    // Add sample_report_source call if srcID is provided
    if (srcID >= 0 && SampleReportSource && ReportPtr && ReportSize) {
      Value *SrcIDVal = ConstantInt::get(Type::getInt32Ty(Ctx), srcID);
      CallInst *ReportCall = CallInst::Create(
          SampleReportSource, {ReportPtr, ReportSize, SrcIDVal});
      ReportCall->insertAfter(SampleCall);

      errs()
          << "[sample-flow-src] Inserted sample_report_source call with SRC_ID="
          << srcID << "\n";
      errs() << "[sample-flow-src]   " << *ReportCall << "\n";
    }
  }

  // Given a base address (allocation, for example), a function call, find the
  // call's argument that aliases the base
  // char buf[16]
  // read(fd, &buf, size) <--- return &buf
  static Value *findFuncArgAliasBase(Value *&Base, llvm::CallBase *&CB) {
    for (auto &Arg : CB->args()) {
      SmallVector<const Value *, 4> Objects;
      getUnderlyingObjects(Arg, Objects);
      for (auto *Obj : Objects) {
        if (Obj == Base) {
          errs() << "[sample-flow-src] Found argument aliasing with Base: "
                 << *Arg << "\n";
          return Arg;
          break;
        }
      }
    }
    return nullptr;
  }

  // Verify the call is anchor, by checking if any argument aliases the base
  // TODO: check if this also suffer from the failing alias analysis problem
  // when call arg is a scalar, AA doesn't see through it, needs IWA
  static Instruction *verifyCallWritesToBase(Value *&Base, Instruction &I,
                                             llvm::CallBase *&CB) {
    for (auto &Arg : CB->args()) {
      SmallVector<const Value *, 4> Objects;
      getUnderlyingObjects(Arg, Objects);
      for (auto *Obj : Objects) {
        if (Obj == Base) {
          errs() << "[sample-flow-src] Found taint source call: " << I << "\n";
          return &I;
        }
      }
    }
    return nullptr;
  }

  // Verify the store is anchor, by checking it writes to Base
  static Instruction *verifyStoreWritesToBase(Value *&Base, Instruction &I) {
    auto *Store = cast<StoreInst>(&I);
    SmallVector<const Value *, 4> Objects;
    getUnderlyingObjects(Store->getPointerOperand(), Objects);
    for (auto *Obj : Objects) {
      if (Obj == Base) {
        errs() << "[sample-flow-src] Found taint source store: " << I << "\n";
        return &I;
      }
    }
    return nullptr;
  }

  // Find the type pointed to by the pointer in the anchor instruction
  static void findPointedToType(const DataLayout &DL, Instruction *&Anchor,
                                Value *&Base, Type *&AllocatedType, Value *&Ptr,
                                Type *&PointedToType) {
    // === Case 1: Anchor is a GEP (line:col mode) ===
    // This happens when line:col mode finds an array/struct access directly
    // Example: matrix[1] or s.age where the GEP is the anchor instruction
    if (auto *GEP = dyn_cast<GetElementPtrInst>(Anchor)) {
      Ptr = GEP;
      PointedToType = inferGEPPointedType(GEP, DL);
      if (PointedToType) {
        errs() << "[sample-flow-src] Inferred pointed-to type from GEP: "
               << *PointedToType << "\n";
      }
    }
    // === Case 2: Anchor is a CallBase (both modes) ===
    // This happens when the taint source is a function call like read(),
    // fgets() And the anchor is mapped to the taint function call directly, not
    // a GEP Example: read(fd, &x, size) or fgets(buf, size, stdin)
    else if (auto *CB = dyn_cast<CallBase>(Anchor)) {
      // Find which argument aliases with Base (same technique as variable name
      // mode). We iterate through all arguments and check which one aliases
      // with our known Base allocation.
      Ptr = findFuncArgAliasBase(Base, CB);

      // === Sub-case 2a: The argument is itself a GEP ===
      // This happens when passing a field or array element to the taint source
      // Example: read(fd, &s.age, size) where &s.age is a GEP
      // Note: I don't think this case is actually reachable,
      // keep it here just in case
      if (Ptr) {
        if (auto *ArgGEP = dyn_cast<GetElementPtrInst>(Ptr)) {
          PointedToType = inferGEPPointedType(ArgGEP, DL);
          if (PointedToType) {
            errs()
                << "[sample-flow-src] Inferred pointed-to type from arg GEP: "
                << *PointedToType << "\n";
          }
        }
      }
    } else if (auto *Load = dyn_cast<LoadInst>(Anchor)) {
      // === Case 3: Anchor is a Load instruction ===
      // This happens when a direct pointer is passed to the taint source
      // Example:
      // void read_data(int fd, char *buf, int size) {
      //   read(fd, buf, size); // Anchor is the load of 'buf'
      // }
      // here buf is passes directly to read, there is no need for GEP,
      // and the load of buf is the anchor instruction
      // This is actually good because we can avoid scanning the arguments for
      // alias of Base
      Ptr = Load->getPointerOperand();

      // Infer the pointed-to type directly from the load's pointer operand type
      PointedToType = Ptr->getType();
      errs() << "[sample-flow-src] Inferred pointed-to type from Load ptr: "
             << *PointedToType << "\n";
    }

    // === Fallback: The argument is the base allocation directly ===
    // This happens with simple variables passed to taint source
    // Example: read(fd, &x, size) where &x is just the alloca
    // PointedToType will be set by the fallback below
    if (!PointedToType && AllocatedType) {
      PointedToType = AllocatedType;
      errs() << "[sample-flow-src] Using allocated type as fallback: "
             << *PointedToType << "\n";
    }
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
             *SampleBytes = nullptr, *SampleReportSource = nullptr;

    declareSamplingFunctions(M, SampleInt, SampleDouble, SampleBytes,
                             SampleReportSource);

    Instruction *Anchor = nullptr;
    Value *Base = nullptr;

    // === Step 1 (recommended): find anchor instruction matching span ===
    errs() << "[sample-flow-src] Try using line:col matching approach\n";

    // Find the LAST instruction matching the line:col, because complex
    // expressions like matrix[1][0] may generate multiple instructions
    // with the same debug location, and we want the final one closest
    // to the actual use.
    for (Instruction &I : instructions(F)) {
      if (DebugLoc DL = I.getDebugLoc()) {
        if (matchesFilename(DL, FileNameOpt.getValue()) &&
            DL.getLine() == LineOpt && DL.getCol() >= ColStartOpt &&
            DL.getCol() <= ColEndOpt) {
          Anchor = &I;
          // Don't break - keep looking for later instructions
        }
      }
    }

    if (!Anchor)
      goto fallback;

    errs() << "[sample-flow-src] Found anchor: " << *Anchor << "\n";

    // === Step 1b: identify base object (alloca/global) ===
    if (auto *GEP = dyn_cast<GetElementPtrInst>(Anchor))
      Base = getBaseObject(GEP, DL);
    else if (auto *Call = dyn_cast<CallBase>(Anchor)) {
      // Note: For now, for calls, we don't know which argument the line:col
      // spans. Always fallback to varname mode for correct identification.
      Base = nullptr;
      errs() << "[sample-flow-src] CallBase anchor - forcing varname "
                "fallback\n";
    } else if (auto *Load = dyn_cast<LoadInst>(Anchor)) {
      Base = getBaseObject(Load->getPointerOperand(), DL);
    }
    // if (!Base)
    //   return PreservedAnalyses::all();

    // fallback
  fallback:
    if (!Anchor || !Base) {
      errs() << "[sample-flow-src] Fallback to using "
                "DILocalVariable/DIGlobalVariable approach "
                "with var name: "
             << VarNameOpt << "\n";

      // Find the variable directly using debug info
      Base = findVariableByName(F, VarNameOpt, LineOpt);

      if (!Base) {
        errs() << "[sample-flow-src] Could not find variable '" << VarNameOpt
               << "' at line " << LineOpt << ", skipping function\n";
        return PreservedAnalyses::all();
      }

      // Now find the ANCHOR: taint instruction (the last writer on line)
      // line)
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == LineOpt) {
            // Case 1: CallBase that writes to Base via an argument (e.g.,
            // fgets)
            if (auto *CB = dyn_cast<CallBase>(&I)) {
              // Check if any argument aliases with Base
              Anchor = verifyCallWritesToBase(Base, I, CB);
            }

            // Case 2: Store that writes to Base (e.g., for scalar variables)
            if (!Anchor && isa<StoreInst>(&I)) {
              Anchor = verifyStoreWritesToBase(Base, I);
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
    }

    errs() << "[sample-flow-src] Base object: " << *Base << "\n";

    // === Step 2: build statement slice ===
    SmallVector<Instruction *, 8> Slice = buildStmtSlice(Anchor);

    // === Step 3: find last writer in slice ===
    Instruction *LastWriter = findLastWriterInSlice(Slice, Base, AA);

    // === Step 4: insert sample call based on type ===
    // Strategy: Check if Base is an alloca or global and what type it has
    AllocaInst *AI = dyn_cast<AllocaInst>(Base);
    GlobalVariable *GV = dyn_cast<GlobalVariable>(Base);
    Type *AllocatedType = nullptr;

    if (AI) {
      AllocatedType = AI->getAllocatedType();
      errs() << "[sample-flow-src] Base is alloca, allocated type: "
             << *AllocatedType << "\n";
    } else if (GV) {
      AllocatedType = GV->getValueType();
      errs() << "[sample-flow-src] Base is global, value type: "
             << *AllocatedType << "\n";
    }

    // Try to infer the pointed-to type from the pointer used in the
    // taint source. We need to determine:
    //   1. Ptr: The exact memory location being tainted
    //   2. PointedToType: The type of data at that location
    Value *Ptr = nullptr;
    Type *PointedToType = nullptr;
    findPointedToType(DL, Anchor, Base, AllocatedType, Ptr, PointedToType);

    // Abort: we do not support sampling pointer types
    if (PointedToType && PointedToType->isPointerTy()) {
      errs()
          << "[sample-flow-src] Pointer types are not supported for sampling\n";
      return PreservedAnalyses::all();
    }

    // Finally, dispatch based on the pointed-to type
    insertSampleCalls(DL, Ctx, SampleInt, SampleDouble, SampleBytes,
                      SampleReportSource, Base, LastWriter, AI, GV, Ptr,
                      PointedToType, SrcIDOpt);

    return PreservedAnalyses::none();
  }
};

} // namespace

// === ModulePass wrapper that stops after first successful instrumentation ===
namespace {

struct SampleFlowSrcModulePass : public PassInfoMixin<SampleFlowSrcModulePass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &MAM) {
    errs() << "=== SampleFlowSrcModulePass::run called on module ===\n";

    auto &FAM =
        MAM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();

    // Try each function until one succeeds
    for (Function &F : M) {
      if (F.isDeclaration())
        continue;

      // TODO:
      // if (F.getFile() != ...)

      errs() << "[sample-flow-src-module] Trying function: " << F.getName()
             << "\n";

      // Run the function pass
      SampleFlowSrcPass FunctionPass;
      PreservedAnalyses PA = FunctionPass.run(F, FAM);

      // Check if instrumentation succeeded
      // If all analyses are preserved, nothing was modified
      if (!PA.areAllPreserved()) {
        errs()
            << "[sample-flow-src-module] Successfully instrumented function: "
            << F.getName() << "\n";
        return PreservedAnalyses::none();
      }
    }

    errs() << "[sample-flow-src-module] No function was instrumented\n";
    return PreservedAnalyses::all();
  }
};

} // namespace

// === Registration boilerplate ===
llvm::PassPluginLibraryInfo getSamplePassPluginInfo() {
  return {
      LLVM_PLUGIN_API_VERSION, "SampleFlowSrcPass", LLVM_VERSION_STRING,
      [](PassBuilder &PB) {
        errs() << "=== SampleFlowSrcPass PASS PLUGIN LOADED ===\n";

        // Register function pass
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

        // Register module pass
        PB.registerPipelineParsingCallback(
            [](StringRef Name, ModulePassManager &MPM,
               ArrayRef<PassBuilder::PipelineElement>) {
              if (Name == "sample-flow-src-module") {
                errs() << "[SampleFlowSrcPass] Registering "
                          "SampleFlowSrcModulePass!\n";
                MPM.addPass(SampleFlowSrcModulePass());
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
