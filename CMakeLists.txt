cmake_minimum_required(VERSION 3.20)
project(pbl LANGUAGES C CXX OBJC OBJCXX)

# -----------------------------------------------------------------
#   CMake Variables
# -----------------------------------------------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_VERBOSE_MAKEFILE 1)       # Enable for more verbose CMake output
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/bin")

# -----------------------------------------------------------------
#   Local Variables
# -----------------------------------------------------------------
set(PROJECT_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/src")

# -----------------------------------------------------------------
#   Target Sources
# -----------------------------------------------------------------
file(GLOB_RECURSE PROJECT_SOURCES
        "${PROJECT_SOURCE_DIR}/*.h"
        "${PROJECT_SOURCE_DIR}/*.cpp"
        "${PROJECT_SOURCE_DIR}/*.mm"
        )

# We do not want to include duplicates
list(REMOVE_ITEM PROJECT_SOURCES "${PROJECT_SOURCE_DIR}/pblpch.h")

# -----------------------------------------------------------------
#   Create Executable
# -----------------------------------------------------------------
add_executable(${PROJECT_NAME} "${PROJECT_SOURCES}")

# -----------------------------------------------------------------
#   Include Directories
# -----------------------------------------------------------------
target_include_directories(${PROJECT_NAME} PUBLIC
        "${PROJECT_SOURCE_DIR}"
        )

# -----------------------------------------------------------------
#   MacOSX Libraries
# -----------------------------------------------------------------
target_link_libraries(${PROJECT_NAME} PUBLIC
        "-framework ApplicationServices"
        "-framework CoreFoundation"
        "-framework Foundation"             # Required for Objective-C
        )

# -----------------------------------------------------------------
#   Precompiled Header(s)
# -----------------------------------------------------------------
target_precompile_headers(${PROJECT_NAME} PRIVATE "${PROJECT_SOURCE_DIR}/pblpch.h")