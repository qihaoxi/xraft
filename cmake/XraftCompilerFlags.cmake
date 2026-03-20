include_guard(GLOBAL)

include(CheckCCompilerFlag)

function(xraft_append_supported_c_flag out_var flag)
  string(MAKE_C_IDENTIFIER "${flag}" _xraft_flag_id)
  set(_xraft_cache_var "XRAFT_HAS_C_FLAG_${_xraft_flag_id}")

  check_c_compiler_flag("${flag}" ${_xraft_cache_var})

  if(${_xraft_cache_var})
    set(${out_var} "${${out_var}};${flag}" PARENT_SCOPE)
  endif()
endfunction()

function(xraft_setup_compiler_flags)
  if(NOT TARGET xraft_project_options)
    add_library(xraft_project_options INTERFACE)
    target_compile_features(xraft_project_options INTERFACE c_std_11)
    target_compile_definitions(xraft_project_options INTERFACE
      $<$<CONFIG:Debug>:XRAFT_DEBUG=1>
    )

    if(XRAFT_ENABLE_STRICT_CHECKS)
      if(UNIX)
        target_compile_definitions(xraft_project_options INTERFACE
          _GNU_SOURCE
          _FILE_OFFSET_BITS=64
          _LARGEFILE_SOURCE
          _LARGEFILE64_SOURCE
        )
      else()
        target_compile_definitions(xraft_project_options INTERFACE
          _FILE_OFFSET_BITS=64
        )
      endif()
    endif()
  endif()

  if(NOT TARGET xraft_project_warnings)
    add_library(xraft_project_warnings INTERFACE)

    if(CMAKE_C_COMPILER_ID MATCHES "Clang|GNU")
      set(_xraft_strict_check_options)

      if(XRAFT_ENABLE_STRICT_CHECKS)
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wno-sign-compare")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wstrict-prototypes")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wmissing-declarations")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wwrite-strings")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wcast-align")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wuninitialized")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wno-unused-function")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-Wno-unused-parameter")
        xraft_append_supported_c_flag(_xraft_strict_check_options "-fstack-protector-strong")

        if(NOT "-fstack-protector-strong" IN_LIST _xraft_strict_check_options)
          xraft_append_supported_c_flag(_xraft_strict_check_options "-fstack-protector")
        endif()

        xraft_append_supported_c_flag(_xraft_strict_check_options "-fstack-clash-protection")
      endif()

      target_compile_options(xraft_project_warnings INTERFACE
        -Wall
        -Wextra
        -Wpedantic
        $<$<BOOL:${XRAFT_ENABLE_STRICT_WARNINGS}>:-Wconversion>
        $<$<BOOL:${XRAFT_ENABLE_STRICT_WARNINGS}>:-Wsign-conversion>
        $<$<OR:$<BOOL:${XRAFT_WARNINGS_AS_ERRORS}>,$<BOOL:${XRAFT_ENABLE_STRICT_CHECKS}>>:-Werror>
        ${_xraft_strict_check_options}
      )
    elseif(MSVC)
      target_compile_options(xraft_project_warnings INTERFACE
        /W4
        $<$<OR:$<BOOL:${XRAFT_WARNINGS_AS_ERRORS}>,$<BOOL:${XRAFT_ENABLE_STRICT_CHECKS}>>:/WX>
      )
    endif()
  endif()
endfunction()

function(xraft_apply_default_target_settings target)
  if(NOT TARGET "${target}")
    message(FATAL_ERROR "xraft_apply_default_target_settings: target '${target}' does not exist.")
  endif()

  get_target_property(_xraft_target_type "${target}" TYPE)

  set(options)
  set(oneValueArgs SCOPE)
  cmake_parse_arguments(XRAFT "${options}" "${oneValueArgs}" "" ${ARGN})

  if(NOT XRAFT_SCOPE)
    set(XRAFT_SCOPE PRIVATE)
  endif()

  if(_xraft_target_type STREQUAL "INTERFACE_LIBRARY")
    set(XRAFT_SCOPE INTERFACE)
  endif()

  target_link_libraries(${target} ${XRAFT_SCOPE}
    xraft_project_options
    xraft_project_warnings
    xraft_project_link_options
    xraft_project_sanitizers
  )
endfunction()

