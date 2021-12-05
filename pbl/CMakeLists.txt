cmake_minimum_required(VERSION 3.20)
set(CMAKE_CXX_STANDARD 17)
project(pbl)

# -----------------------------------------------------------------
#   Local Variables
# -----------------------------------------------------------------
set(PROJECT_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/src")

# -----------------------------------------------------------------
#   Target Sources and Create Executable
# -----------------------------------------------------------------
file(GLOB_RECURSE PROJECT_SOURCES
        "${PROJECT_SOURCE_DIR}/*.h"
        "${PROJECT_SOURCE_DIR}/*.cpp"
        )

# We do not want to include the pch in the sources
list(REMOVE_ITEM PROJECT_SOURCES "${PROJECT_SOURCE_DIR}/pblpch.h")

# -----------------------------------------------------------------
#   Create executable
# -----------------------------------------------------------------
add_executable(${PROJECT_NAME} "${PROJECT_SOURCES}")

# -----------------------------------------------------------------
#   Include directories
# -----------------------------------------------------------------
target_include_directories(${PROJECT_NAME} PUBLIC
        "${PROJECT_SOURCE_DIR}"
        )

# -----------------------------------------------------------------
#   MacOSX Dependencies
# -----------------------------------------------------------------
# Required for IOKit Headers
target_include_directories(${PROJECT_NAME} PUBLIC
        "/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Frameworks/IOKit.framework/Headers"
        )

# Required for linking MacOSX libraries
target_link_libraries(${PROJECT_NAME} PUBLIC
        "-framework CoreFoundation"
        "-framework ApplicationServices"
        )

# -----------------------------------------------------------------
#   Precompiled header(s)
# -----------------------------------------------------------------
target_precompile_headers(${PROJECT_NAME} PRIVATE "${PROJECT_SOURCE_DIR}/pblpch.h")