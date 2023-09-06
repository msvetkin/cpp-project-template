# Copyright (c) 2023 Mikhail Svetkin.
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.25)

list(APPEND VCPKG_MANIFEST_FEATURES "tests")

project(cxx-dev LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
