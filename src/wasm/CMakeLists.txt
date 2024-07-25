# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

add_@cpp_pt_cmake@_executable(wasm)

target_sources(${@cpp_pt_cmake@_executable_target} PRIVATE 
  src/interface.cpp
)

target_link_libraries(${@cpp_pt_cmake@_executable_target}
  PRIVATE
    @cpp_pt_name@::@cpp_pt_module@
)

set_target_properties(${@cpp_pt_cmake@_executable_target} PROPERTIES OUTPUT_NAME "lib@cpp_pt_module@.wasm")
target_link_options(${@cpp_pt_cmake@_executable_target} PRIVATE -nostartfiles -Wl,--no-entry)