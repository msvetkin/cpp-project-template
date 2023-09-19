# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

include(set_@cpp_pt_cmake@_target_properties)

# sets all nessary default things
function(add_@cpp_pt_cmake@_module module_name)
  set(module_target @cpp_pt_cmake@-${module_name})
  set(module_alias @cpp_pt_name@::${module_name})

  add_library(${module_target} ${ARGN})
  add_library(${module_alias} ALIAS ${module_target})

  get_target_property(module_target_type ${module_target} TYPE)
  if("${module_target_type}" STREQUAL "INTERFACE_LIBRARY")
    set(module_type "INTERFACE")
  else()
    set(module_type "PUBLIC")
  endif()

  set_@cpp_pt_cmake@_target_properties(${module_target} ${module_type})

  target_include_directories(
    ${module_target} ${module_type}
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  )
  set_target_properties(${module_target} PROPERTIES EXPORT_NAME ${module_name})

  target_link_libraries(${module_target} ${module_type})

  if (TARGET @cpp_pt_name@)
    target_link_libraries(@cpp_pt_name@ INTERFACE ${module_target})
    install(TARGETS ${module_target} EXPORT @cpp_pt_name@-targets)
    install(DIRECTORY include/@cpp_pt_name@/${module_name} TYPE INCLUDE)
  endif()

  set(@cpp_pt_cmake@_module_target
      ${module_target}
      PARENT_SCOPE
  )
endfunction()
