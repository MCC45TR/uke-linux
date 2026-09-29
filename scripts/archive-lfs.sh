#!/usr/bin/env bash
# Host-only archive and offline verification for selected Git LFS reference objects.
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"
id=${1:?Usage: scripts/archive-lfs.sh SOURCE_ID}
[[ $id =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo 'Invalid source ID' >&2; exit 2; }
entry=$(jq -ce --arg id "$id" '.sources[] | select(.id==$id)' manifests/sources.yaml) || {
  echo 'Unknown source ID' >&2; exit 2;
}
owner=$(jq -r .owner <<<"$entry")
rel=$(jq -r .path <<<"$entry")
[[ $rel == "$owner/referances/"* ]] || { echo 'Invalid source path' >&2; exit 2; }
source="$root/$rel"
[[ $(realpath -m -- "$source") == "$source" && -d $source/.git ]] || {
  echo 'Reference checkout is missing' >&2; exit 1;
}
[[ $(git -C "$source" rev-parse HEAD) == $(jq -r --arg ref "$(jq -r .checkout <<<"$entry")" '.refs[$ref]' <<<"$entry") ]] || {
  echo 'Reference checkout does not match its pin' >&2; exit 1;
}

lfs_bin=$(command -v git-lfs || true)
if [[ -z $lfs_bin ]]; then
  lfs_bin="$root/recovery-uke-ofox/build/host-tools/git-lfs/usr/bin/git-lfs"
fi
[[ -x $lfs_bin ]] || { echo 'Pinned host Git LFS client is missing' >&2; exit 1; }
export PATH="$(dirname -- "$lfs_bin"):$PATH"

mkdir -p build "$owner/referances/bundles"
mkdir -p reports/private
exec 9>reports/private/sources.lock
flock -n 9 || { echo 'Another source operation is running' >&2; exit 1; }
jq -e --arg id "$id" '.sources[$id].git_integrity=="passed" and .sources[$id].offline_git_restore.status=="passed"' manifests/sources.lock.json >/dev/null || {
  echo 'Git archive and offline restore must pass first' >&2; exit 1;
}
work=$(mktemp -d "$root/build/lfs-archive.XXXXXX")
trap 'rm -rf -- "$work"' EXIT
git -C "$source" lfs ls-files --all --long | awk '{print $1}' | sort -u > "$work/oids"
[[ -s $work/oids ]] || { echo 'No Git LFS objects were found' >&2; exit 1; }

: > "$work/paths"
while IFS= read -r oid; do
  [[ $oid =~ ^[0-9a-f]{64}$ ]] || { echo 'Invalid Git LFS object ID' >&2; exit 1; }
  item="objects/${oid:0:2}/${oid:2:2}/$oid"
  [[ -f $source/.git/lfs/$item && ! -L $source/.git/lfs/$item ]] || {
    echo "Missing Git LFS object: $oid" >&2; exit 1;
  }
  [[ $(sha256sum "$source/.git/lfs/$item" | cut -d' ' -f1) == "$oid" ]] || {
    echo "Corrupt Git LFS object: $oid" >&2; exit 1;
  }
  printf '%s\n' "$item" >> "$work/paths"
done < "$work/oids"

git -C "$source" lfs fsck --objects --pointers
bundle="$root/$owner/referances/bundles/$id-lfs.tar"
tar -cf "$bundle.part" -C "$source/.git/lfs" -T "$work/paths"
mv -- "$bundle.part" "$bundle"
tar -xf "$bundle" -C "$work"

while IFS= read -r oid; do
  item="objects/${oid:0:2}/${oid:2:2}/$oid"
  [[ $(sha256sum "$work/$item" | cut -d' ' -f1) == "$oid" ]] || {
    echo "Offline Git LFS restore failed: $oid" >&2; exit 1;
  }
done < "$work/oids"

sha=$(sha256sum "$bundle" | cut -d' ' -f1)
bytes=$(stat -c %s "$bundle")
count=$(wc -l < "$work/oids")
record=$(jq -n --arg id "$id" --arg path "${bundle#"$root/"}" --arg sha "$sha" \
  --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" --argjson bytes "$bytes" \
  --argjson count "$count" --rawfile oids "$work/oids" \
  '{source_id:$id,bundle:{path:$path,sha256:$sha,bytes:$bytes},object_ids:($oids|split("\n")|map(select(length>0))),object_count:$count,offline_restore:{status:"passed",at:$time,network_used:false}}')
lock=manifests/lfs.lock.json
[[ -f $lock ]] || printf '{"schema_version":1,"sources":{}}\n' > "$lock"
jq --arg id "$id" --argjson record "$record" '.sources[$id]=$record' "$lock" > "$work/lock.next"
mv -- "$work/lock.next" "$lock"
jq --arg id "$id" --argjson record "$record" '
  .sources[$id].lfs_archive=$record |
  .sources[$id].lfs_status="verified-offline" |
  .sources[$id].archive_complete=(.sources[$id].git_integrity=="passed" and
    .sources[$id].offline_git_restore.status=="passed" and
    (.sources[$id].submodules|length)==0)
' manifests/sources.lock.json > "$work/sources.next"
mv -- "$work/sources.next" manifests/sources.lock.json
printf '%s: %d LFS objects archived and restored offline\n' "$id" "$count"
