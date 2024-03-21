# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

# sets VCPKG_TARGET_TRIPLET out of VCPKG_PRESET_NAME
function(_vcpkg_autodetect_target_triplet)
  if (DEFINED CACHE{VCPKG_TARGET_TRIPLET})
    return()
  endif()

  if (NOT DEFINED VCPKG_PRESET_NAME)
    message(FATAL_ERROR "Missing mandatory VCPKG_PRESET_NAME cache variable")
  endif()

  # for some reason macOS is possible instead of Darwin
  if("${__vcpkg_bootstrap_host}" MATCHES "Darwin|macOS")
    string(REPLACE "darwin" "osx" VCPKG_PRESET_NAME "${VCPKG_PRESET_NAME}")
  endif()

  string(REPLACE "-" ";" triplet_parts "${VCPKG_PRESET_NAME}")

  # remove compiler
  list(REMOVE_AT triplet_parts 2)
  list(LENGTH triplet_parts triplet_parts_length)
  if(triplet_parts_length EQUAL "2")
    list(APPEND triplet_parts "dynamic")
  else()
    list(REMOVE_ITEM triplet_parts "static")
  endif()

  list(SUBLIST triplet_parts 0 3 triplet_parts)

  list(JOIN triplet_parts "-" vcpkg_target_triplet)

  set(VCPKG_TARGET_TRIPLET "${vcpkg_target_triplet}"
      CACHE STRING "Auto detected vcpkg target triplet")
endfunction()
