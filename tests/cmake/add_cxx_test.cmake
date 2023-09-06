# Copyright (c) 2023 Mikhail Svetkin.
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

find_package(Catch2 CONFIG REQUIRED)
find_package(cxx CONFIG REQUIRED PATHS "${CMAKE_BINARY_DIR}/src")

include(CTest)
include(Catch)

# sets all nessary default things
function(add_cxx_test test_name)
  cmake_path(GET CMAKE_CURRENT_LIST_DIR FILENAME module_name)

  set(test_file "${test_name}_test.cpp")
  set(test_target "${module_name}-${test_name}")

  message(STATUS "module_name: ${module_name}")
  message(STATUS "test_target: ${test_target}")

  add_executable(${test_target} "${test_file}")
  target_link_libraries(
    ${test_target} PRIVATE cxx::${module_name} Catch2::Catch2WithMain
  )

  catch_discover_tests(${test_target} TEST_PREFIX "${test_target}:")
endfunction()
