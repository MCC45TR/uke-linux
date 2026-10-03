# 2026-10-03: one-shot request retirement and interruption boundaries

## REC-B001: a journal-local attempt limit does not prevent cross-journal replay

- **Lesson ID:** REC-B001
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox native boot manager / private EFI regular-file fixtures
- **Evidence class:** source / reference-host failure reproduction and corrected tests
- **Status:** corrected
- **Question or previous assumption:** Does `max_attempts=1` in a private journal prevent reuse of the same saved plan after its owner is released?
- **Finding:** The initial implementation rejected repeated consumption inside one journal but accepted the exact same cancelled plan through a second journal. A CLI probe reproduced a second `ARMED` result. The corrected terminal path retains a private request-ID/plan-hash retirement record before releasing ownership. Execution rejects that ID before creating another journal or `BootNext`; a fresh attempt requires a new reviewed plan.
- **Evidence:** Initial boot_router.cpp SHA-256 `53ce50999021cdbe20d5f9432288ba5f21960aaabbb437efb4658c7de2f4dd4b`, baseline native input-manifest SHA-256 `f4a106b984d32ed5ac2a2337b26fad192393dafdb2076e70f0cf63f4b01aeb10` and baseline host CLI SHA-256 `ad7cce36f0ec2bf68da58d1f019ca45383ebff6a6b20afa3d269e5074e8b60d3`. The probe performed plan → execute → cancel → execute with a second journal on disposable files. Corrected [native fixtures](../../recovery-uke-ofox/tests/ure/boot_router.cpp) cover retirement after success, failure/fallback, cancellation and interrupted/unknown fallback; the [actual JSON CLI fixture](../../recovery-uke-ofox/tests/check-boot-router.sh) checks cross-journal refusal. Both targeted CTests and the CLI fixture passed after correction.
- **Practical consequence:** Enforce request lifetime at the shared variable-store boundary, not only inside an operation journal. Keep retirement records with that store. Confirming the old hash is not authorization to replay a retired ID.
- **Remaining uncertainty:** Deleting/rolling back the fixture store defeats its history; these unsigned records do not resist a malicious administrator. No real EFI store, loader execution or tablet boot was tested.
- **Next validation:** Bind full native/sanitizer and extracted ARM64 results to the corrected source, then design an accepted Uke/Aloha persistent-request backend separately.
- **Supersedes / superseded by:** Supersedes the prototype's broader replay-prevention assumption; within-journal single-consumption evidence remains valid at its original scope.

## REC-B002: new JSON records need atomic publication as well as fsync

- **Lesson ID:** REC-B002
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox native retirement record / host ptrace and SIGKILL fixture
- **Evidence class:** source / failed and corrected reference-host interruption tests
- **Status:** corrected
- **Question or previous assumption:** Is direct creation followed by file/directory fsync sufficient to expose a recoverable retirement record at every process-death boundary?
- **Finding:** The first retirement trial failed with `Malformed, duplicated or excessive JSON` when the child was killed after the final record name appeared. `Root::save_record` creates a new final file before writing it; replacing an existing record uses a different atomic path. The correction first writes/syncs a private temporary record, then publishes it with `renameat2(RENAME_NOREPLACE)` and syncs the directory before removing ownership. Recovery validates a completed existing retirement record and finalizes owner release.
- **Evidence:** Failed-trial boot_router.cpp SHA-256 `84c8065298e7bd33b3decae4a90218bc126382daf0ab0e03c0b41fbd5355ba94`; corresponding test-body SHA-256 `cc8d7ccfc4a891c7f3e968ee401ebbb23da320dcb6c20a3f18bf4fda11d928b9`. The targeted one-shot CTest failed while the actual GUI callback CTest passed. The corrected [implementation](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/boot_router.cpp) and [syscall-boundary fixture](../../recovery-uke-ofox/tests/ure/boot_router.cpp) subsequently passed both targeted CTests and the JSON CLI gate. The fixture kills the actual process with SIGKILL after publication but before owner removal, recovers the retained cancellation and refuses a second journal.
- **Practical consequence:** Distinguish new-record creation from atomic replacement. Keep ownership until the retirement record is durably published, refuse replacement of another record and retain incomplete private temporary files for inspection rather than weakening corruption checks.
- **Remaining uncertainty:** Host SIGKILL preserves the host kernel/page cache. It is not electrical power loss, UFS persistence, a tablet reset or real firmware-variable behavior. A damaged final retirement record intentionally blocks release pending inspection.
- **Next validation:** Complete the pinned sanitizer and ARM64 build/execution gates. Accept a real backend only after its filesystem/variable-store crash guarantees and exact-device forced-reboot behavior are measured.
- **Supersedes / superseded by:** Corrects the direct-create retirement trial; does not change the generic record API or reinterpret earlier raw/GPT transaction evidence.

