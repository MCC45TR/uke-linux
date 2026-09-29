#!/usr/bin/env bash
# Host-only reference manager. Does not execute code from reference repositories.
set -euo pipefail
export GIT_TERMINAL_PROMPT=0 GIT_LFS_SKIP_SMUDGE=1 GIT_NO_LAZY_FETCH=1
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
CAT=manifests/sources.yaml
LOCK=manifests/sources.lock.json
fail() { printf '%s\n' "$*" >&2; exit 1; }
now() { date -u +%Y-%m-%dT%H:%M:%SZ; }
reserve() {
  local free
  free=$(df -B1 --output=avail "$ROOT" | tail -n 1 | tr -d ' ')
  ((free >= 85899345920)) || fail '80 GiB free-space reserve reached'
}
validate_catalog() {
  jq -e '(.sources|length)==(.sources|map(.id)|unique|length) and all(.sources[];
        (.id|test("^[a-z0-9][a-z0-9-]*$")) and
        (.owner|IN("recovery-uke-ofox","senemos-uke-kernel","uke-fedora-builder","uke-project-aloha")))' "$CAT" >/dev/null
  while IFS= read -r source; do
    local owner rel path
    owner=$(jq -r .owner <<<"$source"); rel=$(jq -r .path <<<"$source")
    [[ $rel == "$owner/referances/"* && $rel != *'/bundles/'* && $rel != *'/../'* && $rel != *'/./'* ]] || fail 'Invalid reference path'
    path=$(realpath -m -- "$ROOT/$rel")
    [[ $path == "$ROOT/$owner/referances/"* ]] || fail 'Reference path escapes its component'
    jq -e '. as $s | (.refs|length)>0 and (.refs|has($s.checkout)) and
      all(.refs|to_entries[]; (.key|test("^refs/(heads|tags)/[^[:space:]]+$")) and (.value|test("^[a-f0-9]{40}$")))' <<<"$source" >/dev/null
    while IFS= read -r ref; do git check-ref-format "$ref"; done < <(jq -r '.refs|keys[]' <<<"$source")
  done < <(jq -c '.sources[]' "$CAT")
}
report() {
  {
    printf '# Reference archive status\n\nGit restoration does not prove a build or include missing submodule/LFS objects.\n\n'
    printf '| Source | Component | Phase | Git | Offline restore | Dependencies |\n|---|---|---|---|---|---|\n'
    jq -r --slurpfile lock "$LOCK" '.sources[] as $s | ($lock[0].sources[$s.id] // {}) as $r |
      "| \($s.id) | \($s.owner) | \($s.phase) | \($r.git_integrity // "not-acquired") | \($r.offline_git_restore.status // "not-run") | \(if $r.archive_complete then "complete" else "pending" end) |"' "$CAT"
  } > reports/source-archive.md
}
update_record() { jq "$@" "$record" > "$record.next"; mv "$record.next" "$record"; }
sync_source() {
  reserve
  if [[ ! -e $path ]]; then
    mkdir -p "$(dirname "$path")"
    git clone --origin upstream --no-checkout --no-tags --single-branch --branch "${checkout#refs/*/}" "$url" "$path"
  fi
  [[ $(git -C "$path" remote get-url upstream) == "$url" ]] || fail 'Reference URL differs from catalog'
  if [[ -e $path/.git/index && -n $(git -C "$path" status --porcelain --untracked-files=no) ]]; then fail 'Tracked reference edits; refusing checkout'; fi
  while IFS=$'\t' read -r ref commit; do
    if ! git -C "$path" cat-file -e "$commit^{commit}" 2>/dev/null; then git -C "$path" fetch --no-tags upstream "$ref"; fi
    git -C "$path" cat-file -e "$commit^{commit}"
    git -C "$path" update-ref "refs/archive/${ref#refs/}" "$commit"
  done < <(jq -r '.refs|to_entries[]|[.key,.value]|@tsv' <<<"$source")
  git -C "$path" checkout --detach "$expected"
  update_record --arg time "$(now)" '.acquired_at //= $time | .acquisition="cloned"'
}
verify_source() {
  [[ $(git -C "$path" rev-parse --is-shallow-repository) == false ]] || fail 'Shallow archive rejected'
  if git -C "$path" config --get-regexp 'remote\..*\.promisor' | rg -q 'true$'; then fail 'Partial clone rejected'; fi
  [[ -z $(git -C "$path" status --porcelain --untracked-files=no) ]] || fail 'Tracked reference edits'
  [[ $(git -C "$path" rev-parse HEAD) == "$expected" ]] || fail 'Checkout differs from pinned commit'
  [[ $(git -C "$path" remote get-url upstream) == "$url" ]] || fail 'Reference origin mismatch'
  git -C "$path" fsck --full --no-dangling
  update_record '.refs={} | .submodules=[] | .lfs_attributes=[] | .archive_complete=false'
  local commits=() ref commit tree line name
  while IFS=$'\t' read -r ref commit; do
    [[ $(git -C "$path" rev-parse "$commit^{commit}") == "$commit" ]] || fail 'Pinned commit unavailable'
    tree=$(git -C "$path" rev-parse "$commit^{tree}")
    commits+=("$commit")
    update_record --arg ref "$ref" --arg commit "$commit" --arg tree "$tree" '.refs[$ref]={commit:$commit,tree:$tree}'
    while IFS=$'\t' read -r line name; do
      if [[ $line == '160000 commit '* ]]; then
        update_record --arg ref "$ref" --arg path "$name" --arg commit "${line##* }" '.submodules += [{ref:$ref,path:$path,commit:$commit}]'
      elif [[ $name == *'.gitattributes' ]]; then
        if git -C "$path" show "$commit:$name" | rg -q 'filter=lfs'; then
          update_record --arg ref "$ref" --arg path "$name" '.lfs_attributes += [{ref:$ref,path:$path}]'
        fi
      fi
    done < <(git -C "$path" ls-tree -r "$commit")
  done < <(jq -r '.refs|to_entries[]|[.key,.value]|@tsv' <<<"$source")
  git -C "$path" log --format=%H -G filter=lfs "${commits[@]}" -- .gitattributes '**/.gitattributes' > "$record.history"
  git -C "$path" ls-tree --name-only "$expected" > "$record.licenses"
  update_record --arg time "$(now)" --rawfile hist "$record.history" --rawfile licenses "$record.licenses" '
    .git_integrity="passed" | .git_verified_at=$time | .shallow=false |
    .history="full reachable history of locked refs" |
    .lfs_history_changes=($hist|split("\n")|map(select(length>0))) |
    .submodule_status=(if (.submodules|length)>0 then "pending-separate-archives" else "not-required" end) |
    .lfs_status=(if ((.lfs_attributes|length)+(.lfs_history_changes|length))>0 then "pending-object-audit" else "no-lfs-attributes-detected" end) |
    .license_paths=($licenses|split("\n")|map(select(test("^(license|licence|copying|notice)";"i")))) |
    .license_review="pending-file-level-review"'
}
bundle_source() {
  reserve
  verify_source
  local refs=() ref commit
  mkdir -p "$(dirname "$bundle")"
  while IFS=$'\t' read -r ref commit; do
    refs+=("refs/archive/${ref#refs/}")
    git -C "$path" update-ref "refs/archive/${ref#refs/}" "$commit"
  done < <(jq -r '.refs|to_entries[]|[.key,.value]|@tsv' <<<"$source")
  git -C "$path" bundle create "$bundle.part" "${refs[@]}"
  git -C "$path" bundle verify "$bundle.part"
  mv "$bundle.part" "$bundle"
  update_record --arg path "${bundle#"$ROOT/"}" --arg sha "$(sha256sum "$bundle" | cut -d' ' -f1)" --arg time "$(now)" --argjson bytes "$(stat -c %s "$bundle")" '.bundle={path:$path,sha256:$sha,created_at:$time,bytes:$bytes}'
}
restore_source() {
  reserve
  [[ $(jq -r .bundle.path "$record") == "${bundle#"$ROOT/"}" ]] || fail 'Bundle path mismatch'
  [[ $(sha256sum "$bundle" | cut -d' ' -f1) == $(jq -r .bundle.sha256 "$record") ]] || fail 'Bundle checksum mismatch'
  local dest ref commit tree
  dest=$(mktemp -d "$ROOT/build/restore.XXXXXX")
  trap 'rm -rf -- "$dest"' EXIT
  git init --bare "$dest/repo.git"
  git -C "$dest/repo.git" bundle verify "$bundle"
  git -c protocol.allow=never -c protocol.file.allow=always -C "$dest/repo.git" fetch "$bundle" 'refs/archive/*:refs/archive/*'
  git -C "$dest/repo.git" fsck --full --no-dangling
  while IFS=$'\t' read -r ref commit tree; do
    [[ $(git -C "$dest/repo.git" rev-parse "refs/archive/${ref#refs/}") == "$commit" ]] || fail 'Restored commit mismatch'
    [[ $(git -C "$dest/repo.git" rev-parse "refs/archive/${ref#refs/}^{tree}") == "$tree" ]] || fail 'Restored tree mismatch'
  done < <(jq -r '.refs|to_entries[]|[.key,.value.commit,.value.tree]|@tsv' "$record")
  local lfs_ready=false lfs_file lfs_sha lfs_oid lfs_item
  if jq -e '.lfs_archive.offline_restore.status=="passed"' "$record" >/dev/null; then
    lfs_file="$ROOT/$(jq -r .lfs_archive.bundle.path "$record")"
    [[ $lfs_file == "$ROOT/$owner/referances/bundles/$id-lfs.tar" ]] || fail 'LFS bundle path mismatch'
    lfs_sha=$(jq -r .lfs_archive.bundle.sha256 "$record")
    [[ $(sha256sum "$lfs_file" | cut -d' ' -f1) == "$lfs_sha" ]] || fail 'LFS bundle checksum mismatch'
    while IFS= read -r lfs_item; do
      [[ $lfs_item =~ ^objects/[0-9a-f]{2}/[0-9a-f]{2}/[0-9a-f]{64}$ ]] || fail 'Unsafe LFS archive path'
    done < <(tar -tf "$lfs_file")
    mkdir -p "$dest/lfs"
    tar -xf "$lfs_file" -C "$dest/lfs"
    while IFS= read -r lfs_oid; do
      [[ $lfs_oid =~ ^[0-9a-f]{64}$ ]] || fail 'Invalid LFS object ID'
      lfs_item="$dest/lfs/objects/${lfs_oid:0:2}/${lfs_oid:2:2}/$lfs_oid"
      [[ -f $lfs_item && $(sha256sum "$lfs_item" | cut -d' ' -f1) == "$lfs_oid" ]] || fail 'Restored LFS object mismatch'
    done < <(jq -r '.lfs_archive.object_ids[]' "$record")
    lfs_ready=true
  fi
  update_record --arg time "$(now)" --argjson lfs_ready "$lfs_ready" '
    .offline_git_restore={status:"passed",at:$time,network_used:false} |
    .lfs_status=(if $lfs_ready then "verified-offline" else .lfs_status end) |
    .archive_complete=((.submodules|length)==0 and
      (((.lfs_attributes|length)+(.lfs_history_changes // []|length))==0 or $lfs_ready))'
  rm -rf -- "$dest"
  trap - EXIT
}
command=${1:-}; [[ -n $command ]] || fail 'Usage: scripts/sources.sh validate|sync|verify|bundle|restore-check|archive|report [source IDs] [--phase preparation|implementation|all]'
shift
phase=preparation; ids=()
while (($#)); do
  if [[ $1 == --phase ]]; then phase=${2:?Missing phase}; shift 2; else ids+=("$1"); shift; fi
done
[[ $phase == preparation || $phase == implementation || $phase == all ]] || fail 'Unknown phase'
case $command in validate|sync|verify|bundle|restore-check|archive|report) ;; *) fail 'Unknown operation';; esac
validate_catalog
if [[ $command == validate ]]; then echo 'Source catalog: passed'; exit; fi
mkdir -p reports/private build
exec 9>reports/private/sources.lock
flock -n 9 || fail 'Another source operation is running'
[[ -f $LOCK ]] || printf '{"schema_version":1,"sources":{}}\n' > "$LOCK"
if [[ $command == report ]]; then report; exit; fi
for id in "${ids[@]}"; do jq -e --arg id "$id" 'any(.sources[];.id==$id)' "$CAT" >/dev/null || fail 'Unknown source ID'; done
failures=0
while IFS= read -r source; do
  id=$(jq -r .id <<<"$source")
  if ((${#ids[@]})); then [[ " ${ids[*]} " == *" $id "* ]] || continue
  elif [[ $phase != all && $(jq -r .phase <<<"$source") != "$phase" ]]; then continue; fi
  path="$ROOT/$(jq -r .path <<<"$source")"; url=$(jq -r .url <<<"$source")
  owner=$(jq -r .owner <<<"$source"); checkout=$(jq -r .checkout <<<"$source")
  expected=$(jq -r --arg ref "$checkout" '.refs[$ref]' <<<"$source")
  bundle="$ROOT/$owner/referances/bundles/$id.bundle"
  [[ $(realpath -m "$bundle") == "$bundle" ]] || fail 'Bundle path redirected outside its archive'
  record=$(mktemp "$ROOT/build/record.XXXXXX")
  jq --arg id "$id" --argjson s "$source" '.sources[$id] // {url:$s.url,path:$s.path,owner:$s.owner}' "$LOCK" > "$record"
  if jq -e '.refs' "$record" >/dev/null; then
    jq -e --argjson s "$source" '.refs|with_entries(.value=.value.commit) == $s.refs' "$record" >/dev/null || fail 'Catalog changes an existing pin; an explicit lock update is required'
  fi
  printf '%s: %s\n' "$id" "$command"
  set +e
  (
    set -e
    case $command in
      sync) sync_source;; verify) verify_source;; bundle) bundle_source;; restore-check) restore_source;;
      archive) sync_source; bundle_source; restore_source;;
    esac
  ) >"reports/private/$id.log" 2>&1
  code=$?
  set -e
  if ((code)); then
    update_record --arg time "$(now)" '.archive_complete=false | .last_error={at:$time,message:"Operation failed; inspect the local private log"}'
    printf '%s: failed (reports/private/%s.log)\n' "$id" "$id" >&2
    failures=$((failures+1))
  else update_record 'del(.last_error)'; fi
  jq --arg id "$id" --slurpfile r "$record" '.sources[$id]=$r[0]' "$LOCK" > "$LOCK.next"
  mv "$LOCK.next" "$LOCK"
  rm -f "$record" "$record.next" "$record.history" "$record.licenses"
done < <(jq -c '.sources[]' "$CAT")
report
((failures==0))
