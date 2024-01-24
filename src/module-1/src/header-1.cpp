// SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
// SPDX-License-Identifier: MIT

#include "@cpp_pt_name@/@cpp_pt_module@/@cpp_pt_module_header@.hpp"

#include <memory>

WASM_EXPORT("version") char* version() noexcept {
  auto version = std::make_shared<std::string>(@cpp_pt_name@::@cpp_pt_module@::version());
  return version->data();
}

namespace @cpp_pt_name@::@cpp_pt_module@ {

std::string version() noexcept {
  return "0.0.1";
}

} // namespace @cpp_pt_name@::@cpp_pt_module@
