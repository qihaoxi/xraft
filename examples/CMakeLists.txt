file(GLOB XRAFT_EXAMPLE_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.c")

if(NOT TARGET xraft)
  message(STATUS "Examples requested, but target 'xraft' is not available; skipping examples.")
  return()
endif()

if(NOT XRAFT_EXAMPLE_SOURCES)
  message(STATUS "No example sources found in ${CMAKE_CURRENT_SOURCE_DIR}; skipping examples.")
  return()
endif()

foreach(example_source IN LISTS XRAFT_EXAMPLE_SOURCES)
  get_filename_component(example_name "${example_source}" NAME_WE)
  set(example_target "xraft_example_${example_name}")

  add_executable(${example_target} "${example_source}")
  target_link_libraries(${example_target} PRIVATE xraft)
  xraft_apply_default_target_settings(${example_target})
endforeach()

