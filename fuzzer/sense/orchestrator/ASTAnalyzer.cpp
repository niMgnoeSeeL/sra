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
  LocationFinder(clang::ASTContext &Ctx, unsigned Line, unsigned ColStart,
                 unsigned ColEnd)
      : Context(Ctx), TargetLine(Line), TargetColStart(ColStart),
        TargetColEnd(ColEnd), FoundNode(nullptr) {}

  bool VisitExpr(clang::Expr *E) {
    clang::SourceLocation BeginLoc = E->getBeginLoc();
    clang::SourceLocation EndLoc = E->getEndLoc();

    if (BeginLoc.isInvalid() || EndLoc.isInvalid())
      return true;

    clang::SourceManager &SM = Context.getSourceManager();
    unsigned BeginLine = SM.getSpellingLineNumber(BeginLoc);
    unsigned BeginCol = SM.getSpellingColumnNumber(BeginLoc);
    unsigned EndLine = SM.getSpellingLineNumber(EndLoc);
    unsigned EndCol = SM.getSpellingColumnNumber(EndLoc);

    // Check if this expression's span is contained within the target range
    // The node must:
    // 1. Be on the target line (for now, single-line only)
    // 2. Start at or after TargetColStart
    // 3. End at or before TargetColEnd
    if (BeginLine == TargetLine && EndLine == TargetLine) {
      // Check if the entire node span is within [TargetColStart, TargetColEnd]
      if (BeginCol >= TargetColStart && EndCol <= TargetColEnd) {
        // This node is fully contained - prefer larger spans
        if (!FoundNode) {
          FoundNode = E;
        } else {
          // Compare with existing candidate - prefer the one with larger span
          clang::SourceLocation PrevBegin = FoundNode->getBeginLoc();
          clang::SourceLocation PrevEnd = FoundNode->getEndLoc();
          unsigned PrevBeginCol = SM.getSpellingColumnNumber(PrevBegin);
          unsigned PrevEndCol = SM.getSpellingColumnNumber(PrevEnd);
          unsigned PrevSpan = PrevEndCol - PrevBeginCol;
          unsigned CurrentSpan = EndCol - BeginCol;

          // Prefer the strictly larger span (the outermost expr within bounds)
          if (CurrentSpan > PrevSpan) {
            FoundNode = E;
          }
        }
      }
    }

    return true;
  }

  clang::Expr *getFoundNode() const { return FoundNode; }

private:
  clang::ASTContext &Context;
  unsigned TargetLine;
  unsigned TargetColStart;
  unsigned TargetColEnd;
  clang::Expr *FoundNode;
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
  if (!compileArgs.empty()) {
    // Use provided compile arguments for proper parsing
    std::cout << "[ASTAnalyzer] Building AST with " << compileArgs.size()
              << " compile arguments for: " << fileName << "\n";
    astUnit = clang::tooling::buildASTFromCodeWithArgs(sourceCode, compileArgs,
                                                       fileName);
  }
  // fallback: build AST without compile arguments
  if (astUnit == nullptr) {
    std::cout << "[ASTAnalyzer] Building AST without compile arguments for: "
              << fileName << "\n";
    astUnit = clang::tooling::buildASTFromCode(sourceCode, fileName);
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
  clang::Expr *node = findNodeAtLocation(loc);

  if (!node) {
    // Could not find exact node - still try to extract variable name
    // by searching more broadly
    info.errorMessage = "Could not find exact AST node at location";
    info.isValid = true; // Still valid, pass will use var-name fallback
    return info;
  }

  // Successfully found node - extract variable name
  info.isValid = true;
  try {
    info.varName = extractVarName(node);
    if (info.varName.empty()) {
      info.errorMessage = "Could not extract variable name from AST node";
      return info;
    }
  } catch (const std::exception &e) {
    info.errorMessage = e.what();
    return info;
  } // info is still valid, just no var name

  // Try to infer type (optional, for validation)
  if (auto *DRE = llvm::dyn_cast<clang::DeclRefExpr>(node)) {
    info.typeName = inferLLVMType(DRE->getType());
  } else if (auto *ASE = llvm::dyn_cast<clang::ArraySubscriptExpr>(node)) {
    info.typeName = inferLLVMType(ASE->getType());
  } else if (auto *ME = llvm::dyn_cast<clang::MemberExpr>(node)) {
    info.typeName = inferLLVMType(ME->getType());
  } else if (auto *BO = llvm::dyn_cast<clang::BinaryOperator>(node)) {
    // For binary operators, try to extract type from the operation result
    info.typeName = inferLLVMType(BO->getType());
  }

  std::cout << "[ASTAnalyzer] Analyzed location " << loc.toString() << ": "
            << "var=" << info.varName << ", type=" << info.typeName << "\n";

  return info;
}

clang::Expr *ASTAnalyzer::findNodeAtLocation(const SourceLocation &loc) {
  if (!astUnit)
    return nullptr;

  LocationFinder finder(astUnit->getASTContext(), loc.line, loc.colStart,
                        loc.colEnd);
  finder.TraverseDecl(astUnit->getASTContext().getTranslationUnitDecl());

  return finder.getFoundNode();
}

