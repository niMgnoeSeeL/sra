/**
 * @file BreakLineTransform.cpp
 * @brief Implementation of line-breaking transformation classes
 * 
 * This file implements the functionality for transforming C/C++ source code by
 * inserting line breaks at binary logical operators (&&, ||), ternary conditional
 * operators (?:), and for loop headers to improve code readability and analysis.
 */

#include "BreakLineTransform.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/AST/Stmt.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Lex/Lexer.h"
#include "llvm/Support/raw_ostream.h"

using namespace clang;
using namespace clang::ast_matchers;
using namespace myfmt;

/// Constructor that sets up AST matchers for binary logical operators, ternary operators, and for loops
BreakLineTransformConsumer::BreakLineTransformConsumer(Rewriter &R)
    : Callback(R) {
  // Match binary logical ops (&&, ||)
  Matcher.addMatcher(binaryOperator(hasOperatorName("&&")).bind("binop"), &Callback);
  Matcher.addMatcher(binaryOperator(hasOperatorName("||")).bind("binop"), &Callback);

  // Match ternary ?: operator
  Matcher.addMatcher(conditionalOperator().bind("cond"), &Callback);

  // Match for loops
  Matcher.addMatcher(forStmt().bind("forstmt"), &Callback);

  // Match control flow statements
  Matcher.addMatcher(ifStmt().bind("ifstmt"), &Callback);
  Matcher.addMatcher(whileStmt().bind("whilestmt"), &Callback);
  Matcher.addMatcher(doStmt().bind("dostmt"), &Callback);

  // Match switch statements and cases
  Matcher.addMatcher(switchStmt().bind("switchstmt"), &Callback);
  Matcher.addMatcher(caseStmt().bind("casestmt"), &Callback);
  Matcher.addMatcher(defaultStmt().bind("defaultstmt"), &Callback);

  // Match range-based for loops
  Matcher.addMatcher(cxxForRangeStmt().bind("rangeforstmt"), &Callback);

  // Match exception handling
  Matcher.addMatcher(cxxTryStmt().bind("trystmt"), &Callback);

  // Match label statements
  Matcher.addMatcher(labelStmt().bind("labelstmt"), &Callback);
}

/// Runs all configured matchers against the AST to find and transform target constructs
void BreakLineTransformConsumer::HandleTranslationUnit(ASTContext &Ctx) {
  Matcher.matchAST(Ctx);
}

/// Initializes the rewriter and creates the AST consumer for processing the input file
std::unique_ptr<ASTConsumer>
BreakLineTransformAction::CreateASTConsumer(CompilerInstance &CI, StringRef InFile) {
  RewriterForFile.setSourceMgr(CI.getSourceManager(), CI.getLangOpts());
  CurrentFilePath = InFile.str();
  return std::make_unique<BreakLineTransformConsumer>(RewriterForFile);
}

/// Outputs the transformed source code to stdout or file after all transformations are complete
void BreakLineTransformAction::EndSourceFileAction() {
  auto &SM = getCompilerInstance().getSourceManager();

  if (InPlaceMode_) {
    std::error_code EC;
    llvm::raw_fd_ostream OS(CurrentFilePath, EC);
    if (EC) {
      llvm::errs() << "Error opening file for writing: " << CurrentFilePath
                   << " - " << EC.message() << "\n";
      return;
    }
    RewriterForFile.getEditBuffer(SM.getMainFileID()).write(OS);
  } else {
    RewriterForFile.getEditBuffer(SM.getMainFileID()).write(llvm::outs());
  }
}

