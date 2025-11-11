//===----------------------------------------------------------------------===//
// main.cpp - Orchestrator driver for taint flow instrumentation
//===----------------------------------------------------------------------===//
//
// This is the main entry point for the taint flow instrumentation orchestrator.
// It coordinates all components to transform SARIF taint flow specifications
// into instrumented LLVM IR.
//
// Workflow:
//   1. Parse command-line arguments
//   2. Load SARIF file (SARIFParser)
//   3. Build flow database with SRC_ID/SINK_ID assignment (FlowManager)
//   4. Analyze source code using Clang AST (ASTAnalyzer)
//   5. Generate opt commands for each unique source/sink
//   (InstrumentationStrategy)
//   6. Execute instrumentation passes in sequence
//   7. Generate final instrumented LLVM IR
//
// Usage:
//   taint-orchestrator \
//     --sarif flows.sarif \
//     --input program.ll \
//     --output program.instrumented.ll \
//     --pass-dir ./build \
//     [--opt-path /usr/bin/opt] \
//     [--compile-args "-I/usr/include ..."]
//
// Output:
//   - Instrumented LLVM IR with sample_report_source/sink calls
//   - Summary report of flows and instrumentation points
//   - Error messages for any failed instrumentations
//
//===----------------------------------------------------------------------===//

#include "ASTAnalyzer.h"
#include "FlowManager.h"
#include "InstrumentationStrategy.h"
#include "SARIFParser.h"
#include "ServiceComm.h"
#include <cassert>
#include <cstring>
#include <filesystem>
#include <iostream>
#include <map>
#include <set>
#include <vector>
#include <clang/Tooling/CompilationDatabase.h>
#include <clang/Tooling/JSONCompilationDatabase.h>

namespace fs = std::filesystem;

struct Config {
  std::string sarifFile;
  std::string inputLL;
  std::string outputLL;
  std::string passDir;
  std::string optPath = "opt";
  std::string compileDbPath; // Optional: path to compile_commands.json
  std::vector<std::string> compileArgs;
  bool verbose = false;
};

void printUsage(const char *progName) {
  std::cout << "Usage: " << progName << " [options]\n\n";
  std::cout << "Required options:\n";
  std::cout
      << "  --sarif <file>       SARIF file with taint flow specifications\n";
  std::cout << "  --input <file>       Input LLVM IR file (.ll)\n";
  std::cout
      << "  --output <file>      Output instrumented LLVM IR file (.ll)\n";
  std::cout << "  --pass-dir <dir>     Directory containing pass plugin .so "
               "files\n\n";
  std::cout << "Optional options:\n";
  std::cout << "  --opt-path <path>    Path to opt binary (default: opt)\n";
  std::cout << "  --compile-db <path>  Path to compile_commands.json for "
               "proper AST parsing\n";
  std::cout
      << "  --compile-args <...> Compilation arguments for AST analysis\n";
  std::cout << "                       (comma-separated, used if --compile-db "
               "not provided)\n";
  std::cout << "  --verbose            Enable verbose output\n";
  std::cout << "  --help               Show this help message\n\n";
  std::cout << "Example:\n";
  std::cout << "  " << progName << " \\\n";
  std::cout << "    --sarif flows.sarif \\\n";
  std::cout << "    --input program.ll \\\n";
  std::cout << "    --output program.instrumented.ll \\\n";
  std::cout << "    --pass-dir ./build \\\n";
  std::cout << "    --compile-db ./compile_commands.json\n";
}

bool parseArgs(int argc, char **argv, Config &config) {
  for (int i = 1; i < argc; ++i) {
    std::string arg = argv[i];

    if (arg == "--help" || arg == "-h") {
      printUsage(argv[0]);
      return false;
    } else if (arg == "--sarif" && i + 1 < argc) {
      config.sarifFile = argv[++i];
    } else if (arg == "--input" && i + 1 < argc) {
      config.inputLL = argv[++i];
    } else if (arg == "--output" && i + 1 < argc) {
      config.outputLL = argv[++i];
    } else if (arg == "--pass-dir" && i + 1 < argc) {
      config.passDir = argv[++i];
    } else if (arg == "--opt-path" && i + 1 < argc) {
      config.optPath = argv[++i];
    } else if (arg == "--compile-db" && i + 1 < argc) {
      config.compileDbPath = argv[++i];
    } else if (arg == "--compile-args" && i + 1 < argc) {
      // Parse comma-separated compile args
      std::string argsStr = argv[++i];
      size_t start = 0, end;
      while ((end = argsStr.find(',', start)) != std::string::npos) {
        config.compileArgs.push_back(argsStr.substr(start, end - start));
        start = end + 1;
      }
      config.compileArgs.push_back(argsStr.substr(start));
    } else if (arg == "--verbose" || arg == "-v") {
      config.verbose = true;
    } else {
      std::cerr << "Unknown argument: " << arg << "\n";
      printUsage(argv[0]);
      return false;
    }
  }

  // Validate required arguments
  if (config.sarifFile.empty() || config.inputLL.empty() ||
      config.outputLL.empty() || config.passDir.empty()) {
    std::cerr << "ERROR: Missing required arguments\n\n";
    printUsage(argv[0]);
    return false;
  }

  return true;
}

