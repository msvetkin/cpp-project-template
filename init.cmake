# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.25)

function(print_help)
  message(
    FATAL_ERROR
      "usage: cmake -P init.cmake --project <name> --module <name> --header <name>"
  )
endfunction()

set(cli_args "")
math(EXPR range_stop "${CMAKE_ARGC}-1")
foreach(index RANGE 3 ${range_stop})
  list(APPEND cli_args "${CMAKE_ARGV${index}}")
endforeach()

cmake_parse_arguments(arg "" "--project;--module;--header" "" ${cli_args})

if(DEFINED arg_UNPARSED_ARGUMENTS
   OR (NOT DEFINED arg_--project
       OR NOT DEFINED arg_--module
       OR NOT DEFINED arg_--header)
)
  print_help()
endif()

find_package(Git REQUIRED)

string(REPLACE " " "-" cpp_pt_name "${arg_--project}")
string(REPLACE " " "_" cpp_pt_cmake "${arg_--project}")
string(REPLACE " " "-" cpp_pt_module "${arg_--module}")
string(REPLACE " " "-" cpp_pt_module_header "${arg_--header}")
string(TOUPPER "${cpp_pt_cmake}_${cpp_pt_module}_EXPORT" cpp_pt_module_export)

message(STATUS "----------------")
message(STATUS "project name:    ${cpp_pt_name}")
message(STATUS "cmake functions: add_${cpp_pt_cmake}_<module/test/executable>")
message(STATUS "module:          ${cpp_pt_module}")
message(STATUS "namespace:       ${cpp_pt_name}::${cpp_pt_module}")
message(STATUS "header:          ${cpp_pt_name}/${cpp_pt_module}/${cpp_pt_module_header}.hpp")
message(STATUS "----------------")

function(generate path)
  string(REPLACE "cpp_pt" "${cpp_pt_cmake}" output_path "${path}")
  string(REPLACE "cpp-pt" "${cpp_pt_name}" output_path "${output_path}")
  string(REPLACE "module-1" "${cpp_pt_module}" output_path "${output_path}")
  string(REPLACE "header-1" "${cpp_pt_module_header}" output_path "${output_path}")

  if(IS_DIRECTORY "${path}")
  else()
    configure_file(${CMAKE_SOURCE_DIR}/${path} "${CMAKE_SOURCE_DIR}/${path}" @ONLY)
  endif()

  file(RENAME ${path} ${output_path})
endfunction()

set(templates
    src/module-1
    src/${cpp_pt_module}/CMakeLists.txt
    src/${cpp_pt_module}/include/cpp-pt
    src/${cpp_pt_module}/include/${cpp_pt_name}/module-1
    src/${cpp_pt_module}/include/${cpp_pt_name}/${cpp_pt_module}/header-1.hpp
    src/${cpp_pt_module}/src/header-1.cpp
    src/cli/CMakeLists.txt
    src/cli/src/main.cpp
    src/cmake/add_cpp_pt_executable.cmake
    src/cmake/add_cpp_pt_module.cmake
    src/cmake/cpp-pt-config.cmake
    src/cmake/cpp-pt-install-targets.cmake
    src/cmake/set_cpp_pt_target_properties.cmake
    src/CMakeLists.txt
    tests/module-1
    tests/${cpp_pt_module}/header-1_test.cpp
    tests/${cpp_pt_module}/CMakeLists.txt
    tests/cmake/add_cpp_pt_test.cmake
    tests/CMakeLists.txt
    cmake/vcpkg/vcpkg.toolchain.cmake
    CMakeLists.txt
    vcpkg.json
)

message(STATUS "Setting up project...")
foreach(template IN LISTS templates)
  generate("${template}")
endforeach()

file(REMOVE "init.cmake")
file(REMOVE "README.md")
file(WRITE "README.md" "# Welcome to ${cpp_pt_name}")
file(RENAME ".github/ci.yaml" ".github/workflows/ci.yaml")
execute_process(COMMAND "${GIT_EXECUTABLE}" add "${CMAKE_SOURCE_DIR}")

message(STATUS "----------------")
message(STATUS "${cpp_pt_name} project is ready")
message(STATUS "Confirm: git commit --amend")
message(STATUS "Revert: git reset --hard && git clean -fd")
message(STATUS "----------------")
