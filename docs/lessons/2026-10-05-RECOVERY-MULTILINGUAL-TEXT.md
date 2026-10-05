# 5 October 2026: multilingual text needs shared layout and real failure tests

These are OrangeFox source and reference-host findings for AUD-029. No complete
new Android image, shipping GUI, combined VM or physical tablet was accepted.
Raw traces, allocation probes and native raster atlases remain private.

## REC-MT001: preserve source, font and generated-data provenance separately

- **Lesson ID:** REC-MT001
- **Date:** 2026-10-05
- **Environment scope:** OrangeFox text sources and host packaging adapters.
- **Evidence class:** Exact upstream Git/release files, original font notices and isolated publication controls.
- **Status:** Source and asset closure implemented; binary/package acceptance pending.
- **Question or previous assumption:** An optional CJK font and language XML established usable, redistributable multilingual text.
- **Finding:** The implementation uses HarfBuzz 14.5.1 at `eb033319fc2ebe723597fa497d4bb4331bab8b6b`, FriBidi 1.0.17 at `b93119f5fdc7ea47672cc304c1455ffa6dfe7536`, pinned AOSP FreeType, and six unchanged Noto assets at `f1fe27f9777986e0f5973b4e6dda8be9dae49a95`. Original Arabic/Hebrew/Bengali/Devanagari/Thai/CJK notices are retained. The CJK collection shares one buffer across JP/KR/SC/TC faces; the Indic variable defaults are Regular weight 400. No donor build script, font generator or Python tool is executed. The unaccepted local font draft is excluded from redistribution without deleting its original.
- **Evidence:** FriBidi release archive SHA-256 `6949dcde27d41cebad1fd741fcafc36d55a1020d2d872d4a6eb3914caabbada2`; Unicode notice SHA-256 `e7a93b009565cfce55919a381437ac4db883e9da2126fa28b91d12732bc53d96`. The source/asset lock is `recovery-uke-ofox/manifests/text-layout.lock.json`. Native and Android compilation lists match the original 69 HarfBuzz units and reviewed four-unit FriBidi API. Changed/missing/indirect assets and notices, unknown members, special objects, lock disagreement, unknown upstream/Android edits and modified execution modes refused. Root, per-file, ISC, Microsoft, LGPL and Unicode notices total 514,101 bytes in the tested fixture.
- **Practical consequence:** Licensed bytes and exact source identities accompany the renderer, and extracted-image/source-archive consumers verify them. A character-map check alone cannot establish shaping or provenance.
- **Remaining uncertainty:** FriBidi's release input data is Unicode 18, while its unchanged distributed tables/version header remain Unicode 14.0.0. HarfBuzz uses Unicode 18 properties; this combination does not establish Unicode 18 bidi conformance. Full offline Android dependency/relink and binary reproduction gates remain separate.
- **Next validation:** Build the complete Android target, audit the extracted asset/license bytes and partition capacity, then retain the complete application/library sources and reconstruction recipe with any binary release.

## REC-MT002: one production layout must drive measurement, prefixes and pixels

- **Lesson ID:** REC-MT002
- **Date:** 2026-10-05
- **Environment scope:** Actual minuitwrp renderer and reference-host draw adapter.
- **Evidence class:** Native/sanitizer production functions, independent script oracles and inspected native font atlases.
- **Status:** Focused multilingual layout/drawing controls passed.
- **Question or previous assumption:** Scalar-by-scalar glyph selection and width accumulation handled RTL, ligatures and Indic marks.
- **Finding:** Logical script/font/embedding runs are shaped with HarfBuzz and ordered with FriBidi. Glyphs preserve original byte clusters. Fitted prefixes are reshaped for line-edge context, with bounded fallback search. Combining A8 masks use source-over coverage instead of overwriting their base with transparent pixels. All shared FreeType sizes are restored when normal and preview fonts alternate.
- **Evidence:** Three actual production tests passed natively and with pinned Clang address/undefined/leak instrumentation: bounded UTF-8, allocation/clipping and multilingual layout. The actual 32-language XML corpus contains 35,191 string/display records and 798,009 scalars excluding ASCII controls. Tests cover independent mixed Hebrew/numeric byte order, Arabic contextual forms, four combining/conjunct controls, region-specific CJK families, Regular variable coordinates, interleaved font sizes and 616 native adapter draws across eleven scales and four orientations. All eleven GCC/Clang PPM atlases are byte-identical; 50 and 75 scale atlases were visually inspected without missing boxes or clipped sample marks. Native corpus/sample elapsed time was 6,271 ms with 49,640 KiB peak RSS; instrumented time was 43,024 ms with 639,764 KiB RSS on the reference host in Debug builds.
- **Practical consequence:** The tested supported-language glyph, order and cluster behavior is attributable to production code. Cache/face/source sharing remains bounded, and language changes invalidate strings under the existing renderer lock.
- **Remaining uncertainty:** These are font atlases and adapter draws, not complete OrangeFox screenshots, input hit-target checks, translation review or tablet performance. Stable multiscript ascender/descender metrics change line height and require fresh whole-GUI review. This work does not provide paragraph line breaking or whole-GUI RTL mirroring.
- **Next validation:** After the remaining P1 work, run fresh complete native/sanitizer catalogs, target compilation and shipping/adapted portrait/landscape/scale GUI tests against matching resources.

