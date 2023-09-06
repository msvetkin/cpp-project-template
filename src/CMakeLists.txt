# Copyright (c) 2023 Mikhail Svetkin.
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.25)

project(
  cxx
  VERSION 0.0.1
  LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(add_cxx_module)

find_package(fmt CONFIG REQUIRED)
find_package(Microsoft.GSL CONFIG REQUIRED)
find_package(range-v3 CONFIG REQUIRED)

message(STATUS "before core")
add_subdirectory(core)
message(STATUS "after core")