int main(int argc, char **argv) {
  std::cout << "=== Taint Flow Instrumentation Orchestrator ===\n\n";

  // Parse command-line arguments
  Config config;
  if (!parseArgs(argc, argv, config)) {
    return 1;
  }

  // Step 1: Parse SARIF file
  std::cout << "[Step 1] Parsing SARIF file: " << config.sarifFile << "\n";
  taint::SARIFParser parser;
  if (!parser.parseSARIFFile(config.sarifFile)) {
    std::cerr << "ERROR: " << parser.getError() << "\n";
    return 1;
  }

  // Step 2: Build flow database and assign IDs
  std::cout << "\n[Step 2] Building flow database and assigning IDs\n";
  taint::FlowManager flowMgr;
  for (const auto &flow : parser.getFlows()) {
    flowMgr.addFlow(flow);
  }

  flowMgr.printSummary();

  // Serialize flow database for pass/fuzzer consumption
  std::string flowDbPath = config.outputLL + ".flowdb";
  if (!flowMgr.serializeToFile(flowDbPath)) {
    std::cerr << "WARNING: Failed to serialize flow database\n";
  }

  // Step 3: Analyze source code with AST to extract variable names
  std::cout << "\n[Step 3] Analyzing source code with Clang AST\n";
  taint::ASTAnalyzer astAnalyzer;

  // Load compilation database if provided
  std::unique_ptr<clang::tooling::CompilationDatabase> compileDb;
  if (!config.compileDbPath.empty()) {
    std::cout << "[Step 3] Loading compilation database: "
              << config.compileDbPath << "\n";

    std::string errorMsg;
    compileDb = clang::tooling::JSONCompilationDatabase::loadFromFile(
        config.compileDbPath, errorMsg,
        clang::tooling::JSONCommandLineSyntax::AutoDetect);

    if (!compileDb) {
      std::cerr << "WARNING: Failed to load compilation database: " << errorMsg
                << "\n";
      std::cerr << "         Will use --compile-args if provided\n";
    } else {
      std::cout << "[Step 3] Successfully loaded compilation database\n";
    }
  }

  // Load source files for AST analysis
  std::set<std::string> sourceFiles;
  for (const auto &[loc, _] : flowMgr.getSourceLocations()) {
    sourceFiles.insert(loc.filePath);
  }
  for (const auto &[loc, _] : flowMgr.getSinkLocations()) {
    sourceFiles.insert(loc.filePath);
  }
  for (const auto &[loc, _] : flowMgr.getIntermediateLocations()) {
    sourceFiles.insert(loc.filePath);
  }

  std::map<std::string, bool> astLoadStatus;
  for (const auto &file : sourceFiles) {
    // Get compile commands for this file
    std::vector<std::string> fileCompileArgs;

    if (compileDb) {
      // Look up compile commands from compilation database
      auto commands = compileDb->getCompileCommands(file);

      if (!commands.empty()) {
        // Use the first command (there should only be one per file)
        const auto &cmd = commands[0];

        std::cout << "[AST] Using compile command from database for: " << file
                  << "\n";

        // Extract arguments (skip the compiler name and source file)
        for (const auto &arg : cmd.CommandLine) {
          // Skip compiler executable and the source file itself
          if (arg == cmd.Filename || arg.find("clang") != std::string::npos ||
              arg.find("gcc") != std::string::npos ||
              arg.find("g++") != std::string::npos ||
              arg.find("c++") != std::string::npos) {
            continue;
          }
          fileCompileArgs.push_back(arg);
        }

        if (config.verbose) {
          std::cout << "[AST] Compile args (" << fileCompileArgs.size()
                    << "): ";
          for (const auto &arg : fileCompileArgs) {
            std::cout << arg << " ";
          }
          std::cout << "\n";
        }
      } else {
        std::cout << "[AST] No compile command found in database for: " << file
                  << ", using fallback\n";
        fileCompileArgs = config.compileArgs;
      }
    } else {
      // No compilation database - use --compile-args if provided
      fileCompileArgs = config.compileArgs;
    }

    bool loaded = astAnalyzer.loadSourceFile(file, fileCompileArgs);
    astLoadStatus[file] = loaded;
    if (!loaded) {
      std::cerr << "WARNING: Could not load AST for " << file
                << " - will use best-effort instrumentation\n";
    }
  }

  // Step 4: Generate instrumentation commands
  std::cout << "\n[Step 4] Generating instrumentation commands\n";
  taint::InstrumentationStrategy strategy(config.passDir, config.optPath);

  std::vector<taint::OptCommand> commands;

  // Generate source instrumentation commands
  for (const auto &[loc, srcID] : flowMgr.getSourceLocations()) {
    // AST must be loaded for this file
    assert(astLoadStatus[loc.filePath] &&
           "AST analysis failed - cannot generate instrumentation commands");

    // Analyze location to extract variable name
    taint::InstrumentationInfo info = astAnalyzer.analyzeLocation(loc);

    if (!info.isValid) {
      std::cerr << "WARNING: Location analysis failed for " << loc.toString()
                << ": " << info.errorMessage << "\n";
      continue;
    }

    // For pipelined instrumentation, each command reads from previous output
    std::string input =
        commands.empty() ? config.inputLL : commands.back().outputFile;
    std::string output =
        config.outputLL + ".src" + std::to_string(srcID) + ".ll";

    auto cmd = strategy.generateSourceCommand(loc, srcID, info, input, output);
    commands.push_back(cmd);
  }

  // Generate sink instrumentation commands
  for (const auto &[loc, sinkID] : flowMgr.getSinkLocations()) {
    // AST must be loaded for this file
    assert(astLoadStatus[loc.filePath] &&
           "AST analysis failed - cannot generate instrumentation commands");

    taint::InstrumentationInfo info = astAnalyzer.analyzeLocation(loc);

    if (!info.isValid) {
      std::cerr << "WARNING: Location analysis failed for " << loc.toString()
                << ": " << info.errorMessage << "\n";
      continue;
    }

    // For pipelined instrumentation, each command reads from previous output
    std::string input =
        commands.empty() ? config.inputLL : commands.back().outputFile;
    std::string output =
        config.outputLL + ".sink" + std::to_string(sinkID) + ".ll";

    auto cmd = strategy.generateSinkCommand(loc, sinkID, info, input, output);
    commands.push_back(cmd);
  }

  // Generate dataflow coverage instrumentation command (if there are
  // intermediate locations)
  if (flowMgr.getNumUniqueIntermediates() > 0) {
    std::string input =
        commands.empty() ? config.inputLL : commands.back().outputFile;
    std::string output = config.outputLL + ".dfcov.ll";

    auto cmd = strategy.generateCoverageCommand(flowDbPath, input, output);
    commands.push_back(cmd);
  }

  // Step 5: Execute instrumentation pipeline
  std::cout << "\n[Step 5] Executing instrumentation pipeline ("
            << commands.size() << " passes)\n";

  if (!strategy.executeAll(commands)) {
    std::cerr << "\nERROR: Some instrumentation passes failed\n";
    return 1;
  }

  // Step 6: Create final output file (rename last intermediate)
  if (!commands.empty()) {
    std::string finalIntermediate = commands.back().outputFile;
    try {
      fs::copy_file(finalIntermediate, config.outputLL,
                    fs::copy_options::overwrite_existing);
      std::cout << "\n[Step 6] Created final output: " << config.outputLL
                << "\n";

      // Clean up intermediate files
      for (const auto &cmd : commands) {
        if (cmd.outputFile != config.outputLL) {
          fs::remove(cmd.outputFile);
        }
      }
    } catch (const fs::filesystem_error &e) {
      std::cerr << "ERROR: Failed to create final output: " << e.what() << "\n";
      return 1;
    }
  }

  // Summary
  std::cout << "\n=== Instrumentation Complete ===\n";
  std::cout << "Flows processed: " << flowMgr.getNumFlows() << "\n";
  std::cout << "Sources instrumented: " << flowMgr.getNumUniqueSources()
            << "\n";
  std::cout << "Sinks instrumented: " << flowMgr.getNumUniqueSinks() << "\n";
  std::cout << "Intermediate locations: " << flowMgr.getNumUniqueIntermediates()
            << "\n";
  std::cout << "Flow database: " << flowDbPath << "\n";
  std::cout << "Output: " << config.outputLL << "\n";
  std::cout << "\nNext steps:\n";
  std::cout << "  1. Link with runtime libraries:\n";
  std::cout << "     - libsample_runtime.a (sampling)\n";
  std::cout << "     - libflow_runtime.a (source/sink tracking)\n";
  std::cout << "     - libdf_coverage_runtime.a (dataflow coverage)\n";
  std::cout << "  2. Compile instrumented IR: clang " << config.outputLL
            << " <runtimes> -o program\n";
  std::cout << "  3. Run and monitor taint flow events\n";

  return 0;
}
