# 2026-10-03: coordinated recovery stock image jobs

## REC-S001: six stock LUNs need one recovery journal

- **Lesson ID:** REC-S001
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox / Global stock inputs; disposable host images
- **Evidence class:** source / implementation / reference-host tests
- **Status:** documented finding
- **Question or previous assumption:** Can six independent successful GPT transactions establish a recoverable stock-return operation?
- **Finding:** They cannot establish one shared interruption boundary. The new coordinator binds all six image identities, derives each stock table from measured capacity and current or verified original GUIDs, and prepares complete before/after copies of every changed GPT or selected OS programming range before its first original write. Payloads precede all backup GPTs, then primary metadata. Six LUNs are coordinated, not atomic together.
- **Evidence:** [native coordinator](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/stock_job.cpp), [independent six-LUN tests](../../recovery-uke-ofox/tests/ure/stock_job.cpp) and [build record](../../recovery-uke-ofox/reports/URE-STOCK-JOB-BUILD.md). Tests cover two capacity scales, original disk GUIDs/attributes, three pinned raw payloads, whole logical LUN rollback digests, torn primary/backup GPT bytes and source-directory removal after commit.
- **Practical consequence:** Maintain one bounded durable journal with explicit recovery. Do not reuse six independent metadata success records as a coordinated payload-restoration proof.
- **Remaining uncertainty:** No UFS controller, installed firmware, persistent tablet journal medium or physical stock boot has been tested.
- **Next validation:** Verify exact model/SKU/firmware and live ownership, then rehearse forced reboot and stock return on each identified tablet independently.
- **Supersedes / superseded by:** Extends the valid metadata-only workflow; it does not supersede its narrower evidence or mark the complete stock-return contract accepted.

## REC-S002: OEM source length, programming length and capacity differ

- **Lesson ID:** REC-S002
- **Date:** 2026-10-03
- **Environment scope:** Global OS3.0.303.0.WOZMIXM / OrangeFox
- **Evidence class:** source acquisition / native source inspection / reference-host tests
- **Status:** documented finding
- **Question or previous assumption:** Can an OEM filename or partition capacity determine the bytes to hash and program?
- **Finding:** The verified DTBO source is 20 MiB while its destination is 24 MiB. Sparse userdata has 1,289,147,004 source bytes and a 45 GiB decoded extent; sparse super has 8,199,567,300 source bytes and an 11,274,289,152-byte decoded extent. None measures a tablet's commercial capacity. The new job binds ordinary source SHA-256 and decoded programming length separately, and protects every unprogrammed tail.
- **Evidence:** [ten-image catalog](../../recovery-uke-ofox/manifests/stock-payloads-global.json), [compiled pins](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/stock_payloads.h), [verified acquisition](../../recovery-uke-ofox/scripts/describe-stock-payloads.sh) and independent catalog/pin checks. Native inspection of the actual OEM userdata/super files is recorded in the public build report. DTBO tests independently hash the programmed source bytes and preserve the marked 4 MiB tail.
- **Practical consequence:** Never hash an entire larger partition against a shorter file's checksum. Do not expose a generic 512 GB selector as verified UFS geometry. Acquire only reviewed OS/GPT inputs; never execute OEM scripts or transplant early firmware/calibration.
- **Remaining uncertainty:** Existing live preflight still has the separate DTBO file/capacity mismatch documented by REC-L006. The image coordinator's correct range handling does not repair or accept that live path.
- **Next validation:** Correct the common installed-firmware hash contract independently and test exact source-prefix boundaries before considering live writes.
- **Supersedes / superseded by:** Adds measured sparse-source evidence to REC-L006 without erasing its still-open live-preflight finding.

## REC-S003: sparse holes do not authorize unchanged-target assumptions

