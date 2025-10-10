#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"

#include "BreakLineTransform.h"

using namespace clang;
using namespace clang::tooling;
using namespace llvm;

static cl::OptionCategory MyFmtCategory("myfmt options");

static cl::opt<bool> InPlace("i", cl::desc("Edit files in place"), 
                             cl::cat(MyFmtCategory));

static cl::alias InPlaceAlias("in-place", cl::desc("Alias for -i"), 
                              cl::aliasopt(InPlace), cl::cat(MyFmtCategory));



// Small factory that injects the flag into each action
class MyActionFactory : public clang::tooling::FrontendActionFactory {
public:
  explicit MyActionFactory(bool inPlace) : inPlace_(inPlace) {}
  std::unique_ptr<clang::FrontendAction> create() override {
    return std::make_unique<myfmt::BreakLineTransformAction>(inPlace_);
  }
private:
  bool inPlace_;
};

int main(int argc, const char **argv) {
  auto ExpectedParser = CommonOptionsParser::create(argc, argv, MyFmtCategory);
  if (!ExpectedParser) {
    llvm::errs() << ExpectedParser.takeError();
    return 1;
  }
  CommonOptionsParser &OptionsParser = ExpectedParser.get();

  ClangTool Tool(OptionsParser.getCompilations(),
                 OptionsParser.getSourcePathList());

  MyActionFactory Factory(InPlace);
  return Tool.run(&Factory);
}