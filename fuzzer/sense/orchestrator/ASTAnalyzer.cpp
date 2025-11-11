//===----------------------------------------------------------------------===//
// ASTAnalyzer.cpp - Implementation of Clang AST analysis
//===----------------------------------------------------------------------===//

#include "ASTAnalyzer.h"
#include <clang/AST/RecursiveASTVisitor.h>
#include <clang/Frontend/CompilerInstance.h>
#include <clang/Tooling/Tooling.h>
#include <fstream>
#include <iostream>

namespace taint {

// Helper visitor to find AST node at specific location
class LocationFinder : public clang::RecursiveASTVisitor<LocationFinder> {
public:
  LocationFinder(clang::ASTContext &Ctx, unsigned Line, unsigned Col)
      : Context(Ctx), TargetLine(Line), TargetCol(Col), FoundNode(nullptr) {}

  bool VisitStmt(clang::Stmt *S) {
    clang::SourceLocation Loc = S->getBeginLoc();
    if (Loc.isInvalid())
      return true;

    clang::SourceManager &SM = Context.getSourceManager();
    unsigned Line = SM.getSpellingLineNumber(Loc);
    unsigned Col = SM.getSpellingColumnNumber(Loc);

    // Check if this statement matches our target location
    if (Line == TargetLine && Col >= TargetCol - 2 && Col <= TargetCol + 2) {
      // Found a candidate (allow ±2 column tolerance for different compilers)
      FoundNode = S;
    }

    return true;
  }

