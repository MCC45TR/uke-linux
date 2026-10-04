# 2026-10-04: Bounding recovery text processing

- **Lesson ID:** REC-T001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox Uke text decoder and isolated host fixtures
- **Evidence class:** Source, native host and pinned-Clang sanitizer; no device result
- **Status:** AUD-002 source remediation and focused host checks completed
- **Question or previous assumption:** Could a display decoder safely accept
  arbitrary filename bytes and application-generated truncated UTF-8?
- **Finding:** The original unchanged decoder reproduced a one-byte heap read
  beyond a two-byte allocation containing `f8 00`. Both drawing and width-fit
  callers used it. The new decoder takes an explicit end pointer, recognizes
  only valid one-to-four-byte scalar encodings, and consumes one original byte
  with U+FFFD for malformed input. It never rewrites filesystem names.
- **Evidence:** Reviewed patch `0022-bounded-utf8-text.patch`; the exact
  production function is extracted by `tests/generate-text-decoder.sh`.
  `ure-production-bounded-utf8` passed in 1.17 seconds. Pinned Clang r547379
  ASan/UBSan passed every valid Unicode scalar, each truncated prefix, every
  two-byte input and explicit overlong/surrogate/out-of-range/obsolete forms.
  Tiny allocations have no readable sentinel. A fresh read-only agent found
  no concrete surviving decoder bound or compatibility defect.
- **Practical consequence:** Keep the end pointer through both callers and
  bind the patch, source, declaration and extraction tool into native receipts.
  Byte-prefix cursor measurement and console truncation are legitimate reasons
  for malformed display input; they must not escape the bounded decoder.
- **Remaining uncertainty:** Raster allocation, glyph clipping and font/cache
  ownership remain AUD-003. Target compilation and actual shipping-renderer
  guest acceptance are pending the combined P1 validation. This host result
  does not establish device or all-language visual acceptance.
- **Next validation:** Resolve AUD-003 using the complete production renderer,
  including Uke's ordinary 270-degree rotation, then rebuild the target.
- **Supersedes / superseded by:** Supersedes AUD-002's unsafe decoder source
  state; preserves the original audit and other findings separately.

---

- **Lesson ID:** REC-T002
- **Date:** 2026-10-04
- **Environment scope:** Complete production minuitwrp renderer and pinned FreeType
- **Evidence class:** Source, native host and ASan/UBSan/leak fixtures
- **Status:** AUD-003 allocation, clipping and ownership remediation verified on host
- **Question or previous assumption:** Could clipping after width measurement
  bound raster allocation, and could font source size bound parser memory?
- **Finding:** Neither assumption held. Width measurement previously allocated
  the entire raster, integer dimensions were unchecked, caches were bounded only
  by an ineffective per-face equality check, scaled references leaked and Uke's
  ordinary 270-degree drawing allocated an unchecked second raster. The new
  measurement path does not rasterize. Checked glyph/text/rotation products,
  global cache accounting, source and font-instance limits, shared owned face
  generations, separate size objects and automatic cleanup bound those resources.
  FreeType uses a 64 MiB aggregate parser heap and 16 MiB single-allocation limit
  enforced before allocation, including compressed-font expansion.
- **Evidence:** Patch `0023-bounded-text-raster-and-cache.patch`, complete
  production `truetype.cpp`, actual extracted scale/rotation/wrap functions,
  `tests/ure/text_renderer.cpp` and `docs/TEXT-RENDERING-LIMITS.md`. Pinned
  FreeType revision `d968d2541f7158e18ab22680bfa08a538019bf6a` is built from C
  sources on the host without Python. The final two focused native tests passed
  in 2.29 seconds and pinned Clang sanitizer checks in 14.98 seconds. Their
  controls cover all scalar decoding, four rotations, negative bearings/pitch,
  a 256 MiB WOFF expansion declaration, pre-raster product refusal, cache churn,
  500 temporary scale draws, source replacement and concurrent reference use.
- **Practical consequence:** Enforce limits before copies, parsing and drawing;
  make measurement cheap in memory and retain raw filesystem bytes. Explicitly
  enable exceptions in minuitwrp to catch bounded string/map allocation failures.
  A fixed stderr diagnostic avoids allocating or recursively logging into GUI
  error handling. Counters bound owned resources, not complete process RSS.
- **Remaining uncertainty:** Target compilation, all-script fallback/shaping,
  native-size visual guest acceptance and physical behavior remain separate.
