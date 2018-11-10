#!/bin/sh

SCRIPTDIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"

refactor_pages_to_page_bundles()
{
  if [ ! -d ./content/ ]; then
    echo "Please run script from root of hugo site"
  fi
  local files="$(find ./content/ -iname '*.md' -not -iname '*index.md' -not -ipath './content/home/*')"
  for file in ${files}; do
    local pagedir="${file%.md}"

    echo "${file} -> ${pagedir}/index.md"
    if [ -d "${pagedir}" ]; then
      mkdir "${pagedir}"
    fi

    mv --no-target-directory "${file}" "${pagedir}/index.md"
  done
}

# Bash Strict Mode
set -eu

# set -x
refactor_pages_to_page_bundles "$@"
