#!/bin/bash

SCRIPTDIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"

refactor_pages_to_page_bundles()
{
  cd "${SCRIPTDIR}/../"
  local files="$(find ./content/ -iname '*.md' -not -iname '*index.md' -not -ipath './content/home/*')"
  for file in ${files}; do
    local pagedir="${file%.md}"

    echo "${file} -> ${pagedir}/index.md"
    [[ -d "${pagedir}" ]] || mkdir "${pagedir}"

    mv --no-target-directory "${file}" "${pagedir}/index.md"
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Bash Strict Mode
    set -eu -o pipefail

    # set -x
    refactor_pages_to_page_bundles "$@"
fi
