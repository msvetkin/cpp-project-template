# SPDX-FileCopyrightText: 2023 Mikhail Svetkin <mikhail.svetkin@gmail.com>
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.25)

project(
  cpp-project-template
  VERSION 0.0.1
  LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(add_cpp_project_template_module)
include(add_cpp_project_template_executable)

find_package(fmt CONFIG REQUIRED)
find_package(Microsoft.GSL CONFIG REQUIRED)
find_package(range-v3 CONFIG REQUIRED)

add_subdirectory(core)
add_subdirectory(cli)
