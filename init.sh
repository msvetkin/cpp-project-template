#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

# Check if the script is invoked from within a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This script must be run from within a Git repository."
    exit 1
fi

# Check if the script itself is part of the Git repository
if ! git ls-files --error-unmatch "$0" > /dev/null 2>&1; then
    echo "Error: This script is not part of the Git repository."
    exit 1
fi

# Default values
project_name=""
module_name=""
module_header=""

# Function to display help message
show_help() {
  echo "Usage: $0 [--project=<name>] [--module=<name>] [--header=<name>] [--help]"
  echo "Options:"
  echo "  --project=<name>  Set the project name"
  echo "  --module=<name>   Set the module name"
  echo "  --header=<name>   Set the module header name"
  echo "  --help            Display this help message"
}

# Parse command line arguments
for arg in "$@"; do
  case $arg in
    --project=*)
      project_name="${arg#*=}"
      ;;
    --module=*)
      module_name="${arg#*=}"
      ;;
    --header=*)
      module_header="${arg#*=}"
      ;;
    --help)
      show_help
      exit 0
      ;;
    *)
      echo "Invalid argument: $arg"
      show_help
      exit 1
      ;;
  esac
done

if [ -z "$project_name" ]; then
  read -p "Enter the project name: " project_name
fi

if [ -z "$module_name" ]; then
  read -p "Enter the module name: " module_name
fi

if [ -z "$module_header" ]; then
  read -p "Enter the module header name: " module_header
fi

project_name=$(echo "$project_name" | tr ' ' '-')
project_include=$project_name
project_function=$(echo "$project_name" | tr '-' '_')
module_name=$(echo "$module_name" | tr ' ' '-')
module_header=$(echo "$module_header" | tr ' ' '-')

echo "project name:    ${project_name}"
echo "module include:  #include \"${project_include}/${module_name}/${module_header}.hpp\""
echo "cmake functions: add_${project_function}_module/test"

read -p "Review configurations. Confirm? (y/n): " choice
case "$choice" in
  [yY]*)
      ;;
  *)
      echo "Operation canceled. No changes were made."
      exit 1
      ;;
esac

git ls-files | grep -v "^\." | grep -v "init.sh" | while read -r filename; do
  sed -i "s/cpp-project-template/$project_name/g" "$filename"
  sed -i "s/cpp_project_template/$project_function/g" "$filename"
  sed -i "s/core/$module_name/g" "$filename"
  sed -i "s/optional/$module_header/g" "$filename"
  git add "${filename}"
done

project_include="ndc"
module_name="logging"
module_header="debug"

# Define a function that echoes array elements
rename_module() {
  git mv "src/cmake/add_cpp_project_template_module.cmake" \
         "src/cmake/add_${project_function}_module.cmake"

  git mv "src/cmake/cpp-project-template-config.cmake" \
         "src/cmake/${project_name}-config.cmake"

  local source_parts=(
    "src/core"
    "/include/cpp-project-template"
    "/core"
    "/optional.hpp"
  )

  local destantion_parts=(
    "src/${module_name}"
    "/include/${project_include}"
    "/${module_name}"
    "/${module_header}.hpp"
  )

  local src=""
  local dst=""

  for ((i = 0; i < ${#source_parts[@]}; i++)); do
    src="${dst}${source_parts[i]}"
    dst="${dst}${destantion_parts[i]}"
    git mv "${src}" "${dst}"
  done
}

rename_tests() {
  git mv "tests/cmake/add_cpp_project_template_test.cmake" \
         "tests/cmake/add_${project_function}_test.cmake"

  local source_parts=(
    "tests/core"
    "/optional_test.cpp"
  )

  local destantion_parts=(
    "tests/${module_name}"
    "/${module_header}_test.cpp"
  )

  local src=""
  local dst=""

  for ((i = 0; i < ${#source_parts[@]}; i++)); do
    src="${dst}${source_parts[i]}"
    dst="${dst}${destantion_parts[i]}"
    git mv "${src}" "${dst}"
  done
}

rename_module
rename_tests

git rm init.sh

echo "Done. Please review changes:"
git status

read -p "Review configurations. Confirm? (y/n): " choice
case "$choice" in
  [yY]*)
      ;;
  *)
      git reset --hard && git clean -fd
      echo "Operation canceled. No changes were made."
      exit 1
      ;;
esac
