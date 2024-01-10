// SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
// SPDX-License-Identifier: MIT

#include "@cpp_pt_name@/@cpp_pt_module@/@cpp_pt_module_header@.hpp"

#if __has_include("<fmt/core.h>")
#include <fmt/core.h>
#endif

int main(int /*argc*/, char * /*argv*/ []) {
#if __has_include("<fmt/core.h>")
  fmt::print("@cpp_pt_name@ version: {}\n", @cpp_pt_name@::@cpp_pt_module@::version());
#else
  printf("@cpp_pt_name@ version: %s\n", @cpp_pt_name@::@cpp_pt_module@::version().data());
#endif
  return 0;
}
