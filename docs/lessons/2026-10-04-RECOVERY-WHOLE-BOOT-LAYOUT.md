# 2026-10-04: Separate payload restoration from complete boot layout matching

- **Lesson ID:** REC-BL001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox / Global OS3 stock source programming
- **Evidence class:** Pinned primary source, native host and independent catalog
- **Status:** Prefix versus complete layout semantics corrected
- **Question or previous assumption:** Does writing the approved DTBO source
  prove that the destination's complete boot programming layout is correct?
- **Finding:** The reviewed source has 20 MiB and its partition has 24 MiB.
  The canonical whole layout includes the exact original source, a zero gap and
  a duplicate 64-byte AVB footer at the partition end. Prefix restoration can
  correctly preserve an arbitrary tail and still fail the whole-layout check.
  A preserved tail that was already canonical can match after a prefix job;
  that match does not establish which operation originally produced the tail.
- **Evidence:** AOSP system/core revision
  `1efa79514b2f520c20a837c9216ff6b6e7e0dda3`, `copy_avb_footer`, the independent
  stock programming catalog, and compiled source/partition SHA-256 pins.
  Final image job and read-only inspection report per-selected-boot whole-layout
  results separately from programmed-range verification. Both keep Android
  boot compatibility and physical acceptance false.
- **Practical consequence:** Do not treat `complete_stock_image_job` or a
  payload-range digest as an accepted Android boot chain. No selected boot
  payload produces a false aggregate rather than vacuous layout success.
- **Remaining uncertainty:** These layouts are source-derived and do not
  accept the owner's OS2 firmware, UFS geometry or installed trust chain.
- **Next validation:** Fresh target and combined guest after ordered P1 work;
  separately review complete physical byte evidence and a rehearsed fallback.
- **Supersedes / superseded by:** Refines REC-S002's preserved-tail behavior;
  no old prefix journal is reinterpreted as a whole-partition job.

---

- **Lesson ID:** REC-BL002
- **Date:** 2026-10-04
- **Environment scope:** Native regular-image stock writer and OrangeFox callbacks
- **Evidence class:** Source, native/pinned Clang sanitizer fixtures and CLI
- **Status:** Explicit reviewed whole boot programming implemented
- **Question or previous assumption:** How can the exact canonical DTBO tail
  be restored without introducing a generic partition-tail erase policy?
- **Finding:** A captured `boot_payload_layout` defaults to `preserve-tail`.
  `reviewed-whole-partition` applies only to the five compiled boot payloads,
  with their exact Global source hashes and partition capacities. Streaming
  uses 64 KiB buffers, a private fresh single-link replacement, raw whole SHA-256
  and logical-tree readback. The complete original 24 MiB is mirrored for
  rollback; the conservative DTBO journal estimate increases by 8 MiB. vbmeta,
  super, metadata, userdata, other tails and unselected boot slots are unaffected
  by the additional policy. Raw mirrors are checked against compiled source or
  whole-layout pins before offline recovery effects, not just a resealed plan's
  supplied tree digest.
- **Evidence:** Three focused native CTest controls passed in 58.90 seconds and
  three pinned Clang ASan/UBSan/leak controls passed in 156.66 seconds. Actual
  GUI callbacks invalidate confirmation after a direct layout-choice change.
  Native and instrumented CLI controls passed prefix/whole selection, JSON
  results, option/confirmation refusal and source-independent inspection and
  rollback. Subsequent footer/truncation fixture additions were verified
  separately; the exact input difference contains only that fixture source.
- **Practical consequence:** Review the destructive tail replacement explicitly.
  Existing schema-1 prefix plans remain compatible. Changing the selector never
  changes a retained journal's captured extent or programming interpretation.
- **Remaining uncertainty:** Full target rendering and combined VM acceptance
  remain pending. Android live writes remain unavailable; source pins do not
  authorize a block device or a different installed firmware scope.
