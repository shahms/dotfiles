#!/bin/bash
BASE="$(realpath "${1:-$(dirname "$0")/home}")"
DEST="${2:-$HOME}"

function homepath() {
  echo "${1/#$BASE/$HOME}"
}

# In order to allow for local modification more easily,
# we create directories and symlink files.
find "$BASE" -mindepth 1 -depth -type d| while read dotdir; do
  mkdir -p "$(homepath "$dotdir")"
done

find "$BASE" -type f | while read dotfile; do
  ln -s "${dotfile}" "$(homepath "$dotfile")"
done
