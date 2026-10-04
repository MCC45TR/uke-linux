# 5 October 2026: release requirements follow capabilities, not names

These are OrangeFox source/reference-host records. The preserved public alpha
is unchanged; no new complete image, repeated package, combined guest or tablet
was accepted. Raw diagnostics remain private.

## REC-REL001: a new artifact name must inherit the same evidence policy

- **Lesson ID:** REC-REL001
- **Date:** 2026-10-05
- **Environment scope:** OrangeFox host packaging and manifest publication
- **Evidence class:** Source policy and real host refusal fixtures
- **Status:** AUD-025 name-dependent source gate corrected
- **Question or previous assumption:** A specially named candidate could carry stronger gates while another name with the same features used weaker requirements.
- **Finding:** New packages require an explicit experimental, VM-reviewed or function-reviewed request. All ten shipped feature domains are mandatory exactly once. The reviewed policy computes five, ten or fourteen receipts and binds its content digest; names are absent from this computation. A candidate's policy cannot be changed in place. Unknown classes/features, missing/duplicate capabilities, added request fields, tampered requirements and claimed physical acceptance refuse. Device-validated classes remain unavailable.
- **Evidence:** Final source-input manifest SHA-256 `a491b60e1f93332e7a3f0584edcf24ef94015ab482f51436467eac4ef753c5d9`. Actual preflight controls moved the same feature set between three names and refused the same missing functional receipt with unchanged file content. All fourteen missing and indirect receipt controls passed; reordered capabilities normalized identically. A lower-class request refused an already bound candidate before build/export effects.
- **Practical consequence:** Renaming artifacts cannot avoid the selected class's tests. Every current candidate needs matching source/build and required evidence, while historical manifests retain their historical scope.
- **Remaining uncertainty:** Presence/JSON preflight is deliberately separate from exact source, ELF, runner and semantic validation. Fixtures with placeholder JSON cannot accept an Android build. Local reviewed policy and digests are not an authenticated update trust root.
- **Next validation:** Fresh complete native/sanitizer/image/package receipts and the applicable combined guest after ordered P1 changes; production update authentication remains AUD-035.
- **Supersedes:** AUD-025's candidate-name branches for new publications; no historical receipt was rewritten.

## REC-REL002: equal test counts can describe different suites

- **Lesson ID:** REC-REL002
- **Date:** 2026-10-05
- **Environment scope:** Complete native and pinned-Clang sanitizer receipt producers
- **Evidence class:** Current configured CTest enumeration and metadata refusal controls
- **Status:** Named suite binding replaces historical constants
- **Question or previous assumption:** Historical counts of 17–27 executables remained suitable acceptance gates as source tests expanded.
- **Finding:** Both producers now record complete sorted CTest names and counts. Publication compares those names to the current configured catalog and binds matching source-input digests, native CLI, sanitizer compiler and options. The present catalog contains 47 names; enumerating it does not claim that those 47 tests were freshly run.
- **Evidence:** Production shared validation refused a changed test name with unchanged count, historical count 24, stale source digest, different compiler, changed CLI, disabled sanitizer, a string-valued leak flag and physical-acceptance metadata. Matching synthetic metadata exercised the comparison only; it is not a complete native/sanitizer execution record.
- **Practical consequence:** Receipts cannot substitute a different suite merely because its count matches. New source changes still invalidate the complete source receipt. Existing complete regression producers will generate fresh records after the remaining P1 changes.
- **Remaining uncertainty:** These cooperating-host receipts depend on the honest producer and exact input checks; they are not cryptographic attestation against a compromised host. The existing vptr instrumentation limitation is unchanged.
- **Next validation:** Run both complete producers against unchanged final P1 inputs, then validate their named catalogs before packaging.

## REC-REL003: immutable candidates need guards in every producer

- **Lesson ID:** REC-REL003
- **Date:** 2026-10-05
- **Environment scope:** Package, manifest, archive, repeat, audit and completion-export paths
- **Evidence class:** Source inspection, isolated exact-source entry points and historical-artifact byte comparison
- **Status:** Missing archive guard corrected; all six producers preserve existing seals
- **Question or previous assumption:** Package/manifest guards were sufficient to preserve a sealed candidate.
- **Finding:** Source archiving could still overwrite its public archives. It now shares the seal guard with packaging/manifest/repeat drivers. Audit reports and completion exports also refuse output in sealed directories. New package repeats bind the same accepted build and normalized policy; uniform filenames replace candidate-specific receipt selection. Repeating one build's package does not prove two independent clean builds.
- **Evidence:** All six actual entry points refused the locally available historical alpha; complete file-content hashes matched before and after. Byte-identical copied entry points also refused isolated fixture seals without requiring historical downloads in a new checkout. Indirect/non-file candidate entries refuse before packaging effects. Current complete Android outputs are still unreceipted and cannot supply a positive new package result.
- **Practical consequence:** Preserve historical evidence instead of resealing it with current-source claims. Source snapshots include the completion and release-policy guides. New candidates need new complete build/package/guest evidence.
- **Remaining uncertainty:** The host filesystem owner can still modify files directly; these are cooperating-tool guards. Full source archive dependency closure, authenticated update manifests and physical device durability remain separate.
- **Next validation:** Use a fresh candidate after all P1 changes, prove two actual packages agree, run extracted-payload and combined guest controls, then separately implement signed update/rollback policy.
