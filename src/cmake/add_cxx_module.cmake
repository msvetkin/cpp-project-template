# Copyright (c) 2023 Mikhail Svetkin.
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

include(GNUInstallDirs)

# global target
add_library(cxx INTERFACE)
add_library(cxx::cxx ALIAS cxx)
install(TARGETS cxx EXPORT cxx-targets)

# local build
export(EXPORT cxx-targets NAMESPACE cxx::)
configure_file("cmake/cxx-config.cmake" "." COPYONLY)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  cxx-config-version.cmake COMPATIBILITY SameMajorVersion
)

# installation
install(
  EXPORT cxx-targets
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/cxx
  NAMESPACE cxx::
)

cmake_language(DEFER CALL _add_cxx_module_finalize)

install(
  FILES cmake/cxx-config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/cxx-config-version.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/cxx-config-version.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/cxx
)

# finalizy module
function(_add_cxx_module_finalize)
  get_target_property(target_interface_libs cxx INTERFACE_LINK_LIBRARIES)
  message(STATUS "_add_cxx_module_finalize:")
  foreach(module IN LISTS target_interface_libs)
    if("${module}" MATCHES "cxx")
      message(STATUS "module: ${module}")
      get_target_property(module_libs ${module} INTERFACE_LINK_LIBRARIES)
      message(STATUS "module_libs: ${module_libs}")
    endif()
  endforeach()
  message(STATUS "_add_cxx_module_finalize")
endfunction()

# sets all nessary default things
function(add_cxx_module module_name)
  set(module_target cxx_${module_name})
  set(module_alias cxx::${module_name})

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

  install(TARGETS ${module_target} EXPORT cxx-targets)
  install(DIRECTORY include/cxx/${module_name} TYPE INCLUDE)

  target_link_libraries(cxx INTERFACE ${module_target})

  set(cxx_module_target
      ${module_target}
      PARENT_SCOPE
  )
endfunction()
