#!/usr/bin/env bash
# Host-only negative tests. All repositories and disk payloads are temporary.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT"
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
passed=0
ok() { passed=$((passed+1)); printf 'ok %d - %s\n' "$passed" "$1"; }
reject() { if "$@" >"$tmp/rejected.log" 2>&1; then echo "Expected rejection: $*" >&2; exit 1; fi; }
scripts/sources.sh validate
scripts/device-status.sh --check
ok 'catalog and generated hardware ledger'
jq '.capabilities[0].results.linux="working"' manifests/device-status.json > "$tmp/ledger.json"
reject scripts/device-status.sh validate "$tmp/ledger.json"
ok 'unsupported hardware success rejected'
jq '.capabilities[0].results.recovery="not-working"' manifests/device-status.json > "$tmp/ledger.json"
reject scripts/device-status.sh validate "$tmp/ledger.json"
ok 'unsupported hardware failure rejected'
jq '.capabilities += [.capabilities[0]]' manifests/device-status.json > "$tmp/ledger.json"
reject scripts/device-status.sh validate "$tmp/ledger.json"
ok 'duplicate capability rejected'
jq '.capabilities[0].evidence=["missing-source"]' manifests/device-status.json > "$tmp/ledger.json"
reject scripts/device-status.sh validate "$tmp/ledger.json"
ok 'unknown source evidence rejected'
jq '.physical_device_available=true | .capabilities[0].results.linux="working" | .capabilities[0].tests.linux=["t"] | .test_records.t={environment:"recovery",build_id:"fixture",device_variant:"fixture",firmware_profile:"fixture",timestamp_utc:"2026-09-29T00:00:00Z",evidence:["fixture"]}' manifests/device-status.json > "$tmp/ledger.json"
reject scripts/device-status.sh validate "$tmp/ledger.json"
ok 'wrong-environment evidence rejected'
# A mock free-space probe allows tiny archive fixtures on small CI disks.
mkdir -p "$tmp/ws/scripts" "$tmp/ws/manifests" "$tmp/ws/reports" "$tmp/bin"
cp scripts/sources.sh "$tmp/ws/scripts/"
printf '#!/bin/sh\nprintf "Avail\\n999999999999\\n"\n' > "$tmp/bin/df"
chmod +x "$tmp/bin/df"
git init -q -b main "$tmp/origin"
git -C "$tmp/origin" config user.name 'Archive fixture'
git -C "$tmp/origin" config user.email 'fixture@users.noreply.github.com'
printf 'reference fixture\n' > "$tmp/origin/README"
git -C "$tmp/origin" add README
git -C "$tmp/origin" commit -qm 'Create archive fixture'
commit=$(git -C "$tmp/origin" rev-parse HEAD)
jq -n --arg url "$tmp/origin" --arg commit "$commit" '{schema_version:1,sources:[{id:"fixture",owner:"senemos-uke-kernel",path:"senemos-uke-kernel/referances/test/fixture",url:$url,phase:"preparation",checkout:"refs/heads/main",refs:{"refs/heads/main":$commit}}]}' > "$tmp/ws/manifests/sources.yaml"
archive() { PATH="$tmp/bin:$PATH" bash "$tmp/ws/scripts/sources.sh" "$@"; }
archive archive > "$tmp/archive.log" 2>&1 || { cat "$tmp/archive.log"; cat "$tmp/ws/reports/private/fixture.log"; exit 1; }
jq -e '.sources.fixture.archive_complete and .sources.fixture.offline_git_restore.network_used==false' "$tmp/ws/manifests/sources.lock.json" >/dev/null
ok 'full-history bundle restores offline with identical commit and tree'
cp "$tmp/ws/manifests/sources.yaml" "$tmp/catalog.json"
jq '.sources[0].path="senemos-uke-kernel/referances/../../escape"' "$tmp/catalog.json" > "$tmp/ws/manifests/sources.yaml"
reject archive validate
ok 'reference path traversal rejected'
cp "$tmp/catalog.json" "$tmp/ws/manifests/sources.yaml"
printf 'modified\n' >> "$tmp/ws/senemos-uke-kernel/referances/test/fixture/README"
reject archive sync
rg -q modified "$tmp/ws/senemos-uke-kernel/referances/test/fixture/README"
ok 'dirty reference preserved'
git -C "$tmp/ws/senemos-uke-kernel/referances/test/fixture" restore README
jq '.sources[0].refs["refs/heads/main"]="0000000000000000000000000000000000000000"' "$tmp/catalog.json" > "$tmp/ws/manifests/sources.yaml"
reject archive sync
ok 'existing pin cannot silently change'
cp "$tmp/catalog.json" "$tmp/ws/manifests/sources.yaml"
printf 'corrupt\n' >> "$tmp/ws/senemos-uke-kernel/referances/bundles/fixture.bundle"
reject archive restore-check
ok 'corrupt bundle rejected'
# LFS attributes removed at HEAD still require historical object auditing.
printf '*.bin filter=lfs diff=lfs merge=lfs -text\n' > "$tmp/origin/.gitattributes"
git -C "$tmp/origin" add .gitattributes
git -C "$tmp/origin" commit -qm 'Introduce LFS fixture attributes'
git -C "$tmp/origin" rm -q .gitattributes
git -C "$tmp/origin" commit -qm 'Remove LFS fixture attributes'
commit=$(git -C "$tmp/origin" rev-parse HEAD)
jq --arg commit "$commit" '.sources[0].refs["refs/heads/main"]=$commit' "$tmp/catalog.json" > "$tmp/ws/manifests/sources.yaml"
rm "$tmp/ws/manifests/sources.lock.json"
archive archive > "$tmp/lfs.log" 2>&1 || { cat "$tmp/lfs.log"; cat "$tmp/ws/reports/private/fixture.log"; exit 1; }
jq -e '.sources.fixture.archive_complete==false and (.sources.fixture.lfs_history_changes|length)>0' "$tmp/ws/manifests/sources.lock.json" >/dev/null
ok 'historical LFS prevents false archive completion'
mkdir -p "$tmp/payload/usr/bin"
printf '#!/bin/sh\nexit 0\n' > "$tmp/payload/usr/bin/helper"
scripts/check-target-payload.sh "$tmp/payload" >/dev/null
printf '#!/usr/bin/env %s\n' 'python3' > "$tmp/payload/usr/bin/helper"
reject scripts/check-target-payload.sh "$tmp/payload"
ok 'renamed Python target script rejected'
rm "$tmp/payload/usr/bin/helper"
ln -s /usr/bin/python3 "$tmp/payload/usr/bin/alias"
reject scripts/check-target-payload.sh "$tmp/payload"
ok 'Python target symlink rejected'
printf 'ro.build.user=uke-builder\nro.build.host=uke-build\n' > "$tmp/payload/prop.default"
scripts/check-target-privacy.sh "$tmp/payload" >/dev/null
printf 'ro.build.user=private-builder\nro.build.host=uke-build\n' > "$tmp/payload/prop.default"
reject scripts/check-target-privacy.sh "$tmp/payload"
ok 'private target build identity rejected'
printf 'ro.build.user=uke-builder\nro.build.host=uke-build\n' > "$tmp/payload/prop.default"
printf '/%s/%s/private\n' home fixture > "$tmp/payload/usr/bin/path-record"
reject scripts/check-target-privacy.sh "$tmp/payload"
ok 'private target build path rejected'
# Staged content is scanned even when the worktree has a sanitized replacement.
git init -q -b main "$tmp/publication"
git -C "$tmp/publication" config user.email fixture@users.noreply.github.com
printf '/%s/%s/private\n' home fixture > "$tmp/publication/README.md"
git -C "$tmp/publication" add README.md
printf 'safe replacement\n' > "$tmp/publication/README.md"
reject scripts/privacy-check.sh "$tmp/publication"
ok 'private staged content rejected despite clean worktree replacement'
git -C "$tmp/publication" add README.md
scripts/privacy-check.sh "$tmp/publication" >/dev/null
ok 'sanitized publication index accepted'
# Exactly 100 unique numbered steps, each dependency exists and precedes its consumer.
awk -F '|' '/^\| [0-9][0-9][0-9] \|/ {gsub(/ /,"",$2); if(seen[$2]++)exit 1; n++; dep=$4; gsub(/ /,"",dep); count=split(dep,a,","); for(i=1;i<=count;i++)if(a[i]~/^[0-9]+$/ && (!seen[a[i]] || a[i]+0 >= $2+0))exit 2} END{if(n!=100)exit 3}' PLAN.md
ok '100 unique dependency-ordered plan steps'
printf '%d host checks passed; no hardware tests performed.\n' "$passed"
