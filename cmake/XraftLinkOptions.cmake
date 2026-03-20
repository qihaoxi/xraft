include_guard(GLOBAL)

include(CheckCCompilerFlag)

function(xraft_setup_link_options)
  if(TARGET xraft_project_link_options)
    return()
  endif()

  add_library(xraft_project_link_options INTERFACE)

  if(CMAKE_C_COMPILER_ID MATCHES "Clang|GNU")
    set(_xraft_strict_link_options)

    if(XRAFT_ENABLE_STRICT_CHECKS AND UNIX AND NOT APPLE)
      check_c_compiler_flag("-rdynamic" XRAFT_HAS_C_FLAG_RDYNAMIC)

      if(XRAFT_HAS_C_FLAG_RDYNAMIC)
        list(APPEND _xraft_strict_link_options
          $<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:-rdynamic>
        )
      endif()
    endif()

    if(UNIX AND NOT APPLE)
      target_link_options(xraft_project_link_options INTERFACE
        $<$<BOOL:${XRAFT_ENABLE_LINKER_AS_NEEDED}>:-Wl,--as-needed>
        $<$<BOOL:${XRAFT_ENABLE_NO_UNDEFINED}>:-Wl,--no-undefined>
        ${_xraft_strict_link_options}
      )
    elseif(APPLE)
      target_link_options(xraft_project_link_options INTERFACE
        $<$<BOOL:${XRAFT_ENABLE_NO_UNDEFINED}>:-Wl,-undefined,error>
      )
    endif()
  endif()
endfunction()

