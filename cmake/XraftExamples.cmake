include_guard(GLOBAL)

function(xraft_enable_examples)
  if(NOT XRAFT_BUILD_EXAMPLES)
    message(STATUS "Examples are disabled (XRAFT_BUILD_EXAMPLES=OFF).")
    return()
  endif()

  if(EXISTS "${PROJECT_SOURCE_DIR}/examples/CMakeLists.txt")
    add_subdirectory("${PROJECT_SOURCE_DIR}/examples" "${PROJECT_BINARY_DIR}/examples")
  else()
    message(STATUS "Skipping examples/: no CMakeLists.txt found.")
  endif()
endfunction()

