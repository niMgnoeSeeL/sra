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
    bool dynamicTracking, const std::string &inputLL,
    const std::string &outputLL) {
  OptCommand cmd;
  cmd.command = buildOptCommand("sample-flow-src-module", loc, info, srcID,
                                dynamicTracking, inputLL, outputLL, true);
  cmd.inputFile = inputLL;
  cmd.outputFile = outputLL;
  cmd.id = srcID;
  cmd.dynamicTracking = dynamicTracking;
  cmd.isSource = true;
  cmd.location = loc;

  std::cout << "[InstrumentationStrategy] Generated source command for SRC_ID="
            << srcID << ":\n  " << cmd.command << "\n";
  return cmd;
}

OptCommand InstrumentationStrategy::generateSinkCommand(
    const SourceLocation &loc, int sinkID, const InstrumentationInfo &info,
    bool dynamicTracking, const std::string &inputLL,
    const std::string &outputLL) {
  OptCommand cmd;
  cmd.command = buildOptCommand("sample-flow-sink-module", loc, info, sinkID,
                                dynamicTracking, inputLL, outputLL, false);
  cmd.inputFile = inputLL;
  cmd.outputFile = outputLL;
  cmd.id = sinkID;
  cmd.dynamicTracking = dynamicTracking;
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

static std::string_view last_line(std::string_view s) {
  // drop trailing '\n'
  while (!s.empty() && s.back() == '\n')
    s.remove_suffix(1);

  if (s.empty())
    return {};

  // take after last '\n'
  auto pos = s.find_last_of('\n');
  return (pos == std::string_view::npos) ? s : s.substr(pos + 1);
}

bool InstrumentationStrategy::executeCommand(const OptCommand &cmd,
                                             std::string &errorOutput) {
  std::cout << "[InstrumentationStrategy] Executing: " << cmd.command << "\n";

  InstrumentationResult result = runShellCommand(cmd.command, errorOutput);

  if (result.code == InstrumentationResultCode::Success) {
    if (cmd.id >= 0) {
      // Source or sink instrumentation
      std::cout << "[InstrumentationStrategy] ✅ SUCCESS: instrumented "
                << (cmd.isSource ? "source" : "sink") << " at "
                << cmd.location.toString() << "\n\n";
    } else {
      // Coverage or other instrumentation
      std::cout << "[InstrumentationStrategy] ✅ SUCCESS: completed "
                   "instrumentation\n\n";
    }
  } else if (result.code == InstrumentationResultCode::NotFound) {
    if (cmd.id >= 0) {
      std::cerr
          << "[InstrumentationStrategy] ⚠️  WARNING: Instrumentation point ("
          << cmd.location.toString() << ") not found in the module\n\n";
    } else {
      std::cerr << "[InstrumentationStrategy] ⚠️  WARNING: Instrumentation point"
                   " not found in the module\n\n";
    }
  } else if (result.code == InstrumentationResultCode::NotImplemented) {
    if (cmd.id >= 0) {
      std::cerr << "[InstrumentationStrategy] ❓ WARNING: Instrumentation for "
                   "point at "
                << cmd.location.toString() << " is not implemented\n\n";
    } else {
      std::cerr
          << "[InstrumentationStrategy] ❓ WARNING: Instrumentation is not "
             "implemented\n\n";
    }
    if (auto line = last_line(errorOutput); !line.empty()) {
      std::cerr << "  Error output (last line): " << line << "\n\n";
    }
  } else if (result.code == InstrumentationResultCode::Error) {
    if (cmd.id >= 0) {
      std::cerr
          << "[InstrumentationStrategy] ❌ ERROR: Instrumentation failed at "
          << cmd.location.toString() << "\n\n";
    } else {
      std::cerr
          << "[InstrumentationStrategy] ❌ ERROR: Instrumentation failed\n\n";
    }
    std::cerr << "  Command: " << cmd.command << "\n";
    if (auto line = last_line(errorOutput); !line.empty()) {
      std::cerr << "  Error output (last line): " << line << "\n\n";
    }
  }

  return result.code == InstrumentationResultCode::Success;
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
    const InstrumentationInfo &info, int id, bool dynamicTracking,
    const std::string &inputLL, const std::string &outputLL, bool isSource) {
  std::ostringstream oss;

  // Build pass plugin path
  std::string passPlugin;
  if (passName == "sample-flow-src-module" || passName == "sample-flow-src") {
    passPlugin = fs::path(passPluginDir) / "SampleFlowSrcPass.so";
  } else if (passName == "sample-flow-sink-module" ||
             passName == "sample-flow-sink") {
    passPlugin = fs::path(passPluginDir) / "SampleFlowSinkPass.so";
  } else {
    passPlugin = fs::path(passPluginDir) / (passName + ".so");
  }

  // Determine option prefix based on pass type
  std::string optPrefix = isSource ? "src-" : "sink-";

  // Use the full file path for disambiguation
  // This allows us to distinguish between files with the same name
  // in different directories (e.g., src/main.c vs test/main.c)
  std::string filePath = loc.filePath;

  // Base opt command
  oss << optPath << " -load-pass-plugin=" << passPlugin
      << " -passes=" << passName;

  // Always add line parameter
  oss << " --" << optPrefix << "line=" << loc.line;

  // Add column parameters for line:col mode
  oss << " --" << optPrefix << "col-start=" << loc.colStart << " --"
      << optPrefix << "col-end=" << loc.colEnd;

  // Add file path parameter for disambiguation
  oss << " --" << optPrefix << "file=" << filePath;

  // Add variable name if available (fallback mode)
  if (!info.varName.empty()) {
    oss << " --" << optPrefix << "var-name=" << info.varName;
  }

  // Add ID parameter
  if (isSource) {
    oss << " --src-id=" << id;
  } else {
    oss << " --sink-id=" << id;
  }

  // Add dynamic tracking flag
  if (dynamicTracking) {
    oss << (isSource ? " --dynamic-src" : " --dynamic-sink");
  }

  // Input/output files
  oss << " " << inputLL << " -S -o " << outputLL;

  return oss.str();
}

InstrumentationResult
InstrumentationStrategy::runShellCommand(const std::string &cmd,
                                         std::string &errorOutput) {
  // Use popen to capture output
  std::string cmd_both = cmd + " 2>&1";
  std::array<char, 1048576> buffer;
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd_both.c_str(), "r"),
                                                pclose);

  if (!pipe) {
    return {InstrumentationResultCode::Error, "Failed to execute command"};
  }

  // Read command output
  while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
    errorOutput += buffer.data();
  }

  // Check exit status. pclose returns -1 on error.
  int exitStatus = pclose(pipe.release());

  // Check for specific output messages to determine the result
  if (errorOutput.find("[sample-flow-src-module] Source not found in module") !=
          std::string::npos ||
      errorOutput.find("[sample-flow-sink-module] Sink not found in module") !=
          std::string::npos) {
    return {InstrumentationResultCode::NotFound, errorOutput};
  }

  if (errorOutput.find(
          "[sample-flow-src-module] No function was instrumented") !=
          std::string::npos ||
      errorOutput.find(
          "[sample-flow-sink-module] No function was instrumented") !=
          std::string::npos) {
    return {InstrumentationResultCode::NotImplemented, errorOutput};
  }

  // Check the command's exit status
  if (exitStatus == 0) {
    return {InstrumentationResultCode::Success, errorOutput};
  }

  // Any other non-zero exit status is a general error
  return {InstrumentationResultCode::Error, errorOutput};
}

} // namespace taint
