# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.25)

get_property(IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)

if(IN_TRY_COMPILE)
  return()
endif()

unset(IN_TRY_COMPILE)

include(${CMAKE_CURRENT_LIST_DIR}/bootstrap/vcpkg-config.cmake)

vcpkg_configure(
  CACHE_DIR_NAME @cpp_pt_name@
  REPO https://github.com/rioam2/vcpkg-wasm32-wasi
  REF 983e077b814c4c0e56336e1d32407c2b2c13a90b
)

include($CACHE{_VCPKG_TOOLCHAIN_FILE})
