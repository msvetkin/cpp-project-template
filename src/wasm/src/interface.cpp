#include "../include/interface.hpp"

#include "@cpp_pt_name@/@cpp_pt_module@/@cpp_pt_module_header@.hpp"

#include <fmt/core.h>

#include <cstdlib>
#include <cstring>
#include <string>

// Memory management exports
void* wasm_malloc(size_t nbytes) {
  return std::malloc(nbytes);
}

void wasm_free(void* ptr) {
  return std::free(ptr);
}

// Exported WASM functions
uint8_t* version() {
  std::string version = @cpp_pt_name@::@cpp_pt_module@::version();
  uint8_t* versionPointer = (uint8_t*)wasm_malloc(version.length());
  std::memcpy(versionPointer, version.c_str(), version.length());
  return versionPointer;
}

// WASM CLI entrypoint (_start)
int main(int /*argc*/, char* /*argv*/[]) {
  fmt::println("Hello from the CLI!");
  fmt::println("@cpp_pt_name@ version: {}", @cpp_pt_name@::@cpp_pt_module@::version());
  return 0;
}
