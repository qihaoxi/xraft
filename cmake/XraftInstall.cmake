include_guard(GLOBAL)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

function(xraft_enable_install)
  if(NOT TARGET xraft)
    message(STATUS "Skipping install/export setup: target 'xraft' is not available.")
    return()
  endif()

  set(_xraft_package_dir "${CMAKE_INSTALL_LIBDIR}/cmake/xraft")
  set(_xraft_config_file "${CMAKE_CURRENT_BINARY_DIR}/xraftConfig.cmake")
  set(_xraft_version_file "${CMAKE_CURRENT_BINARY_DIR}/xraftConfigVersion.cmake")

  set_target_properties(xraft PROPERTIES EXPORT_NAME xraft)

  install(TARGETS xraft
    EXPORT xraftTargets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )

  foreach(_xraft_export_target IN ITEMS
    xraft_project_options
    xraft_project_warnings
    xraft_project_link_options
    xraft_project_sanitizers
  )
    if(TARGET ${_xraft_export_target})
      install(TARGETS ${_xraft_export_target}
        EXPORT xraftTargets
      )
    endif()
  endforeach()

  if(EXISTS "${PROJECT_SOURCE_DIR}/include")
    install(DIRECTORY "${PROJECT_SOURCE_DIR}/include/"
      DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
      FILES_MATCHING PATTERN "*.h"
    )
  endif()

  file(GLOB _xraft_src_headers CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/src/*.h")
  if(_xraft_src_headers)
    install(FILES ${_xraft_src_headers}
      DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
  endif()

  configure_package_config_file(
    "${PROJECT_SOURCE_DIR}/cmake/XraftConfig.cmake.in"
    "${_xraft_config_file}"
    INSTALL_DESTINATION "${_xraft_package_dir}"
  )

  write_basic_package_version_file(
    "${_xraft_version_file}"
    VERSION "${XRAFT_VERSION}"
    COMPATIBILITY SameMajorVersion
  )

  install(EXPORT xraftTargets
    FILE xraftTargets.cmake
    NAMESPACE xraft::
    DESTINATION "${_xraft_package_dir}"
  )

  install(FILES
    "${_xraft_config_file}"
    "${_xraft_version_file}"
    DESTINATION "${_xraft_package_dir}"
  )
endfunction()

