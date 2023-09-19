# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

add_@cpp_pt_cmake@_module(@cpp_pt_module@)

target_sources(${@cpp_pt_cmake@_module_target} PRIVATE
  include/@cpp_pt_name@/@cpp_pt_module@/@cpp_pt_module_header@.hpp
  src/@cpp_pt_module_header@.cpp)
