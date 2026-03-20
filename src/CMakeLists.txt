file(GLOB XRAFT_SOURCE_FILES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.c")
file(GLOB XRAFT_HEADER_FILES CONFIGURE_DEPENDS
  "${CMAKE_CURRENT_SOURCE_DIR}/*.h"
  "${PROJECT_SOURCE_DIR}/include/*.h"
)

if((NOT XRAFT_SOURCE_FILES) AND (NOT XRAFT_HEADER_FILES))
  message(STATUS "No sources or headers found in ${CMAKE_CURRENT_SOURCE_DIR}; skipping the xraft library target.")
  return()
endif()

if(XRAFT_SOURCE_FILES)
  add_library(xraft ${XRAFT_SOURCE_FILES} ${XRAFT_HEADER_FILES})
else()
  add_library(xraft INTERFACE)
endif()

add_library(xraft::xraft ALIAS xraft)

target_include_directories(xraft INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  $<INSTALL_INTERFACE:include>
)

if(EXISTS "${PROJECT_SOURCE_DIR}/include")
  target_include_directories(xraft INTERFACE
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
  )
endif()

if(XRAFT_SOURCE_FILES)
  target_include_directories(xraft PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
  )

  if(EXISTS "${PROJECT_SOURCE_DIR}/include")
    target_include_directories(xraft PUBLIC
      $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    )
  endif()
endif()

xraft_apply_default_target_settings(xraft SCOPE PUBLIC)

