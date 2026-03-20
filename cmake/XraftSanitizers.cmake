include_guard(GLOBAL)

function(xraft_setup_sanitizers)
  if(TARGET xraft_project_sanitizers)
    return()
  endif()

  add_library(xraft_project_sanitizers INTERFACE)

  if(NOT CMAKE_C_COMPILER_ID MATCHES "Clang|GNU")
    if(XRAFT_ENABLE_ASAN OR XRAFT_ENABLE_UBSAN OR XRAFT_ENABLE_TSAN OR XRAFT_ENABLE_MSAN)
      message(WARNING "Sanitizers are only configured for Clang/GNU-compatible toolchains; requested options will be ignored.")
    endif()
    return()
  endif()

  if(XRAFT_ENABLE_TSAN AND (XRAFT_ENABLE_ASAN OR XRAFT_ENABLE_MSAN))
    message(FATAL_ERROR "ThreadSanitizer cannot be combined with AddressSanitizer or MemorySanitizer.")
  endif()

  if(XRAFT_ENABLE_MSAN AND NOT CMAKE_C_COMPILER_ID MATCHES "Clang")
    message(FATAL_ERROR "MemorySanitizer requires Clang.")
  endif()

  set(_xraft_sanitizer_flags)

  if(XRAFT_ENABLE_ASAN)
    list(APPEND _xraft_sanitizer_flags -fsanitize=address)
  endif()

  if(XRAFT_ENABLE_UBSAN)
    list(APPEND _xraft_sanitizer_flags -fsanitize=undefined)
  endif()

  if(XRAFT_ENABLE_TSAN)
    list(APPEND _xraft_sanitizer_flags -fsanitize=thread)
  endif()

  if(XRAFT_ENABLE_MSAN)
    list(APPEND _xraft_sanitizer_flags -fsanitize=memory -fsanitize-memory-track-origins)
  endif()

  if(_xraft_sanitizer_flags)
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
      message(WARNING "Sanitizers are typically used with non-Release builds.")
    endif()

    list(REMOVE_DUPLICATES _xraft_sanitizer_flags)

    target_compile_options(xraft_project_sanitizers INTERFACE
      ${_xraft_sanitizer_flags}
      -fno-omit-frame-pointer
    )

    target_link_options(xraft_project_sanitizers INTERFACE
      ${_xraft_sanitizer_flags}
      -fno-omit-frame-pointer
    )
  endif()
endfunction()

