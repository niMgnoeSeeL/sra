//===- PointeeRecoveryPass.cpp - Demo pass for PointeeBaseRecovery -------===//
//
// LLVM 20 pass plugin: Demonstration of PointeeBaseRecovery utility
//
// PURPOSE:
//  Demo pass showing how to use PointeeBaseRecovery to trace pointer
//  arguments back to their base allocations using MemorySSA + alias analysis.
//
// USAGE:
//  opt -load-pass-plugin=./PointeeRecoveryPass.so \
//      -passes="recover-pointee-bases" \
//      --recover-pointee-only-calls-to="function_name" \
//      --recover-pointee-verbose \
//      input.ll -S -o /dev/null
//
// SEE: PointeeBaseRecovery.h for the reusable utility implementation
//
//===----------------------------------------------------------------------===//

#include "PointeeBaseRecovery.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

static cl::opt<std::string>
    TargetCallee("recover-pointee-only-calls-to",
                 cl::desc("Only analyze calls to this callee name (empty=all)"),
                 cl::init(""));

static cl::opt<unsigned> MaxDepth(
    "recover-pointee-max-depth",
    cl::desc("Max recursion depth when chasing through memory/phi/select"),
    cl::init(16));

static cl::opt<unsigned> MaxMemPhiFanout(
    "recover-pointee-max-memphi-fanout",
    cl::desc("Cap number of MemoryPhi incomings explored (0=unlimited)"),
    cl::init(64));

static cl::opt<bool>
    VerboseDebug("recover-pointee-verbose",
                 cl::desc("Enable verbose debug output for pointer recovery"),
                 cl::init(false));

namespace {

/// Utility: try to get a stable "name-ish" string for printing.
static void printValueBrief(raw_ostream &OS, const Value *V) {
  if (!V) {
    OS << "<null>";
    return;
  }
  if (V->hasName())
    OS << "%" << V->getName();
  else
    OS << "<unnamed>";
  OS << " : ";
  V->getType()->print(OS);
}

class RecoverPointeeBasesPass : public PassInfoMixin<RecoverPointeeBasesPass> {
public:
  // This is an analysis/printing pass, not an optimization, so run even on
  // optnone
  static bool isRequired() { return true; }

  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    errs() << "=== RecoverPointeeBasesPass::run called on function: "
           << F.getName() << " ===\n";
    if (F.isDeclaration())
      return PreservedAnalyses::all();

    auto &AA = FAM.getResult<AAManager>(F);
    auto &MSSA = FAM.getResult<MemorySSAAnalysis>(F).getMSSA();

    // Ensure MemorySSA uses are optimized with alias analysis
    // This makes getOptimized() skip NoAlias stores automatically
    MSSA.ensureOptimizedUses();

    // Create configuration from command-line options
    PointeeRecoveryConfig Config(MaxDepth, MaxMemPhiFanout, VerboseDebug);

    // Create the recoverer with our config
    PointeeBaseRecoverer Recoverer(F, AA, MSSA, Config);

    for (BasicBlock &BB : F) {
      for (Instruction &I : BB) {
        auto *CB = dyn_cast<CallBase>(&I);
        if (!CB)
          continue;

        Function *Callee = CB->getCalledFunction();
        if (!TargetCallee.empty()) {
          if (!Callee || Callee->getName() != TargetCallee)
            continue;
        }

        errs() << "\n[recover-pointee-bases] In function " << F.getName()
               << " at: " << I << "\n";

        for (unsigned ai = 0; ai < CB->arg_size(); ++ai) {
          Value *Arg = CB->getArgOperand(ai);
          if (!Arg->getType()->isPointerTy())
            continue;

          SmallPtrSet<const Value *, 16> Bases;
          Recoverer.recoverBases(Arg, &I, Bases);

          errs() << "  Arg#" << ai << " ";
          printValueBrief(errs(), Arg);
          errs() << "\n";

          if (Bases.empty()) {
            errs() << "    Bases: <none>\n";
            continue;
          }

          errs() << "    Bases (" << Bases.size() << "):\n";
          for (const Value *B : Bases) {
            errs() << "      - " << *B << "\n";
          }
        }
      }
    }

    // We only print; we don't mutate IR.
    return PreservedAnalyses::all();
  }
};

} // namespace

//-----------------------------------------------------------------------------
// Pass plugin registration
//-----------------------------------------------------------------------------
llvm::PassPluginLibraryInfo getPointeeRecoveryPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "RecoverPointeeBasesPass", "0.1",
          [](PassBuilder &PB) {
            errs() << "=== RecoverPointeeBasesPass PASS PLUGIN LOADED ===\n";

            // Register for module pass pipeline (implicit mode:
            // -passes=recover-pointee-bases)
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "recover-pointee-bases") {
                    MPM.addPass(createModuleToFunctionPassAdaptor(
                        RecoverPointeeBasesPass()));
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getPointeeRecoveryPassPluginInfo();
}