  clang::Stmt *getFoundNode() const { return FoundNode; }

private:
  clang::ASTContext &Context;
  unsigned TargetLine;
  unsigned TargetCol;
  clang::Stmt *FoundNode;
};

bool ASTAnalyzer::loadSourceFile(const std::string &filePath,
                                 const std::vector<std::string> &compileArgs) {
  currentFilePath = filePath;

  // Read source file content
  std::ifstream file(filePath);
  if (!file.is_open()) {
    std::cerr << "[ASTAnalyzer] Failed to open source file: " << filePath
              << "\n";
    return false;
  }

  std::string sourceCode((std::istreambuf_iterator<char>(file)),
                         std::istreambuf_iterator<char>());
  file.close();

  // Extract just the filename for the virtual file system
  std::string fileName = filePath.substr(filePath.find_last_of("/\\") + 1);

  // Build AST with proper compilation arguments
  if (compileArgs.empty()) {
    // No compile args provided - use simple parsing
    std::cout << "[ASTAnalyzer] Building AST without compile arguments for: "
              << fileName << "\n";
    astUnit = clang::tooling::buildASTFromCode(sourceCode, fileName);
  } else {
    // Use provided compile arguments for proper parsing
    std::cout << "[ASTAnalyzer] Building AST with " << compileArgs.size()
              << " compile arguments for: " << fileName << "\n";
    astUnit = clang::tooling::buildASTFromCodeWithArgs(sourceCode, compileArgs,
                                                       fileName);
  }

  if (!astUnit) {
    std::cerr << "[ASTAnalyzer] Failed to parse source file: " << filePath
              << "\n";
    return false;
  }

  std::cout << "[ASTAnalyzer] Successfully loaded AST for: " << filePath
            << "\n";
  return true;
}

InstrumentationInfo ASTAnalyzer::analyzeLocation(const SourceLocation &loc) {
  InstrumentationInfo info;
  info.isValid = false;

  if (!astUnit) {
    info.errorMessage = "AST not loaded";
    return info;
  }

  // Verify the location is in the current file
  if (loc.filePath != currentFilePath) {
    info.errorMessage = "Location is in different file: " + loc.filePath;
    return info;
  }

  // Find AST node at this location
  clang::Stmt *node = findNodeAtLocation(loc);

  if (!node) {
    // Could not find exact node - still try to extract variable name
    // by searching more broadly
    info.errorMessage = "Could not find exact AST node at location";
    info.isValid = true; // Still valid, pass will use var-name fallback
    info.varName = "";   // TODO: could try broader search here
    return info;
  }

  // Successfully found node - extract variable name
  info.isValid = true;
  info.varName = extractVarName(node);

  // Try to infer type (optional, for validation)
  if (auto *DRE = llvm::dyn_cast<clang::DeclRefExpr>(node)) {
    info.typeName = inferLLVMType(DRE->getType());
  } else if (auto *ASE = llvm::dyn_cast<clang::ArraySubscriptExpr>(node)) {
    info.typeName = inferLLVMType(ASE->getType());
  } else if (auto *ME = llvm::dyn_cast<clang::MemberExpr>(node)) {
    info.typeName = inferLLVMType(ME->getType());
  }

  std::cout << "[ASTAnalyzer] Analyzed location " << loc.toString() << ": "
            << "var=" << info.varName << ", type=" << info.typeName << "\n";

  return info;
}

clang::Stmt *ASTAnalyzer::findNodeAtLocation(const SourceLocation &loc) {
  if (!astUnit)
    return nullptr;

  LocationFinder finder(astUnit->getASTContext(), loc.line, loc.colStart);
  finder.TraverseDecl(astUnit->getASTContext().getTranslationUnitDecl());

  return finder.getFoundNode();
}

std::string ASTAnalyzer::extractVarName(clang::Stmt *node) {
  if (!node)
    return "";

  // DeclRefExpr: direct variable reference (e.g., "x")
  if (auto *DRE = llvm::dyn_cast<clang::DeclRefExpr>(node)) {
    return DRE->getNameInfo().getAsString();
  }

  // ArraySubscriptExpr: array access (e.g., "buf[5]")
  if (auto *ASE = llvm::dyn_cast<clang::ArraySubscriptExpr>(node)) {
    // Get the base array name
    if (auto *Base = llvm::dyn_cast<clang::DeclRefExpr>(
            ASE->getBase()->IgnoreImpCasts())) {
      return Base->getNameInfo().getAsString();
    }
  }

  // MemberExpr: struct field access (e.g., "s.age")
  if (auto *ME = llvm::dyn_cast<clang::MemberExpr>(node)) {
    // Get the base struct name
    if (auto *Base = llvm::dyn_cast<clang::DeclRefExpr>(
            ME->getBase()->IgnoreImpCasts())) {
      return Base->getNameInfo().getAsString();
    }
  }

  return "";
}

std::string ASTAnalyzer::inferLLVMType(clang::QualType type) {
  const clang::Type *T = type.getTypePtr();

  if (T->isIntegerType()) {
    // Check specific integer sizes
    if (type->isSignedIntegerType() || type->isUnsignedIntegerType()) {
      unsigned BitWidth = astUnit->getASTContext().getTypeSize(type);
      return "i" + std::to_string(BitWidth);
    }
    return "i32"; // Default
  }

  if (T->isFloatingType()) {
    if (T->isSpecificBuiltinType(clang::BuiltinType::Float))
      return "float";
    if (T->isSpecificBuiltinType(clang::BuiltinType::Double))
      return "double";
    return "float";
  }

  if (T->isPointerType()) {
    return "ptr";
  }

  if (T->isArrayType()) {
    if (auto *CAT = llvm::dyn_cast<clang::ConstantArrayType>(T)) {
      uint64_t Size = CAT->getSize().getZExtValue();
      clang::QualType ElemType = CAT->getElementType();
      std::string ElemTypeName = inferLLVMType(ElemType);
      return "[" + std::to_string(Size) + " x " + ElemTypeName + "]";
    }
    return "array";
  }

  if (T->isStructureType()) {
    if (auto *RD = T->getAsStructureType()->getDecl()) {
      return "%" + RD->getNameAsString();
    }
    return "struct";
  }

  return "unknown";
}

} // namespace taint
