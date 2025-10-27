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
    // In LLVM 20+, debug info can be in debug records (#dbg_declare) or
    // intrinsics. We need to find the variable that:
    // 1. Has the matching name
    // 2. Is in scope at TaintLine (check DILocalVariable line range)
    // 3. Is actually used/defined on TaintLine

    errs() << "[sample-flow-src] Searching for declaration of variable '"
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
                errs() << "[sample-flow-src]   Found candidate: " << *Address
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
              errs() << "[sample-flow-src]   Found candidate (intrinsic): "
                     << *AI << " declared at line " << DIVar->getLine() << "\n";
            }
          }
        }
      }
    }

    if (Candidates.empty()) {
      errs() << "[sample-flow-src] No variables named '" << VarName
             << "' found\n";
      return nullptr;
    }

    // Filter candidates: keep only those that are in scope at TaintLine
    // and are actually used on TaintLine
    Value *BestMatch = nullptr;
    DILocalVariable *BestDIVar = nullptr;

    for (auto [Address, DIVar] : Candidates) {
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
        if (!BestMatch || DIVar->getLine() > BestDIVar->getLine()) {
          BestMatch = Address;
          BestDIVar = DIVar;
          errs() << "[sample-flow-src]   Accepted as best match: " << *Address
                 << "\n";
        }
      } else {
        errs() << "[sample-flow-src]   Rejecting " << *Address
               << " - not used on line " << TaintLine << "\n";
      }
    }

    if (BestMatch) {
      errs() << "[sample-flow-src] Selected variable '" << VarName
             << "' declared at line " << BestDIVar->getLine()
             << ", address: " << *BestMatch << "\n";
    } else {
      errs() << "[sample-flow-src] No variable '" << VarName
             << "' is used on line " << TaintLine << "\n";
    }

    return BestMatch;
  }

  static void declareSamplingFunctions(Module &M, Function *&SampleInt,
                                       Function *&SampleDouble,
                                       Function *&SampleBytes) {
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
                                Function *&SampleBytes, Value *&Base,
                                Instruction *&LastWriter, AllocaInst *&AI,
                                Value *&Ptr, Type *&PointedToType) {
    // Initialize the sample call instruction pointer
    CallInst *SampleCall = nullptr;
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

      // Case 3: Array or buffer - use sample_bytes
    } else {
      errs()
          << "[sample-flow-src] Detected array/buffer - using sample_bytes\n";

      // Ensure we have a pointer
      if (!Ptr) {
        // Fallback: create GEP from base
        IRBuilder<> B(LastWriter->getParent());
        if (AI) {
          Ptr = B.CreateConstInBoundsGEP2_64(AI->getAllocatedType(), AI, 0, 0);
        } else {
          Ptr = Base;
        }
        errs() << "[sample-flow-src] Ptr from fallback: " << *Ptr << "\n";
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

      // Create and insert the sample_bytes call
      SampleCall = CallInst::Create(SampleBytes, {Ptr, Len});
      SampleCall->insertAfter(LastWriter);
    } // end case 3

    errs() << "[sample-flow-src] Inserted sample call: " << *SampleCall << "\n";
    errs() << "[sample-flow-src]   immediately after: " << *LastWriter << "\n";
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
             *SampleBytes = nullptr;

    declareSamplingFunctions(M, SampleInt, SampleDouble, SampleBytes);

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

    } else {
      // === Step 1 (recommended): find anchor instruction matching span ===
      errs() << "[sample-flow-src] Using line:col matching approach\n";

      // Find the LAST instruction matching the line:col, because complex
      // expressions like matrix[1][0] may generate multiple instructions
      // with the same debug location, and we want the final one closest
      // to the actual use.
      for (Instruction &I : instructions(F)) {
        if (DebugLoc DL = I.getDebugLoc()) {
          if (DL.getLine() == LineOpt && DL.getCol() >= ColStartOpt &&
              DL.getCol() <= ColEndOpt) {
            Anchor = &I;
            // Don't break - keep looking for later instructions
          }
        }
      }

      assert(Anchor && "[sample-flow-src] ERROR: Anchor instruction not found");

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

    // === Step 2: build statement slice ===
    SmallVector<Instruction *, 8> Slice = buildStmtSlice(Anchor);

    // === Step 3: find last writer in slice ===
    Instruction *LastWriter = findLastWriterInSlice(Slice, Base, AA);

    // === Step 4: insert sample call based on type ===
    // Strategy: Check if Base is an alloca and what type it allocates
    AllocaInst *AI = dyn_cast<AllocaInst>(Base);
    Type *AllocatedType = AI ? AI->getAllocatedType() : nullptr;

    if (AllocatedType) {
      errs() << "[sample-flow-src] Allocated type: " << *AllocatedType << "\n";
    }

    // Try to infer the pointed-to type from the pointer used in the
    // taint source. We need to determine:
    //   1. Ptr: The exact memory location being tainted
    //   2. PointedToType: The type of data at that location
    Value *Ptr = nullptr;
    Type *PointedToType = nullptr;
    findPointedToType(DL, Anchor, Base, AllocatedType, Ptr, PointedToType);

    // Finally, dispatch based on the pointed-to type
    insertSampleCalls(DL, Ctx, SampleInt, SampleDouble, SampleBytes, Base,
                      LastWriter, AI, Ptr, PointedToType);

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
