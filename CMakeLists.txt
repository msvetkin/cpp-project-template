# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT
@CPP_PT_HAS_NOT_BEEN_INIT_PLEASE_READ_README@
cmake_minimum_required(VERSION 3.25)

project(@cpp_pt_name@-dev LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

add_subdirectory(src)

enable_testing()
add_subdirectory(tests)
