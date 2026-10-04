#!/usr/bin/env bash
# Host-only gitlink/catalog comparison; never initializes or executes donors.
set -euo pipefail
export GIT_NO_LAZY_FETCH=1
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"
entry=$(jq -ce '.sources[] | select(.id=="uke-linux")' manifests/sources.yaml)
path=$(jq -r .path <<< "$entry")
ref=$(jq -r .checkout <<< "$entry")
pin=$(jq -r --arg ref "$ref" '.refs[$ref]' <<< "$entry")
[[ $path == senemos-uke-kernel/referances/* ]]
[[ $(realpath -m -- "$path") == "$root/$path" ]]
[[ $(git -C "$path" rev-parse HEAD) == "$pin" ]]
[[ $(git -C "$path" remote get-url upstream) == $(jq -r .url <<< "$entry") ]]
jq -e --arg ref "$ref" --arg pin "$pin" '.sources["uke-linux"].refs[$ref].commit==$pin' \
  manifests/sources.lock.json >/dev/null
mkdir -p build
work=$(mktemp -d "$root/build/uke-dependency-audit.XXXXXX")
trap 'rm -rf -- "$work"' EXIT
git -C "$path" show "$pin:.gitmodules" > "$work/gitmodules"
git -C "$path" ls-tree -r "$pin" | awk '$1=="160000" {print $3, $4}' > "$work/gitlinks"
: > "$work/map.jsonl"
while read -r commit subpath; do
  url=$(git config -f "$work/gitmodules" --get "submodule.$subpath.url")
  jq -n --arg ref "$ref" --arg path "$subpath" --arg commit "$commit" --arg url "$url" \
    --slurpfile catalog manifests/sources.yaml --slurpfile lock manifests/sources.lock.json '
    {ref:$ref,path:$path,commit:$commit,url:$url,
     dependency_archive_status:"not-linked-or-verified-as-parent-closure",
     exact_pin_catalog_matches:[$catalog[0].sources[] | select(any(.refs[]; .==$commit)) |
       . as $s | {id:.id,path:.path,url:.url,canonical_url_matches:(.url==$url),
         archive_complete:($lock[0].sources[$s.id].archive_complete // false)}]}' >> "$work/map.jsonl"
done < "$work/gitlinks"
jq -s --arg pin "$pin" --slurpfile lock manifests/sources.lock.json '
  {schema_version:1,reviewed_on:"2026-10-04",parent_id:"uke-linux",parent_commit:$pin,
   parent_git_restore:$lock[0].sources["uke-linux"].offline_git_restore.status,
   dependency_closure:(if $lock[0].sources["uke-linux"].archive_complete then "complete" else "pending" end),
   catalog_matches_are_not_parent_closure_proof:true,submodules:.}' "$work/map.jsonl"
