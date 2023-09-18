# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

# sets default target properties
function(set_@cpp_pt_cmake@_target_properties target type)
  target_compile_features(${target} ${type} cxx_std_20)
  set_target_properties(${target}
   PROPERTIES
     CXX_STANDARD_REQUIRED ON
  )
endfunction()
