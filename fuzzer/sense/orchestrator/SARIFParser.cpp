//===----------------------------------------------------------------------===//
// SARIFParser.cpp - Implementation of SARIF parsing logic
//===----------------------------------------------------------------------===//

#include "SARIFParser.h"
#include <filesystem>
#include <fstream>
#include <iostream>

namespace fs = std::filesystem;
using json = nlohmann::json;

namespace taint {

bool SARIFParser::parseSARIFFile(const std::string &filePath,
                                 const std::string &sourceDir) {
  flows.clear();
  errorMessage.clear();
  std::string baseDir;

  // Check file exists
  if (!fs::exists(filePath)) {
    errorMessage = "SARIF file not found: " + filePath;
    return false;
  }

  // Get base directory for resolving relative paths
  if (!sourceDir.empty()) {
    std::cout << "[SARIFParser] Using provided source directory: " << sourceDir
              << "\n";
    baseDir = sourceDir;
  } else {
    std::cout << "[SARIFParser] No source directory provided, using SARIF "
                 "file's directory\n";
    baseDir = fs::path(filePath).parent_path().string();
  }

  // Read and parse JSON
  std::ifstream ifs(filePath);
  if (!ifs.is_open()) {
    errorMessage = "Failed to open SARIF file: " + filePath;
    return false;
  }

  json sarifDoc;
  try {
    ifs >> sarifDoc;
  } catch (const json::parse_error &e) {
    errorMessage = std::string("JSON parse error: ") + e.what();
    return false;
  }

  // Validate SARIF structure
  if (!sarifDoc.contains("runs") || !sarifDoc["runs"].is_array()) {
    errorMessage = "Invalid SARIF format: missing 'runs' array";
    return false;
  }

  // Parse all runs
  for (const auto &run : sarifDoc["runs"]) {
    if (!run.contains("results") || !run["results"].is_array()) {
      continue;
    }

    // Parse all results in this run
    for (const auto &result : run["results"]) {
      // Extract codeFlows (taint flows)
      if (!result.contains("codeFlows") || !result["codeFlows"].is_array()) {
        continue;
      }

      for (const auto &codeFlow : result["codeFlows"]) {
        try {
          Flow flow = extractFlow(codeFlow, result, baseDir);
          flows.push_back(flow);
        } catch (const std::exception &e) {
          std::cerr << "[SARIFParser] Warning: Failed to extract flow: "
                    << e.what() << "\n";
        }
      }
    }
  }

  std::cout << "[SARIFParser] Successfully parsed " << flows.size()
            << " flows from " << filePath << "\n";
  return true;
}

SourceLocation SARIFParser::convertLocation(const json &location,
                                            const std::string &baseDir) {
  SourceLocation loc;

  // Extract physical location
  if (!location.contains("physicalLocation")) {
    throw std::runtime_error("Missing physicalLocation");
  }

  const auto &physLoc = location["physicalLocation"];

  // Extract file path (artifactLocation.uri)
  if (physLoc.contains("artifactLocation") &&
      physLoc["artifactLocation"].contains("uri")) {
    std::string uri = physLoc["artifactLocation"]["uri"];
    loc.filePath = resolveFilePath(uri, baseDir);
  } else {
    throw std::runtime_error("Missing file path in location");
  }

  // Extract region (line and column range)
  if (!physLoc.contains("region")) {
    throw std::runtime_error("Missing region in location");
  }

  const auto &region = physLoc["region"];

  // SARIF uses 1-based line and column numbers
  loc.line = region.value("startLine", 0);
  loc.colStart = region.value("startColumn", 0);

  // Handle end column (may be missing for single-character locations)
  if (region.contains("endColumn")) {
    loc.colEnd = region["endColumn"];
  } else {
    loc.colEnd = loc.colStart;
  }

  return loc;
}

Flow SARIFParser::extractFlow(const json &codeFlow, const json &result,
                              const std::string &baseDir) {
  Flow flow;

  // Extract description from result message
  if (result.contains("message") && result["message"].contains("text")) {
    std::string messageText = result["message"]["text"];
    std::replace(messageText.begin(), messageText.end(), '\n', ' ');
    flow.description = messageText;
  }

  // Extract threadFlows (SARIF supports multiple threads, we use first)
  if (!codeFlow.contains("threadFlows") ||
      !codeFlow["threadFlows"].is_array() || codeFlow["threadFlows"].empty()) {
    throw std::runtime_error("Missing or empty threadFlows");
  }

  const auto &threadFlow = codeFlow["threadFlows"][0];

  if (!threadFlow.contains("locations") ||
      !threadFlow["locations"].is_array() ||
      threadFlow["locations"].size() < 2) {
    throw std::runtime_error("Flow must have at least source and sink");
  }

  const auto &locations = threadFlow["locations"];

  // First location = source
  const auto &firstLoc = locations[0]["location"];
  flow.source = convertLocation(firstLoc, baseDir);

  // Last location = sink
  const auto &lastLoc = locations[locations.size() - 1]["location"];
  flow.sink = convertLocation(lastLoc, baseDir);

  // Optional: Extract intermediate path nodes
  for (size_t i = 1; i < locations.size() - 1; ++i) {
    const auto &intermediateLoc = locations[i]["location"];
    flow.path.push_back(convertLocation(intermediateLoc, baseDir));
  }

  return flow;
}

std::string SARIFParser::resolveFilePath(const std::string &uriOrPath,
                                         const std::string &baseDir) {
  // Handle file:// URIs
  std::string path = uriOrPath;
  if (path.rfind("file://", 0) == 0) {
    path = path.substr(7); // Remove "file://"
  }

  // Handle relative paths
  fs::path fsPath(path);
  if (fsPath.is_relative()) {
    fsPath = fs::path(baseDir) / fsPath;
  }

  // Canonicalize (resolve .., ., symlinks)
  try {
    return fs::canonical(fsPath).string();
  } catch (const fs::filesystem_error &) {
    // If canonical fails (file doesn't exist yet), return absolute path
    return fs::absolute(fsPath).string();
  }
}

} // namespace taint
