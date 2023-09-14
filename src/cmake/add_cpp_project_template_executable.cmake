# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

# sets all nessary default things
function(add_cpp_project_template_executable executable_name)
  set(executable_target cpp-project-template_${executable_name})

  add_executable(${executable_target} ${ARGN})

  install(TARGETS ${executable_target} EXPORT cpp-project-template-targets)

  set(cpp_project_template_executable_target
      ${executable_target}
      PARENT_SCOPE
  )
endfunction()