/// Dispatches matched AST nodes to appropriate transformation methods based on node type
void BreakLineTransformCallback::run(const MatchFinder::MatchResult &Result) {
  if (const auto *binop = Result.Nodes.getNodeAs<BinaryOperator>("binop")) {
    breakBinaryLogical(binop, Result);
  }
  if (const auto *cond = Result.Nodes.getNodeAs<ConditionalOperator>("cond")) {
    breakTernary(cond, Result);
  }
  if (const auto *forstmt = Result.Nodes.getNodeAs<ForStmt>("forstmt")) {
    breakForLoop(forstmt, Result);
  }
  if (const auto *ifstmt = Result.Nodes.getNodeAs<IfStmt>("ifstmt")) {
    breakIfStatement(ifstmt, Result);
  }
  if (const auto *whilestmt = Result.Nodes.getNodeAs<WhileStmt>("whilestmt")) {
    breakWhileStatement(whilestmt, Result);
  }
  if (const auto *dostmt = Result.Nodes.getNodeAs<DoStmt>("dostmt")) {
    breakDoWhileStatement(dostmt, Result);
  }
  if (const auto *switchstmt = Result.Nodes.getNodeAs<SwitchStmt>("switchstmt")) {
    breakSwitchStatement(switchstmt, Result);
  }
  if (const auto *casestmt = Result.Nodes.getNodeAs<CaseStmt>("casestmt")) {
    breakCaseStatement(casestmt, Result);
  }
  if (const auto *defaultstmt = Result.Nodes.getNodeAs<DefaultStmt>("defaultstmt")) {
    breakDefaultStatement(defaultstmt, Result);
  }
  if (const auto *rangeforstmt = Result.Nodes.getNodeAs<CXXForRangeStmt>("rangeforstmt")) {
    breakRangeForStatement(rangeforstmt, Result);
  }
  if (const auto *trystmt = Result.Nodes.getNodeAs<CXXTryStmt>("trystmt")) {
    breakTryStatement(trystmt, Result);
  }
  if (const auto *labelstmt = Result.Nodes.getNodeAs<LabelStmt>("labelstmt")) {
    breakLabelStatement(labelstmt, Result);
  }
}

