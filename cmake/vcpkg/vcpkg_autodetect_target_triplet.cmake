# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

# sets VCPKG_TARGET_TRIPLET out of PRESET_NAME_TO_VCPKG_TARGET_TRIPLET
function(vcpkg_autodetect_target_target_triplet)
  if (APPLE)
    string(REPLACE "darwin" "osx" PRESET_NAME_TO_VCPKG_TARGET_TRIPLET "${PRESET_NAME_TO_VCPKG_TARGET_TRIPLET}")
  endif()

  string(REPLACE "-" ";" triplet_parts "${PRESET_NAME_TO_VCPKG_TARGET_TRIPLET}")
  message(STATUS "triplet_parts: ${triplet_parts}")

  # remove compiler
  list(REMOVE_AT triplet_parts 2)
  message(STATUS "triplet_parts: ${triplet_parts}")
  list(LENGTH triplet_parts triplet_parts_length)
  message(STATUS "triplet_parts_length: ${triplet_parts_length}")
  if (triplet_parts_length EQUAL "2")
    list(APPEND triplet_parts "dynamic")
  else()
    message(STATUS "remove static")
    list(REMOVE_ITEM triplet_parts "static")
    message(STATUS "triplet_parts: ${triplet_parts}")
  endif()

  list(SUBLIST triplet_parts 0 3 triplet_parts)
  message(STATUS "final triplet_parts: ${triplet_parts}")

  list(JOIN triplet_parts "-" VCPKG_TARGET_TRIPLET)

  message(STATUS "Auto detected VCPKG_TARGET_TRIPLET: ${VCPKG_TARGET_TRIPLET}")
  set(VCPKG_TARGET_TRIPLET "${VCPKG_TARGET_TRIPLET}" CACHE INTERNAL "")
endfunction()
