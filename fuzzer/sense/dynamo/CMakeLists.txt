cmake_minimum_required(VERSION 3.20)
project(track_reads)

# Use release build to match drrun
set(CMAKE_BUILD_TYPE "Release")

# Find DynamoRIO
find_package(DynamoRIO REQUIRED)
if (NOT DynamoRIO_FOUND)
  message(FATAL_ERROR "DynamoRIO not found. Set DynamoRIO_DIR to the installation path.")
endif()

# Build the minimal test client
add_library(minimal_test SHARED minimal_test.c)
configure_DynamoRIO_client(minimal_test)

# Build the client library (must come before configure_DynamoRIO_client)
add_library(track_reads SHARED track_reads.c)

# Configure DynamoRIO client (must come after add_library)
configure_DynamoRIO_client(track_reads)

# Use DynamoRIO extensions
use_DynamoRIO_extension(track_reads drmgr)
use_DynamoRIO_extension(track_reads drwrap)
use_DynamoRIO_extension(track_reads drutil)
use_DynamoRIO_extension(track_reads drsyms)

# Build the marker-based client library
add_library(track_reads_marker SHARED track_reads_marker.c marker_common.c read_tracker.c)
configure_DynamoRIO_client(track_reads_marker)
use_DynamoRIO_extension(track_reads_marker drmgr)
use_DynamoRIO_extension(track_reads_marker drwrap)
use_DynamoRIO_extension(track_reads_marker drutil)
use_DynamoRIO_extension(track_reads_marker drsyms)

# Build the client library for tracking writes
add_library(track_writes_marker SHARED track_writes_marker.c marker_common.c write_tracker.c)
configure_DynamoRIO_client(track_writes_marker)
use_DynamoRIO_extension(track_writes_marker drmgr)
use_DynamoRIO_extension(track_writes_marker drwrap)
use_DynamoRIO_extension(track_writes_marker drutil)
use_DynamoRIO_extension(track_writes_marker drsyms)

# Build the combined read/write client library
add_library(track_rw_marker SHARED track_rw_marker.c marker_common.c read_tracker.c write_tracker.c)
configure_DynamoRIO_client(track_rw_marker)
use_DynamoRIO_extension(track_rw_marker drmgr)
use_DynamoRIO_extension(track_rw_marker drwrap)
use_DynamoRIO_extension(track_rw_marker drutil)
use_DynamoRIO_extension(track_rw_marker drsyms)


# Install
install(TARGETS track_reads track_reads_marker track_writes_marker track_rw_marker minimal_test DESTINATION lib)
# Build the test applications with debug flags
# -O0 -g
add_executable(target tests/target.c)
target_compile_options(target PRIVATE -O0 -g)

add_executable(target_persist tests/target_persist.c)
target_compile_options(target_persist PRIVATE -O0 -g)

add_executable(target_marker tests/target_marker.c)
target_compile_options(target_marker PRIVATE -O0 -g)

add_executable(target_marker_offset tests/target_marker_offset.c)
target_compile_options(target_marker_offset PRIVATE -O0 -g)

add_executable(target_marker_writes tests/target_marker_writes.c)
target_compile_options(target_marker_writes PRIVATE -O0 -g)

add_executable(target_marker_rw tests/target_marker_rw.c)
target_compile_options(target_marker_rw PRIVATE -O0 -g)