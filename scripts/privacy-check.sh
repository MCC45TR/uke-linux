#!/usr/bin/env bash
# Publication guardrail. Reports paths only, never matching secret contents.
set -euo pipefail
repo=${1:-.}
repo=$(git -C "$repo" rev-parse --show-toplevel)
cd "$repo"
email=$(git config user.email || true)
[[ $email == *'@users.noreply.github.com' ]] || { echo 'Use a GitHub no-reply email for project commits' >&2; exit 1; }
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
failed=0
# Inspect the complete proposed index, including unchanged files.
while IFS= read -r -d '' entry; do
  meta=${entry%%$'\t'*}; path=${entry#*$'\t'}
  [[ $meta == '160000 '* ]] && continue
  case "$path" in
    *.py|*.pyc|*.pyo|*.pem|*.key|*.img|*.bundle|*.rpm|*.tgz|.env|*/.env|.env.*|*/.env.*|*/reports/private/*|reports/private/*)
      printf 'Forbidden publication path: %s\n' "$path" >&2; failed=1; continue;;
  esac
  git show ":$path" > "$tmp/content"
  if rg -a -q -e '-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----' \
    -e 'gh[pousr]_[A-Za-z0-9]{30,}' -e 'github_pat_[A-Za-z0-9_]{40,}' \
    -e 'AKIA[0-9A-Z]{16}' -e '/(home|Users)/[[:alnum:]_.-]+/' \
    -e '[[:alnum:]_.+-]+@(gmail|hotmail|outlook|yahoo)\.[[:alpha:]]+' "$tmp/content"; then
    printf 'Potential private content in: %s\n' "$path" >&2; failed=1
  fi
done < <(git ls-files --stage -z)
((failed==0)) || exit 1
printf 'Publication index and configured identity: passed (%s)\n' "$(basename "$repo")"
