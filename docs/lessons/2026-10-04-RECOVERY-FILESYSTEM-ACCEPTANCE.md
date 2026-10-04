# 2026-10-04: Populated filesystem boundaries and recoverable admission failures

## REC-FS001 — Space refusal still needs an inspectable persistent journal

- **Lesson ID:** REC-FS001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox recovery management, regular-image host fixtures
- **Evidence class:** Source and reference-host fault injection
- **Status:** Corrected; matching focused native and sanitizer controls passed
- **Question or previous assumption:** Does an insufficient-space refusal leave the common persistent owner recoverable?
- **Finding:** The space check followed ownership acquisition and plan publication but preceded state publication and the preparation error handler. A refused request therefore retained an owner and plan without the state required for inspection or cancellation. Moving initial state publication before space admission and placing admission inside the error handler preserves the ordinary `FAILED_SAFE` inspect/cancel path.
- **Evidence:** `ure-filesystem-failed-preparation` initially failed in 0.23 seconds with an absent-record error after the injected `fstatvfs` refusal. Its original image remained unchanged. The private initial native build/test logs and failed image/coordinator directories were retained. The fixture links the production library and wraps only host-test syscall/executable boundaries; no production fault hook was introduced.
- **Practical consequence:** Insufficient journal capacity must produce a durable recoverable state before returning. A failed owner is retired only through exact-plan cancellation after verifying original bytes.
- **Remaining uncertainty:** Host syscall injection cannot establish device storage durability or actual physical medium exhaustion behavior. A failed state fsync still requires conservative retained ownership.
- **Next validation:** Fresh target and combined generic guest after ordered P1 source work; separate physical medium exhaustion and durability admission.
- **Supersedes / superseded by:** Refines REC-O001 common ownership recovery; no physical admission is changed.

## REC-FS002 — A populated shrink oracle must prove content relocation and metadata

- **Lesson ID:** REC-FS002
- **Date:** 2026-10-04
- **Environment scope:** Ext4 reference-host fixtures
- **Evidence class:** Reference-host tools; production-command receipts remain separate
- **Status:** Matching production host matrix passed; original probe evidence retained
- **Question or previous assumption:** Do clean empty-filesystem tests establish preservation near a populated filesystem's minimum size?
- **Finding:** An independently constructed 160 MiB ext4 fixture with 80 MiB nonzero payload, quota, hardlink, symlink, explicit owner/mode and a user xattr reported 27,220 blocks of 4 KiB as its minimum with e2fsprogs 1.47.4. Direct-tool trials rejected one block below and accepted that boundary and one block above. A separate 192 MiB fixture fragmented the 80 MiB payload into 18 extents, including allocations beyond its reported 27,755-block minimum. These are properties of the selected fixtures and host tool, not universal safe minimums or Android encrypted-data acceptance.
- **Evidence:** Private `fs-boundary-probe-path` and `fs-fragment-probe-path` records identify preserved setup/tool logs. `debugfs` stat/blocks and `resize2fs -P/-M` supply independent geometry observations. The production matrix independently dumps and compares file bytes, inode sharing, symlink target, UID/GID, permissions, xattr, quota feature, UUID/label, read-only check, original inode/container size and whole-image rollback.
- **Practical consequence:** Require actual allocation above the requested boundary and independent post-operation data oracles; a successful tool status or an unchanged empty image is insufficient.
- **Remaining uncertainty:** Other ext4 features, tool versions, F2FS/NTFS relocation, malformed metadata and encrypted userdata require distinct coverage. The host fixture disables `orphan_file` and `encrypt` to avoid the known older Android-tool incompatibility; that does not validate Android FBE trust.
- **Next validation:** Fresh target/combined guest for the same data/metadata/minimum/damage controls; separate arbitrary corruption and encrypted-data acceptance.
- **Supersedes / superseded by:** Extends REC-L005 and REC-F013's bounded filesystem fixture scope; their earlier results are preserved.

## REC-FS003 — Quota corrections and fixture setup errors are not target failures

