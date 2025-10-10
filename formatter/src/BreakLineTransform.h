/**
 * @file BreakLineTransform.h
 * @brief Header file for line-breaking transformation classes
 * 
 * This file defines the classes responsible for performing AST-based transformations
 * to insert line breaks at specific code constructs: binary logical operators,
 * ternary conditional operators, and for loop headers.
 */

#ifndef BREAK_LINE_TRANSFORM_H
#define BREAK_LINE_TRANSFORM_H

#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/FrontendAction.h"
#include "clang/Rewrite/Core/Rewriter.h"

namespace myfmt {

/// Callback class that handles AST node matches and performs line-breaking transformations
/// on binary logical operators, ternary operators, and for loops.
class BreakLineTransformCallback : public clang::ast_matchers::MatchFinder::MatchCallback {
public:
  /// Constructor that initializes the callback with a reference to the rewriter
  explicit BreakLineTransformCallback(clang::Rewriter &R) : TheRewriter(R) {}
  
  /// Main callback method invoked when AST matchers find matching nodes
  void run(const clang::ast_matchers::MatchFinder::MatchResult &Result) override;

private:
  clang::Rewriter &TheRewriter;

  /// Inserts line breaks before binary logical operators (&& and ||)
  void breakBinaryLogical(const clang::BinaryOperator *binop,
                          const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks before ternary conditional operators (? and :)
  void breakTernary(const clang::ConditionalOperator *cond,
                    const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks after semicolons in for loop headers
  void breakForLoop(const clang::ForStmt *forstmt,
                    const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks between control flow conditions and their statements
  void breakIfStatement(const clang::IfStmt *ifstmt,
                        const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks between while loop conditions and their statements
  void breakWhileStatement(const clang::WhileStmt *whilestmt,
                           const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks in do-while statements
  void breakDoWhileStatement(const clang::DoStmt *dostmt,
                             const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks in switch statements and case labels
  void breakSwitchStatement(const clang::SwitchStmt *switchstmt,
                            const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks in case statements
  void breakCaseStatement(const clang::CaseStmt *casestmt,
                          const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks in default statements
  void breakDefaultStatement(const clang::DefaultStmt *defaultstmt,
                             const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks in range-based for loops
  void breakRangeForStatement(const clang::CXXForRangeStmt *rangeforstmt,
                              const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks in try-catch statements
  void breakTryStatement(const clang::CXXTryStmt *trystmt,
                         const clang::ast_matchers::MatchFinder::MatchResult &Result);
  
  /// Inserts line breaks in label statements
  void breakLabelStatement(const clang::LabelStmt *labelstmt,
                           const clang::ast_matchers::MatchFinder::MatchResult &Result);
};

/// AST consumer that sets up matchers for target constructs and processes the translation unit
class BreakLineTransformConsumer : public clang::ASTConsumer {
public:
  /// Constructor that initializes the consumer and sets up AST matchers
  explicit BreakLineTransformConsumer(clang::Rewriter &R);
  
  /// Processes the entire translation unit by running the configured matchers
  void HandleTranslationUnit(clang::ASTContext &Ctx) override;

private:
  clang::ast_matchers::MatchFinder Matcher;
  BreakLineTransformCallback Callback;
};

/// Frontend action that coordinates the line-breaking transformation process
class BreakLineTransformAction : public clang::ASTFrontendAction {
public:
  /// Constructor that optionally enables in-place editing mode
  explicit BreakLineTransformAction(bool InPlaceMode = false) : InPlaceMode_(InPlaceMode) {}
  
  /// Creates and returns the AST consumer for processing the source file
  std::unique_ptr<clang::ASTConsumer>
  CreateASTConsumer(clang::CompilerInstance &CI, llvm::StringRef InFile) override;

  /// Outputs the transformed source code to stdout or file after processing is complete
  void EndSourceFileAction() override;

private:
  /// Rewriter instance used to modify the source code throughout the transformation process
  clang::Rewriter RewriterForFile;
  /// Flag indicating whether to edit files in place or output to stdout
  bool InPlaceMode_;
  /// Path to the current file being processed (for in-place editing)
  std::string CurrentFilePath;
};

} // namespace myfmt

#endif // BREAK_LINE_TRANSFORM_H
