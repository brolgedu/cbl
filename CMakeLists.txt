cmake_minimum_required(VERSION 3.20)
project(cbl LANGUAGES C CXX OBJC OBJCXX)

# -----------------------------------------------------------------
#   CMake Variables
# -----------------------------------------------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_VERBOSE_MAKEFILE 1)       # Enable for more verbose CMake output
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/bin")
set(CMAKE_INSTALL_PREFIX "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}" CACHE PATH "Install here" FORCE)

# -----------------------------------------------------------------
#   Local Variables
# -----------------------------------------------------------------
set(PROJECT_ENABLE_TESTS 0)
set(PROJECT_ENABLE_DEBUG 0)
set(PROJECT_DIR "${CMAKE_CURRENT_LIST_DIR}/cbl")
set(PROJECT_SOURCE_DIR  "${PROJECT_DIR}/src")
set(PROJECT_VENDOR_DIR "${PROJECT_DIR}/vendor")
set(PROJECT_ASSETS_DIR "${PROJECT_DIR}/assets")

# -----------------------------------------------------------------
#   Target Sources
# -----------------------------------------------------------------
file(GLOB_RECURSE PROJECT_SOURCES
        "${PROJECT_SOURCE_DIR}/*.h"
        "${PROJECT_SOURCE_DIR}/*.cpp"
        "${PROJECT_SOURCE_DIR}/*.mm"
        )

# We do not want to include duplicates
list(REMOVE_ITEM PROJECT_SOURCES
        "${PROJECT_SOURCE_DIR}/cblpch.h")

list(REMOVE_ITEM PROJECT_SOURCES
        "${PROJECT_SOURCE_DIR}/main.mm")

# -----------------------------------------------------------------
#   Testing Sources (if enabled)
# -----------------------------------------------------------------
if (PROJECT_ENABLE_TESTS)
    # Include test sources
    list(APPEND PROJECT_SOURCES
            "modules/tests/file_system/file_system_test.mm"
            #            "modules/tests/folder_manager/folder_manager_test.mm"
            )

    # Remove program entry point from main program if necessary
    list(REMOVE_ITEM PROJECT_SOURCES
            "${PROJECT_SOURCE_DIR}/main.cpp"
            "${PROJECT_SOURCE_DIR}/main.mm"
            )
endif ()

# -----------------------------------------------------------------
#   Create Executable
# -----------------------------------------------------------------
add_executable(${PROJECT_NAME} "${PROJECT_SOURCES}")

# -----------------------------------------------------------------
#   Include Directories
# -----------------------------------------------------------------
target_include_directories(${PROJECT_NAME} PUBLIC
        "${PROJECT_SOURCE_DIR}"
        "${PROJECT_ASSETS_DIR}/fonts"
        "${PROJECT_VENDOR_DIR}/imgui"
        "${PROJECT_VENDOR_DIR}/GLFW"
        )

# -----------------------------------------------------------------
#   Libraries
# -----------------------------------------------------------------
# glfw
#find_package(glfw3 3.3 REQUIRED)
add_subdirectory("${PROJECT_VENDOR_DIR}/GLFW")
target_link_libraries(${PROJECT_NAME} PUBLIC glfw)
add_subdirectory("${PROJECT_VENDOR_DIR}/imgui")
target_link_libraries(${PROJECT_NAME} PRIVATE
        "imgui"
        "glfw"
        )

if (APPLE)
    target_link_libraries(${PROJECT_NAME} PRIVATE
            "-framework ApplicationServices"
            "-framework CoreFoundation"
            "-framework Foundation"
            "-framework Appkit"
            "-framework OpenGL"
            )
endif ()

# Work-around for "does not return NSSTRING" xcode13 commandline tools compile error
target_compile_options(${PROJECT_NAME} PRIVATE "-DNS_FORMAT_ARGUMENT(A)=")

# -----------------------------------------------------------------
#   Precompiled Header(s)
# -----------------------------------------------------------------
target_precompile_headers(${PROJECT_NAME} PRIVATE "${PROJECT_SOURCE_DIR}/cblpch.h")

if (PROJECT_ENABLE_DEBUG)
    target_compile_definitions(${PROJECT_NAME} PUBLIC "CBL_DEBUG=1")
endif ()

# -----------------------------------------------------------------
#   Install application
# -----------------------------------------------------------------
file(GLOB_RECURSE PROJECT_ASSETS "${PROJECT_ASSETS_DIR}/*/")

add_custom_target(install_${PROJECT_NAME} SOURCES ${PROJECT_SOURCES} DEPENDS ${PROJECT_ASSETS})
install(TARGETS "${PROJECT_NAME}" DESTINATION "${CMAKE_INSTALL_PREFIX}" CONFIGURATIONS Debug)
#install(TARGETS "${PROJECT_NAME}" DESTINATION "${CMAKE_INSTALL_PREFIX}" CONFIGURATIONS Release)
#install(FILES "${CMAKE_INSTALL_PREFIX}/${PROJECT_NAME}" DESTINATION "${CMAKE_INSTALL_PREFIX}/release")