cmake_minimum_required(VERSION 3.20)
project(pblApp)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_VERBOSE_MAKEFILE 1) # Enable for more verbose CMake output

# -----------------------------------------------------------------
#   CMake Variables
# -----------------------------------------------------------------
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/bin")

add_subdirectory(pbl)