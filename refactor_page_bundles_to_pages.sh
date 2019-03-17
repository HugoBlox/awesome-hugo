#!/usr/bin/env bash

# Converts homepage page bundles to page files.
#
# E.g. an About section named `content/home/about/index.md` is converted to `content/home/about.md`

refactor_page_bundles_to_pages()
{
  # Check that the command was run from the site root.
  if [ ! -d ./content/ ]; then
    echo "Please run the script from the root of your Academic site" >&2
    exit 1
  fi

  # Iterate over the homepage sections (excluding Gallery as it generally requires a bundle).
  local files="$(find ./content/home/*/index.md -not './content/home/gallery/index.md')"
  for file in ${files}; do
    local pagedir="$(dirname ${file})"
    local pagename="$(dirname ${file}).md"
    echo "${file} -> ${pagename}"

    # Check file does not already exist.
    if [ -f "${pagename}" ]; then
      echo "File ${pagename} already exists!"
      exit 1
    fi

    # For dry run, comment out `mv` and `rm` lines below.
    mv "${file}" "${pagename}"

    # Let user decide whether to remove dir as may contain assets.
    \rm -ri "${pagedir}"
  done
}

# Bash Strict Mode
set -eu

# To debug, uncomment line below:
# set -x

refactor_page_bundles_to_pages "$@"
