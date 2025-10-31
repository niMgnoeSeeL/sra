//===----------------------------------------------------------------------===//
// SARIFParser.h - Parse SARIF format from static analysis tools
//===----------------------------------------------------------------------===//
//
// This component parses SARIF (Static Analysis Results Interchange Format)
// JSON files produced by tools like CodeQL and extracts taint flow information.
//
// SARIF format overview:
//   - runs[].results[].codeFlows[].threadFlows[].locations[]
//   - Each location has physicalLocation with region (line:col)
//   - Flows typically have: source → [intermediate nodes] → sink
//
// Key responsibilities:
//   1. Parse SARIF JSON using nlohmann/json
//   2. Extract taint flows from results
//   3. Identify source (first location) and sink (last location)
//   4. Convert SARIF locations to SourceLocation structures
//   5. Create Flow objects for FlowManager
//
//===----------------------------------------------------------------------===//

#ifndef SARIFPARSER_H
#define SARIFPARSER_H

#include "FlowManager.h"
#include <nlohmann/json.hpp>
#include <string>
#include <vector>

namespace taint {

class SARIFParser {
public:
  SARIFParser() = default;

  // Parse SARIF file and extract flows
  bool parseSARIFFile(const std::string &filePath);

  // Get extracted flows
  const std::vector<Flow> &getFlows() const { return flows; }

  // Error handling
  bool hasError() const { return !errorMessage.empty(); }
  const std::string &getError() const { return errorMessage; }

private:
  std::vector<Flow> flows;
  std::string errorMessage;

  // Helper: Convert SARIF location to SourceLocation
  SourceLocation convertLocation(const nlohmann::json &location,
                                  const std::string &baseDir);

  // Helper: Extract flow from SARIF codeFlow object
  Flow extractFlow(const nlohmann::json &codeFlow,
                   const nlohmann::json &result, const std::string &baseDir);

  // Helper: Resolve relative file paths
  std::string resolveFilePath(const std::string &uriOrPath,
                              const std::string &baseDir);
};

} // namespace taint

#endif // SARIFPARSER_H
