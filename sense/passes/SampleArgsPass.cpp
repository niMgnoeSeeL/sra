#include "llvm/IR/Attributes.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Type.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

// ---------- CLI knobs ----------
static cl::opt<unsigned long long> SeedOpt(
    "sample-seed", cl::init(0x1234567890ABCDEFull),
    cl::desc("Seed for sampling runtime (default 0x1234567890ABCDEF)"));

static cl::opt<int> BudgetOpt(
    "sample-budget", cl::init(-1),
    cl::desc("Max number of samples per process (-1 = unlimited)"));

// Only sample these function names if non-empty (comma-separated)
static cl::opt<std::string> OnlyFnsOpt(
    "sample-only-fns", cl::init(""),
    cl::desc("Comma-separated list of function names to sample (default: all)"));

static bool nameAllowed(StringRef N) {
  if (OnlyFnsOpt.empty()) return true;
  SmallVector<StringRef, 8> Names;
  StringRef(OnlyFnsOpt).split(Names, ',');
  for (auto S : Names) if (S == N) return true;
  return false;
}

namespace {

struct SampleArgsFunctionPass : public PassInfoMixin<SampleArgsFunctionPass> {

  // Insert runtime decls (sample_seed, sample_set_budget, sample_int, sample_double, printf)
  static void ensureRuntimeDecls(Module &M, Function *&SampleSeed,
                                 Function *&SampleBudget, Function *&SampleInt,
                                 Function *&SampleDouble, Function *&Printf) {
    LLVMContext &Ctx = M.getContext();
    auto *VoidTy = Type::getVoidTy(Ctx);
    auto *I32Ty  = Type::getInt32Ty(Ctx);
    auto *I64Ty  = Type::getInt64Ty(Ctx);
    auto *F64Ty  = Type::getDoubleTy(Ctx);
    auto *CharPtrTy = PointerType::getUnqual(Type::getInt8Ty(Ctx));

    SampleSeed = cast<Function>(M.getOrInsertFunction(
        "sample_seed", FunctionType::get(VoidTy, {I64Ty}, false)).getCallee());
    SampleBudget = cast<Function>(M.getOrInsertFunction(
        "sample_set_budget", FunctionType::get(VoidTy, {I32Ty}, false)).getCallee());
    SampleInt = cast<Function>(M.getOrInsertFunction(
        "sample_int", FunctionType::get(I32Ty, {I32Ty}, false)).getCallee());
    SampleDouble = cast<Function>(M.getOrInsertFunction(
        "sample_double", FunctionType::get(F64Ty, {F64Ty}, false)).getCallee());
    Printf = cast<Function>(M.getOrInsertFunction(
        "printf", FunctionType::get(I32Ty, ArrayRef<Type*>{CharPtrTy}, true)).getCallee());
  }

  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    if (F.isDeclaration() || !nameAllowed(F.getName()))
      return PreservedAnalyses::all();

    Module &M = *F.getParent();
    Function *SampleSeed = nullptr, *SampleBudget = nullptr, *SampleInt = nullptr, *SampleDouble = nullptr, *Printf = nullptr;
    ensureRuntimeDecls(M, SampleSeed, SampleBudget, SampleInt, SampleDouble, Printf);

    // Insert at function entry
    BasicBlock &Entry = F.getEntryBlock();
    IRBuilder<> B(&*Entry.getFirstInsertionPt());
    
    // Runtime will initialize from environment variables automatically
    // No need to call seed/budget functions here

    // For each argument, if i32 or double, replace downstream uses with mutated value
    SmallVector<Argument*, 8> Args;
    for (auto &A : F.args()) Args.push_back(&A);

    bool Changed = false;

    for (Argument *A : Args) {
      Type *T = A->getType();
      Value *NewV = nullptr;

      if (T->isIntegerTy(32)) {
        // call i32 @mut_int(i32)
        NewV = B.CreateCall(SampleInt, A, A->getName() + ".mut");
      } else if (T->isDoubleTy()) {
        // call double @mut_double(double)
        NewV = B.CreateCall(SampleDouble, A, A->getName() + ".mut");
      } else {
        continue; // skip unsupported types in this minimal example
      }

      // Replace uses of argument with the mutated value.
      // The insertion point dominates the whole function entry, so RAUW is safe.
      A->replaceAllUsesWith(NewV);
      // But keep the call using the original A operand; restore the operand:
      cast<CallInst>(NewV)->setArgOperand(0, A);

      Changed = true;
    }

    // Instrument return statements to print return values
    if (nameAllowed(F.getName())) {
      for (auto &BB : F) {
        for (auto &I : BB) {
          if (auto *RetInst = dyn_cast<ReturnInst>(&I)) {
            Value *RetVal = RetInst->getReturnValue();
            if (RetVal) {
              IRBuilder<> RetBuilder(RetInst);
              Type *RetType = RetVal->getType();
              
              // Create format string and print call based on return type
              if (RetType->isIntegerTy(32)) {
                Constant *FmtStr = RetBuilder.CreateGlobalString(
                  "%d\n", ".str.mut.int");
                RetBuilder.CreateCall(Printf, {FmtStr, RetVal});
              } else if (RetType->isDoubleTy()) {
                Constant *FmtStr = RetBuilder.CreateGlobalString(
                  "%.6f\n", ".str.mut.double");
                RetBuilder.CreateCall(Printf, {FmtStr, RetVal});
              }
              Changed = true;
            }
          }
        }
      }
    }

    return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
  }
};

} // end anonymous namespace

// ---- Plugin entry point (new PM) ----
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {
    LLVM_PLUGIN_API_VERSION, "SampleArgsPass", "0.1",
    [](PassBuilder &PB) {
      // opt -passes="function(sample-args)"
      PB.registerPipelineParsingCallback(
          [](StringRef Name, FunctionPassManager &FPM,
             ArrayRef<PassBuilder::PipelineElement>) {
            if (Name == "sample-args") {
              FPM.addPass(SampleArgsFunctionPass{});
              return true;
            }
            return false;
          });
    }
  };
}