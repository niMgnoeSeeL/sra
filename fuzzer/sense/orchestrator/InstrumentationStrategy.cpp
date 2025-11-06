//===----------------------------------------------------------------------===//
// InstrumentationStrategy.cpp - Implementation of opt command generation
//===----------------------------------------------------------------------===//

#include "InstrumentationStrategy.h"
#include <array>
#include <cstdio>
#include <filesystem>
#include <iostream>
#include <memory>
#include <sstream>

namespace fs = std::filesystem;

namespace taint {

OptCommand InstrumentationStrategy::generateSourceCommand(
    const SourceLocation &loc, int srcID, const InstrumentationInfo &info,
    const std::string &inputLL, const std::string &outputLL) {
  OptCommand cmd;
  cmd.command =
      buildOptCommand("sample-flow-src", loc, info, srcID, inputLL, outputLL);
  cmd.inputFile = inputLL;
  cmd.outputFile = outputLL;
  cmd.id = srcID;
  cmd.isSource = true;
  cmd.location = loc;

  std::cout << "[InstrumentationStrategy] Generated source command for SRC_ID="
            << srcID << ":\n  " << cmd.command << "\n";
  return cmd;
}

OptCommand InstrumentationStrategy::generateSinkCommand(
    const SourceLocation &loc, int sinkID, const InstrumentationInfo &info,
    const std::string &inputLL, const std::string &outputLL) {
  OptCommand cmd;
  cmd.command =
      buildOptCommand("sample-flow-sink", loc, info, sinkID, inputLL, outputLL);
  cmd.inputFile = inputLL;
  cmd.outputFile = outputLL;
  cmd.id = sinkID;
  cmd.isSource = false;
  cmd.location = loc;

  std::cout << "[InstrumentationStrategy] Generated sink command for SINK_ID="
            << sinkID << ":\n  " << cmd.command << "\n";
  return cmd;
}

OptCommand
InstrumentationStrategy::generateCoverageCommand(const std::string &flowDbPath,
                                                 const std::string &inputLL,
                                                 const std::string &outputLL) {
  OptCommand cmd;
  cmd.inputFile = inputLL;
  cmd.outputFile = outputLL;
  cmd.id = -1;          // No specific ID for coverage pass
  cmd.isSource = false; // Not a source or sink

  // Build opt command for DataFlowCoveragePass
  std::ostringstream oss;

  fs::path passPlugin = fs::path(passPluginDir) / "DataFlowCoveragePass.so";

  oss << optPath << " -load-pass-plugin=" << passPlugin
      << " -passes=df-coverage"
      << " -df-flow-db=" << flowDbPath << " " << inputLL << " -S -o "
      << outputLL;

  cmd.command = oss.str();

  std::cout << "[InstrumentationStrategy] Generated coverage command:\n  ";
  std::cout << cmd.command << "\n";

  return cmd;
}

bool InstrumentationStrategy::executeCommand(const OptCommand &cmd,
                                             std::string &errorOutput) {
  std::cout << "[InstrumentationStrategy] Executing: " << cmd.command << "\n";

  bool success = runShellCommand(cmd.command, errorOutput);

  if (success) {
    if (cmd.id >= 0) {
      // Source or sink instrumentation
      std::cout << "[InstrumentationStrategy] Successfully instrumented "
                << (cmd.isSource ? "source" : "sink") << " at "
                << cmd.location.toString() << "\n";
    } else {
      // Coverage or other instrumentation
      std::cout << "[InstrumentationStrategy] Successfully completed "
                   "instrumentation\n";
    }
  } else {
    if (cmd.id >= 0) {
      std::cerr << "[InstrumentationStrategy] ERROR: Instrumentation failed at "
                << cmd.location.toString() << "\n";
    } else {
      std::cerr << "[InstrumentationStrategy] ERROR: Instrumentation failed\n";
    }
    std::cerr << "  Command: " << cmd.command << "\n";
    std::cerr << "  Error output: " << errorOutput << "\n";
  }

  return success;
}

bool InstrumentationStrategy::executeAll(
    const std::vector<OptCommand> &commands) {
  int successCount = 0;
  int failCount = 0;

  for (const auto &cmd : commands) {
    std::string errorOutput;
    if (executeCommand(cmd, errorOutput)) {
      successCount++;
    } else {
      failCount++;
    }
  }

  std::cout << "\n[InstrumentationStrategy] Batch execution complete:\n";
  std::cout << "  Success: " << successCount << "\n";
  std::cout << "  Failed: " << failCount << "\n";

  return failCount == 0;
}

std::string InstrumentationStrategy::buildOptCommand(
    const std::string &passName, const SourceLocation &loc,
    const InstrumentationInfo &info, int id, const std::string &inputLL,
    const std::string &outputLL) {
  std::ostringstream oss;

  // Build pass plugin path
  std::string passPlugin;
  if (passName == "sample-flow-src") {
    passPlugin = fs::path(passPluginDir) / "SampleFlowSrcPass.so";
  } else if (passName == "sample-flow-sink") {
    passPlugin = fs::path(passPluginDir) / "SampleFlowSinkPass.so";
  } else {
    passPlugin = fs::path(passPluginDir) / (passName + ".so");
  }

  // Base opt command
  oss << optPath << " -load-pass-plugin=" << passPlugin
      << " -passes=" << passName;

  // Always add line parameter
  oss << " -sample-line=" << loc.line;

  // Add column parameters for line:col mode
  oss << " -sample-col-start=" << loc.colStart
      << " -sample-col-end=" << loc.colEnd;

  // Add variable name if available (fallback mode)
  if (!info.varName.empty()) {
    oss << " -sample-var-name=" << info.varName;
  }

  // Add ID parameter
  if (passName == "sample-flow-src") {
    oss << " -sample-src-id=" << id;
  } else if (passName == "sample-flow-sink") {
    oss << " -sample-sink-id=" << id;
  }

  // Input/output files
  oss << " " << inputLL << " -S -o " << outputLL;

  return oss.str();
}

bool InstrumentationStrategy::runShellCommand(const std::string &cmd,
                                              std::string &output) {
  output.clear();

  // Use popen to capture output
  std::array<char, 128> buffer;
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd.c_str(), "r"),
                                                pclose);

  if (!pipe) {
    output = "Failed to execute command";
    return false;
  }

  // Read command output
  while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
    output += buffer.data();
  }

  // Check exit status
  int exitStatus = pclose(pipe.release());
  return (exitStatus == 0);
}

} // namespace taint
