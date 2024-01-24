include_guard(GLOBAL)

cmake_minimum_required(VERSION 3.25)

get_property(IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)

if (IN_TRY_COMPILE)
  return()
endif()

unset(IN_TRY_COMPILE)

# Until Platform/WASI.cmake is upstream we need to inject the path to it
# into CMAKE_MODULE_PATH.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/..")

include(${CMAKE_CURRENT_LIST_DIR}/wasi-sdk_bootstrap.cmake)
wasi_sdk_bootstrap(
  TAG wasi-sdk-21 
  WASI_SYSROOT_OUTPUT CMAKE_SYSROOT
)

set(CMAKE_SYSTEM_NAME WASI)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR wasm32)
set(triple wasm32-wasi)

set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)
set(CMAKE_ASM_COMPILER clang)
set(CMAKE_AR llvm-ar)
set(CMAKE_RANLIB llvm-ranlib)
set(CMAKE_C_COMPILER_TARGET ${triple})
set(CMAKE_CXX_COMPILER_TARGET ${triple})
set(CMAKE_ASM_COMPILER_TARGET ${triple})

# Don't look in the sysroot for executables to run during the build
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# Only look in the sysroot (not in the host paths) for the rest
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CLANG_DEFAULT_RTLIB "compiler-rt")
set(LIBCXX_USE_COMPILER_RT "YES")
set(LIBCXXABI_USE_COMPILER_RT "YES")

add_compile_options(
  "-stdlib=libc++" 
  "-fno-exceptions" 
  "-D_WASI_EMULATED_SIGNAL"
)
