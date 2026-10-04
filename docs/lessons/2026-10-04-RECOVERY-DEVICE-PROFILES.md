# 2026-10-04: Exact device scope before live storage admission

- **Lesson ID:** REC-U001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox / stock Android inventory / firmware source catalog
- **Evidence class:** Existing own-device read-only stock record and source comparison
- **Status:** Profile distinction recorded; physical geometry remains unavailable
- **Question or previous assumption:** Does a Uke label or a reviewed Global OS3
  archive accept the owner's installed POCO Pad X1?
- **Finding:** `STOCK-ADB-20261003-01` observes POCO Pad X1 `25099RP08G`,
  `uke_p_global`, `ukepgl`/`cliffs` and Global `OS2.0.205.0.VOZMIXM`. Protected
  stock geometry reads did not obtain full capacities, sectors, original GUIDs
  or both complete GPT copies. Mounted `/data` capacity and owner-declared
  storage capacity cannot substitute for those measurements. Global OS3.0.303.0
  and CN OS3.0.302.0 remain source-package scopes, not accepted installed units.
- **Evidence:** Reviewed stock inventory and component firmware/boot catalogs.
  This continuation performed no additional ADB, tablet or block-device access.
- **Practical consequence:** Keep Pad 7 and POCO Pad X1 commercial/SKU/capacity
  acceptance separate. Do not transfer Nabu geometry or another unit's GUIDs.
- **Remaining uncertainty:** Complete stock primary/backup GPT, both boot stacks
  and an independently rehearsed fallback remain unverified for the specimen.
- **Next validation:** Independently reviewed read-only physical geometry and
  whole-partition evidence per commercial/SKU/firmware configuration.
- **Supersedes / superseded by:** Implements AUD-006's profile boundary while
  preserving the inventory's explicit denied/uncollected classifications.

---

- **Lesson ID:** REC-U002
- **Date:** 2026-10-04
- **Environment scope:** Native host profile-declaration comparator and Android policy
- **Evidence class:** Source, native/pinned Clang sanitizer fixtures and JSON CLI
- **Status:** Exact declaration validation implemented; live authority closed
- **Question or previous assumption:** What complete evidence contract must
  match without allowing a supplied JSON record to authorize a device write?
- **Finding:** The bounded comparator requires exact commercial/product/SKU and
  installed firmware identities, all six LUN capacities/sectors, complete GPT
  partition ranges/types/attributes, unit original disk/partition GUID backups,
  both GPT record hashes and both whole-partition boot/recovery stacks. It rejects
  incomplete, overlapping, excessive, duplicate, foreign-unit and wrong-profile
  declarations. A prefix hash cannot represent a full programmed partition.
  Matching declarations still report no accepted profile, no live plan and no
  physical result. Android refuses imported comparison before reading paths.
- **Evidence:** Three focused CTest controls passed native in 0.61 seconds and
  pinned Clang ASan/UBSan/leak checks in 2.58 seconds. Native and sanitized JSON
  scripts passed current/synthetic root, unrelated options and unopened FIFO
  controls. The host Android-property ABI test deliberately supplies plausible
  properties and proves that they cannot enable acceptance.
- **Practical consequence:** Use declaration matching as a contract fixture,
  never as provenance, GPT CRC, raw-byte verification or hardware collection.
  The compiled live registry remains empty and cannot be populated by options,
  JSON or environment variables.
- **Remaining uncertainty:** A native physical collector must use retained,
  revalidated read-only kernel descriptors and independently verify GPT/backup
  bytes and accepted release pins. Its device backend is not implemented or
  accepted by these synthetic declarations.
- **Next validation:** Fresh target and combined guest after ordered P1 work;
  separately review any proposed unit profile against physical evidence.
- **Supersedes / superseded by:** Adds AUD-006's bounded native contract while
  preserving the live-block refusal and unit privacy boundaries.

---

- **Lesson ID:** REC-U003
- **Date:** 2026-10-04
- **Environment scope:** Live storage preflight diagnostics and admission ordering
- **Evidence class:** Source and affected host policy checks
- **Status:** Premature firmware inference and unnecessary reads corrected
- **Question or previous assumption:** Can matching Global package boot hashes
  alone establish installed identity on an otherwise unaccepted commercial unit?
- **Finding:** The earlier preflight could set its firmware identity flag after
  the Global boot-stack loop without complete model/SKU/geometry acceptance.
  The writer remained blocked, but that diagnostic inference was too broad.
  Preflight now adds exact unit-profile blockers and returns before complete
  boot-media hashing when the registry has no accepted scope. Current recovery
  property observations explicitly do not prove installed Android firmware.
- **Evidence:** `device_profile_admission_status`, `storage_preflight`, public
  capability reason codes and the existing management policy regression.
- **Practical consequence:** Order acceptance before expensive whole-media
  reads; do not repeatedly hash gigabytes for an already unaccepted plan.
- **Remaining uncertainty:** No timing benchmark or physical boot-stack result
  was acquired. This ordering does not accept a native physical writer.
- **Next validation:** Measure an accepted collector only after its unit scope
  and fallback/transaction prerequisites have independent evidence.
- **Supersedes / superseded by:** Narrows the old preflight's firmware-identity
  diagnostic without changing its existing final live-write refusal.

---

- **Lesson ID:** REC-U004
- **Date:** 2026-10-04
- **Environment scope:** Focused fixture builds and exact final source identity
- **Evidence class:** Private compiler/CTest logs and frozen-input comparisons
- **Status:** Scaffolding and mixed-revision trials corrected and preserved
- **Question or previous assumption:** Did an intermediate successful control
  apply to the final source, and was a numeric zero compared semantically?
- **Finding:** The first new CMake test lacked its library header include path.
  A later fixture compared JsonCpp UInt64 zero with a signed literal and
  falsely reported an authority failure. It now checks numeric value and
  distinguishes declaration mismatch from authority refusal. Another sanitizer
  build had already compiled the validator when the cross disk/partition GUID
  control was added, so that mixed-revision trial correctly lacked the new
  rejection. Final builds began after source freeze and passed; both final
  commands checked that all recorded inputs stayed byte-identical.
- **Evidence:** Private `profile-test-include-failed.log`,
  `profile-test-zero-type-failed.log`, `profile-mixed-revision-sanitizer-failed.log`
  and final native/sanitizer/CLI logs. These are source/host receipts, not target,
  release or combined guest acceptance.
- **Practical consequence:** Freeze relevant sources before parallel builds,
  retain failed trials and avoid conflating fixture numeric types or stale
  objects with a production security result.
- **Remaining uncertainty:** Fresh Android target compilation and combined VM
  acceptance remain later ordered stages; the physical profile registry is empty.
- **Next validation:** Preserve a focused local commit and move to AUD-007.
- **Supersedes / superseded by:** Supersedes intermediate fixture assumptions,
  preserving their failures and the final evidence boundary.
