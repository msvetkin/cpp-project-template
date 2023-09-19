# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

include(set_@cpp_pt_cmake@_target_properties)

# sets all nessary default things
function(add_@cpp_pt_cmake@_executable executable_name)
  set(executable_target @cpp_pt_cmake@-${executable_name})

  add_executable(${executable_target} ${ARGN})
  set_@cpp_pt_cmake@_target_properties(${executable_target} PRIVATE)

  if (TARGET @cpp_pt_name@)
    install(TARGETS ${executable_target} EXPORT @cpp_pt_name@-targets)
  endif()

  set(@cpp_pt_cmake@_executable_target
      ${executable_target}
      PARENT_SCOPE
  )
endfunction()
