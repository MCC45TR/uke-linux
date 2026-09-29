#!/usr/bin/env bash
# Host-only ledger validation and Markdown generation.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mode=${1:-render}
input=${2:-$ROOT/manifests/device-status.json}
jq -e '
 . as $d |
 (.capabilities|length)==(.capabilities|map(.id)|unique|length) and
 all(.capabilities[]; . as $c |
   (.evidence|length)>0 and all(.evidence[]; . as $e | $d.sources|has($e)) and
   (.note|length)>0 and
   all(["recovery","uefi","linux"][]; . as $layer |
     $c.results[$layer] as $result |
     ($result|IN("working","partial","not-working","not-tested","not-applicable")) and
     (if ($result|IN("working","partial","not-working")) then
       $d.physical_device_available==true and ($c.tests[$layer]|length)>0 and
       all($c.tests[$layer][]; . as $tid | $d.test_records[$tid] as $r |
         $r!=null and $r.environment==$layer and
         all(["build_id","device_variant","firmware_profile","timestamp_utc","evidence"][]; . as $f | ($r[$f]|length)>0))
      else true end)))' "$input" >/dev/null || { echo 'Device evidence validation failed' >&2; exit 1; }
if [[ $mode == validate ]]; then echo 'Device evidence: passed'; exit; fi
[[ $mode == render || $mode == --check ]] || { echo 'Usage: scripts/device-status.sh [render|--check|validate] [ledger.json]' >&2; exit 1; }
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
{
cat <<'TEXT'
# Device status: POCO Pad X1 and Xiaomi Pad 7 / uke

Target family: **POCO Pad X1 and Xiaomi Pad 7 (`uke`)**. Primary physical validation hardware: **POCO Pad X1 8 GB / 512 GB**. Kernel product: **senemos-uke-kernel-mainline**. Target sequence: OrangeFox, Project Aloha, then Fedora Rawhide AArch64.

This document is generated from `manifests/device-status.json`. Source evidence identifies a candidate component or capability; it does not establish that our software works on it.

TEXT
jq -r '"Ledger updated: **\(.updated_at)**. Physical device available: **\(.physical_device_available)**. Tracked capabilities: **\(.capabilities|length)**."' "$input"
cat <<'TEXT'

No own-device acceptance has been performed. A missing implementation or an untested feature is not a measured hardware failure. Third-party results are recorded separately.

## Reading the results

- **working**: acceptance passed on the recorded build, firmware and physical variant.
- **partial**: some tested functions work; limitations must be recorded.
- **not-working**: a real test observed failure.
- **not-tested**: no success or failure claim.
- **not-applicable**: the function is outside that environment's scope, with a recorded reason.

## Coverage

| Environment | Working | Partial | Not working | Not tested | Not applicable |
|---|---:|---:|---:|---:|---:|
TEXT
jq -r '. as $d | ["recovery","uefi","linux"][] as $l | "| " + $l + " | " + (["working","partial","not-working","not-tested","not-applicable"]|map(. as $s|[$d.capabilities[]|select(.results[$l]==$s)]|length|tostring)|join(" | ")) + " |"' "$input"
printf '\n## Variant rules\n\n'
jq -r '.variant_rules[]|"- "+.' "$input"
# Preserve ledger category order.
while IFS= read -r category; do
  printf '\n## %s\n\n' "$category"
  printf '| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |\n|---|---|---|---|---|---|---|\n'
  jq -r --arg category "$category" 'def cell: tostring|gsub("\\|";"\\|")|gsub("\n";" "); .capabilities[]|select(.category==$category)| [.id,.component,.capability,.results.recovery,.results.uefi,.results.linux,((.evidence|join(", "))+": "+.note)]|"| "+(map(cell)|join(" | "))+" |"' "$input"
done < <(jq -r 'reduce .capabilities[].category as $c ([];if index($c) then . else .+[$c] end) | .[]' "$input")
printf '\n## Third-party observations\n\n'
jq -r '.third_party_observations[]|"- "+.' "$input"
printf '\n## Evidence needed next\n\n'
jq -r '.next_evidence[]|"- "+.' "$input"
printf '\n## Source key\n\n'
jq -r '.sources|to_entries[]|"- **\(.key):** [\(.value.title)](\(.value.url)) — \(.value.scope)."' "$input"
cat <<'TEXT'

## Updating this document

Edit the ledger, then run `scripts/device-status.sh`. Each working, partial or failed result requires a test record for that environment with build ID, physical variant, firmware profile, UTC timestamp and evidence. `scripts/device-status.sh --check` rejects unsupported results and stale generated Markdown. Automated source checks never promote a physical result.
TEXT
} > "$tmp"
if [[ $mode == --check ]]; then cmp -s "$tmp" "$ROOT/DEVICE-STATUS.md" || { echo 'DEVICE-STATUS.md is stale' >&2; exit 1; }; echo 'Device status: passed'
else cp "$tmp" "$ROOT/DEVICE-STATUS.md"; fi
