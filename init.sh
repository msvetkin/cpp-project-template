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

read -p "Enter the project name: " project_name
read -p "Enter the module name: " module_name
read -p "Enter the module header: " module_header

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
done

mkdir -p src/${module_name}/include/${project_include}/${module_name}
mkdir -p tests/${module_name}

git ls-files | tac | grep -v "^\." | grep -v "init.sh" | while read -r filename; do
  new_filename="${filename//cpp-project-template/$project_name}"
  new_filename="${new_filename//cpp_project_template/$project_function}"
  new_filename="${new_filename//core/$module_name}"
  new_filename="${new_filename//optional/$module_header}"

  if [ "$filename" != "$new_filename" ]; then
    git mv "$filename" "$new_filename"
  fi
done

git rm init.sh
