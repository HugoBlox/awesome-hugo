#!/usr/bin/env bash

# Helps migrate from v4.1 to v4.2
#
# Refactors homepage sections named `content/home/X.md` to `content/home/X/index.md`,
# treating homepage sections as headless page bundles in Hugo.
#
# - E.g. an About section named `content/home/about.md` is converted to `content/home/about/index.md`

refactor_pages_to_page_bundles()
{
  # Check that the command was run from the site root.
  if [ ! -d ./content/ ]; then
    echo "Please run the script from the root of your Academic site" >&2
    exit 1
  fi

  # Iterate over the homepage sections.
  local files="$(find ./content/home/ -iname '*.md' -not -iname '*index.md')"
  for file in ${files}; do
    local pagedir="${file%.md}"

    echo "${file} -> ${pagedir}/index.md"
    if [ ! -d "${pagedir}" ]; then
      mkdir "${pagedir}"
    fi

    mv "${file}" "${pagedir}/index.md"
  done
}

refactor_pages_as_headless()
{
  # Check that the command was run from the site root.
  if [ ! -d ./content/ ]; then
    echo "Please run the script from the root of your Academic site" >&2
    exit 1
  fi

  # Iterate over the homepage sections.
  local files="$(find ./content/home/ -iname 'index.md')"
  for file in ${files}; do
    # Append new parameter after `widget` line using Mac and Unix friendly sed notation.
    sed -e '/widget =/a\'$'\n''headless = true  # This file represents a page section.' "${file}" > tmp && mv tmp "${file}"
  done
}

# Bash Strict Mode
set -eu

# To debug, uncomment line below:
# set -x

refactor_pages_to_page_bundles "$@"
refactor_pages_as_headless "$@"
