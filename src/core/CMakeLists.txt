# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

add_cxx_module(core INTERFACE)

target_sources(${cxx_module_target} PRIVATE include/cxx/core/optional.hpp)

target_link_libraries(${cxx_module_target} INTERFACE fmt::fmt)
