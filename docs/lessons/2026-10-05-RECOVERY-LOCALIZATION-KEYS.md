# 5 October 2026: retain JSON owners and validate generated key closure

These are AUD-030 OrangeFox source and reference-host findings. The complete
Android target, shipping GUI, combined VM, translation meaning and physical
tablet were not accepted. Private traces and generated catalogs remain local.

## REC-KEY001: a subscript does not extend its temporary JSON owner's lifetime

- **Lesson ID:** REC-KEY001
- **Date:** 2026-10-05
- **Environment scope:** Host-only C++20 catalog tool and the actual lookup header.
- **Evidence class:** Production generator/schema tests, independently compiled headers and a pinned-Clang ASan negative.
- **Status:** Reproduced draft lifetime defect corrected; focused host closure passed.
- **Question or previous assumption:** Iterating `parse(input)["strings"]` kept the parsed JSON storage alive throughout a C++20 range loop.
- **Finding:** The parsed owner must be named and retained through validation and iteration. The generator now checks schema/version, row/string types, key/source uniqueness, UTF-8/NUL rules, reserved aliases and byte/row budgets before building a deterministic table. A staged same-directory header is renamed only after validation and writing; malformed inputs retain the original header. Fixed three-digit octal literals preserve exact UTF-8 and non-BMP/control/quote/backslash bytes without invalid JSON surrogate escapes in C++.
- **Evidence:** `recovery-uke-ofox/src/localization/key-catalog.cpp` and `reports/URE-LOCALIZATION-KEYS-2026-10-05.json`. Five native/five sanitizer controls passed, including actual display/preview/partition/management callbacks with host platform stand-ins. Empty, one-row, non-BMP/control and full current catalogs compiled against the unchanged actual lookup adapter with 1/2/2/3,189 exact ordered entries. A 16,384-row ownership fixture and 57 real schema/budget/indirect/special-file refusals passed. The deliberately invalid original temporary-owner pattern still failed with ASan `heap-use-after-free`; it is not a passing CTest or tablet executable.
- **Practical consequence:** A structural generation pass can be tied to actual key count/order/source bytes rather than the mere presence of a generated file. Duplicate source messages or aliases cannot silently overwrite another mapping. Typed opaque paths/numbers retain their original bytes during the tested lookup.
- **Remaining uncertainty:** The typed consumer is tested as a host adapter; these controls do not prove current shipping GUI integration or translated warning meaning. Host publication is not a tablet journal, and a final-directory synchronization failure can occur after the header becomes visible.
- **Next validation:** Complete AUD-031 source/context/parent provenance and language-switch review rules, then run fresh complete named native/sanitizer, target/image and shipping/combined GUI gates.

## REC-KEY002: reject collisions rather than weakening the generator for a producer mistake

- **Lesson ID:** REC-KEY002
- **Date:** 2026-10-05
- **Environment scope:** Pinned JsonCpp parsing and fresh structural source collection.
- **Evidence class:** Failed controls, exact full-catalog inspection and corrected production behavior.
- **Status:** Parser-option gap and alias mismatch reproduced and corrected.
- **Question or previous assumption:** Setting `allowComments=false` made the pinned parser reject all comments, and automatic source hashing matched the explicit Extra alias.
- **Finding:** The first actual negative suite accepted an in-object comment after 45 refusals. The pinned JsonCpp still skips comments in some object positions despite that option. An independent string-aware token/nesting scan now rejects slash tokens outside strings and excessive depth; slash bytes inside strings remain data. The first full-header trial then correctly refused the producer's hash-derived Extra key. `prepare` now assigns `ure_extra_tab` explicitly; unknown/colliding older inputs remain refused rather than silently normalized.
- **Evidence:** Preserved private first/second negative logs and the failed initial full-catalog generation. Final native and sanitizer catalogs contain 3,189 current source rows across 32 language inventories, replacing neither the older audit's 2,664-row observation nor its evidence. Full catalog SHA-256 `84a7ad7b06d148c19366b532a1b4c5b40d8bfdd854a4235d727948a7ac8c347b`. All four GCC/Clang generated headers and full catalog bytes are identical; repeated production generation is identical.
- **Practical consequence:** Parser configuration needs an actual negative oracle. A producer/consumer disagreement should be resolved at its source instead of disabling collision checks. A source inventory is distinct from language completeness.
- **Remaining uncertainty:** Structural collection still uses regex/context heuristics and does not provide competent linguistic review. Placeholder preservation alone cannot prove a translation's meaning.
- **Next validation:** Regenerate expected jobs from current catalogs and bind translations to exact source, context, locale/target and parent identities; keep stale imports and unreviewed safety wording outside accepted materialization.

## REC-KEY003: scoped receipts must keep generation and translation acceptance separate

- **Lesson ID:** REC-KEY003
- **Date:** 2026-10-05
- **Environment scope:** Resource-isolated GCC/pinned-Clang C++ host checks and source inventories.
- **Evidence class:** Frozen before/after inputs, executable/compiler receipts, halt-on-error negative and complete-catalog enumeration.
- **Status:** Focused key generation receipts passed; broader acceptance remains false.
- **Question or previous assumption:** A safe, compiled lookup header established complete translation or recovery readiness.
- **Finding:** The tool is a host-only `BUILD_TESTING` target using pinned JsonCpp plus host libxml2 2.15.4/OpenSSL 4.0.3 development libraries. The producer uses the existing resource envelope/cache with at most two compilation workers. It exports address/undefined/leak halt options inside the service and requires the independent original-owner negative. Unvalidated translation job/import/materialization entry points refuse without creating output while AUD-031 remains open. A subsequent input-control trial detected that listing required generator files individually had accidentally narrowed the optional directory membership capture. The whole localization directory capture was retained, new generator/test mutation controls were added, and the complete input/resource controls passed before fresh focused receipts were collected. No translator request, Python tool or device operation ran.
- **Evidence:** Final shared input SHA-256 `58c4215e4582366a495ad5143c6223bf520974aa1d57183c85143d0a0f8f64df`; localization identity `da28e15569909b476ddc0110d4e576c96cb07312cf3e6b98b9d69101e018e168`. Final native receipt SHA-256 `9ba0b78c019f1733c456adc8fbb389671a3769029368efdaae2593a62cb126eb`; sanitizer receipt SHA-256 `5faf8047a33fa5ab0873b8cc66c279eb439bcdef274550c343cc97ed5058b569`. Both retain matching before/after identities and explicitly false full-catalog/build/GUI/VM/provenance/meaning/device acceptance. Earlier focused results remain historical and do not substitute for this corrected membership capture. The current complete CTest catalog has 49 entries; only the five scoped entries ran here. Existing owner GUI drafts remain separate and uncommitted by this checkpoint.
- **Practical consequence:** Required generator/lookup/test sources are part of localization identity, while unrelated optional font/network drafts remain inventoried without execution or promotion. Focused receipts cannot replace release-policy acceptance.
- **Remaining uncertainty:** The documented pinned-runtime vptr exclusion remains. Complete Android dependency/build/image/capacity closure, whole-page input/visual checks, semantic review and tablet acceptance remain required.
- **Next validation:** Preserve this exact host evidence, close remaining P1 gates in order and run the complete fresh software/VM acceptance set before considering P2 or physical validation.
