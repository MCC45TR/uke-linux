#!/usr/bin/env bash
# Host-only inventory of pinned donor Git objects. Never executes donor code.
# With no arguments, retain the original six-source Xiaomi Uke inventory.
set -euo pipefail
export GIT_NO_LAZY_FETCH=1
root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"
mkdir -p build
work=$(mktemp -d "$root/build/xiaomi-uke-audit.XXXXXX")
trap 'rm -rf -- "$work"' EXIT
ids=(xiaomi-uke-device xiaomi-uke-recovery xiaomi-uke-common-device
     xiaomi-uke-kernel-prebuilts xiaomi-uke-vendor xiaomi-uke-common-vendor)
if (($#)); then ids=("$@"); fi
[[ $(printf '%s\n' "${ids[@]}" | sort -u | wc -l) -eq ${#ids[@]} ]] || {
  printf 'Duplicate source ID in audit request.\n' >&2; exit 2;
}
for id in "${ids[@]}"; do
  [[ $id =~ ^[a-z0-9][a-z0-9-]*$ ]] || {
    printf 'Invalid source ID in audit request.\n' >&2; exit 2;
  }
  entry=$(jq -ce --arg id "$id" '.sources[] | select(.id==$id)' manifests/sources.yaml)
  owner=$(jq -r .owner <<<"$entry")
  rel=$(jq -r .path <<<"$entry")
  path="$root/$rel"
  [[ $rel == "$owner/referances/"* && $(realpath -m -- "$path") == "$path" ]]
  ref=$(jq -r .checkout <<<"$entry")
  commit=$(jq -r --arg ref "$ref" '.refs[$ref]' <<<"$entry")
  [[ $(git -C "$path" rev-parse HEAD) == "$commit" ]]
  [[ $(git -C "$path" remote get-url upstream) == $(jq -r .url <<<"$entry") ]]
  [[ $(git -C "$path" rev-parse --is-shallow-repository) == false ]]
  [[ -z $(git -C "$path" status --porcelain --untracked-files=no) ]]
  tree=$(git -C "$path" rev-parse "$commit^{tree}")
  commits=$(git -C "$path" rev-list --count "$commit")
  git -C "$path" ls-tree -rzl "$commit" > "$work/tree"
  jq -Rs 'split("\u0000") | map(select(length>0) |
    capture("^(?<mode>[0-7]{6}) (?<type>[^ ]+) (?<oid>[a-f0-9]{40}) +(?<bytes>[0-9]+|-)\t(?<path>.*)$") |
    .size_bytes=(if .bytes=="-" then null else (.bytes|tonumber) end) | del(.bytes))' \
    "$work/tree" > "$work/files"
  jq -n --argjson source "$entry" --arg tree "$tree" --arg commit "$commit" \
    --argjson commits "$commits" --arg id "$id" --slurpfile files "$work/files" \
    --slurpfile lock manifests/sources.lock.json '
    $files[0] as $f | $lock[0].sources[$id] as $a |
    {id:$id,owner:$source.owner,path:$source.path,url:$source.url,
     ref:$source.checkout,commit:$commit,tree:$tree,reachable_commits:$commits,
     archive:{git_integrity:$a.git_integrity,offline_git_restore:$a.offline_git_restore,
       archive_complete:$a.archive_complete,bundle:$a.bundle,lfs_status:$a.lfs_status,
       lfs_object_count:($a.lfs_archive.object_count // 0),
       lfs_bundle:($a.lfs_archive.bundle // null),submodules:$a.submodules},
     statistics:{tracked_files:($f|length),tracked_git_bytes:($f|map(.size_bytes // 0)|add),
       modules:($f|map(select(.path|endswith(".ko")))|length),
       distinct_module_filenames:($f|map(select(.path|endswith(".ko"))|.path|split("/")[-1])|unique|length),
       distinct_module_git_blobs:($f|map(select(.path|endswith(".ko"))|.oid)|unique|length),
       kernel_header_files:($f|map(select(.path|startswith("kernel-headers/")))|length),
       python_files:($f|map(select(.path|endswith(".py")))|length),
       shared_objects:($f|map(select(.path|endswith(".so")))|length),
       device_tree_sources:($f|map(select(.path|test("\\.dtsi?$")))|length),
       compiled_dtb:($f|map(select(.path|endswith(".dtb")))|length),
       sensor_configuration_files:($f|map(select(.path|contains("/sensors/config/")))|length),
       firmware_paths:($f|map(select(.path|contains("firmware/")))|length)},
     top_level:($f|group_by(.path|split("/")[0])|map({name:(.[0].path|split("/")[0]),
       files:length,git_bytes:(map(.size_bytes // 0)|add)})),
     largest_git_blobs:($f|sort_by(.size_bytes // 0)|reverse|.[0:5]),
     native_source_paths:($f|map(select((.path|test("\\.(c|cc|cpp|S)$")) and
       (.path|startswith("kernel-headers/")|not)))|map(.path)),
     python_paths:($f|map(select(.path|endswith(".py")))|map(.path)),
     license_named_paths:($f|map(select(.path|test("(^|/)(LICENSE|LICENCE|COPYING|NOTICE)([^/]*)$";"i")))|map(.path)),
     module_groups:($f|map(select(.path|endswith(".ko")))|
       group_by(.path|split("/")[0:2]|join("/"))|
       map({directory:(.[0].path|split("/")[0:2]|join("/")),files:length})),
     selected_paths:($f|map(select(.path|test("(^|/)(BoardConfig[^/]*|[^/]*\\.mk|lineage.dependencies|fstab[^/]*|recovery.fstab|twrp.flags|extract-files[^/]*|setup-makefiles[^/]*|modules.load[^/]*|modules.blocklist|init[^/]*\\.(rc|sh)|xiaomi[^/]*\\.(c|cpp)|power-mode.cpp|sm7675[^/]*\\.json|lsm6dso_0.json|qmc6308_0.json|sip1328.json|stk3bcx_0.json|sx937x_0.json|novatek[^/]*\\.bin|[^/]*thp_config.ini|[^/]*qdcm_calib[^/]*|[^/]*sensor\\.o82[^/]*|[^/]*thermal-map[^/]*|kernel|dtbo.img|[^/]*\\.dtb)$")))|map(.path))}' \
     > "$work/$id.json"
done
jq -s '{schema_version:1,reviewed_on:"2026-10-04",evidence_class:"source-and-local-archive",
  donor_code_executed:false,donor_payload_deployed:false,hardware_tests_performed:false,
  tracked_bytes_include_LFS_payloads:false,repositories:.}' "$work"/*.json
