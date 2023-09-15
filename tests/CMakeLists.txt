# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT
@CPP_PT_HAS_NOT_BEEN_INIT_PLEASE_READ_README@
cmake_minimum_required(VERSION 3.25)

project(@cpp_pt_name@-tests LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(add_@cpp_pt_cmake@_test)

add_subdirectory(@cpp_pt_module@)

add_test(
  NAME cmake-install
  COMMAND ${CMAKE_COMMAND} --install ${CMAKE_BINARY_DIR} --config $<CONFIG>
          --prefix "${CMAKE_CURRENT_BINARY_DIR}/cmake/$<CONFIG>/install/"
)
