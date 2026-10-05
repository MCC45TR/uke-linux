# 5 October 2026: invalidate reviewed operation context after a language change

These are partial AUD-031 OrangeFox source and reference-host findings. No
translation import, competent semantic review, complete Android/GUI/VM test or
tablet acceptance is established by this checkpoint.

## REC-LR001: machine-plan identity does not preserve a changed warning review

- **Lesson ID:** REC-LR001
- **Date:** 2026-10-05
- **Environment scope:** Actual recovery management callbacks with host GUI variables and private regular images.
- **Evidence class:** Reproduced stale-completion negative, native callback controls and pinned-Clang address/undefined/leak instrumentation.
- **Status:** Language-review defect reproduced and corrected; four native/four sanitizer controls passed.
- **Question or previous assumption:** A native plan's unchanged digest allowed its previous review to remain valid after changing the interface language.
- **Finding:** The language is part of the human review context. It now belongs to immutable worker inputs, so an old-language result is discarded rather than applied to a different view. A session changing language invalidates all reviewed plans and journal-action flags before opening the target; its mutation guards require a fresh review. Exact captured Btrfs controls also require a current-language review. Owned job cancellation remains reachable and machine requests, paths, journal contents and digests remain unmodified.
- **Evidence:** `recovery-uke-ofox/tests/ure/gui_language.cpp` failed before the fix with `Completed old-language plan was published into the new language`. The corrected actual callbacks reject an English completion in `pt_BR`, refuse reuse of a `pt_BR` review in `pt_PT`, then complete a fresh reviewed raw-image backup and independently verify its bytes. Filesystem review invalidation, exact backend control, cancellation/lifetime behavior and zero worker GUI accesses passed in the same four-control set. The first negative fixture compile required an explicit `<unistd.h>` include; that failed compile is retained separately from the successful negative oracle.
- **Practical consequence:** A translated warning cannot silently reuse an earlier confirmation. Restoring a journal review in the current language allows the original native recovery workflow without retargeting the operation.
- **Remaining uncertainty:** Callback tests use explicit host UI/backend stand-ins. Source/context/parent provenance and competent review of translated destructive warnings remain open; placeholder preservation does not prove meaning. Full current test catalogs, shipping Android/GUI and generic VM acceptance remain pending.
- **Next validation:** Regenerate and validate translation work against current source/context/locale identities, reject foreign child imports and require genuine review evidence before accepting new wording.

## REC-LR002: publish a tested change without absorbing unrelated owner drafts

- **Lesson ID:** REC-LR002
- **Date:** 2026-10-05
- **Environment scope:** Resource-isolated GCC and pinned-Clang reference-host compilation, unchanged actual callback generator and separate reviewed GUI fixture.
- **Evidence class:** Frozen manifests, reviewed-only compilation/run, exact overlay preservation and scoped receipts.
- **Status:** Four native/four sanitizer reviewed-only controls passed; owner overlay preserved byte-for-byte.
- **Question or previous assumption:** Passing controls against a dirty working GUI also proved the focused commit worked independently.
- **Finding:** The reviewed GUI change was applied to the committed base separately from the owner's 39-insertion/26-deletion overlay. Copies of the unchanged production hook generator compiled and ran all four controls against this reviewed-only GUI in both modes. Reversing only the new change reconstructed the exact original owner file. Only the reviewed GUI blob was staged; unrelated overlay changes remain local.
- **Evidence:** `recovery-uke-ofox/reports/URE-LOCALIZATION-REVIEW-2026-10-05.json`. Shared frozen working-input SHA-256 `412799af32a81000aed026860ef7d45366d7ea40944758e3b50570ec7242eaee`; localization identity `25b6b559efdb4f32e0a8898a34e4233cda1a4b4a7c3dc6d7b69cd52a9c632e02`. Working GUI SHA-256 `a33844ead0fa2ecd063475728f7c7d3fda4f3862b32038ca5b7089e8b376ff86` differs deliberately from reviewed-only GUI `d8f73d987595dae5040398acab5d261e29d0a72a85a5468a28819fccae1a7bfb`. The complete configured CTest catalog contains 50 entries; only four focused entries ran here. Native/sanitizer receipt SHA-256 values are `02c0df3f0ab09e5f75b17bce4dce5f30f8d54d67cfea01638ff5617c4c3d5d4f` and `6f36541ab20c32d110b7658451ac86a0d8ae7253d66f87175cd1cdd1b592f260`; reviewed-only receipts are `6b8fc08b7dfb29d4a5d7db7dc7f80fa074f80c973a9d06aa507454e1a685047b` and `4d7b969a1ac3f68504f520275e410d59ac3e5959cd5f9363e61b38d297660407`. All before/after manifests match. Input/resource mutation and stale-record controls passed separately.
- **Practical consequence:** Working-source and published-source acceptance remain auditable without discarding concurrent work or treating a partial callback receipt as a complete build.
- **Remaining uncertainty:** The pinned runtime's documented vptr exclusion remains. Reviewed-only callback execution is not an Android window or full target compilation. Translation entry points stay disabled and all broader acceptance flags stay false.
- **Next validation:** Preserve this focused publication, complete the remaining AUD-031 obligations and collect fresh full named catalogs and target/image/GUI/VM receipts after the P1 corrections.
