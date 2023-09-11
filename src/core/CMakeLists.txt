# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

add_cpp_project_template_module(core INTERFACE)

target_sources(${cpp_project_template_module_target} PRIVATE include/cpp-project-template/core/optional.hpp)

target_link_libraries(${cpp_project_template_module_target} INTERFACE fmt::fmt)
