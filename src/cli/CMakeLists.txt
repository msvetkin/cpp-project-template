# SPDX-FileCopyrightText: 2023 Mikhail Svetkin <mikhail.svetkin@gmail.com>
# SPDX-License-Identifier: MIT

add_@cpp_pt_cmake@_executable(cli)

target_sources(${@cpp_pt_cmake@_executable_target} PRIVATE src/main.cpp)

target_link_libraries(${@cpp_pt_cmake@_executable_target}
  PRIVATE
    @cpp_pt_name@::@cpp_pt_module@
)
