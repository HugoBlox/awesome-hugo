#!/bin/sh

# Helps migrate from v2.4.0 to v3.0.0
#
# Refactor a page named `X.md` to `content/<section>/X/index.md` to use the
# new page bundles and featured image system
#
# - E.g. a post `content/post/X.md` is converted to `content/post/X/index.md`

refactor_pages_to_page_bundles()
{
  if [ ! -d ./content/ ]; then
    echo "Please run the script from the root of your Academic site" >&2
    exit 1
  fi
  local files="$(find ./content/ -iname '*.md' -not -iname '*index.md' -not -ipath './content/home/*')"
  for file in ${files}; do
    local pagedir="${file%.md}"

    echo "${file} -> ${pagedir}/index.md"
    if [ ! -d "${pagedir}" ]; then
      mkdir "${pagedir}"
    fi

    mv "${file}" "${pagedir}/index.md"
  done
}

# Bash Strict Mode
set -eu

# set -x
refactor_pages_to_page_bundles "$@"