- **Lesson ID:** REC-S003
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox native image engine; host filesystem optimization
- **Evidence class:** source / reference-host tests
- **Status:** documented finding
- **Question or previous assumption:** Can Android DONT_CARE chunks or regular-file holes establish that existing storage bytes are already zero?
- **Finding:** No. The native sparse-v1 decoder checks exact RAW/FILL/DONT_CARE/CRC chunk sizes, aggregate boundaries, declared checksums and decoded content. DONT_CARE requires an explicit zero policy before staging. Zero/repeated leaves and SEEK_DATA can optimize fresh regular-file mirrors, while existing target writes are skipped only after an independent byte read matches the desired data.
- **Evidence:** [AOSP libsparse](https://android.googlesource.com/platform/system/core/+/5fa5708025843fe24566401025d830f05a3a39e2/libsparse/sparse_read.cpp), pinned local Android source inspection; [native ranges/decoder](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/image_ranges.cpp); [independent byte/CRC oracle tests](../../recovery-uke-ofox/tests/ure/image_ranges.cpp), including holes versus allocated zeros, unaligned ranges, malformed versions/chunks, cached-leaf boundaries and pinned sparse metadata.
- **Practical consequence:** Use the domain-separated `ure-image-range-sha256-tree-v1` digest explicitly; it is not ordinary whole-file SHA-256. Keep fixed 16 MiB transaction chunks, 64 KiB I/O buffers, bounded decoded sizes and conservative two-copy staging space plus 64 MiB. Reflinks and sparse staging do not reduce the reviewed budget or prove throughput.
- **Remaining uncertainty:** Native large-source inspection establishes parsing and logical content, not flashing, Android data reconstruction, secure erase or UFS zero semantics.
- **Next validation:** Test each pinned source and planned extent on disposable media under the exact accepted live writer before physical restoration.
- **Supersedes / superseded by:** No prior physical or throughput result is superseded.

## REC-S004: recovery must inspect actual bytes and retain direction

- **Lesson ID:** REC-S004
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox; disposable host images
- **Evidence class:** implementation / reference-host interruption tests
- **Status:** documented finding
- **Question or previous assumption:** Can a recorded progress counter authorize resuming a six-LUN write?
- **Finding:** Progress is not authority. Reopening checks retained private journal files, complete mirror coverage/content, all image identities, protected bytes and actual changed-range bytes. Only original, desired or the expected before/after mixture permits recovery. Unrelated divergence, a corrupt mirror or changed inode refuses resume and rollback. Once rollback starts, its direction cannot be reversed. Staging cancellation requires every target to remain original.
- **Evidence:** Actual child SIGKILL during payload application, independent torn GPT byte fixtures, missing-ROM recovery, failed-staging cancellation and terminal-state refusal in [native tests](../../recovery-uke-ofox/tests/ure/stock_job.cpp). [CLI checks](../../recovery-uke-ofox/tests/check-stock-job.sh) validate exact confirmation and options against the real executable.
- **Practical consequence:** Synchronize intent before bytes and verify chunks after synchronization. Require explicit inspected recovery and a persistent journal; preserve the owner's forced-reboot requirement from REC-L002.
- **Remaining uncertainty:** Host SIGKILL and manually torn image bytes are not a tablet forced reboot or proof of UFS flush ordering.
- **Next validation:** Add an exact-CLI persistent guest-reset test for this stock candidate; subsequently validate shipping-kernel/UFS behavior independently.
- **Supersedes / superseded by:** No earlier generic partition VM result is relabeled as a stock-job reset test.

## REC-S005: model and SKU choices must expose evidence boundaries

- **Lesson ID:** REC-S005
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox CLI / GUI; Global source profile
- **Evidence class:** source / actual GUI callback tests
- **Status:** documented finding
- **Question or previous assumption:** Does testing both commercial model names and two synthetic capacities establish model/SKU compatibility?
- **Finding:** No. The planner exposes model/SKU as declarations and keeps identity, SKU capacity, Android boot compatibility, physical-test and live-write readiness flags false. The actual management callbacks review all six measured image capacities, explicit A/B destinations, reset/zero choices, protected tails and staging budget. Changed choices invalidate confirmation; a changed recovery journal requires a fresh bound inspection.
- **Evidence:** [GUI callback tests](../../recovery-uke-ofox/tests/ure/stock_gui.cpp), source-built stock pages in [maintainer XML](../../recovery-uke-ofox/src/device/xiaomi/uke/maintainer.xml), and the extracted ramdisk audit. Both model declarations, one/both slot sets, data-reset refusals and complete six-LUN rollback are covered by host fixtures.
- **Practical consequence:** Keep Pad 7 and POCO Pad X1 acceptance separate. Only the independently verified Global source profile is compiled; CN and other firmware need their own reviewed catalogs and tests. No action switches the active slot implicitly.
- **Remaining uncertainty:** No rendered tablet GUI, display/touch/input test or exact model/SKU/firmware hardware record exists.
- **Next validation:** Render/review the workflow and obtain model/SKU-specific capacity, slot, firmware and boot evidence before live acceptance.
- **Supersedes / superseded by:** Supersedes no physical-support record; neither declaration is promoted to a hardware profile.

## REC-S006: failed fixtures should be corrected without relaxing guards

- **Lesson ID:** REC-S006
- **Date:** 2026-10-03
- **Environment scope:** host GCC/Clang tests / extracted ARM64 QEMU-user runner
- **Evidence class:** failed build/test trials / corrected reference-host and emulation tests
- **Status:** corrected
- **Question or previous assumption:** Were initial development failures evidence that production bounds or compiler flags should be weakened?
- **Finding:** No. A fixture helper named `write` resolved to POSIX `write` for a string literal; it was renamed `put_bytes`. Reference-helper name parameters use value `string_view` after compiler lifetime diagnostics. A GUI statement was split to resolve misleading indentation. A 20 MiB fixture read exceeded the intentional 4 MiB API bound and was replaced with private 64 KiB streaming plus an independent checksum. CLI stdout assertions now use the established `.data` envelope, while saved plans remain raw JSON. The QEMU-user fixture initially tried creating a temporary directory inside its read-only project mount; its disposable files now use `/tmp`.
- **Evidence:** Retained private first-failure logs for the bounded-read, CLI-envelope and read-only-fixture trials; corrected source/tests and final build/test identities in the [reviewed build report](../../recovery-uke-ofox/reports/URE-STOCK-JOB-BUILD.md). The failed QEMU trial had not created its stock fixture or written a stock target.
- **Practical consequence:** Keep warnings-as-errors, native read bounds and the read-only project sandbox. Rerun source-bound verification after the host-script correction; do not reuse an older input receipt as current evidence.
- **Remaining uncertainty:** Fixture corrections do not establish hardware acceptance or improve the shipping kernel's capabilities.
- **Next validation:** Preserve exact final native/sanitizer input hashes, extracted CLI identity and package checksums with this checkpoint.
- **Supersedes / superseded by:** Corrects these unsuccessful fixture trials only; their failure evidence remains retained privately.

## REC-S007: a new CLI needs new build and emulation receipts

- **Lesson ID:** REC-S007
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox Android 16 / host sanitizers / QEMU-user / package
- **Evidence class:** build / package / emulation
- **Status:** documented finding
- **Question or previous assumption:** Can the sealed partition candidate's successful generic guest reboot establish the new stock candidate's reset behavior?
- **Finding:** No. The new source has 21 native CTest executables and source-bound ASan/UBSan/leak checks. Its AArch64 recovery/CLI/GUI build uses the preserved stock kernel. The actual compressed ramdisk audit verifies source/staging agreement, ELF closure, embedded archives, privacy and absence of Python, then runs the extracted ARM64 CLI's stock workflow. This QEMU-user result uses host-backed regular images; the new candidate keeps generic VM records null.
- **Evidence:** [build report](../../recovery-uke-ofox/reports/URE-STOCK-JOB-BUILD.md), [strict candidate gates](../../recovery-uke-ofox/scripts/describe-prerelease.sh), recursive [payload auditor](../../recovery-uke-ofox/scripts/audit-recovery-image.sh) and the earlier separately sealed `ure-partition-job-alpha` candidate from REC-L007.
- **Practical consequence:** Preserve earlier artifacts and their receipts. Seal the new candidate only after fresh native, sanitizer, extracted-payload and repeated-package gates agree. No tablet Python or new target runtime is introduced. The pinned host sanitizer still excludes vptr instrumentation because of the documented host runtime limitation.
- **Remaining uncertainty:** Fresh compilation is not independently reproducible compilation. QEMU user is not guest reset, UFS, physical GUI or Android stock boot. Btrfs remains disabled in the shipping stock kernel; FBE still requires installed KeyMint/TEE trust.
- **Next validation:** Keep live writer/model/SKU/forced-reboot acceptance as the next ordered work; retain independent kernel, FBE and physical gates.
- **Supersedes / superseded by:** Extends REC-L007 with a different candidate and bounded evidence; preserves its earlier exact-CLI generic guest-reset result.
