# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

# sets VCPKG_TARGET_TRIPLET out of PRESET_NAME_TO_VCPKG_TARGET_TRIPLET
function(vcpkg_autodetect_target_target_triplet)
  if (APPLE)
    string(REPLACE "darwin" "osx" PRESET_NAME_TO_VCPKG_TARGET_TRIPLET "${PRESET_NAME_TO_VCPKG_TARGET_TRIPLET}")
  endif()

  string(REPLACE "-" ";" triplet_parts "${PRESET_NAME_TO_VCPKG_TARGET_TRIPLET}")

  # remove compiler
  list(REMOVE_AT triplet_parts 2)
  list(LENGTH triplet_parts triplet_parts_length)
  if (triplet_parts_length EQUAL "2")
    list(APPEND triplet_parts "dynamic")
  else()
    list(REMOVE_ITEM triplet_parts "static")
  endif()

  list(SUBLIST triplet_parts 0 3 triplet_parts)

  list(JOIN triplet_parts "-" vcpkg_target_triplet)

  message(STATUS "Auto detected VCPKG_TARGET_TRIPLET: ${vcpkg_target_triplet}")
  set(VCPKG_TARGET_TRIPLET "${vcpkg_target_triplet}" CACHE STRING "Auto detected
  vcpkg target triplet")
endfunction()
