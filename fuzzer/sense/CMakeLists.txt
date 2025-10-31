cmake_minimum_required(VERSION 3.20)
project(mutargs LANGUAGES C CXX)

# Find your installed LLVM (recommend LLVM 20)
find_package(LLVM 20.1...<21 REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION} at ${LLVM_DIR}")

# Add this flag -fstandalone-debug to Fix a lldb bug
# so that we can use lldb to pretty-print libstdc++ types
# See https://github.com/vadimcn/codelldb/issues/415
add_compile_options(-fstandalone-debug)

# LLVM CMake helpers and definitions
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ---- runtime libraries (pure C; no LLVM deps) ----
add_library(mut_runtime STATIC
  runtime/mut_runtime.c
)
target_include_directories(mut_runtime PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/runtime)

add_library(sample_runtime STATIC
  runtime/sample_runtime.c
)
target_include_directories(sample_runtime PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/runtime)

add_library(flow_runtime STATIC
  runtime/flow_runtime.c
)
target_include_directories(flow_runtime PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/runtime)

# ---- pass plugins (new PM) ----
add_llvm_pass_plugin(MutArgsPass
  passes/MutArgsPass.cpp
)

add_llvm_pass_plugin(SampleArgsPass
  passes/SampleArgsPass.cpp
)

add_llvm_pass_plugin(SampleFlowSrcPass
  passes/SampleFlowSrcPass.cpp
)

add_llvm_pass_plugin(DummyIOPass
  passes/DummyIOPass.cpp
)
# Link to nothing extra; pass plugins link LLVM bits implicitly via the macro.
# We expose symbols that will be referenced from the runtime libraries at link time of the final program.

# ---- orchestrator executable ----
# Find Clang for AST analysis
find_package(Clang REQUIRED CONFIG)

# Find or fetch nlohmann/json for SARIF parsing
find_package(nlohmann_json 3.2.0 QUIET)
if(NOT nlohmann_json_FOUND)
  message(STATUS "nlohmann/json not found, using FetchContent")
  include(FetchContent)
  FetchContent_Declare(
    json
    URL https://github.com/nlohmann/json/releases/download/v3.11.3/json.tar.xz
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  )
  FetchContent_MakeAvailable(json)
endif()

add_executable(taint-orchestrator
  orchestrator/main.cpp
  orchestrator/FlowManager.cpp
  orchestrator/SARIFParser.cpp
  orchestrator/ASTAnalyzer.cpp
  orchestrator/InstrumentationStrategy.cpp
  orchestrator/ServiceComm.cpp
)

target_include_directories(taint-orchestrator PRIVATE
  ${LLVM_INCLUDE_DIRS}
  ${CLANG_INCLUDE_DIRS}
  ${CMAKE_CURRENT_SOURCE_DIR}/orchestrator
)

target_link_libraries(taint-orchestrator PRIVATE
  # LLVM libraries
  LLVM
  # Clang libraries for AST analysis
  clangAST
  clangBasic
  clangFrontend
  clangSerialization
  clangTooling
  # JSON library
  nlohmann_json::nlohmann_json
)

target_compile_definitions(taint-orchestrator PRIVATE
  ${LLVM_DEFINITIONS}
)

# ---- tiny demos (optional) ----
add_executable(demo demo/demo.c)
target_link_libraries(demo PRIVATE mut_runtime)

add_executable(sample_demo demo/demo.c)
target_link_libraries(sample_demo PRIVATE sample_runtime)

# ---- interference demo programs ----
add_executable(demo_constant demo/demo_constant.c)
target_link_libraries(demo_constant PRIVATE sample_runtime)

add_executable(demo_linear demo/demo_linear.c)
target_link_libraries(demo_linear PRIVATE sample_runtime)

add_executable(demo_modulo demo/demo_modulo.c)
target_link_libraries(demo_modulo PRIVATE sample_runtime)

add_executable(demo_sign demo/demo_sign.c)
target_link_libraries(demo_sign PRIVATE sample_runtime)

add_executable(demo_parity demo/demo_parity.c)
target_link_libraries(demo_parity PRIVATE sample_runtime)

add_executable(demo_hash demo/demo_hash.c)
target_link_libraries(demo_hash PRIVATE sample_runtime)
