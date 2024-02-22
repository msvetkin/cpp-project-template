# SPDX-FileCopyrightText: Copyright 2024 Mikhail Svetkin
# SPDX-License-Identifier: MIT

function(_vcpkg_update_manifest_hash)
  set(_VCPKG_MANIFEST_HASH "$CACHE{__VCPKG_MANIFEST_HASH}"
      CACHE INTERNAL "Hash of vcpkg manifest file")
endfunction()

# disable vcpkg manifest install step on cmake reconfigure if vcpkg.json has not
# changed.
function(_vcpkg_skip_install_on_reconfigure)
  if (DEFINED CACHE{VCPKG_MANIFEST_DIR})
    set(vcpkg_manifest_file "$CACHE{VCPKG_MANIFEST_DIR}/vcpkg.json")
  else()
    set(vcpkg_manifest_file "${CMAKE_SOURCE_DIR}/vcpkg.json")
  endif()

  file(SHA512 "${vcpkg_manifest_file}" vcpkg_manifest_hash)

  if (DEFINED CACHE{_VCPKG_MANIFEST_HASH} AND _VCPKG_MANIFEST_HASH STREQUAL vcpkg_manifest_hash)
    set(VCPKG_MANIFEST_INSTALL OFF CACHE INTERNAL "")
    set_property(DIRECTORY APPEND
      PROPERTY
        CMAKE_CONFIGURE_DEPENDS "${vcpkg_manifest_file}"
    )
  else()
    set(VCPKG_MANIFEST_INSTALL ON CACHE INTERNAL "")
  endif()

  # I was not able to propgate vcpkg_manifest_hash via defer call, so workaround
  # it with another cache variable.
  set(__VCPKG_MANIFEST_HASH "${vcpkg_manifest_hash}" CACHE INTERNAL "")

  # set actual hash only when vcpkg install command succeed.
  # The only way you to detect to assume that configuration step succeed.
  cmake_language(DEFER DIRECTORY ${CMAKE_SOURCE_DIR} CALL _vcpkg_update_manifest_hash)
endfunction()
