# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.25)

include(${CMAKE_CURRENT_LIST_DIR}/vcpkg_bootstrap.cmake)

vcpkg_bootstrap(
  https://github.com/microsoft/vcpkg.git
  9edb1b8e590cc086563301d735cae4b6e732d2d2 # 2023.08.09
)

include($CACHE{VCPKG_TOOLCHAIN_FILE})
