#!/usr/bin/env bash

# Helps migrate from Academic v4.1 to v4.2
#
# Refactors homepage sections named `content/home/X/index.md`
# as headless page bundles in Hugo.
#
# - E.g. Adds `headless = true` to `content/home/about.md`.

refactor_homepage_widget_bundles_as_headless()
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
    sed -e '/widget:/a\'$'\n''headless: true  # This file represents a page section.' "${file}" > tmp && mv tmp "${file}"
  done
}

# Bash Strict Mode
set -eu

# To debug, uncomment line below:
# set -x

refactor_homepage_widget_bundles_as_headless "$@"
