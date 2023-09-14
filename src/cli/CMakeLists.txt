# SPDX-FileCopyrightText: 2023 Mikhail Svetkin <mikhail.svetkin@gmail.com>
# SPDX-License-Identifier: MIT

add_cpp_project_template_executable(cli)

target_sources(${cpp_project_template_executable_target} PRIVATE src/main.cpp)

target_link_libraries(${cpp_project_template_executable_target}
  PRIVATE
    cpp-project-template::core
)
