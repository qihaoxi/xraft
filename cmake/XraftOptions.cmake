include_guard(GLOBAL)

include(CTest)

function(xraft_setup_options)
  if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
    set(_xraft_is_top_level TRUE)
  else()
    set(_xraft_is_top_level FALSE)
  endif()

  if(_xraft_is_top_level AND NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release RelWithDebInfo MinSizeRel)
  endif()

  if(NOT DEFINED CMAKE_POSITION_INDEPENDENT_CODE)
    set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "Build position independent code." )
  endif()

  set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "Export compile_commands.json." )

  if(DEFINED STRICT_CHECKS AND NOT DEFINED XRAFT_ENABLE_STRICT_CHECKS)
    set(_xraft_default_strict_checks "${STRICT_CHECKS}")
  else()
    set(_xraft_default_strict_checks OFF)
  endif()

  option(BUILD_SHARED_LIBS "Build shared libraries instead of static libraries." OFF)
  option(XRAFT_BUILD_EXAMPLES "Build example programs." ON)
  option(XRAFT_WARNINGS_AS_ERRORS "Treat compiler warnings as errors." OFF)
  option(XRAFT_ENABLE_STRICT_WARNINGS "Enable additional strict compiler warnings." OFF)
  option(XRAFT_ENABLE_STRICT_CHECKS "Enable legacy strict checks, hardening flags, and large-file feature macros." ${_xraft_default_strict_checks})
  option(XRAFT_ENABLE_LINKER_AS_NEEDED "Pass --as-needed to the linker when supported." ON)
  option(XRAFT_ENABLE_NO_UNDEFINED "Fail the link when undefined symbols remain." OFF)
  option(XRAFT_ENABLE_ASAN "Enable AddressSanitizer." OFF)
  option(XRAFT_ENABLE_UBSAN "Enable UndefinedBehaviorSanitizer." OFF)
  option(XRAFT_ENABLE_TSAN "Enable ThreadSanitizer." OFF)
  option(XRAFT_ENABLE_MSAN "Enable MemorySanitizer (Clang only)." OFF)

  set(STRICT_CHECKS "${XRAFT_ENABLE_STRICT_CHECKS}" CACHE BOOL "Compatibility alias for XRAFT_ENABLE_STRICT_CHECKS." FORCE)
endfunction()

