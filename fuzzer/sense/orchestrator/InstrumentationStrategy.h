//===----------------------------------------------------------------------===//
// InstrumentationStrategy.h - Generate opt commands for instrumentation
//===----------------------------------------------------------------------===//
//
// This component translates flow information and analysis results into
// concrete LLVM opt commands for instrumentation passes.
//
// Key responsibilities:
//   1. Generate opt commands for source instrumentation (SampleFlowSrcPass)
//   2. Generate opt commands for sink instrumentation (SampleFlowSinkPass)
//   3. Handle both line:col and var-name modes
//   4. Pass SRC_ID/SINK_ID to instrumentation passes
//   5. Manage opt invocation and error handling
//
// Command format examples:
//
// Source instrumentation (line:col mode):
//   opt -load-pass-plugin=./SampleFlowSrcPass.so \
//       -passes=sample-flow-src \
//       -sample-line=7 -sample-col-start=9 -sample-col-end=12 \
//       -sample-src-id=1 \
//       input.ll -S -o output.ll
//
// Source instrumentation (var-name mode):
//   opt -load-pass-plugin=./SampleFlowSrcPass.so \
//       -passes=sample-flow-src \
//       -sample-line=7 \
//       -sample-var-name=buf \
//       -sample-src-id=1 \
//       input.ll -S -o output.ll
//
// Sink instrumentation (similar structure with -sample-sink-id)
//
//===----------------------------------------------------------------------===//

#ifndef INSTRUMENTATIONSTRATEGY_H
#define INSTRUMENTATIONSTRATEGY_H

#include "ASTAnalyzer.h"
#include "FlowManager.h"
#include <string>
#include <vector>

namespace taint {

struct OptCommand {
  std::string command;        // Full opt command line
  std::string inputFile;      // Input LLVM IR file
  std::string outputFile;     // Output LLVM IR file
  int id;                     // SRC_ID or SINK_ID
  bool isSource;              // true = source, false = sink
  SourceLocation location;    // Location being instrumented
};

class InstrumentationStrategy {
public:
  InstrumentationStrategy(const std::string &passPluginDir,
                          const std::string &optPath = "opt")
      : passPluginDir(passPluginDir), optPath(optPath) {}

  // Generate source instrumentation command
  OptCommand generateSourceCommand(const SourceLocation &loc, int srcID,
                                   const InstrumentationInfo &info,
                                   const std::string &inputLL,
                                   const std::string &outputLL);

  // Generate sink instrumentation command
  OptCommand generateSinkCommand(const SourceLocation &loc, int sinkID,
                                 const InstrumentationInfo &info,
                                 const std::string &inputLL,
                                 const std::string &outputLL);

  // Execute an opt command
  bool executeCommand(const OptCommand &cmd, std::string &errorOutput);

  // Batch execution: run all commands in sequence
  bool executeAll(const std::vector<OptCommand> &commands);

  // Get/set opt path and plugin directory
  void setOptPath(const std::string &path) { optPath = path; }
  void setPassPluginDir(const std::string &dir) { passPluginDir = dir; }

private:
  std::string passPluginDir; // Directory containing .so files
  std::string optPath;       // Path to opt binary

  // Helper: Build opt command string
  std::string buildOptCommand(const std::string &passName,
                              const SourceLocation &loc,
                              const InstrumentationInfo &info, int id,
                              const std::string &inputLL,
                              const std::string &outputLL);

  // Helper: Execute shell command
  bool runShellCommand(const std::string &cmd, std::string &output);
};

} // namespace taint

#endif // INSTRUMENTATIONSTRATEGY_H
