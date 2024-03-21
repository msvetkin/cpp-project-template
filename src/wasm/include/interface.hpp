#pragma once

#include "@cpp_pt_name@/@cpp_pt_module@/export.hpp"

#include <cstdint>

// Memory management exports
WASM_EXPORT("wasm_malloc") void* wasm_malloc(size_t nbytes);
WASM_EXPORT("wasm_free") void wasm_free(void* ptr);

// Exported WASM functions
WASM_EXPORT("version") uint8_t* version();

// WASM CLI entrypoint (_start)
int main(int /*argc*/, char* /*argv*/[]);
