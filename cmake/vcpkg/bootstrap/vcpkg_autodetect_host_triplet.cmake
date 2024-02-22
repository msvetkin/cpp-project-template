# SPDX-FileCopyrightText: Copyright 2024 Mikhail Svetkin
# SPDX-License-Identifier: MIT

# vcpkg-tool detects it by default, but we need this info to be able to use
# find_package(... NO_DEFAULT_PATH PATH ${VCPKG_INSTALLED_DIR}/${VCPKG_HOST_TRIPLET})
function(_vcpkg_autodetect_host_triplet)
  if (DEFINED CACHE{VCPKG_HOST_TRIPLET})
    return()
  endif()

  if ("${__vcpkg_bootstrap_host}" STREQUAL "Linux")
    set(host_triplet_os "linux" CACHE INTERNAL "")
  elseif("${__vcpkg_bootstrap_host}" STREQUAL "Windows")
    set(host_triplet_os "windows" CACHE INTERNAL "")
  else()
    set(host_triplet_os "osx")
  endif()

  if("${__vcpkg_bootstrap_arch}" MATCHES "arm|aarch")
    set(host_triplet_arch "arm64")
  else()
    set(host_triplet_arch "x64")
  endif()

  set(VCPKG_HOST_TRIPLET "${host_triplet_arch}-${host_triplet_os}"
      CACHE STRING "Auto detected vcpkg host triplet")
endfunction()