## REC-B003: consumed requests and missing variables are observations, not boot results

- **Lesson ID:** REC-B003
- **Date:** 2026-10-03
- **Environment scope:** UEFI contract research / OrangeFox fixture routing and GUI
- **Evidence class:** primary specification / source / reference-host tests
- **Status:** documented finding
- **Question or previous assumption:** Can a disappearing `BootNext`, valid AArch64 loader header or declared Uke profile establish successful or failed OS boot?
- **Finding:** No. UEFI's one-shot ordering removes `BootNext` before handing control to its option, then returns to the ordinary default sequence. The fixture records an interrupted handoff or unexplained missing variable as `UNKNOWN` and never automatically repeats it. Acknowledgements match the request, single attempt, private handoff token and loader hash, but always keep physical success false. Declared model/firmware and EFI path labels remain unverified context.
- **Evidence:** [UEFI 2.11 §3.1.2](https://uefi.org/specs/UEFI/2.11/03_Boot_Manager.html#load-option-processing), reviewed on 3 October 2026; [bounded routing contract](../../recovery-uke-ofox/docs/BOOT-ROUTING.md), native wrong-target/path/architecture/reserved-attribute fixtures and [actual OrangeFox callbacks](../../recovery-uke-ofox/tests/ure/boot_gui.cpp). The native parser admits a restricted GPT/file-path/ASCII subset and rejects reserved load-option attribute bits; it is not a full UEFI conformance validator.
- **Practical consequence:** Preserve the exact default and refuse foreign request ownership even when `BootNext` bytes match. Treat loader shape/checksum, GUI review, fixture receipt and actual OS/device acceptance as separate evidence.
- **Remaining uncertainty:** Mounted ESP block identity, root/kernel/DT/ABI/signature closure, firmware runtime writes, Aloha Uke support, Android return, Windows boot and either commercial model's physical behavior remain open.
- **Next validation:** Develop source-reviewed Aloha routing and a trusted OS acknowledgement channel only after the independent boot/kernel/storage prerequisites are accepted.
- **Supersedes / superseded by:** No physical support record is superseded; `DEVICE-STATUS.md` remains governed by separate device evidence.

## REC-B004: persisted JSON identity must survive its numeric representation

- **Lesson ID:** REC-B004
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox native boot request / host fixtures and ARM64 build
- **Evidence class:** source / failed and corrected host tests / build
- **Status:** corrected
- **Question or previous assumption:** Can raw JsonCpp value equality compare a descriptor identity before and after a saved-plan round trip?
- **Finding:** An unchanged fixture failed with `stale-boot-context` because positive integer fields had different signed/unsigned JsonCpp representations after parsing. Comparing the canonical serialized identity preserves the complete field values while surviving the round trip. Separate phase checks also make a repeated acknowledgement fail as an invalid transition before checking the already released owner.
- **Evidence:** Private `boot-router-test.log` and `boot-router-test-retry.log`; corrected native boot-router and actual GUI callback tests. Initial compilation separately exposed missing standard headers, misleading loop indentation and unused boot helpers in other generated callback fixtures; those were corrected without relaxing warnings as errors. All 23 current CTests subsequently passed pinned address/undefined/leak instrumentation in 462.05 seconds. The stock-kernel ARM64 recovery build completed in 4:23.
- **Practical consequence:** Bind persisted identity by canonical content and keep explicit transition validation. Instrumentation, callback execution, CLI execution and final payload auditing retain separate receipts.
- **Remaining uncertainty:** The sanitizer runtime still excludes vptr instrumentation as previously documented. Build and host tests do not establish real firmware writes, OS acknowledgement trust or physical routing.
- **Next validation:** Audit the final compressed ramdisk, execute its exact CLI under emulation and record isolated generic-kernel VM trials against that binary.
- **Supersedes / superseded by:** Corrects the in-memory equality assumption; no device result is superseded.
