# 5 October 2026: recovery completion must describe the actual build

Trials ran on 4 October UTC / 4–5 October local time. Raw host paths, logs and
job identities remain private. All results below are source/reference-host
evidence; no complete new Android image, combined guest or tablet was accepted.

## REC-COMP001: output presence is insufficient evidence of compilation

- **Lesson ID:** REC-COMP001
- **Date:** 2026-10-05
- **Environment scope:** OrangeFox host build, packaging and publication
- **Evidence class:** Source changes, actual compiler fixtures and production refusal controls
- **Status:** AUD-024 source/host contract corrected; complete image acceptance pending
- **Question or previous assumption:** Matching staged sources and an existing ELF established that it had been rebuilt from the current inputs.
- **Finding:** Every new job now owns fresh output. Content indexes include ignored/untracked/staged source and prebuilts, modes, links and source timestamps; all 399 locked project revisions/tree identities are verified. Selected installed host tools/direct ELF runtimes are recorded. Compilation uses readonly sources and a cleared, fixed environment. Before/after differences refuse sealing. Readonly receipts bind image, payload, installed products and generated build configuration; extracted-image audits compare the entire payload. New manifests derive compile status from accepted completion evidence.
- **Evidence:** Final input manifest SHA-256 `5cb2b95a823a9886b5d3a649be13275e80d1c1b7e968ac0a42de71162d9fe637`; real pinned-Clang ARM64 compilation and changed-header rebuild produced different ELF hashes. Unrebuilt headers/timestamps, real Git-ignored inputs, changed modes/pins/toolchains/ELFs, escaping links, receipt corruption, missing service records and wrong evidence classes refused. Existing unreceipted recovery output refused production verifier, image audit and packaging before destination publication; its image bytes remained unchanged. Host-fixture receipts cannot pass the Android-recovery class.
- **Practical consequence:** Old outputs remain useful as historical diagnostics but cannot be presented as fresh compile evidence. Packaging needs a fresh accepted build; the public alpha and sealed historical candidates remain unchanged.
- **Remaining uncertainty:** Selected direct host dependencies are not a hermetic OS closure; before/after checks assume cooperating host automation. Content receipts do not provide binary reproducibility, a cryptographic trust root or protection from a compromised host account.
- **Next validation:** After ordered P1 source changes, perform clean/warm complete image builds, extracted-payload audits and matching combined functional/visual VM testing. Authenticate update manifests separately in AUD-035.
- **Supersedes:** AUD-024's previous hardcoded compile claim for new candidates; historical manifests remain historical.

## REC-COMP002: worker publication and successful service exit differ

- **Lesson ID:** REC-COMP002
- **Date:** 2026-10-05
- **Environment scope:** Owned host service and atomic directory publication
- **Evidence class:** Actual directory/termination fixtures and controller contract
- **Status:** Completion acceptance tightened after final review
- **Question or previous assumption:** A worker's final publication marker established that the enclosing service completed successfully.
- **Finding:** The worker checks command status and OOM deltas, then atomically publishes the fresh directory. It does not acknowledge service success. Only the outer controller, after successful systemd-run and matching command status, adds the final readonly completion record. Lost controllers and late worker termination cannot self-acknowledge. Linux directory exchange retains the previous complete output without an absent-output interval; directory-sync failure leaves completion unaccepted.
- **Evidence:** Forty real exchanges with a concurrent observer reported no missing output. Existing destinations, symlinks and cross-filesystem exchanges refused. An intentionally SIGKILLed isolated compiler child left partial output and no seal/publication; actual compiler failure also refused. Missing acknowledgment, false controller confirmation, nonzero service status and OOM metadata negative controls passed. These intentional child terminations are distinct from the owner's earlier unexplained application shutdowns.
- **Practical consequence:** A visible new output can still be unaccepted. Verification requires matching input/product evidence and a successful enclosing service acknowledgment.
- **Remaining uncertainty:** This is a cooperating-host contract, not physical power-loss durability or adversarial controller authentication. A forced host restart between publication and acknowledgment can require manual review; no automatic completion recovery is claimed.
- **Next validation:** Preserve these refusal controls and measure the real complete build service, then bind the exact package/guest receipts.

## REC-COMP003: full content closure has measurable cache and I/O costs

- **Lesson ID:** REC-COMP003
- **Date:** 2026-10-05
- **Environment scope:** Complete Android source inventory on the reference Btrfs host
- **Evidence class:** Two actual source scans and cgroup/process measurements
- **Status:** Measured inventory, bounded sorts and preserved oracle corrections
- **Question or previous assumption:** Bounded scanner RSS established low total memory cost.
- **Finding:** Both inventories matched across 811,108 regular files. File manifest SHA-256 is `5c25e900007f5ea72a585c26bb4043e38d12dc7a05772f7a1f42015c05b3e16e`; layout SHA-256 is `0231469a545bc75aeb14f28eb6dd1619c2dad165b96e618abb0b0f2c9d34b145`. Source metadata parsing is streaming; both sort buffers are capped at 64 MiB with one worker and admitted disk spill. The final run took 2:43.84 with 66,816 KiB maximum command RSS, but its cgroup peak was 12,248,391,680 bytes. Final charged file cache was 12,066,119,680 bytes, anonymous memory 679,936 bytes and shmem zero. Memory-high throttling occurred 100,665 times; max/OOM/kill counters were zero. Final memory PSI avg10/avg60/avg300 was 0.00/0.22/0.16.
- **Evidence:** Private frozen controls and actual source-index/service records. The preceding scan took 2:56.93 with 229,232 KiB maximum RSS and 11,777,523,712 charged peak bytes, under different sort/cache conditions. Its indexes were byte-identical to the final bounded scan. Actual 399-project revision manifest SHA-256 is `f7f693b45fdac51a04de9ea6d3dc374c015279fe84ea5e4e990a7291e4c0d385`.
- **Practical consequence:** Measure scanner RSS, charged cache, throttling and PSI separately. Do not infer desktop responsiveness or full-image build safety from a successful index, or attribute the two scan timings solely to the sort limit.
- **Remaining uncertainty:** Cache state, aggregate filesystem work and pressure differ between trials; this does not identify the earlier task shutdown cause. Full inventories intentionally add I/O; equivalent immutable snapshots could reduce repeated work only with their own closure validation.
- **Next validation:** Complete-image clean/warm measurements and desktop response after the source corrections.
- **Superseding corrections:** The first fixture attempted to reseal a previously refused job; production correctly refused, and the test was changed to create a fresh job. An earlier corruption test masked subsequent link refusal checks, so corruption moved last without resealing. A later oracle expected stdout `FAILED`, while checksum refusal appeared on stderr; the oracle was corrected to the actual checksum warning on a valid JSON/readonly record. Preserved failures are not counted as passing receipts.
