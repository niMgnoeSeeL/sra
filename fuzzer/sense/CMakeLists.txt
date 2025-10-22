cmake_minimum_required(VERSION 3.20)
project(mutargs LANGUAGES C CXX)

# Find your installed LLVM (recommend LLVM 20)
find_package(LLVM 20.1...<21 REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION} at ${LLVM_DIR}")

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

# ---- pass plugins (new PM) ----
add_llvm_pass_plugin(MutArgsPass
  passes/MutArgsPass.cpp
)

add_llvm_pass_plugin(SampleArgsPass
  passes/SampleArgsPass.cpp
)

add_llvm_pass_plugin(DummyIOPass
  passes/DummyIOPass.cpp
)
# Link to nothing extra; pass plugins link LLVM bits implicitly via the macro.
# We expose symbols that will be referenced from the runtime libraries at link time of the final program.

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
