# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

find_package(fmt CONFIG REQUIRED)
find_package(Microsoft.GSL CONFIG REQUIRED)
find_package(range-v3 CONFIG REQUIRED)

# sets default target properties
function(set_@cpp_pt_cmake@_target_properties target type)
  target_compile_features(${target} ${type} cxx_std_20)
  set_target_properties(${target}
   PROPERTIES
     CXX_STANDARD_REQUIRED ON
  )

  target_link_libraries(${target}
    ${type}
      fmt::fmt
      range-v3::range-v3
      Microsoft.GSL::GSL
  )
endfunction()
