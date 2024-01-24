function(_wasi_sdk_find_root wasi_sdk_version out_wasi_sdk_root)
  if (DEFINED ENV{WASI_SDK_INSTALLATION_ROOT})
    set(root "$ENV{WASI_SDK_INSTALLATION_ROOT}")
  elseif(WIN32)
    set(root "$ENV{LOCALAPPDATA}/wask-sdk/${wasi_sdk_version}/cache")
  else()
    set(root "$ENV{HOME}/.cache/wasi-sdk/${wasi_sdk_version}")
  endif()

  set(${out_wasi_sdk_root}
      ${root}
      PARENT_SCOPE
  )
endfunction()

function(wasi_sdk_bootstrap)
  cmake_parse_arguments(
    PARSE_ARGV 0 "arg"
    ""
    "TAG;WASI_SYSROOT_OUTPUT"
    ""
  )
  if (DEFINED arg_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR
      "internal error: ${CMAKE_CURRENT_FUNCTION} passed extra args:"
      "${arg_UNPARSED_ARGUMENTS}"
    )
  endif()

  # Parse release version
  string(REGEX MATCH "([0-9.])+" wasi_sdk_version ${arg_TAG})
  if (NOT "${wasi_sdk_version}" MATCHES "[.]+")
    set(wasi_sdk_version "${wasi_sdk_version}.0")
  endif()

  # Locate cache root
  if(DEFINED CACHE{_WASI_SDK_ROOT})
    set(wasi_sdk_root $CACHE{_WASI_SDK_ROOT})
  else()
    _wasi_sdk_find_root("${wasi_sdk_version}" wasi_sdk_root)
  endif()
  if (NOT EXISTS ${wasi_sdk_root})
    message(STATUS "Creating wasi-sdk cache directory: ${wasi_sdk_root}")
    file(MAKE_DIRECTORY ${wasi_sdk_root})
  else()
    message(STATUS "Cache directory for wasi-sdk exists already: ${wasi_sdk_root}")
  endif()

  # Define wasi-sdk dependencies, paths and download locations
  set(wasi_sdk_sysroot_tarball_name "wasi-sysroot-${wasi_sdk_version}.tar.gz")
  set(wasi_sdk_libclang_tarball_name "libclang_rt.builtins-wasm32-wasi-${wasi_sdk_version}.tar.gz")
  set(wasi_sdk_sysroot_tarball_path "${wasi_sdk_root}/${wasi_sdk_sysroot_tarball_name}")
  set(wasi_sdk_libclang_tarball_path "${wasi_sdk_root}/${wasi_sdk_libclang_tarball_name}")
  set(wasi_sdk_release_base_url "https://github.com/WebAssembly/wasi-sdk/releases/download/${arg_TAG}")
  set(wasi_sdk_sysroot_tarball_url "${wasi_sdk_release_base_url}/${wasi_sdk_sysroot_tarball_name}")
  set(wasi_sdk_libclang_tarball_url "${wasi_sdk_release_base_url}/${wasi_sdk_libclang_tarball_name}")

  # Download wasi-sdk sysroot
  if (NOT EXISTS ${wasi_sdk_sysroot_tarball_path})
    message(STATUS "Downloading wasi-sdk sysroot from ${wasi_sdk_sysroot_tarball_url}")
    file(DOWNLOAD ${wasi_sdk_sysroot_tarball_url} ${wasi_sdk_sysroot_tarball_path} STATUS wasi_sdk_sysroot_dl_status)
    list(GET wasi_sdk_sysroot_dl_status 0 wasi_sdk_sysroot_dl_failed)
    if (wasi_sdk_sysroot_dl_failed)
      file(REMOVE ${wasi_sdk_sysroot_tarball_path})
      message(FATAL_ERROR "Download for wasi-sdk sysroot failed.")
    else()
      message(STATUS "Successfully downloaded wasi-sdk sysroot to ${wasi_sdk_sysroot_tarball_path}")
    endif()
  else()
    message(STATUS "wasi-sdk sysroot has already been downloaded and cached.")
  endif()

  # Download wasi-sdk libclang runtime builtins
  if (NOT EXISTS ${wasi_sdk_libclang_tarball_path})
    message(STATUS "Downloading wasi-sdk libclang runtime builtins from ${wasi_sdk_libclang_tarball_url}")
    file(DOWNLOAD ${wasi_sdk_libclang_tarball_url} ${wasi_sdk_libclang_tarball_path} STATUS wasi_sdk_libclang_dl_status)
    list(GET wasi_sdk_libclang_dl_status 0 wasi_sdk_libclang_dl_failed)
    if (wasi_sdk_libclang_dl_failed)
      file(REMOVE ${wasi_sdk_libclang_tarball_path})
      message(FATAL_ERROR "Download for wasi-sdk libclang runtime builtins failed.")
    else()
      message(STATUS "Successfully downloaded wasi-sdk libclang runtime builtins to ${wasi_sdk_libclang_tarball_path}")
    endif()
  else()
    message(STATUS "wasi-sdk libclang runtime builtins have already been downloaded and cached.")
  endif()

  # Extract wasi-sdk sysroot to cache directory
  message(STATUS "Extracting wasi-sdk sysroot to ${wasi_sdk_root}")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xzf ${wasi_sdk_sysroot_tarball_path}
    WORKING_DIRECTORY ${wasi_sdk_root}
  )

  # Extract wasi-sdk libclang runtime builtins to cache directory
  message(STATUS "Extracting wasi-sdk libclang runtime builtins to ${wasi_sdk_root}")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xzf ${wasi_sdk_libclang_tarball_path}
    WORKING_DIRECTORY ${wasi_sdk_root}
    )

  # Move wasi-sdk libclang runtime builtins to clang resource directory
  execute_process(COMMAND clang --print-resource-dir OUTPUT_VARIABLE clang_resource_dir OUTPUT_STRIP_TRAILING_WHITESPACE)
  message(STATUS "Moving wasi-sdk libclang runtime builtins to ${clang_resource_dir}")
  if (NOT EXISTS "${clang_resource_dir}/lib/wasi")
      message(STATUS "Creating wasi-sdk libclang runtime builtin directory: ${clang_resource_dir}/lib/wasi")
      file(MAKE_DIRECTORY "${clang_resource_dir}/lib/wasi")
  endif()
  file(
    COPY_FILE "${wasi_sdk_root}/lib/wasi/libclang_rt.builtins-wasm32.a" "${clang_resource_dir}/lib/wasi/libclang_rt.builtins-wasm32.a" 
    ONLY_IF_DIFFERENT
    RESULT wasi_sdk_runtime_copy_failed
  )
  if (wasi_sdk_runtime_copy_failed)
    message(FATAL_ERROR "Moving wasi-sdk libclang runtime builtins to ${wasi_sdk_root}/lib/wasi failed. \n${wasi_sdk_runtime_copy_failed}\n")
  endif()

  set(${arg_WASI_SYSROOT_OUTPUT}
      "${wasi_sdk_root}/wasi-sysroot"
      PARENT_SCOPE
  )
endfunction()
