# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

# sets all nessary default things
function(add_@cpp_pt_cmake@_executable executable_name)
  set(executable_target @cpp_pt_cmake@_${executable_name})

  add_executable(${executable_target} ${ARGN})

  install(TARGETS ${executable_target} EXPORT @cpp_pt_name@-targets)

  set(@cpp_pt_cmake@_executable_target
      ${executable_target}
      PARENT_SCOPE
  )
endfunction()
