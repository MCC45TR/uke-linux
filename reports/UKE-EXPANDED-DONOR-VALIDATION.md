# Additional Uke donor intake: validation receipt

Date: 4 October 2026. Scope: host-only source/archive/documentation review.
No donor scripts or installers were executed. No device was accessed, no
partition or host firmware was modified, and no runtime payload was deployed.

| Check | Result | Evidence and limit |
|---|---|---|
| Requested repository presence | Passed: 13 parent clones | Seven new entries and six existing references; component-owned paths in the [inventory](../docs/research/UKE-EXPANDED-DONOR-INVENTORY.json) |
| Full selected-ref Git history/integrity | Passed for all 13 parents | Non-shallow clones, exact commits/trees, archive-manager `verify` receipts |
| Offline bundle restoration | Passed for all 13 parents | Archive-manager `restore-check`; network disabled; checksums and restored commit/tree identities |
| Complete reference archives | 12 complete; one pending | `uke-linux` retains 19 unresolved parent dependency links; no false completion claim |
| Dependency map regeneration | Passed | `scripts/audit-uke-linux-dependencies.sh` output matches the dated map; 19 gitlinks, 14 exact catalog-pin matches, five unmatched |
| Metadata inventory regeneration | Passed | Explicit 13-source invocation of `scripts/audit-xiaomi-uke.sh`; byte-identical output with unchanged receipts |
| Invalid/duplicate/unknown audit requests | Passed: all rejected | Traversal-shaped ID, duplicate ID and nonexistent catalog ID return failure |
| Repository identity comparisons | Passed | Recovery mirror and Resources/Xiaomi kernel pairs have identical pinned trees; no independent hardware result inferred |
| Image/DT metadata | Read-only inspection completed | Vember per-ref Image SHA-256/banners and default FDT header framing; no boot, ABI or DT schema acceptance |
| Bash syntax and catalog | Passed | `bash -n` for both audit helpers; `scripts/sources.sh validate` |
| Root host regression suite | Passed: 19/19 | `tests/run.sh`; archive corruption/dirty-pin checks, ledger evidence rules, payload Python/privacy rejection and 100 dependency-ordered plan steps |
| Publication-tree regression suite | Passed: 19/19 | Disposable export of prior committed root plus proposed catalog/lock/report/plan changes; uses committed hardware ledger/scripts, without unrelated workspace changes |
| Whitespace/diff review | Passed | `git diff --check` and staged diff review |

Publication privacy is checked against the complete proposed Git index and
GitHub no-reply identity before each commit. Source clones, bundles, binary
payloads, temporary probe outputs and private logs remain outside that index.
The public review contains static filenames and provenance metadata, not donor
login credentials, private keys, raw calibration contents or home paths.

No recovery/kernel build, package build, new VM test or physical acceptance is
claimed by this receipt. The nine dated lessons include the failed SIGPIPE
banner diagnostic and its corrected probe, so command failure is not hidden
or misclassified as a kernel defect.

See the [expanded audit](../docs/research/UKE-EXPANDED-DONOR-AUDIT.md),
[dependency map](../docs/research/UKE-LINUX-DEPENDENCY-MAP.json) and
[lesson index](../docs/lessons/DONOR-INDEX.md) for reuse priorities and remaining
validation. The [archive lock](../manifests/sources.lock.json) preserves exact
bundle digests and restore timestamps; later revalidation may update receipts
without changing this historical intake record.
