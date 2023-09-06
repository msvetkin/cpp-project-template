# Copyright (c) 2023 Mikhail Svetkin.
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.25)

project(cxx-tests LANGUAGES CXX)

message(STATUS "PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR}")

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(add_cxx_test)

add_subdirectory(core)

add_test(
  NAME cmake-install
  COMMAND ${CMAKE_COMMAND} --install ${CMAKE_BINARY_DIR} --config $<CONFIG>
          --prefix "${CMAKE_CURRENT_BINARY_DIR}/cmake/$<CONFIG>/install/"
)
