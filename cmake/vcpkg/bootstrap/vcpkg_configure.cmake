# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

# bootstrap and configure vcpkg
function(vcpkg_configure)
  _vcpkg_bootstrap(${ARGN})
  _vcpkg_autodetect_target_triplet()
  _vcpkg_autodetect_host_triplet()
  _vcpkg_skip_install_on_reconfigure()

  if ("${__vcpkg_bootstrap_host}" STREQUAL "Linux"
      AND "${__vcpkg_bootstrap_arch}" MATCHES "arm|aarch")
    # VCPKG_FORCE_SYSTEM_BINARIES must be set on "weird platforms", see
    # https://github.com/microsoft/vcpkg-tool/blob/1c9ec1978a6b0c2b39c9e9554a96e3e275f7556e/src/vcpkg.cpp#L277
    set(ENV{VCPKG_FORCE_SYSTEM_BINARIES} 1)
  endif()
endfunction()