std::string ASTAnalyzer::extractVarName(clang::Expr *node) {
  if (!node)
    return "";

  // Strip implicit casts to get to the real expression
  node = node->IgnoreImpCasts();

  // Handle RecoveryExpr (error recovery) - skip
  if (auto *RE = llvm::dyn_cast<clang::RecoveryExpr>(node)) {
    throw std::runtime_error(
        "[ASTAnalyzer] Cannot extract variable name from RecoveryExpr");
  }

  // DeclRefExpr: direct variable reference (e.g., "x", "buf")
  if (auto *DRE = llvm::dyn_cast<clang::DeclRefExpr>(node)) {
    return DRE->getNameInfo().getAsString();
  }

  // ArraySubscriptExpr: array access (e.g., "buf[5]", "arr[i]")
  if (auto *ASE = llvm::dyn_cast<clang::ArraySubscriptExpr>(node)) {
    // Recursively extract from base
    std::string BaseName = extractVarName(ASE->getBase());
    if (!BaseName.empty())
      return BaseName;
  }

  // MemberExpr: struct/class field access (e.g., "s.age", "p->field")
  if (auto *ME = llvm::dyn_cast<clang::MemberExpr>(node)) {
    // Recursively extract from base
    std::string BaseName = extractVarName(ME->getBase());
    if (!BaseName.empty())
      return BaseName;
  }

  // UnaryOperator: unary operations (e.g., "-x", "*p", "&x", "++i")
  if (auto *UO = llvm::dyn_cast<clang::UnaryOperator>(node)) {
    std::string SubName = extractVarName(UO->getSubExpr());
    if (!SubName.empty())
      return SubName;
  }

  if (auto *UOE = llvm::dyn_cast<clang::UnaryExprOrTypeTraitExpr>(node)) {
    std::string SubName = extractVarName(UOE->getArgumentExpr());
    if (!SubName.empty())
      return SubName;
  }

  // BinaryOperator: binary operations (e.g., "a + b", "x * y")
  if (auto *BO = llvm::dyn_cast<clang::BinaryOperator>(node)) {
    // Try left side first
    std::string LeftVar = extractVarName(BO->getLHS());
    if (!LeftVar.empty())
      return LeftVar;
    // Then right side
    std::string RightVar = extractVarName(BO->getRHS());
    return RightVar;
  }

  // ConditionalOperator: ternary operator (e.g., "cond ? a : b")
  if (auto *CO = llvm::dyn_cast<clang::ConditionalOperator>(node)) {
    // Try condition first
    std::string CondVar = extractVarName(CO->getCond());
    if (!CondVar.empty())
      return CondVar;
    // Then true branch
    std::string TrueVar = extractVarName(CO->getTrueExpr());
    if (!TrueVar.empty())
      return TrueVar;
    // Finally false branch
    std::string FalseVar = extractVarName(CO->getFalseExpr());
    if (!FalseVar.empty())
      return FalseVar;
  }

  // CallExpr: function calls (e.g., "foo(x)", "log(y)")
  if (auto *CE = llvm::dyn_cast<clang::CallExpr>(node)) {
    // Try to extract from arguments
    for (unsigned i = 0; i < CE->getNumArgs(); ++i) {
      std::string ArgVar = extractVarName(CE->getArg(i));
      if (!ArgVar.empty())
        return ArgVar;
    }
  }

  // ParenExpr: parenthesized expressions (e.g., "(x)")
  if (auto *PE = llvm::dyn_cast<clang::ParenExpr>(node)) {
    return extractVarName(PE->getSubExpr());
  }

  // CompoundAssignOperator: compound assignments (e.g., "x += 5")
  if (auto *CAO = llvm::dyn_cast<clang::CompoundAssignOperator>(node)) {
    // Extract from LHS (the variable being modified)
    std::string LHS = extractVarName(CAO->getLHS());
    if (!LHS.empty())
      return LHS;
    // Fallback to RHS
    std::string RHS = extractVarName(CAO->getRHS());
    if (!RHS.empty())
      return RHS;
  }

  // CStyleCastExpr: C-style casts (e.g., "(int)x")
  if (auto *CSCE = llvm::dyn_cast<clang::CStyleCastExpr>(node)) {
    return extractVarName(CSCE->getSubExpr());
  }

  // CXXStaticCastExpr, CXXReinterpretCastExpr, etc.: C++ casts
  if (auto *CCE = llvm::dyn_cast<clang::CXXNamedCastExpr>(node)) {
    return extractVarName(CCE->getSubExpr());
  }

  // StmtExpr: GNU statement expressions (e.g., "({int x = 5; x;})")
  if (auto *SE = llvm::dyn_cast<clang::StmtExpr>(node)) {
    // This is rare, just try to find any DeclRefExpr inside
    // For now, return empty
    return "";
  }

  if (auto *CDSME = llvm::dyn_cast<clang::CXXDependentScopeMemberExpr>(node)) {
    // Returns the name of the
    return extractVarName(CDSME->getBase());
  }

  // Literals have no variable names - return empty
  if (llvm::isa<clang::IntegerLiteral>(node) ||
      llvm::isa<clang::FloatingLiteral>(node) ||
      llvm::isa<clang::StringLiteral>(node) ||
      llvm::isa<clang::CharacterLiteral>(node)) {
    // matched expression is literal with no var name
    return "";
  }

  // If we get here, we have an unhandled expression type
  // TODO: suppressed for now
  // assert(false && "[ASTAnalyzer] Unhandled expression type in
  // extractVarName");
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
