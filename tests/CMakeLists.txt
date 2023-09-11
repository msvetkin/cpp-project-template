# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.25)

project(cpp-project-template-tests LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(add_cpp_project_template_test)

add_subdirectory(core)

add_test(
  NAME cmake-install
  COMMAND ${CMAKE_COMMAND} --install ${CMAKE_BINARY_DIR} --config $<CONFIG>
          --prefix "${CMAKE_CURRENT_BINARY_DIR}/cmake/$<CONFIG>/install/"
)
