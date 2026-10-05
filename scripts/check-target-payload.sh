#!/usr/bin/env bash
# Host-side scan of an already extracted target payload. Never runs target files.
set -euo pipefail
[[ $# == 1 && -d $1 ]] || { echo 'Usage: scripts/check-target-payload.sh EXTRACTED_TARGET_DIRECTORY' >&2; exit 2; }
for tool in realpath find readlink head grep od tr readelf; do
  command -v "$tool" >/dev/null || { printf 'Missing host audit tool: %s\n' "$tool" >&2; exit 2; }
done
root=$(realpath -- "$1")
failed=0
while IFS= read -r -d '' path; do
  name=${path##*/}
  case "$name" in
    *.py|*.pyc|*.pyo|*.pyz|python|python[0-9]*|libpython*|pypy*)
      printf 'Python target payload rejected: %s\n' "${path#"$root/"}" >&2; failed=1; continue;;
  esac
  if [[ -L $path ]]; then
    link=$(readlink -- "$path")
    case "${link##*/}" in python*|pypy*|libpython*) printf 'Python target link rejected: %s\n' "${path#"$root/"}" >&2; failed=1;; esac
  elif [[ -f $path ]]; then
    if head -c 256 -- "$path" | LC_ALL=C grep -aEq '^#![^[:cntrl:]]*(python|pypy)'; then
      printf 'Python target script rejected: %s\n' "${path#"$root/"}" >&2; failed=1
    elif [[ $(od -An -tx1 -N4 -- "$path" | tr -d ' \n') == 7f454c46 ]]; then
      if ! dynamic=$(readelf -d -- "$path" 2>/dev/null); then
        printf 'Unreadable target ELF rejected: %s\n' "${path#"$root/"}" >&2; failed=1
      elif grep 'NEEDED.*libpython' <<< "$dynamic" >/dev/null; then
        printf 'Python runtime dependency rejected: %s\n' "${path#"$root/"}" >&2; failed=1
      fi
    fi
  fi
done < <(find "$root" -mindepth 1 \( -type f -o -type l \) -print0)
((failed==0)) || exit 1
echo 'Extracted target payload: no recognized Python files, entrypoints or dynamic dependencies'
