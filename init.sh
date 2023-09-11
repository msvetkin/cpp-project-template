# SPDX-FileCopyrightText: Copyright 2023 Mikhail Svetkin
# SPDX-License-Identifier: MIT

#!/usr/bin/env bash

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

project_name=$(echo "$project_name" | tr ' ' '-')
project_include=$project_name
project_function=$(echo "$project_name" | tr '-' '_')

echo "project name:     ${project_name}"
echo "project include:  ${project_include}"
echo "project function: ${project_function}"

git ls-files | grep -v "^\." | grep -v "init.sh" | while read -r filename; do
  sed -i "s/cpp-project-template/$project_name/g" "$filename"
  sed -i "s/cpp_project_template/$project_function/g" "$filename"
done
