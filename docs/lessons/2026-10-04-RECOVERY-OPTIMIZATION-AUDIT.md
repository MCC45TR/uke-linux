# 2026-10-04: Recovery audit findings and acceptance boundaries

- **Lesson ID:** REC-A001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox Uke source, existing host/package/generic-VM
  evidence and small isolated x86-64 probes; no physical device operations
- **Evidence class:** Source, host sanitizer reproduction and read-only packaging
  checks; earlier emulation results were reviewed, not rerun
- **Status:** Open findings documented; implementation and device acceptance pending
- **Question or previous assumption:** Did userdata-scoped URE jobs and read-only
  fstab entries establish safe behavior across all stock recovery paths? Which
  resource, performance and acceptance gaps should be fixed before further use?
- **Finding:** They do not establish a common mutation boundary. Stock Format
  Data can enter filesystem formatting without the URE installed-profile write
  contract. Two small sanitizer probes independently establish a malformed-UTF-8
  over-read and a host-only draft localization generator use-after-free. The
  host budget permits its job to consume an entire 16 GiB target machine's RAM,
  and the inner build namespace recreates RAM-backed temporary storage. These
  are source findings; they do not diagnose a previous OOM without its log.
- **Evidence:** Parent baseline
  `c8938d1c0b9431177b872b03d512f951d954f79c`; recovery baseline
  `6b5f3adfc44c2f46f132ef55670791f6cd010ab0`.
  The [dated component audit](../../recovery-uke-ofox/reports/URE-OPTIMIZATION-SECURITY-AUDIT-2026-10-04.md)
  records AUD-001–AUD-037 with source locations, confidence, consequence,
  proposed change and acceptance tests. The
  [host-probe receipt](../../recovery-uke-ofox/reports/URE-AUDIT-HOST-PROBES-2026-10-04.json)
  records exact compiler, source, input and private-log digests.
- **Practical consequence:** Close the shared mutation policy and text-memory
  defects before accepting device writes. Fix host headroom/temporary-storage
  policy before another clean build. Keep image-only, encrypted-userdata and
  firmware/profile refusals intact. Optimize redundant Btrfs reads, manifest
  serialization, hardlink hashing and monitor conversion only with equivalent
  integrity and independently measured resource results. Incomplete capabilities
  and unmeasured opportunities are not counted as reproduced failures.
- **Remaining uncertainty:** No full new build, shipping-kernel boot, real GPT
  writer, populated physical shrink, dock negotiation, sensor stream or complete
  all-language interface acceptance was performed. Three specialist reviews
  supplied partial inputs; this is not a claim of three completed audits or
  exhaustive upstream coverage. Existing receipts do not validate the new draft.
- **Next validation:** Apply the report's order: common native write gate and
  decoder/allocation/generator fixes; host/build provenance; persistent installer
  and ownership; populated failure fixtures; bounded jobs and performance;
  localization/UI closure; separate exact-model physical acceptance.
- **Supersedes / superseded by:** Qualifies any earlier wording implying that
  all stock recovery operations share URE preflight. It preserves the bounded
  positive results of REC-F001–REC-F014, REC-VM001–REC-VM027 and REC-W001.

## REC-A002: Text-decoder memory defect is independently reproducible

- **Environment / evidence:** Unchanged `utf8_to_unicode` function extracted
  from the pinned patched `truetype.cpp`; x86-64 C++20 with hash-verified AOSP
  clang-r547379, ASan/UBSan, vptr instrumentation and leak detection excluded.
- **Finding:** A two-byte allocation containing `0xf8,0x00` yields an ASan
  `heap-buffer-overflow`, one-byte read, exit 1. Source SHA-256 is
  `99fff5b1819b325d86a2bd992aeff1165c6219fc9d1d982c50887d770201b29a`.
  The private log SHA-256 is
  `c92fea92ba7f14d7e1cfb2dc667cceaed7486449eceb78c7019bdbdc3b727207`.
- **Consequence:** Bound input decoding and renderer advancement; inspect
  allocation failure and width/height arithmetic in the same path.
- **Uncertainty:** This isolates the actual decoder; it is not an end-to-end
  GUI, tablet crash or exploit demonstration.
- **Next validation:** Malformed Unicode corpus and allocator-failure renderer
  tests after the product patch, with valid filenames preserved byte-for-byte.

## REC-A003: Draft localization generation has a separate ownership failure

