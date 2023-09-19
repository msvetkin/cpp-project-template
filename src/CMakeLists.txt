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

include(@cpp_pt_name@-install-targets)
include(add_@cpp_pt_cmake@_module)
include(add_@cpp_pt_cmake@_executable)

add_subdirectory(@cpp_pt_module@)
add_subdirectory(cli)
