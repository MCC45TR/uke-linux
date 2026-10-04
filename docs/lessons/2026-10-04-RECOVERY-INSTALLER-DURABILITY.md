# 2026-10-04: Recovery installer durability and interruption boundaries

- **Lesson ID:** REC-I001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox legacy installer and native image transaction model
- **Evidence class:** Source and disposable host-image fixtures; no device write
- **Status:** Volatile writer removed; focused native/sanitizer acceptance passed
- **Question or previous assumption:** Does a verified backup in recovery `/tmp`
  survive a forced restart while the active recovery is being replaced?
- **Finding:** It does not. The old raw-copy writer and RAM-disk backup were
  removed entirely. The standalone install mode refuses before any file open,
  child process or device ioctl, even if a future common policy were changed.
  Read-only pinned-catalog inspection remains available. A separate native
  image model binds exact 100 MiB active/inactive/staged objects, opposite fixture
  slots, immutable fallback content, profile declaration and the reviewed image.
- **Evidence:** `installer.cpp`, new `libuke/installer_job.cpp`, prepared
  replacement backup adapter, exact production installer admission fixture and
  `ure-durable-recovery-image-install`. The final focused native set passed
  5/5 in 70.39 seconds and pinned Clang ASan/UBSan/leak checks passed 5/5 in
  99.97 seconds. Native JSON CLI exposes only explicitly
  named image preparation/execution/inspection/recovery operations.
- **Practical consequence:** Keep verified old and proposed chunks in a local
  persistent journal before effects, with source-independent resume/rollback.
  Admit only writable ext4/Btrfs/F2FS/XFS with synchronization support; refuse
  RAM, overlay and unknown filesystem semantics. Record recovery bytes as
  `reviewed-recovery-image`, not as a filesystem transformation.
- **Remaining uncertainty:** Requested filesystem synchronization is not proof
  of device controller persistence, a host acknowledgement or a physical stock
  fallback. The legacy live installer remains explicitly unavailable.
- **Next validation:** Common
  ownership in AUD-005 and combined fresh-target/VM acceptance after all P1 work.
- **Supersedes / superseded by:** Supersedes AUD-004's volatile source path;
  preserves the original audit and unaccepted physical installation gate.

---

- **Lesson ID:** REC-I002
- **Date:** 2026-10-04
- **Environment scope:** Initial wrapper/raw/mirror journal publication
- **Evidence class:** Independent read-only review and actual host SIGKILL fixtures
- **Status:** Pre-write interruption defects corrected in source
- **Question or previous assumption:** Would atomic first publication alone
  make every interrupted preparation resumable?
- **Finding:** Atomic publication prevents partial final JSON, but leaves private
  unpublished artifacts after SIGKILL. A newly created raw directory can also
  lack its initial plan or state. The first candidate treated that directory as
  initialized, and mirror creation rejected legitimate unpublished records.
  The corrected installer verifies complete original target bytes before any
  initialization recovery. It retains incomplete raw preparation in an archival
  directory before rebuilding, recognizes bounded private publication artifacts,
  and rejects conflicting plans or foreign files. Safe cancellation is based on
  original bytes and an eligible nonterminal phase, including durable execution
  intent recorded immediately before the first actual write.
- **Evidence:** `Root::save_record` now uses private temporary write/file fsync,
  `RENAME_NOREPLACE` and directory fsync. Fixtures terminate the actual creator
  during standalone, wrapper, raw-plan, raw-state, before-mirror and after-mirror
  first publication, as well as before and during target writes.
- **Practical consequence:** Preserve interrupted records rather than deleting
  them or trusting progress counters. Newly published plans remain no-replace.
- **Remaining uncertainty:** Cooperative global ownership is still AUD-005;
  these records cannot exclude arbitrary root writers or prove cross-boot device
  identity without installed-profile evidence.
- **Next validation:** Guest restart
  cases against the fresh target build.
- **Supersedes / superseded by:** Corrects the initial AUD-004 candidate review
  findings without erasing the failed trials.

---

- **Lesson ID:** REC-I003
- **Date:** 2026-10-04
- **Environment scope:** Shared raw restore completion, including installer reuse
- **Evidence class:** Independent source review and target-fsync fault injection
- **Status:** Readback-only completion defect corrected
- **Question or previous assumption:** Can a resumed job skip target fsync when
  all desired bytes already read back correctly?
- **Finding:** Those bytes can still be dirty page-cache content after a failed
  flush or forced termination. The original raw backend synchronized only newly
  written chunks. It could therefore skip every write and publish completion
  without retrying target synchronization. Completion now unconditionally checks
  target fsync before final full readback and terminal publication, for both
  forward restore and rollback. A repeatedly failed no-rewrite flush remains
  `FAILED_UNCERTAIN`; successful recovery performs one flush with zero rewrites.
