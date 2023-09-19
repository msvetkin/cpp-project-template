// SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
// SPDX-License-Identifier: MIT

#include "@cpp_pt_name@/@cpp_pt_module@/@cpp_pt_module_header@.hpp"

#include <fmt/core.h>

int main(int /*argc*/, char * /*argv*/ []) {
  fmt::print("@cpp_pt_name@ version: {}\n", @cpp_pt_name@::@cpp_pt_module@::version());
  return 0;
}
