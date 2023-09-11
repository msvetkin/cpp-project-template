# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

include(GNUInstallDirs)

# global target
add_library(cpp-project-template INTERFACE)
add_library(cpp-project-template::cpp-project-template ALIAS cpp-project-template)
install(TARGETS cpp-project-template EXPORT cpp-project-template-targets)

# local build
export(EXPORT cpp-project-template-targets NAMESPACE cpp-project-template::)
configure_file("cmake/cpp-project-template-config.cmake" "." COPYONLY)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  cpp-project-template-config-version.cmake COMPATIBILITY SameMajorVersion
)

# installation
install(
  EXPORT cpp-project-template-targets
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/cpp-project-template
  NAMESPACE cpp-project-template::
)

install(
  FILES cmake/cpp-project-template-config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/cpp-project-template-config-version.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/cpp-project-template-config-version.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/cpp-project-template
)

# sets all nessary default things
function(add_cpp_project_template_module module_name)
  set(module_target cpp-project-template_${module_name})
  set(module_alias cpp-project-template::${module_name})

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

  install(TARGETS ${module_target} EXPORT cpp-project-template-targets)
  install(DIRECTORY include/cpp-project-template/${module_name} TYPE INCLUDE)

  target_link_libraries(cpp-project-template INTERFACE ${module_target})

  set(cpp_project_template_module_target
      ${module_target}
      PARENT_SCOPE
  )
endfunction()
