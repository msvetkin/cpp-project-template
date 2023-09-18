# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

include_guard(GLOBAL)

include(GNUInstallDirs)

add_library(@cpp_pt_name@ INTERFACE)
add_library(@cpp_pt_name@::@cpp_pt_name@ ALIAS @cpp_pt_name@)
install(TARGETS @cpp_pt_name@ EXPORT @cpp_pt_name@-targets)

export(EXPORT @cpp_pt_name@-targets NAMESPACE @cpp_pt_name@::)
configure_file("cmake/@cpp_pt_name@-config.cmake" "." COPYONLY)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  @cpp_pt_name@-config-version.cmake COMPATIBILITY SameMajorVersion
)

install(
  EXPORT @cpp_pt_name@-targets
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/@cpp_pt_name@
  NAMESPACE @cpp_pt_name@::
)

install(
  FILES cmake/@cpp_pt_name@-config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/@cpp_pt_name@-config-version.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/@cpp_pt_name@
)

