# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.25)

get_property(IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)

if (IN_TRY_COMPILE)
  return()
endif()

unset(IN_TRY_COMPILE)

if (NOT DEFINED VCPKG_BUILTIN_BASELINE)
  message(FATAL_ERROR "Missing mandatory VCPKG_BUILTIN_BASELINE")
endif()

if (NOT DEFINED VCPKG_BOOTSTRAP_CHECKOUT)
  set(VCPKG_BOOTSTRAP_CHECKOUT "${VCPKG_BUILTIN_BASELINE}" CACHE INTERNAL "")
endif()

if (EXISTS "${CMAKE_SOURCE_DIR}/vcpkg.json")
  configure_file(${CMAKE_SOURCE_DIR}/vcpkg.json "." @ONLY)
  set(VCPKG_MANIFEST_DIR ${CMAKE_BINARY_DIR} CACHE INTERNAL "")
endif()

include(${CMAKE_CURRENT_LIST_DIR}/vcpkg_bootstrap.cmake)

vcpkg_bootstrap(
  https://github.com/microsoft/vcpkg.git
  "${VCPKG_BOOTSTRAP_CHECKOUT}"
)

include($CACHE{VCPKG_TOOLCHAIN_FILE})
