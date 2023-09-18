# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

include(GNUInstallDirs)

# global target
add_library(@cpp_pt_name@ INTERFACE)
add_library(@cpp_pt_name@::@cpp_pt_name@ ALIAS @cpp_pt_name@)
install(TARGETS @cpp_pt_name@ EXPORT @cpp_pt_name@-targets)

# local build
export(EXPORT @cpp_pt_name@-targets NAMESPACE @cpp_pt_name@::)
configure_file("cmake/@cpp_pt_name@-config.cmake" "." COPYONLY)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  @cpp_pt_name@-config-version.cmake COMPATIBILITY SameMajorVersion
)

# installation
install(
  EXPORT @cpp_pt_name@-targets
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/@cpp_pt_name@
  NAMESPACE @cpp_pt_name@::
)

install(
  FILES cmake/@cpp_pt_name@-config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/@cpp_pt_name@-config-version.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/@cpp_pt_name@
)

# sets all nessary default things
function(add_@cpp_pt_cmake@_module module_name)
  set(module_target @cpp_pt_cmake@_${module_name})
  set(module_alias @cpp_pt_name@::${module_name})

  add_library(${module_target} ${ARGN})
  add_library(${module_alias} ALIAS ${module_target})

  get_target_property(module_target_type ${module_target} TYPE)
  if("${module_target_type}" STREQUAL "INTERFACE_LIBRARY")
    set(module_type "INTERFACE")
  else()
    set(module_type "PUBLIC")
  endif()

  target_include_directories(
    ${module_target} ${module_type}
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  )
  set_target_properties(${module_target} PROPERTIES EXPORT_NAME ${module_name})

  target_link_libraries(${module_target} ${module_type})

  install(TARGETS ${module_target} EXPORT @cpp_pt_name@-targets)
  install(DIRECTORY include/@cpp_pt_name@/${module_name} TYPE INCLUDE)

  target_link_libraries(@cpp_pt_name@ INTERFACE ${module_target})

  set(@cpp_pt_cmake@_module_target
      ${module_target}
      PARENT_SCOPE
  )
endfunction()