- **Lesson ID:** REC-FS003
- **Date:** 2026-10-04
- **Environment scope:** Ext4 reference-host setup
- **Evidence class:** Reference-host tools
- **Status:** Corrected fixture handling
- **Question or previous assumption:** Can fixture metadata setup require a successful checker to exit nonzero?
- **Finding:** Changing an inode's UID/GID while quotas are enabled required quota-accounting corrections. `e2fsck -p` returned its documented corrected-filesystem status 1, causing an initial `set -e` probe to stop. Setup now explicitly accepts only status 0 or 1; the final independent read-only check must still return 0. Debugfs command exit status alone is not accepted as proof that payload creation succeeded. The first staged-copy fault trial also failed to inject a write error because the host supported `FICLONE`; the test must disable only that private staged reflink before injecting `ENOSPC` after a verified 1 MiB copy. It must not remove production reflink optimization.
- **Evidence:** Preserved metadata/check logs show corrected UID/GID quota entries and the expected inode mode, hardlink count and exact user xattr. The matrix subsequently requires complete dumped-byte comparisons and actual extent/block measurements.
- **Practical consequence:** Preserve tool-specific exit semantics and distinguish a setup-oracle error from an implementation defect. Do not broaden production success codes to hide unrelated failures.
- **Remaining uncertainty:** Only the selected repairable quota/inode fixtures are covered; this is not a general corruption-recovery guarantee.
- **Next validation:** Require a genuinely damaged inode fixture to fail read-only checking before repair, then verify contents and exact rollback to the damaged original.
- **Supersedes / superseded by:** None.

## REC-FS004 — Persisted volume serials need numeric comparison

- **Lesson ID:** REC-FS004
- **Date:** 2026-10-04
- **Environment scope:** Filesystem plan persistence and populated NTFS host fixtures
- **Evidence class:** Source, native and pinned sanitizer failure controls
- **Status:** Corrected comparison; matching focused native and sanitizer controls passed
- **Question or previous assumption:** Does JsonCpp value equality compare a persisted positive serial to a freshly probed unsigned serial by numeric value?
- **Finding:** Not reliably. The new NTFS/FAT serial guard initially compared JSON values directly. A valid positive number parsed from disk could have a signed internal representation while the same freshly probed number was explicitly unsigned. The native and instrumented production CLI both refused successful staged NTFS resize despite identical independent raw serial bytes. The guard now requires a valid unsigned-range value on each side and compares `asUInt64()` values. F2FS UUID probing was also added so its resize follows the existing unchanged-UUID contract.
- **Evidence:** Frozen input manifest SHA-256 `53b6bd5a9fb95cc8aeaffaf90dde5f96dbfe2856cba2214a6a644c3ee2c8dc32`; preserved `filesystem-before-serial-comparison` native/instrumented test logs show refusal after 64.98/74.75 seconds. Both original and private staged NTFS boot records contained the same eight serial bytes. The original image was not applied; the retained state was `FAILED_SAFE`.
- **Practical consequence:** Compare validated JSON numeric values, not internal storage tags, for persisted identity fields. A refusal test must independently establish whether the underlying identity changed before blaming the tool.
- **Remaining uncertainty:** Host NTFS/FAT identity receipts do not establish Windows boot compatibility or Android/device writer admission.
- **Next validation:** Matching native/instrumented populated NTFS/FAT/F2FS shrink and exact original rollback, then the combined guest after ordered P1 source work.
- **Supersedes / superseded by:** Applies the same parsed-number lesson as REC-O009 to a new volume-identity field; previous successful ownership evidence is unchanged.

## REC-FS005 — Preserve NTFS's required Windows check in independent readback

- **Lesson ID:** REC-FS005
- **Date:** 2026-10-04
- **Environment scope:** Populated NTFS reference-host oracle
- **Evidence class:** Reference-host tools and pinned source inspection
- **Status:** Corrected readback oracle
- **Question or previous assumption:** Can an ordinary NTFS reader inspect a successfully resized image without acknowledging its scheduled Windows check?
- **Finding:** `ntfsresize` deliberately schedules Windows chkdsk. The first independent readback then refused the scheduled-check volume even though the native job had completed its staged check/application. The host oracle now uses the force flag only on `ntfscat` and `ntfsinfo`, whose pinned implementations mount with `NTFS_MNT_RDONLY`. It does not clear the check flag, mount the image or alter production checker behavior.
- **Evidence:** Preserved `filesystem-before-ntfs-read-oracle` native/instrumented logs failed in 71.58/82.76 seconds. Pinned `external/ntfs-3g/ntfsprogs/ntfscat.c:418` and `ntfsinfo.c:2467` retain read-only mounting with the force/recover option. Exact before/after serial, file contents, volume label and full original-image rollback remain separate assertions.
- **Practical consequence:** A zero resize/check result cannot become a claim of complete NTFS repair or Windows boot acceptance. Keep the scheduled-check state and use an explicitly read-only oracle to examine data.
- **Remaining uncertainty:** Windows chkdsk and Windows boot remain untested. Host reader recovery behavior is not an authorized live mount workflow.
- **Next validation:** Complete populated shrink/readback/rollback receipts with the revised oracle and require separate Windows-side validation.
- **Supersedes / superseded by:** Refines REC-F013's limited NTFS scope without changing its Windows acceptance gap.

## REC-FS006 — A successful F2FS tool exit does not prove requested shrink

