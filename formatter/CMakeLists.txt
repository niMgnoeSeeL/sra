cmake_minimum_required(VERSION 3.20)
project(MyFmtTool LANGUAGES C CXX)

find_package(LLVM 20.1...<21 REQUIRED CONFIG)
message(STATUS "LLVM_DIR = ${LLVM_DIR}")

# monolithic clang-cpp
find_library(CLANG_CPP_LIB
  NAMES clang-cpp clang-cpp20
  HINTS /usr/lib/llvm-20/lib /usr/lib/x86_64-linux-gnu
  REQUIRED)

# try the imported LLVM target first; otherwise fall back to the .so
set(HAVE_LLVM_TARGET OFF)
if (TARGET LLVM)
  set(HAVE_LLVM_TARGET ON)
else()
  find_library(LLVM_SHARED
    NAMES LLVM
    HINTS /usr/lib/llvm-20/lib /usr/lib/x86_64-linux-gnu
    REQUIRED)
endif()

add_executable(myfmt
  src/main.cpp
  src/BreakLineTransform.cpp)

target_include_directories(myfmt PRIVATE
  /usr/lib/llvm-20/include)  # has <clang/...> after installing libclang-20-dev

# IMPORTANT: order matters for GNU ld; keep clang-cpp before LLVM
if (HAVE_LLVM_TARGET)
  target_link_libraries(myfmt PRIVATE
    ${CLANG_CPP_LIB}
    LLVM            # imported target from find_package(LLVM)
    LLVMSupport
    LLVMOption)
else()
  target_link_libraries(myfmt PRIVATE
    ${CLANG_CPP_LIB}
    ${LLVM_SHARED}  # raw libLLVM.so
    LLVMSupport
    LLVMOption)
endif()

# If your distro uses --as-needed by default, this guarantees LLVM isn't dropped
# target_link_options(myfmt PRIVATE -Wl,--no-as-needed)

install(TARGETS myfmt RUNTIME DESTINATION bin)