- **Next validation:** Run the combined fresh-target and VM matrix after ordered
  P1 remediation; never reuse earlier binaries or source receipts for this patch.
- **Supersedes / superseded by:** Supersedes AUD-003's unsafe allocation state;
  does not complete AUD-029 multilingual rendering.

---

- **Lesson ID:** REC-T003
- **Date:** 2026-10-04
- **Environment scope:** Text candidate review and compatibility regressions
- **Evidence class:** Independent read-only source review and production fixtures
- **Status:** Confirmed review findings corrected before commit
- **Question or previous assumption:** Would tighter bounds preserve default
  input widgets, scale preview and rotated texture sampling?
- **Finding:** The first candidate refused width zero even though GUIInput uses
  it as the unscaled-input sentinel. It also prevented preview enlargement,
  could wrap leading punctuation without consuming bytes, reused an obsolete
  face generation after theme replacement, and used clipped bounds as the
  origin of a full rotated texture. The independent review identified each
  concrete caller or sampling contract. Corrected tests now exercise those
  actual paths; a clipped rotated rectangle retains the complete texture origin.
  A synthetic 1,536-pixel-square outline is refused before FT_Render_Glyph.
- **Evidence:** One fresh candidate review; actual `GUIText::SetMaxWidth(0)`
  and UreScalePreview callers; production wrapper, rotation and AddLines
  extraction; leading delimiter/zero-width controls; replaced-inode face
  identity control and full texture-coordinate oracles for 90/180 degrees.
- **Failed trials and corrections:** The first host build hit CMake's removed
  pre-3.5 compatibility and an inherited header warning; an explicit host policy
  floor and system include classification resolved them. The wrap extractor
  initially included unrelated following methods and was bounded correctly.
  The first sanitizer run detected a new/free mismatch in the test enjector;
  symbol wrappers now preserve the real allocator/deallocator classification.
  No sanitizer check was disabled. Initial WOFF tests showed no parser refusal
  because AOSP's ftoption.h leaves zlib commented even when CMake finds zlib.
  The host fixture now mirrors Android.bp's explicit USE_ZLIB definition and
  verifies the parser-budget rejection rather than accepting early format failure.
- **Practical consequence:** Review real sentinel values and compile the same
  optional parser branch as production. Assert forward progress and texture
  coordinates, not only successful return codes or bounded surface dimensions.
- **Remaining uncertainty:** A passing fixture is not all-page visual acceptance.
  The single candidate review is scoped to this finding and its compatibility.
- **Next validation:** Include default inputs and enlarged previews in final
  portrait/landscape guest captures, with all-language acceptance kept separate.

---

- **Lesson ID:** REC-T004
- **Date:** 2026-10-04
- **Environment scope:** Reviewed recovery patch staging and interruption resilience
- **Evidence class:** Source, isolated Git fixture and current host observations
- **Status:** Exact stack staging verified; reported task shutdown cause unresolved
- **Question or previous assumption:** Can a later overlapping patch be validated
  by reverse-checking every earlier patch against the final source?
- **Finding:** Later renderer edits replace earlier decoder context. The new
  stager reconstructs every reviewed prefix in an isolated index, accepts only
  an exact known prefix and compares exact final bytes. Unknown edits are refused
  before replacing any file. A fresh disposable source clone exercised clean
  application and preserved a deliberately unreviewed modification after refusal.
  Incremental English commits preserve completed work across task interruption.
- **Evidence:** `configs/recovery-patches.list`, `prepare-recovery-patches.sh`
  and `tests/check-text-patches.sh`. Focused compilation used two workers. At
  the owner's latest shutdown report, the accessible current application cgroup
  showed zero high/max/oom/oom_kill events and the accessible current-day kernel
  OOM query had no records. That observation does not establish why an earlier
  task or application exited, or prove safety on a complete 16 GiB machine.
- **Practical consequence:** Preserve the exact-source admission boundary while
  supporting reviewed overlapping patches. Keep raw diagnostics private, retain
  interrupted work and resolve AUD-022's adaptive host reserve in its report order.
- **Remaining uncertainty:** Access and current-group observations cannot rule
  out an earlier OOM, application defect, service termination or remote turn failure.
- **Next validation:** Record available-memory/ancestor limits and job OOM/PSI
  receipts when the ordered host-budget remediation and combined build run occur.