## REC-MT003: allocation failure must not become partial layout success

- **Lesson ID:** REC-MT003
- **Date:** 2026-10-05
- **Environment scope:** HarfBuzz/FriBidi allocators, FreeType variation parser and renderer failure paths.
- **Evidence class:** Actual host SIGSEGV/stack trace, deterministic allocation failures and sanitizer regression.
- **Status:** Reproduced library and compatibility defects corrected.
- **Question or previous assumption:** Bounding input/heap sizes made upstream out-of-memory paths safe.
- **Finding:** A real failure at allocation sweep index 40 dereferenced a null FriBidi line-run buffer. Two line-reorder allocations now refuse cleanly, and partially allocated deep-isolate bracket stacks are released. The shared allocator enforces 16 MiB total/4 MiB single limits; any refusal invalidates the layout. Empty glyph bitmaps such as spaces remain valid even when their pixel buffer is null. FreeType's valid zero-region variable delta lookup required the upstream `b1cbcb20454e3b465b0d3ea4d5457975cfa747e7` guard to avoid null-pointer arithmetic.
- **Evidence:** `patches/0031-fribidi-allocation-failure.patch` and the reviewed FreeType `0032` backport; forty nested isolates, both reorder allocations, repeated retained-owner checks, original font-load/raster/string/rotation failure sweeps, and the independent overlapping A8 oracle passed. The final allocation test injected 118 failures and reported 80 draw/load refusals, with all font/face/source/cache owners released. Earlier failed qsort declaration, redundant build macro, valid-space handling and resource-newline oracles are retained in private logs. The build declaration includes `stdlib.h`; the redundant macro was removed; language resources are tested by their actual line-separator semantics rather than treating LF as a missing glyph.
- **Practical consequence:** A library allocator refusal cannot silently publish partial glyph positions. Upstream size limits still require deliberate failure-path testing; one failed glyph must be distinguishable from a valid empty bitmap.
- **Remaining uncertainty:** Tested failure points do not exhaust every possible font/parser/library path or establish physical fault tolerance. Per-library budgets exclude bounded C++ containers, process/stack and sanitizer overhead.
- **Next validation:** Carry these exact patches/oracles into the complete target and combined guest; broaden only when a new failure or shipped feature justifies another check.

## REC-MT004: private staging and instrumentation need independent negative oracles

- **Lesson ID:** REC-MT004
- **Date:** 2026-10-05
- **Environment scope:** Host source preparation, isolated test services and evidence publication.
- **Evidence class:** Failed/corrected staging and sanitizer commands, frozen source comparisons and three-test receipts.
- **Status:** Focused evidence producer corrected and passed; complete release acceptance remains false.
- **Question or previous assumption:** Outer sanitizer environment options survived systemd isolation, and a repeated archive had identical execution modes under every umask.
- **Finding:** An ad-hoc run printed a FreeType UBSan report but returned a CTest pass because its outer halt options were not preserved by the isolated service. That result was rejected. The focused producer now exports sanitizer options inside its owned service, verifies a deliberately failing host-only overflow probe, and rejects any sanitizer diagnostic. Separately, private umask 077 changed extracted executable bits from 0755 to 0700, making a correct source snapshot refuse. Exact verified archives now restore original permissions before comparison, without executing their scripts. The initial source-stage check also explicitly permits only the original within-tree regular-target documentation symlink; it does not consume its instructions.
- **Evidence:** The corrected halt-on-error negative rejected the original FreeType defect. Final frozen native input SHA-256 `c0396fda842315a52947d6990d340934305894cf4e8abf2427d88320ffac9fa4`; localization inventory SHA-256 `fbef50e0e44c1cbef271b8c974e366dbc39d723d86c2c1c9e29a972aaf33b973`. Native receipt SHA-256 `72c29c41e21b0f670bd8a5b01a4762d0f64ebdb612c4d4933f9671b945bec9b9`; sanitizer receipt SHA-256 `177254ac584c7342094fdafcc39b883329d64a25bc36cc9c87f4e6b5ed75eb29`. Both receipts retain identical before/after sources, three executable/test identities and atlas indexes. The actual complete CTest catalog now has 48 entries; it was not executed in full for this checkpoint. Resource, reviewed-stack and all-language inventory controls passed independently.
- **Practical consequence:** Process exit and source/class identity must accompany a positive log. Focused receipts are explicitly marked as incomplete native/build/GUI/VM acceptance and cannot replace full release-policy records. A nondeterministic archive permission mask must not be mistaken for a source mutation.
- **Remaining uncertainty:** The pinned host runtime's vptr exclusion remains documented. These software controls neither diagnose earlier desktop task exits nor authenticate a compromised host. Hardware, complete image/capacity, translation semantics and combined GUI acceptance remain unaccepted.
- **Next validation:** Fix AUD-030/031 in order, then complete the fresh named native/sanitizer, build, extracted-image, package and applicable VM gates. Retain these corrections rather than replacing their failed observations with the final pass.
