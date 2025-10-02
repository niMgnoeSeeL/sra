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
    "mut-seed", cl::init(0xC0FFEEULL),
    cl::desc("Seed for mutator runtime (default 0xC0FFEE)"));

static cl::opt<int> BudgetOpt(
    "mut-budget", cl::init(-1),
    cl::desc("Max number of mutations per process (-1 = unlimited)"));

// Only mutate these function names if non-empty (comma-separated)
static cl::opt<std::string> OnlyFnsOpt(
    "mut-only-fns", cl::init(""),
    cl::desc("Comma-separated list of function names to mutate (default: all)"));

static bool nameAllowed(StringRef N) {
  if (OnlyFnsOpt.empty()) return true;
  SmallVector<StringRef, 8> Names;
  StringRef(OnlyFnsOpt).split(Names, ',');
  for (auto S : Names) if (S == N) return true;
  return false;
}

namespace {

struct MutArgsFunctionPass : public PassInfoMixin<MutArgsFunctionPass> {

  // Insert runtime decls (mut_seed, mut_set_budget, mut_int, mut_double, printf)
  static void insrtLibFuncDecls(Module &M, Function *&MutSeed,
                                 Function *&MutBudget, Function *&MutInt,
                                 Function *&MutDouble, Function *&Printf) {
    LLVMContext &Ctx = M.getContext();
    auto *VoidTy = Type::getVoidTy(Ctx);
    auto *I32Ty  = Type::getInt32Ty(Ctx);
    auto *I64Ty  = Type::getInt64Ty(Ctx);
    auto *F64Ty  = Type::getDoubleTy(Ctx);
    auto *CharPtrTy = PointerType::getUnqual(Type::getInt8Ty(Ctx));

    MutSeed = cast<Function>(M.getOrInsertFunction(
        "mut_seed", FunctionType::get(VoidTy, {I64Ty}, false)).getCallee());
    MutBudget = cast<Function>(M.getOrInsertFunction(
        "mut_set_budget", FunctionType::get(VoidTy, {I32Ty}, false)).getCallee());
    MutInt = cast<Function>(M.getOrInsertFunction(
        "mut_int", FunctionType::get(I32Ty, {I32Ty}, false)).getCallee());
    MutDouble = cast<Function>(M.getOrInsertFunction(
        "mut_double", FunctionType::get(F64Ty, {F64Ty}, false)).getCallee());
    Printf = cast<Function>(M.getOrInsertFunction(
        "printf", FunctionType::get(I32Ty, ArrayRef<Type*>{CharPtrTy}, true)).getCallee());
  }

  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    if (F.isDeclaration() || !nameAllowed(F.getName()))
      return PreservedAnalyses::all();

    Module &M = *F.getParent();
    Function *MutSeed = nullptr, *MutBudget = nullptr, *MutInt = nullptr, *MutDouble = nullptr, *Printf = nullptr;
    insrtLibFuncDecls(M, MutSeed, MutBudget, MutInt, MutDouble, Printf);

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
        NewV = B.CreateCall(MutInt, A, A->getName() + ".mut");
      } else if (T->isDoubleTy()) {
        // call double @mut_double(double)
        NewV = B.CreateCall(MutDouble, A, A->getName() + ".mut");
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
                Constant *FuncName = RetBuilder.CreateGlobalString(
                  F.getName(), ".str.mut.fname");
                RetBuilder.CreateCall(Printf, {FmtStr, FuncName, RetVal});
              } else if (RetType->isDoubleTy()) {
                Constant *FmtStr = RetBuilder.CreateGlobalString(
                  "%.6f\n", ".str.mut.double");
                Constant *FuncName = RetBuilder.CreateGlobalString(
                  F.getName(), ".str.mut.fname");
                RetBuilder.CreateCall(Printf, {FmtStr, FuncName, RetVal});
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
    LLVM_PLUGIN_API_VERSION, "MutArgsPass", "0.1",
    [](PassBuilder &PB) {
      // opt -passes="function(mut-args)"
      PB.registerPipelineParsingCallback(
          [](StringRef Name, FunctionPassManager &FPM,
             ArrayRef<PassBuilder::PipelineElement>) {
            if (Name == "mut-args") {
              FPM.addPass(MutArgsFunctionPass{});
              return true;
            }
            return false;
          });
    }
  };
}
