cmake_minimum_required(VERSION 3.13)

project(xraft LANGUAGES C)

set(XRAFT_VERSION 0.1.0)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(XraftOptions)
include(XraftCompilerFlags)
include(XraftLinkOptions)
include(XraftSanitizers)
include(XraftTesting)
include(XraftExamples)
include(XraftInstall)

xraft_setup_options()
xraft_setup_compiler_flags()
xraft_setup_link_options()
xraft_setup_sanitizers()

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/CMakeLists.txt")
  add_subdirectory(src)
else()
  message(STATUS "Skipping src/: no CMakeLists.txt found.")
endif()

xraft_enable_install()

xraft_enable_testing()
xraft_enable_examples()
