//===----------------------------------------------------------------------===//
// ASTAnalyzer.h - Clang AST analysis for instrumentation planning
//===----------------------------------------------------------------------===//
//
// This component uses Clang's AST (Abstract Syntax Tree) to analyze source
// code and determine the best instrumentation strategy for each flow location.
//
// Key responsibilities:
//   1. Load and parse source files using Clang's LibTooling
//   2. Map source locations (line:col) to AST nodes
//   3. Determine instrumentation mode:
//      - line:col mode (recommended): Direct location-based instrumentation
//      - var-name mode (fallback): Debug info-based variable name matching
//   4. Extract variable names and types at instrumentation points
//   5. Validate that locations are instrumentable
//
// Instrumentation mode selection:
//   - Use line:col mode for:
//     * Array/struct field accesses (e.g., buf[5], s.age)
//     * Direct expressions with clear source locations
//     * Any location with precise debug info
//   - Fallback to var-name mode only when:
//     * Line:col mode fails to find exact AST node
//     * Complex macro expansions obscure locations
//
//===----------------------------------------------------------------------===//

#ifndef ASTANALYZER_H
#define ASTANALYZER_H

#include "FlowManager.h"
#include <clang/AST/ASTContext.h>
#include <clang/Frontend/ASTUnit.h>
#include <memory>
#include <string>

namespace taint {

enum class InstrumentationMode {
  LineCol, // Use line:col directly (recommended)
  VarName  // Use variable name (fallback)
};

struct InstrumentationInfo {
  std::string varName;  // Variable name extracted from AST
  std::string typeName; // Inferred type (e.g., "i32", "double", "[16 x i8]")
  bool isValid;         // Whether location is instrumentable
  std::string errorMessage; // If invalid, why?
};

class ASTAnalyzer {
public:
  ASTAnalyzer() = default;

  // Load and parse a source file
  bool loadSourceFile(const std::string &filePath,
                      const std::vector<std::string> &compileArgs = {});

  // Analyze a source location and determine instrumentation strategy
  InstrumentationInfo analyzeLocation(const SourceLocation &loc);

  // Check if AST is loaded
  bool isLoaded() const { return astUnit != nullptr; }

  // Get current file path
  const std::string &getCurrentFile() const { return currentFilePath; }

private:
  std::unique_ptr<clang::ASTUnit> astUnit;
  std::string currentFilePath;

  // Helper: Find AST node at specific line:col
  clang::Stmt *findNodeAtLocation(const SourceLocation &loc);

  // Helper: Extract variable name from AST node
  std::string extractVarName(clang::Stmt *node);

  // Helper: Infer LLVM type from Clang type
  std::string inferLLVMType(clang::QualType type);
};

} // namespace taint

#endif // ASTANALYZER_H
