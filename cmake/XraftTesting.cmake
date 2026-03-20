include_guard(GLOBAL)

function(xraft_enable_testing)
  if(NOT BUILD_TESTING)
    message(STATUS "Tests are disabled (BUILD_TESTING=OFF).")
    return()
  endif()

  if(EXISTS "${PROJECT_SOURCE_DIR}/tests/CMakeLists.txt")
    add_subdirectory("${PROJECT_SOURCE_DIR}/tests" "${PROJECT_BINARY_DIR}/tests")
  else()
    message(STATUS "Skipping tests/: no CMakeLists.txt found.")
  endif()
endfunction()

