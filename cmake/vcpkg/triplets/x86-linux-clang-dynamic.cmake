set(VCPKG_TARGET_ARCHITECTURE x86)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

set(VCPKG_CXX_FLAGS -stdlib=libc++)
set(VCPKG_C_FLAGS -stdlib=libc++)
set(VCPKG_LINKER_FLAGS "-stdlib=libc++ -lc++abi")
