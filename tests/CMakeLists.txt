file(GLOB XRAFT_TEST_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.c")

if(NOT TARGET xraft)
  message(STATUS "Tests requested, but target 'xraft' is not available; skipping tests.")
  return()
endif()

if(NOT XRAFT_TEST_SOURCES)
  message(STATUS "No test sources found in ${CMAKE_CURRENT_SOURCE_DIR}; skipping tests.")
  return()
endif()

foreach(test_source IN LISTS XRAFT_TEST_SOURCES)
  get_filename_component(test_name "${test_source}" NAME_WE)
  set(test_target "xraft_test_${test_name}")

  add_executable(${test_target} "${test_source}")
  target_link_libraries(${test_target} PRIVATE xraft)
  xraft_apply_default_target_settings(${test_target})

  add_test(NAME ${test_target} COMMAND ${test_target})
endforeach()

