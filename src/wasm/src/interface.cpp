#include "@cpp_pt_name@/@cpp_pt_module@/@cpp_pt_module_header@.hpp"

#include <fmt/core.h>

#include <cstdlib>
#include <cstring>
#include <string>

// Memory management exports
extern "C" __attribute__((export_name("wasm_malloc"))) void* wasm_malloc(size_t nbytes) {
  return std::malloc(nbytes);
}

extern "C" __attribute__((export_name("wasm_free"))) void wasm_free(
    void* ptr) {
  return std::free(ptr);
}

// Exported WASM functions
extern "C" __attribute__((export_name("version"))) uint8_t* version() {
  std::string version = @cpp_pt_name@::@cpp_pt_module@::version();
  uint8_t* versionPointer = (uint8_t*)wasm_malloc(version.length());
  std::memcpy(versionPointer, version.c_str(), version.length());
  return versionPointer;
}

// This is the WASM module's initialization entrypoint. It should be called
// before running any other exported function because it initializes implicit
// global/static resources. This is only required in library/reactor mode of
// WebAssembly. Read more here:
// https://wasmcloud.com/blog/webassembly-patterns-command-reactor-library#the-reactor-pattern
extern "C" void __wasm_call_ctors();
extern "C" __attribute__((export_name("_start"))) void _start() {
  __wasm_call_ctors();
}