- **Evidence:** Corrected `run_restore`, last-chunk and repeated target-sync
  injection in `tests/ure/installer_job.cpp`, independent complete-byte oracles,
  and the existing raw/stream restore regression executables.
- **Practical consequence:** Hash/readback evidence supplements synchronization;
  it cannot replace it. Never classify a failed flush as durable completion.
- **Remaining uncertainty:** Filesystem and controller flush guarantees on a
  physical unit still require separate acceptance.
- **Next validation:** Generic-guest
  interruption/cleanup receipts; retain physical durability as unaccepted.
- **Supersedes / superseded by:** Corrects the shared raw backend behavior
  exposed while implementing AUD-004.

---

- **Lesson ID:** REC-I004
- **Date:** 2026-10-04
- **Environment scope:** Wrapper/raw plan and retained-directory binding
- **Evidence class:** Source review and adverse fixture controls
- **Status:** Diagnostic and pathname binding corrected
- **Question or previous assumption:** Does a valid raw journal automatically
  belong to the wrapper that inspects it?
- **Finding:** Another independently valid raw journal for the same target inode
  can describe a different replacement. Inspection now verifies the exact nested
  restore digest before adding the wrapper receipt. Raw creation also uses the
  retained wrapper directory descriptor, with pathname identity checks before
  delegation and outcome publication. Replacing the wrapper pathname before raw
  creation refuses before target effects.
- **Evidence:** Same-cycle independent candidate review; foreign valid raw
  journal and wrapper-directory replacement controls. Initial plan/outcome shape
  checks reject non-object and nonnumeric nested inputs before conversions.
- **Practical consequence:** Preserve exact operation/plan/directory identity
  through recovery and diagnostics; a valid unrelated journal is insufficient.
- **Remaining uncertainty:** Root-level adversarial changes remain outside a
  cooperative coordinator's authority. Common lifetime admission is AUD-005.
- **Next validation:** Integrate the
  shared ownership boundary before whole-workflow acceptance.
- **Supersedes / superseded by:** Corrects the candidate's mixed inspection and
  fresh-path raw creation gaps.

---

- **Lesson ID:** REC-I005
- **Date:** 2026-10-04
- **Environment scope:** Focused host build/test execution and failed trials
- **Evidence class:** Private compiler/CTest logs and corrected fixture source
- **Status:** Reproducible corrections recorded
- **Question or previous assumption:** Did passing the first trial establish the
  final source, and were identity numeric types preserved by JSON parsing?
- **Finding:** The first build attempt lacked the compiler launcher's required
  cache directory environment and failed before compilation. A later native
  trial exposed strict JsonCpp signed/unsigned equality for parsed inode values;
  descriptor identities now compare canonical JSON representation. Another trial
  correctly classified untouched execution intent as original but exposed the
  cancellation admission gap described in REC-I002. The corrected complete
  native installer model passed in 154.06 seconds before final input-shape and
  oracle changes. That intermediate result is not the final-source receipt.
- **Evidence:** Ignored `build/p1/installer-*` logs. Compiles use two workers and
  content-checked host ccache. Independent byte validation now compares bounded
  read buffers against known content with `memcmp`, preserving complete-byte
  coverage while avoiding per-byte debug iterator overhead.
- **Further correction:** The first final sanitizer trial exceeded 300 seconds
  without a reported memory defect. Shared raw inspection compared all matching
  byte buffers with scalar C++ loops. The corrected backend compares complete
  buffers first and inspects bytes only inside a genuinely mixed segment; it
  still hashes and reads every byte. Final installer checks took 58.54 seconds
  native and 62.92 seconds sanitized. Existing partial-byte and unrelated-byte
  divergence controls passed. Timing is focused host evidence, not a universal
  performance guarantee or a diagnosis of the user's application shutdown.
- **Practical consequence:** Export required cache configuration, preserve failed
  trials and rerun affected checks after actual source/test changes. Do not infer
  full native, shipping, VM or physical acceptance from a focused intermediate
  result.
- **Remaining uncertainty:** The user's earlier application/task shutdown cause
  remains unestablished; accessible current cgroup OOM counters are not evidence
  about a different earlier process or cgroup.
- **Next validation:** Preserve the verified source in a focused local commit
  and move to AUD-005; run fresh target and combined VM acceptance afterward.
- **Supersedes / superseded by:** Supersedes intermediate trial assumptions only;
  preserves the source and review findings above.
