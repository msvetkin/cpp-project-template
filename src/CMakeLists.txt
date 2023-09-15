# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT
@CPP_PT_HAS_NOT_BEEN_INIT_PLEASE_READ_README@
cmake_minimum_required(VERSION 3.25)

project(
  @cpp_pt_name@
  VERSION 0.0.1
  LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(add_@cpp_pt_cmake@_module)
include(add_@cpp_pt_cmake@_executable)

find_package(fmt CONFIG REQUIRED)
find_package(Microsoft.GSL CONFIG REQUIRED)
find_package(range-v3 CONFIG REQUIRED)

add_subdirectory(@cpp_pt_module@)
# add_subdirectory(cli)