- **Lesson ID:** REC-FS006
- **Date:** 2026-10-04
- **Environment scope:** Native filesystem staging and populated F2FS host fixtures
- **Evidence class:** Source, native/instrumented production CLI and independent on-disk geometry
- **Status:** Corrected; matching focused native and sanitizer controls passed
- **Question or previous assumption:** Does a zero `resize.f2fs` result imply its requested size was persisted?
- **Finding:** The host 1.16.0 tool returned zero for a 64 MiB request on a 512 MiB filesystem containing 80 MiB of payload, but both the primary superblock and independent read-only checker still described 512 MiB. The engine previously accepted this unchanged geometry as `COMPLETE`. It now checks ext4 block count/block size and both F2FS superblocks against the exact reviewed byte size before publishing or applying a replacement. F2FS primary/backup UUID and size must agree. An impossible no-op returns `filesystem-resize-geometry-mismatch` with the original target untouched; a genuinely failed tool retains its separate failure code.
- **Evidence:** Preserved `filesystem-before-size-enforcement` native/instrumented logs failed the expected-refusal oracle in 94.06/108.03 seconds. The retained F2FS state had zero tool status and successful post-check, yet its block count at superblock byte 36 was 131,072, not the requested 16,384. A direct independent 256 MiB shrink trial produced 65,536 blocks, confirming that the selected host tool can perform a feasible shrink. Pinned Android f2fs-tools revision `0aa5acbbb6c405a2e5cc02bca6f4eb74d146da12` remains distinct from the installed host 1.16.0 tool.
- **Practical consequence:** Check persisted size, identity and independent content before changing GPT boundaries. Tool success cannot authorize a partition shrink when the contained filesystem still exceeds it. The shared staging helper enforces this for both standalone and compound partition jobs.
- **Remaining uncertainty:** Arbitrary F2FS damage, different kernel/tool versions and physical filesystem/GPT durability remain untested. Historical clean/empty guest results did not cover this impossible populated-size case.
- **Next validation:** Matching native/instrumented feasible and impossible populated shrink, both independent superblocks, complete data/identity readback, original rollback and compound-partition regressions; fresh target/combined guest later.
- **Supersedes / superseded by:** Refines REC-F013 and AUD-010's acceptance scope; historical container preservation/rollback evidence remains valid but cannot substitute for exact filesystem-size proof.

## REC-FS007 — Matching source/host receipts keep their separate acceptance scope

- **Lesson ID:** REC-FS007
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox native host build and private regular images
- **Evidence class:** Build, native production CLI, pinned Clang ASan/UBSan/leak controls
- **Status:** Focused source/host acceptance passed
- **Question or previous assumption:** Do the corrected filesystem guards preserve both populated data and the existing compound/format workflows?
- **Finding:** The new failure/matrix set passed 2/2 native in 132.06 seconds and 2/2 instrumented in 152.11 seconds. Existing compound partition/transaction regressions subsequently passed 2/2 native in 131.05 seconds and 2/2 instrumented in 295.37 seconds. Both original six-format CLI sets passed. Input manifests captured after each regression were byte-identical to the frozen source input manifest. Builds used two compiler jobs and ccache; no live target, host block device or connected tablet was opened.
- **Evidence:** Frozen input manifest SHA-256 `4618981a374dd15cd723ea91f850b25faffc5434f23cfd82fffe43258273c18f`. Private `filesystem-acceptance-{native,sanitizer}-{build,test}` and `filesystem-regression-{native,sanitizer}-{build,test,cli,inputs}` artifacts preserve exact outputs. The pinned compiler is Android `clang-r547379`, with address/undefined sanitizers, frame pointers, vptr exclusion, leak detection and halt-on-error settings. Host tools: e2fsprogs 1.47.4; f2fs-tools 1.16.0; ntfs-3g 2026.9.28; fatresize 1.1.0; mtools 4.0.49. Final ext4 production fixtures measured 27,221/27,756 minimum blocks; the earlier smaller metadata probes had distinct 27,220/27,755 minima and are not substituted for these receipts.
- **Practical consequence:** Use independent whole-image, data, metadata and persisted geometry oracles for source acceptance. Retain the unaccepted live writer, FBE, arbitrary corruption, Windows-side and shipping-kernel/tool gates.
- **Remaining uncertainty:** This is not a fresh Android build, complete release, generic VM or physical hardware receipt. Host FAT/Btrfs tools are not proof that those tools are packaged in recovery. No independent fresh agent review occurred in this continuation.
- **Next validation:** Continue AUD-012–035 in their original order, then build and run combined generic VM acceptance; P2 remains last.
- **Supersedes / superseded by:** Completes the host controls in REC-FS001–006 while preserving their failed trials and outstanding target/physical requirements.