- **Environment / evidence:** Full draft `src/localization/catalog.cpp` built
  with the same pinned instrumentation and pinned JsonCpp sources. A one-entry
  public-text JSON catalog is passed to the `keys` subcommand.
- **Finding:** Range iteration over a member of a temporary parsed JSON value
  uses freed storage. ASan reports `heap-use-after-free`, a two-byte read, exit 1.
  Tool source SHA-256 is
  `cd3286477f5f6c37d96042c56afe21070d3bb26f0bded689383a37c6fc7879cc`;
  private log SHA-256 is
  `9c4ec0be33412b15d8ca3d2861c928a49531d1b99e81aeb56c12f60bdcc29fe7`.
  The current generated header contains only the Extra alias; the working
  catalog has 2,664 custom strings. The draft is not packaged or accepted.
- **Consequence:** Keep the JSON owner alive and verify complete generated-key
  closure before adopting this generator or its produced headers. Bind imports
  to current source/context and review destructive-operation wording.
- **Uncertainty:** The full 21,935,820-byte catalog trial exceeded its five-second
  deadline and is inconclusive. It is not an additional reproduced failure.
- **Next validation:** Empty/single/full catalog sanitizer tests, key count,
  collision and provenance negatives; all-language glyph/rendering acceptance.

## REC-A004: Toolchain preparation failures are not product test results

- **Environment / evidence:** Initial host GCC sanitizer link attempted before
  the existing project's sanitizer-toolchain procedure was applied.
- **Finding:** GCC could not link the absent `libasan.so.8.0.0`; the first UTF-8
  execution therefore had no linked test binary. No product conclusion is drawn
  from that attempt. Repeating with the existing clang-r547379 binary whose
  SHA-256 is `55d80d777d85327543868817fb836231691eae2e13030ab31a01a769a820bf2f`
  reproduced REC-A002 and REC-A003.
- **Consequence:** Use the established pinned sanitizer runtime rather than
  installing an ad hoc host package or treating compile failure as a test pass.
- **Uncertainty / next validation:** Only small host probes ran; the complete
  product and sanitizer suite must be rebuilt after the actual fixes.

## REC-A005: Both archived recovery-slot capacities pass; live geometry does not

- **Environment / evidence:** Read-only draft capacity checker, sealed
  `ure-vm-review-alpha` image and reviewed Global/CN OEM layout JSON files.
- **Finding:** The image is 104,857,600 bytes and fits recovery_a/recovery_b in
  both profiles. Its 38,817,792-byte aligned v4 payload leaves 65,970,176 bytes
  after a conservative 69,632-byte AVB reservation. Reducing recovery_b by one
  sector in copied profiles is refused with exit 1 and no success receipt.
  Checker SHA-256 is
  `bc0d2b7b73defcee5defbe22b945dda086f362a545dab24da17db645647eb077`;
  positive private receipt SHA-256 is
  `22e8b89fd619ef4258d7cb6094fa16ac23af5fc54cb82878f3f41b136a4758f5`.
- **Consequence:** This closes a reviewed-profile size calculation, not physical
  capacity or the next draft's image size. Keep both-slot checks in future
  publication with malformed-header and AVB-boundary negatives.
- **Uncertainty:** Owner stock inventory did not expose actual locked GPT/block
  extents. Localization fonts and modified GUI have not been rebuilt. The checker
  is not yet wired into packaging. No write authorization follows from this fit.
- **Next validation:** Integrate and test the checker, rebuild the candidate,
  repeat the packaged-image comparison, then independently read actual geometry
  through a separately accepted device path.

## REC-A006: Font aliases and existing receipts do not complete language support

- **Environment / evidence:** Character map of the staged static Roboto
  resource, SHA-256
  `06cba01eb71ea5cbd3a7df498910624db68953beead4be18fd91f8ec7dc72351`;
  packaging copies that same face over the recovery's TTF aliases.
- **Finding:** Required Arabic, Hebrew, Indic, Thai and CJK character blocks are
  absent. Existing 32 language XML files and matching font filenames do not
  establish readable multilingual interfaces. The unbuilt CJK face alone also
  does not establish all-script shaping, RTL, licensing or payload acceptance.
- **Consequence:** Track key, glyph, shaping, safety wording and visual/input
  closure independently. Invalidate current-input receipts when any new header,
  generated language or font changes.
- **Uncertainty / next validation:** Build a licensed, source-pinned bounded font
  set; test every language at 50–100 percent and both orientations, and recheck
  final image capacity. Do not label machine translations fully reviewed.
