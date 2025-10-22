#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

struct DummyIOFunctionPass : public PassInfoMixin<DummyIOFunctionPass> {

  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    errs() << "=== DummyIOFunctionPass::run called on function: " << F.getName() << " ===\n";
    
    // Skip if this is a declaration or an intrinsic
    if (F.isDeclaration() || F.isIntrinsic()) {
      errs() << "    Skipping declaration/intrinsic function: " << F.getName() << "\n";
      return PreservedAnalyses::all();
    }

    // Print to stderr during compilation - this proves the pass is running
    errs() << "*** DUMMY PASS LOADED AND RUNNING *** Processing function: " << F.getName() << "\n";
    
    // Also print some basic info
    errs() << "    Function has " << F.size() << " basic blocks\n";
    errs() << "    Function has " << F.arg_size() << " arguments\n";

    return PreservedAnalyses::all();
  }
};

struct DummyIOModulePass : public PassInfoMixin<DummyIOModulePass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    FunctionAnalysisManager &FAM = AM.getResult<FunctionAnalysisManagerModuleProxy>(M).getManager();
    
    for (Function &F : M) {
      if (!F.isDeclaration() && !F.isIntrinsic()) {
        DummyIOFunctionPass().run(F, FAM);
      }
    }
    
    return PreservedAnalyses::none();
  }
};

} // anonymous namespace

// Register the pass
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {
    LLVM_PLUGIN_API_VERSION, "DummyIOPass", LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
      // Print when the plugin is loaded
      errs() << "=== DUMMY PASS PLUGIN LOADED ===\n";
      
      // Register to run automatically in optimization pipelines
      // This is triggered when clang/afl-cc -fpass-plugin=$WORK/utils/DummyIOPass.so 
      // uses any optimization flag or not at all.
      PB.registerPipelineStartEPCallback(
        [](ModulePassManager &MPM, OptimizationLevel Level) {
          errs() << "=== Pipeline start callback - adding DummyIOModulePass ===\n";
          MPM.addPass(DummyIOModulePass());
        });
    }
  };
}