# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

include(set_@cpp_pt_cmake@_target_properties)

include(GenerateExportHeader)
include(GNUInstallDirs)

# generaete header with export macro
function(_@cpp_pt_cmake@_module_generate_export_headers target)
  set(export_file_dir "${CMAKE_CURRENT_BINARY_DIR}/include/@cpp_pt_name@")
  set(export_file "${export_file_dir}/${module_name}/export.hpp")
  generate_export_header(${module_target}
    EXPORT_FILE_NAME ${export_file}
  )

  if (WASI)
    file(APPEND ${export_file} "\
      \n#ifndef WASM_EXPORT\
      \n#define WASM_EXPORT(name) extern \"C\" __attribute__((export_name(name)))\
      \n#endif")
  else ()
    file(APPEND ${export_file} "\
      \n#ifndef WASM_EXPORT\
      \n#define WASM_EXPORT(name)\
      \n#endif")
  endif ()

  target_include_directories(
    ${module_target} ${module_type}
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
  )

  if (TARGET @cpp_pt_name@)
    install(DIRECTORY ${export_file_dir} TYPE INCLUDE)
  endif()
endfunction()

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
    _@cpp_pt_cmake@_module_generate_export_headers(${module_target})
  endif()

  set_@cpp_pt_cmake@_target_properties(${module_target} ${module_type})

  target_include_directories(
    ${module_target} ${module_type}
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
  )
  set_target_properties(${module_target} PROPERTIES EXPORT_NAME ${module_name})

  target_link_libraries(${module_target} ${module_type})

  if (TARGET @cpp_pt_name@)
    target_link_libraries(@cpp_pt_name@ INTERFACE ${module_target})
    install(TARGETS ${module_target} EXPORT @cpp_pt_name@-targets)
    install(DIRECTORY include/@cpp_pt_name@ TYPE INCLUDE)
  endif()

  set(@cpp_pt_cmake@_module_target
      ${module_target}
      PARENT_SCOPE
  )

  if(WASI)
    set(module_target_wasm "${module_target}_wasm")
    add_executable(${module_target_wasm} ${ARGN})
    set_target_properties(${module_target_wasm} PROPERTIES OUTPUT_NAME "lib@cpp_pt_cmake@-${module_name}.wasm")
    target_include_directories(
      ${module_target_wasm} ${module_type}
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
      $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    target_link_options(
      ${module_target_wasm} PUBLIC 
      -nostartfiles 
      -Wl,--no-entry
    )
    set(@cpp_pt_cmake@_module_target_wasm
      ${module_target_wasm}
      PARENT_SCOPE
    )
  endif()
endfunction()
