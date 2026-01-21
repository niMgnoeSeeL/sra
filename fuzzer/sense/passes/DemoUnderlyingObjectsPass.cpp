//===- DemoUnderlyingObjectsPass.cpp - Demo getUnderlyingObjects --------===//
//
// This pass demonstrates that getUnderlyingObjects does NOT trace through
// loads. It analyzes calls to sink_function() and shows what underlying
// objects are found for each argument.
//
//===---------------------------------------------------------------------===//

#include "llvm/Analysis/MemoryBuiltins.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DebugProgramInstruction.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

using namespace llvm;

namespace {

struct DemoUnderlyingObjectsPass
    : public PassInfoMixin<DemoUnderlyingObjectsPass> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    errs() << "\n=== DemoUnderlyingObjectsPass on function: " << F.getName()
           << " ===\n";

    // Find all allocas first (these are our "base objects")
    errs() << "\n[ALLOCAS IN FUNCTION]\n";
    for (Instruction &I : instructions(F)) {
      if (auto *AI = dyn_cast<AllocaInst>(&I)) {
        errs() << "  " << *AI << "\n";
      }
    }

    // Now find calls to sink_function
    for (Instruction &I : instructions(F)) {
      if (auto *Call = dyn_cast<CallInst>(&I)) {
        Function *Callee = Call->getCalledFunction();
        if (!Callee || Callee->getName() != "sink_function")
          continue;

        errs() << "\n[FOUND CALL]\n";
        errs() << "  " << *Call << "\n";
        errs() << "  Callee: " << Callee->getName() << "\n";

        // Analyze each argument
        for (auto &Arg : Call->args()) {
          errs() << "\n  [ARGUMENT]\n";
          errs() << "    Value: " << *Arg << "\n";
          errs() << "    Type: " << *Arg->getType() << "\n";

          // Check if it's a load instruction
          if (auto *Load = dyn_cast<LoadInst>(Arg)) {
            errs() << "    ✓ This argument IS a LoadInst\n";
            errs() << "    Load's pointer operand: "
                   << *Load->getPointerOperand() << "\n";

            // Check if pointer operand is an alloca
            if (auto *AI = dyn_cast<AllocaInst>(Load->getPointerOperand())) {
              errs() << "    ✓ Loads FROM alloca: " << *AI << "\n";
            } else {
              errs() << "    ✗ Does NOT load from a direct alloca\n";
            }
          } else {
            errs() << "    ✗ This argument is NOT a LoadInst\n";
          }

          // NOW: Call getUnderlyingObjects on the argument
          errs() << "\n    [CALLING getUnderlyingObjects on argument]\n";
          SmallVector<const Value *, 4> Objects;
          getUnderlyingObjects(Arg, Objects);

          errs() << "    getUnderlyingObjects returned " << Objects.size()
                 << " object(s):\n";
          for (const Value *Obj : Objects) {
            errs() << "      → " << *Obj << "\n";

            // Check what type of value this is
            if (isa<AllocaInst>(Obj)) {
              errs() << "        (This is an AllocaInst - a BASE object)\n";
            } else if (isa<LoadInst>(Obj)) {
              errs() << "        (This is a LoadInst - NOT a base object!)\n";
              errs()
                  << "        ⚠️  getUnderlyingObjects STOPPED at the load!\n";
            } else if (isa<Argument>(Obj)) {
              errs() << "        (This is a function Argument)\n";
            } else {
              errs() << "        (Type: " << Obj->getValueName() << ")\n";
            }
          }

          // Summary
          errs() << "\n    [SUMMARY]\n";
          if (auto *Load = dyn_cast<LoadInst>(Arg)) {
            Value *LoadFrom = Load->getPointerOperand();
            bool FoundLoadFrom = false;
            for (const Value *Obj : Objects) {
              if (Obj == LoadFrom) {
                FoundLoadFrom = true;
                break;
              }
            }

            if (FoundLoadFrom) {
              errs() << "    ✓ getUnderlyingObjects found the alloca we load "
                        "FROM\n";
            } else {
              errs() << "    ✗ getUnderlyingObjects DID NOT find the alloca we "
                        "load FROM\n";
              errs() << "    ✗ It only returned the LoadInst itself: " << *Arg
                     << "\n";
              errs() << "    ✗ To trace through the load, you must manually "
                        "check:\n";
              errs() << "         if (auto *L = dyn_cast<LoadInst>(Arg))\n";
              errs() << "           "
                        "getUnderlyingObjects(L->getPointerOperand(), ...)\n";
            }
          }
        }
      }
    }

    errs() << "\n=== End of DemoUnderlyingObjectsPass ===\n\n";
    return PreservedAnalyses::all();
  }
};

} // namespace

//-----------------------------------------------------------------------------
// New PM Registration
//-----------------------------------------------------------------------------
llvm::PassPluginLibraryInfo getDemoUnderlyingObjectsPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "DemoUnderlyingObjectsPass",
          LLVM_VERSION_STRING, [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "demo-underlying") {
                    FPM.addPass(DemoUnderlyingObjectsPass());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getDemoUnderlyingObjectsPassPluginInfo();
}
