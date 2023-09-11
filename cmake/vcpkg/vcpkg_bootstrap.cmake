# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

# stash all local changes
function(_vcpkg_stash vcpkg_root)
  message(STATUS "vcpkg stash all local changes")

  execute_process(
    COMMAND ${GIT_EXECUTABLE} stash
    WORKING_DIRECTORY ${vcpkg_root}
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL "0")
    message(FATAL_ERROR "${GIT_EXECUTABLE} stash failed with ${result}")
  endif()
endfunction()

# checkout to a specific baseline
function(_vcpkg_checkout vcpkg_root vcpkg_commit)
  message(STATUS "vcpkg checkout to ${vcpkg_commit}")

  execute_process(
    COMMAND ${GIT_EXECUTABLE} checkout ${vcpkg_commit}
    WORKING_DIRECTORY ${vcpkg_root}
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL "0")
    message(
      FATAL_ERROR
        "${GIT_EXECUTABLE} checkout ${vcpkg_commit} failed with ${result}"
    )
  endif()
endfunction()

# clone
function(_vcpkg_clone vcpkg_root vcpkg_repo vcpkg_commit)
  message(STATUS "Cloning vckpg to ${vcpkg_root}")

  execute_process(
    COMMAND ${GIT_EXECUTABLE} clone ${vcpkg_repo} ${vcpkg_root}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL "0")
    message(FATAL_ERROR "failed to clone ${vcpkg_repo} to ${vcpkg_root}")
  endif()

  _vcpkg_checkout(${vcpkg_root} ${vcpkg_commit})
endfunction()

# boostrap
function(_vcpkg_bootstrap vcpkg_root)
  message(STATUS "Bootstrap vckpg")

  if(WIN32)
    set(bootstrap_cmd "${vcpkg_root}/bootstrap-vcpkg.bat")
  else()
    set(bootstrap_cmd "${vcpkg_root}/bootstrap-vcpkg.sh")

  endif()
  execute_process(
    COMMAND ${bootstrap_cmd} -disableMetrics
    WORKING_DIRECTORY ${vcpkg_root}
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL "0")
    message(FATAL_ERROR "${bootstrap_cmd} failed with ${result}")
  endif()
endfunction()

# upgrade
function(_vcpkg_upgrade vcpkg_root vcpkg_repo vcpkg_commit)
  execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    WORKING_DIRECTORY ${vcpkg_root}
    OUTPUT_VARIABLE current_git_hash OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL "0")
    message(
      FATAL_ERROR "${GIT_EXECUTABLE} rev-parse HEAD failed with ${result}"
    )
  endif()

  if("${current_git_hash}" STREQUAL "${vcpkg_commit}")
    return()
  endif()

  message(STATUS "Upgrade vcpkg")
  message(STATUS "vcpkg current commit: ${current_git_hash}")
  message(STATUS "vcpkg release:        ${vcpkg_commit}")

  execute_process(
    COMMAND ${GIT_EXECUTABLE} remote set-url origin ${vcpkg_repo}
    WORKING_DIRECTORY ${vcpkg_root}
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL "0")
    message(FATAL_ERROR "failed to change origin to ${vcpkg_repo}")
  endif()

  execute_process(
    COMMAND ${GIT_EXECUTABLE} fetch
    WORKING_DIRECTORY ${vcpkg_root}
    RESULT_VARIABLE result
  )

  if(NOT result EQUAL "0")
    message(FATAL_ERROR "${GIT_EXECUTABLE} fetch failed with ${result}")
  endif()

  _vcpkg_stash(${vcpkg_root})
  _vcpkg_checkout(${vcpkg_root} ${vcpkg_commit})
  _vcpkg_bootstrap(${vcpkg_root})
endfunction()

# find root
function(_vcpkg_find_root vcpkg_root)
  if(WIN32)
    set(root $ENV{LOCALAPPDATA}/vcpkg/repos/cpp-project-template/cache)
  else()
    set(root $ENV{HOME}/.cache/vcpkg/repos/cpp-project-template)
  endif()

  set(${vcpkg_root}
      ${root}
      PARENT_SCOPE
  )
endfunction()

# bootstrap
function(vcpkg_bootstrap vcpkg_repo vcpkg_commit)
  find_package(Git QUIET REQUIRED)

  if(DEFINED CACHE{VCPKG_ROOT})
    set(vcpkg_root $CACHE{VCPKG_ROOT})
  else()
    _vcpkg_find_root(vcpkg_root)
  endif()

  if(NOT EXISTS ${vcpkg_root})
    _vcpkg_clone(${vcpkg_root} ${vcpkg_repo} ${vcpkg_commit})
    _vcpkg_bootstrap(${vcpkg_root})
  else()
    message(STATUS "Found vcpkg in: ${vcpkg_root}")
    _vcpkg_upgrade(${vcpkg_root} ${vcpkg_repo} ${vcpkg_commit})
  endif()

  if(DEFINED CACHE{VCPKG_TOOLCHAIN_FILE})
    return()
  endif()

  set(VCPKG_ROOT
      "${vcpkg_root}"
      CACHE PATH "vcpkg root"
  )

  if(WIN32)
    set(VCPKG_EXECUTABLE
        "${vcpkg_root}/vcpkg.exe"
        CACHE PATH "vcpkg executable"
    )
  else()
    set(VCPKG_EXECUTABLE
        "${vcpkg_root}/vcpkg"
        CACHE PATH "vcpkg executable"
    )
  endif()

  set(VCPKG_TOOLCHAIN_FILE
      "${vcpkg_root}/scripts/buildsystems/vcpkg.cmake"
      CACHE PATH "vcpkg toolchain file"
  )
endfunction()
