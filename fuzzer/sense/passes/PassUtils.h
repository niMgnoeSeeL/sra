/**
 *===----------------------------------------------------------------------===//
 * PassUtils.h: Common utilities for LLVM passes
 *===----------------------------------------------------------------------===//
 *
 * This header provides shared utility functions used across multiple passes:
 *   - getFunctionSourcePath: Extract source file path from function debug info
 *   - NotImplementedError: Custom exception for unsupported instrumentation
 *
 *===----------------------------------------------------------------------===//
 */

#ifndef SENSE_PASS_UTILS_H
#define SENSE_PASS_UTILS_H

#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include <exception>
#include <optional>
#include <string>

namespace llvm {

/**
 * Custom exception for unsupported instrumentation scenarios.
 * 
 * This is thrown when a pass encounters a situation it cannot handle
 * (e.g., pointer types in sampling, unsupported data layouts).
 */
class NotImplementedError : public std::exception {
private:
  std::string Message;

public:
  explicit NotImplementedError(const std::string &Msg = "Not implemented")
      : Message(Msg) {}

  const char *what() const noexcept override { return Message.c_str(); }
};

/**
 * Extract the source file path from a function's debug information.
 * 
 * This function retrieves the canonical source file path for a given function
 * by examining its DISubprogram metadata. This is useful for filtering
 * functions based on their source file location.
 * 
 * @param F The function to query
 * @return The full source path (directory + filename) if available,
 *         std::nullopt if the function has no debug info
 * 
 * Example:
 *   auto PathOpt = getFunctionSourcePath(F);
 *   if (PathOpt && *PathOpt == "/path/to/target.c") {
 *     // Process this function
 *   }
 */
static inline std::optional<std::string>
getFunctionSourcePath(const Function &F) {
  if (const DISubprogram *SP = F.getSubprogram()) {
    const DIFile *File = SP->getFile();
    if (!File)
      return std::nullopt;

    // These are StringRef
    StringRef Dir = File->getDirectory();
    StringRef Name = File->getFilename();

    if (!Dir.empty())
      return (Dir + "/" + Name).str();
    return Name.str();
  }

  // No attached subprogram → probably no debug info
  return std::nullopt;
}

} // namespace llvm

#endif // SENSE_PASS_UTILS_H