/// Transforms binary logical operators (&&, ||) by inserting newlines before the operator
void BreakLineTransformCallback::breakBinaryLogical(const BinaryOperator *binop,
                                                    const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;

  // Location of '&&' or '||'
  SourceLocation opLoc = binop->getOperatorLoc();

  // Only touch main-file (avoid macro expansions for now)
  if (!SM.isWrittenInMainFile(opLoc)) return;

  // Calculate proper indentation by aligning with the start of the expression
  SourceLocation exprStart = binop->getLHS()->getBeginLoc();
  unsigned exprColumn = SM.getSpellingColumnNumber(exprStart);
  std::string indentStr = "\n" + std::string(exprColumn - 1, ' ');

  // Insert a newline with proper indentation before the operator token
  TheRewriter.InsertText(opLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
}

/// Transforms ternary conditional operators (?:) by inserting newlines before both ? and :
void BreakLineTransformCallback::breakTernary(const ConditionalOperator *cond,
                                              const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;

  SourceLocation qLoc = cond->getQuestionLoc();
  SourceLocation cLoc = cond->getColonLoc();

  if (SM.isWrittenInMainFile(qLoc)) {
    // Calculate proper indentation by aligning with the start of the condition
    SourceLocation condStart = cond->getCond()->getBeginLoc();
    unsigned condColumn = SM.getSpellingColumnNumber(condStart);
    std::string indentStr = "\n" + std::string(condColumn - 1, ' ');
    TheRewriter.InsertText(qLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }

  if (SM.isWrittenInMainFile(cLoc)) {
    // Use the same indentation for the colon
    SourceLocation condStart = cond->getCond()->getBeginLoc();
    unsigned condColumn = SM.getSpellingColumnNumber(condStart);
    std::string indentStr = "\n" + std::string(condColumn - 1, ' ');
    TheRewriter.InsertText(cLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}

/// Transforms for loops by inserting newlines after each semicolon in the loop header
void BreakLineTransformCallback::breakForLoop(const ForStmt *forstmt,
                                              const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  const LangOptions &LangOpts = Result.Context->getLangOpts();

  // Get the location of the opening parenthesis
  SourceLocation forLoc = forstmt->getForLoc();
  if (!SM.isWrittenInMainFile(forLoc)) return;

  // Find the opening parenthesis after "for"
  SourceLocation lParenLoc = Lexer::findLocationAfterToken(
    forLoc, tok::l_paren, SM, LangOpts, /*SkipTrailingWhitespaceAndNewLine=*/false);

  if (lParenLoc.isInvalid()) return;

  // Find the semicolons in the for loop
  // We need to search within the for statement's source range
  SourceLocation beginSearch = lParenLoc;
  SourceLocation endSearch = forstmt->getRParenLoc();

  if (endSearch.isInvalid() || !SM.isWrittenInMainFile(endSearch)) return;

  // Get the source text between the parentheses
  CharSourceRange forHeaderRange = CharSourceRange::getCharRange(beginSearch, endSearch);
  StringRef forHeaderText = Lexer::getSourceText(forHeaderRange, SM, LangOpts);

  if (forHeaderText.empty()) return;

  // Find the positions of semicolons in the source text
  size_t firstSemiPos = forHeaderText.find(';');
  if (firstSemiPos == StringRef::npos) return;

  size_t secondSemiPos = forHeaderText.find(';', firstSemiPos + 1);
  if (secondSemiPos == StringRef::npos) return;

  // Calculate the actual source locations of the semicolons
  SourceLocation firstSemiLoc = beginSearch.getLocWithOffset(firstSemiPos);
  SourceLocation secondSemiLoc = beginSearch.getLocWithOffset(secondSemiPos);

  // Calculate indentation - align with the start of the for loop content
  // Find the column position of the opening parenthesis
  unsigned forColumn = SM.getSpellingColumnNumber(lParenLoc);
  std::string indentStr = "\n" + std::string(forColumn + 3, ' '); // +3 to align after "for("

  // Insert newlines with proper indentation after the semicolons
  TheRewriter.InsertText(firstSemiLoc, indentStr, /*InsertAfter=*/true, /*indentNewLines=*/false);
  TheRewriter.InsertText(secondSemiLoc, indentStr, /*InsertAfter=*/true, /*indentNewLines=*/false);
}

/// Transforms if statements by inserting line breaks between condition and statement when on same line
void BreakLineTransformCallback::breakIfStatement(const IfStmt *ifstmt,
                                                  const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation ifLoc = ifstmt->getIfLoc();
  if (!SM.isWrittenInMainFile(ifLoc)) return;

  const Stmt *thenStmt = ifstmt->getThen();
  if (!thenStmt) return;

  // Only transform if the statement is not a compound statement (i.e., no braces)
  if (isa<CompoundStmt>(thenStmt)) return;

  SourceLocation thenLoc = thenStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(thenLoc)) return;

  // Calculate base indentation from the 'if' statement
  unsigned ifColumn = SM.getSpellingColumnNumber(ifLoc);
  
  // Check if 'if' and then-statement are on the same line
  unsigned ifLine = SM.getSpellingLineNumber(ifLoc);
  unsigned thenLine = SM.getSpellingLineNumber(thenLoc);
  
  if (ifLine == thenLine) {
    // Use standard 4-space indentation for the then-statement
    std::string indentStr = "\n" + std::string(ifColumn + 4, ' ');
    TheRewriter.InsertText(thenLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }

  // Handle else clause if present
  const Stmt *elseStmt = ifstmt->getElse();
  if (elseStmt && !isa<CompoundStmt>(elseStmt)) {
    SourceLocation elseLoc = ifstmt->getElseLoc();
    SourceLocation elseStmtLoc = elseStmt->getBeginLoc();
    
    if (SM.isWrittenInMainFile(elseLoc) && SM.isWrittenInMainFile(elseStmtLoc)) {
      
      // Special handling for 'else if' - don't break the 'else if' construct
      bool isElseIf = isa<IfStmt>(elseStmt);
      
      if (!isElseIf) {
        // For regular else (not else if), handle line breaking
        
        // First, check if 'else' keyword and then-statement are on the same line
        // If so, put 'else' on a new line
        unsigned thenEndLine = SM.getSpellingLineNumber(thenStmt->getEndLoc());
        unsigned elseLine = SM.getSpellingLineNumber(elseLoc);
        
        if (thenEndLine == elseLine) {
          // Put 'else' on a new line, aligned with 'if'
          std::string elseNewlineStr = "\n" + std::string(ifColumn, ' ');
          TheRewriter.InsertText(elseLoc, elseNewlineStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
        }
        
        // Then, check if 'else' keyword and else-statement are on the same line
        // If so, put the else-statement on a new line with proper indentation
        unsigned elseStmtLine = SM.getSpellingLineNumber(elseStmtLoc);
        elseLine = SM.getSpellingLineNumber(elseLoc); // Re-read after potential modification
        
        if (elseLine == elseStmtLine) {
          std::string elseStmtIndentStr = "\n" + std::string(ifColumn + 4, ' ');
          TheRewriter.InsertText(elseStmtLoc, elseStmtIndentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
        }
      } else {
        // For 'else if', just ensure 'else if' is on a new line if needed
        unsigned thenEndLine = SM.getSpellingLineNumber(thenStmt->getEndLoc());
        unsigned elseLine = SM.getSpellingLineNumber(elseLoc);
        
        if (thenEndLine == elseLine) {
          // Put 'else if' on a new line, aligned with the original 'if'
          std::string elseNewlineStr = "\n" + std::string(ifColumn, ' ');
          TheRewriter.InsertText(elseLoc, elseNewlineStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
        }
      }
    }
  }
}

/// Transforms while statements by inserting line breaks between condition and statement when on same line
void BreakLineTransformCallback::breakWhileStatement(const WhileStmt *whilestmt,
                                                     const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation whileLoc = whilestmt->getWhileLoc();
  if (!SM.isWrittenInMainFile(whileLoc)) return;

  const Stmt *bodyStmt = whilestmt->getBody();
  if (!bodyStmt) return;

  // Only transform if the statement is not a compound statement (i.e., no braces)
  if (isa<CompoundStmt>(bodyStmt)) return;

  SourceLocation bodyLoc = bodyStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(bodyLoc)) return;

  // Check if they're on the same line
  unsigned whileLine = SM.getSpellingLineNumber(whileLoc);
  unsigned bodyLine = SM.getSpellingLineNumber(bodyLoc);
  
  if (whileLine == bodyLine) {
    // Use consistent 4-space indentation
    unsigned whileColumn = SM.getSpellingColumnNumber(whileLoc);
    std::string indentStr = "\n" + std::string(whileColumn + 4, ' ');
    
    TheRewriter.InsertText(bodyLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}

/// Transforms do-while statements by inserting line breaks appropriately
void BreakLineTransformCallback::breakDoWhileStatement(const DoStmt *dostmt,
                                                       const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation doLoc = dostmt->getDoLoc();
  SourceLocation whileLoc = dostmt->getWhileLoc();
  
  if (!SM.isWrittenInMainFile(doLoc) || !SM.isWrittenInMainFile(whileLoc)) return;

  const Stmt *bodyStmt = dostmt->getBody();
  if (!bodyStmt) return;

  // Only transform if the body is not a compound statement (i.e., no braces)
  if (isa<CompoundStmt>(bodyStmt)) return;

  SourceLocation bodyLoc = bodyStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(bodyLoc)) return;

  unsigned doColumn = SM.getSpellingColumnNumber(doLoc);

  // Check if do and body are on the same line
  unsigned doLine = SM.getSpellingLineNumber(doLoc);
  unsigned bodyLine = SM.getSpellingLineNumber(bodyLoc);
  
  if (doLine == bodyLine) {
    // Use consistent 4-space indentation for the body
    std::string indentStr = "\n" + std::string(doColumn + 4, ' ');
    TheRewriter.InsertText(bodyLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }

  // Ensure while is on a new line after the body, aligned with 'do'
  unsigned bodyEndLine = SM.getSpellingLineNumber(bodyStmt->getEndLoc());
  unsigned whileLine = SM.getSpellingLineNumber(whileLoc);
  
  if (bodyEndLine == whileLine) {
    std::string whileIndentStr = "\n" + std::string(doColumn, ' ');
    TheRewriter.InsertText(whileLoc, whileIndentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}

/// Transforms switch statements by ensuring proper line breaks
void BreakLineTransformCallback::breakSwitchStatement(const SwitchStmt *switchstmt,
                                                      const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation switchLoc = switchstmt->getSwitchLoc();
  if (!SM.isWrittenInMainFile(switchLoc)) return;

  const Stmt *bodyStmt = switchstmt->getBody();
  if (!bodyStmt) return;

  SourceLocation bodyLoc = bodyStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(bodyLoc)) return;

  // Check if switch and body are on the same line
  unsigned switchLine = SM.getSpellingLineNumber(switchLoc);
  unsigned bodyLine = SM.getSpellingLineNumber(bodyLoc);
  
  if (switchLine == bodyLine) {
    unsigned switchColumn = SM.getSpellingColumnNumber(switchLoc);
    std::string indentStr = "\n" + std::string(switchColumn, ' ');
    TheRewriter.InsertText(bodyLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}

/// Transforms case statements by inserting line breaks between case labels and statements
void BreakLineTransformCallback::breakCaseStatement(const CaseStmt *casestmt,
                                                    const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation caseLoc = casestmt->getCaseLoc();
  if (!SM.isWrittenInMainFile(caseLoc)) return;

  const Stmt *subStmt = casestmt->getSubStmt();
  if (!subStmt) return;

  SourceLocation subStmtLoc = subStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(subStmtLoc)) return;

  // Skip if subStmt is another case/default (case fall-through)
  if (isa<CaseStmt>(subStmt) || isa<DefaultStmt>(subStmt)) return;

  // Check if case label and statement are on the same line
  unsigned caseLine = SM.getSpellingLineNumber(caseLoc);
  unsigned subStmtLine = SM.getSpellingLineNumber(subStmtLoc);
  
  if (caseLine == subStmtLine) {
    unsigned caseColumn = SM.getSpellingColumnNumber(caseLoc);
    std::string indentStr = "\n" + std::string(caseColumn + 4, ' ');
    TheRewriter.InsertText(subStmtLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}

/// Transforms default statements by inserting line breaks between default labels and statements
void BreakLineTransformCallback::breakDefaultStatement(const DefaultStmt *defaultstmt,
                                                       const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation defaultLoc = defaultstmt->getDefaultLoc();
  if (!SM.isWrittenInMainFile(defaultLoc)) return;

  const Stmt *subStmt = defaultstmt->getSubStmt();
  if (!subStmt) return;

  SourceLocation subStmtLoc = subStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(subStmtLoc)) return;

  // Skip if subStmt is another case/default (case fall-through)
  if (isa<CaseStmt>(subStmt) || isa<DefaultStmt>(subStmt)) return;

  // Check if default label and statement are on the same line
  unsigned defaultLine = SM.getSpellingLineNumber(defaultLoc);
  unsigned subStmtLine = SM.getSpellingLineNumber(subStmtLoc);
  
  if (defaultLine == subStmtLine) {
    unsigned defaultColumn = SM.getSpellingColumnNumber(defaultLoc);
    std::string indentStr = "\n" + std::string(defaultColumn + 4, ' ');
    TheRewriter.InsertText(subStmtLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}

/// Transforms range-based for statements by inserting line breaks between condition and statement
void BreakLineTransformCallback::breakRangeForStatement(const CXXForRangeStmt *rangeforstmt,
                                                        const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation forLoc = rangeforstmt->getForLoc();
  if (!SM.isWrittenInMainFile(forLoc)) return;

  const Stmt *bodyStmt = rangeforstmt->getBody();
  if (!bodyStmt) return;

  // Only transform if the statement is not a compound statement (i.e., no braces)
  if (isa<CompoundStmt>(bodyStmt)) return;

  SourceLocation bodyLoc = bodyStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(bodyLoc)) return;

  // Check if they're on the same line
  unsigned forLine = SM.getSpellingLineNumber(forLoc);
  unsigned bodyLine = SM.getSpellingLineNumber(bodyLoc);
  
  if (forLine == bodyLine) {
    unsigned forColumn = SM.getSpellingColumnNumber(forLoc);
    std::string indentStr = "\n" + std::string(forColumn + 4, ' ');
    TheRewriter.InsertText(bodyLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}

/// Transforms try statements by ensuring proper line breaks
void BreakLineTransformCallback::breakTryStatement(const CXXTryStmt *trystmt,
                                                   const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation tryLoc = trystmt->getTryLoc();
  if (!SM.isWrittenInMainFile(tryLoc)) return;

  const Stmt *tryBlock = trystmt->getTryBlock();
  if (!tryBlock) return;

  SourceLocation tryBlockLoc = tryBlock->getBeginLoc();
  if (!SM.isWrittenInMainFile(tryBlockLoc)) return;

  // Check if try and block are on the same line
  unsigned tryLine = SM.getSpellingLineNumber(tryLoc);
  unsigned tryBlockLine = SM.getSpellingLineNumber(tryBlockLoc);
  
  if (tryLine == tryBlockLine) {
    unsigned tryColumn = SM.getSpellingColumnNumber(tryLoc);
    std::string indentStr = "\n" + std::string(tryColumn, ' ');
    TheRewriter.InsertText(tryBlockLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }

  // Handle catch clauses
  for (unsigned i = 0; i < trystmt->getNumHandlers(); ++i) {
    const CXXCatchStmt *catchStmt = trystmt->getHandler(i);
    if (!catchStmt) continue;

    SourceLocation catchLoc = catchStmt->getCatchLoc();
    if (!SM.isWrittenInMainFile(catchLoc)) continue;

    // Check if this catch clause should start on a new line
    // For the first catch, check if it's on the same line as the try block end
    // For subsequent catches, check if it's on the same line as the previous catch
    SourceLocation prevLoc;
    if (i == 0) {
      // First catch: check against try block end
      prevLoc = tryBlock->getEndLoc();
    } else {
      // Subsequent catch: check against previous catch
      const CXXCatchStmt *prevCatch = trystmt->getHandler(i - 1);
      if (prevCatch && prevCatch->getHandlerBlock()) {
        prevLoc = prevCatch->getHandlerBlock()->getEndLoc();
      } else {
        continue;
      }
    }

    if (prevLoc.isValid() && SM.isWrittenInMainFile(prevLoc)) {
      unsigned prevLine = SM.getSpellingLineNumber(prevLoc);
      unsigned catchLine = SM.getSpellingLineNumber(catchLoc);
      
      if (prevLine == catchLine) {
        unsigned tryColumn = SM.getSpellingColumnNumber(tryLoc);
        std::string catchIndentStr = "\n" + std::string(tryColumn, ' ');
        TheRewriter.InsertText(catchLoc, catchIndentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
      }
    }

    const Stmt *handlerBlock = catchStmt->getHandlerBlock();
    if (!handlerBlock) continue;

    SourceLocation handlerLoc = handlerBlock->getBeginLoc();
    if (!SM.isWrittenInMainFile(handlerLoc)) continue;

    // Check if catch and handler block are on the same line
    unsigned catchLineAfter = SM.getSpellingLineNumber(catchLoc);
    unsigned handlerLine = SM.getSpellingLineNumber(handlerLoc);
    
    if (catchLineAfter == handlerLine) {
      unsigned catchColumn = SM.getSpellingColumnNumber(catchLoc);
      std::string handlerIndentStr = "\n" + std::string(catchColumn, ' ');
      TheRewriter.InsertText(handlerLoc, handlerIndentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
    }
  }
}

/// Transforms label statements by inserting line breaks between labels and statements
void BreakLineTransformCallback::breakLabelStatement(const LabelStmt *labelstmt,
                                                     const MatchFinder::MatchResult &Result) {
  SourceManager &SM = *Result.SourceManager;
  
  SourceLocation labelLoc = labelstmt->getIdentLoc();
  if (!SM.isWrittenInMainFile(labelLoc)) return;

  const Stmt *subStmt = labelstmt->getSubStmt();
  if (!subStmt) return;

  SourceLocation subStmtLoc = subStmt->getBeginLoc();
  if (!SM.isWrittenInMainFile(subStmtLoc)) return;

  // Check if label and statement are on the same line
  unsigned labelLine = SM.getSpellingLineNumber(labelLoc);
  unsigned subStmtLine = SM.getSpellingLineNumber(subStmtLoc);
  
  if (labelLine == subStmtLine) {
    unsigned labelColumn = SM.getSpellingColumnNumber(labelLoc);
    std::string indentStr = "\n" + std::string(labelColumn + 4, ' ');
    TheRewriter.InsertText(subStmtLoc, indentStr, /*InsertAfter=*/false, /*indentNewLines=*/false);
  }
}