- **Next validation:** Carry the captured choice and distinct result fields
  through fresh target/guest acceptance after all P1 source fixes.
- **Supersedes / superseded by:** Implements AUD-007; preserves default source
  prefix behavior while adding an explicitly selected exact-capacity alternative.

---

- **Lesson ID:** REC-BL003
- **Date:** 2026-10-04
- **Environment scope:** Disposable six-LUN images and host process interruption
- **Evidence class:** Independent byte/hash oracles and actual host SIGKILL
- **Status:** Tail inclusion and rollback controls passed
- **Question or previous assumption:** Does the new extent survive an interrupted
  writer and recover when the original source directory is unavailable?
- **Finding:** Fixtures preserve a noncanonical tail in prefix mode, require
  the exact canonical gap/footer in whole mode, and restore every original LUN's
  logical content on rollback. A child was killed after actual writes entered
  the former DTBO tail, with another selected payload keeping the writer alive
  for observation. Retained mirrors allowed offline inspection, resume and full
  rollback. The observation does not identify the exact physical sector or
  footer write boundary at which a tablet would reboot.
- **Evidence:** Complete six-LUN digest oracles, independent DTBO byte assembly,
  compiled ordinary whole SHA-256, selected-range/protected-range checks and
  native/instrumented fixtures. Controls reject damaged source/gap/final footer,
  missing or end-shifted footer, truncation, wrong profile/capacity/pins, reused
  replacement, source aliasing and unknown tail policies before unauthorized
  effects. The independent five-image catalog also passed.
- **Practical consequence:** Include every byte newly admitted for programming
  in original mirrors, checkpoint coverage, protection complements and rollback.
- **Remaining uncertainty:** Host SIGKILL is not tablet forced-reboot durability
  or six-LUN atomicity. No device or host block storage was accessed.
- **Next validation:** Generic guest acceptance, then separately authorized
  physical forced-restart tests only for an accepted unit and fallback profile.
- **Supersedes / superseded by:** Adds full-tail recovery controls without
  claiming resolution of the later AUD-008 write-frontier P2 finding.

---

- **Lesson ID:** REC-BL004
- **Date:** 2026-10-04
- **Environment scope:** Host build environment and fixture scaffolding
- **Evidence class:** Captured failed compiler/CTest output and corrected reruns
- **Status:** Invocation and bounded fixture-read mistakes corrected
- **Question or previous assumption:** Were the initial failures product defects
  or a reason to relax production read and cache requirements?
- **Finding:** The first build invocation omitted the required `CCACHE_DIR` and
  the launcher refused without running the compiler. It was rerun with the
  configured host cache. The first independent DTBO oracle attempted one 24 MiB
  production read, exceeding the helper's 4 MiB bound; that control failed in
  1.98 seconds while the stock job and GUI controls passed. The oracle now
  compares in 64 KiB pieces. Production read bounds were retained.
- **Evidence:** Initial console refusals and final private native, sanitizer,
  CLI and catalog logs. Separate frozen input manifests distinguish the full
  three-control runs from the later explicit missing/shifted-footer and truncation
  fixture enrichment, which passed native in 2.42 seconds and instrumented in
  2.79 seconds. Final frozen inputs have manifest SHA-256
  `1031a579224e94c27fb666c057b9e3c9850b5b840f13ba74defd479734db4696`.
  No full release receipt is inferred from focused checks.
- **Practical consequence:** Establish launcher prerequisites explicitly; make
  independent oracles respect bounded I/O instead of weakening runtime limits.
- **Remaining uncertainty:** These trials do not diagnose the user's earlier
  application crashes or establish a 16 GiB aggregate host resource policy.
- **Next validation:** Address the ordered host resource findings in AUD-022–023
  and fresh release input/evidence closure in AUD-024–025.
- **Supersedes / superseded by:** Preserves failed trials with their narrow causes
  rather than misclassifying them as device or memory-pressure failures.
