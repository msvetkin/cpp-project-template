# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

# CMAKE_HOST_* variables are not available during first configure on windows.
cmake_host_system_information(RESULT __vcpkg_bootstrap_host QUERY OS_NAME)
cmake_host_system_information(RESULT __vcpkg_bootstrap_arch QUERY OS_PLATFORM)

set(__vcpkg_bootstrap_list_dir "${CMAKE_CURRENT_LIST_DIR}")

include(${__vcpkg_bootstrap_list_dir}/vcpkg_autodetect_target_triplet.cmake)
include(${__vcpkg_bootstrap_list_dir}/vcpkg_autodetect_host_triplet.cmake)
include(${__vcpkg_bootstrap_list_dir}/vcpkg_skip_install_on_reconfigure.cmake)
include(${__vcpkg_bootstrap_list_dir}/vcpkg_bootstrap.cmake)
include(${__vcpkg_bootstrap_list_dir}/vcpkg_configure.cmake)
