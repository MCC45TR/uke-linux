# 2026-10-03: source-derived stock boot programming checks

## REC-P001: a larger DTBO partition also needs AVB layout evidence

- **Lesson ID:** REC-P001
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox / Global OS3.0.303.0.WOZMIXM sources
- **Evidence class:** source / host reconstruction / read-only host inspection
- **Status:** corrected
- **Question or previous assumption:** Is replacing the 24 MiB whole-partition checksum with the 20 MiB source-prefix checksum sufficient to repair the older DTBO preflight mismatch?
- **Finding:** A prefix-only check would leave the partition-end AVB metadata and gap unverified. Pinned AOSP fastboot preserves a raw source with an AVB footer, extends a fresh temporary file to the larger physical partition, and duplicates the footer at its end. For the verified 20 MiB DTBO source and 24 MiB OEM GPT capacity, this source-derived whole-partition layout hashes to `9e55ff8afdf178e424187f0dc7d6dd2fa570308e22d8df7ac895d65017dbc0d7`. It is a canonical source reconstruction, not a physical stock dump or proof of the installed flashing path.
- **Evidence:** Local `system/core` revision `1efa79514b2f520c20a837c9216ff6b6e7e0dda3`, fastboot.cpp `copy_avb_footer`; [AOSP fastboot](https://android.googlesource.com/platform/system/core/+/1efa79514b2f520c20a837c9216ff6b6e7e0dda3/fastboot/fastboot.cpp); `external/avb` revision `5ac0c3a071d811846a62412383dd6e259f341e6e`, [footer structure](https://android.googlesource.com/platform/external/avb/+/5ac0c3a071d811846a62412383dd6e259f341e6e/libavb/avb_footer.h); [generated catalog](../../recovery-uke-ofox/manifests/stock-boot-programming-global.json). Independent Bash reconstruction and actual installer helper tests verify the digest without executing fastboot or an OEM program.
- **Practical consequence:** Keep exact 24 MiB geometry and a whole-partition hash, including the zero gap and duplicated final footer. Store source length/hash and partition length/hash as different policy fields. Do not normalize, pad or repair an existing partition to make verification pass.
- **Remaining uncertainty:** Another installed Uke tail policy remains refused. Neither Pad 7 nor POCO Pad X1 has an accepted model/SKU/firmware dump, and the common storage writer remains disabled.
- **Next validation:** Obtain exact model/SKU/firmware and measured installed DTBO layout evidence, then validate authoritative preflight independently of this source-derived candidate.
- **Supersedes / superseded by:** Supersedes the still-unfixed source/capacity hash contract documented by REC-L006 and REC-S002 for the current source only. Their dated findings and earlier sealed binaries remain unchanged. No physical result is superseded.

## REC-P002: embedded metadata is not installed Android trust

- **Lesson ID:** REC-P002
- **Date:** 2026-10-03
- **Environment scope:** Global DTBO source / pinned host AVB inspection
- **Evidence class:** source / read-only host tool result
- **Status:** documented finding
- **Question or previous assumption:** Does a parsed OEM DTBO footer prove an installed AVB or KeyMint/TEE security chain?
- **Finding:** No. Pinned host avbtool reports footer version 1.0, original DT extent 592,007 bytes, embedded vbmeta offset 593,920, size 640 and algorithm NONE for this one DTBO source. The source is still exactly bound by its verified ordinary SHA-256. These embedded fields do not establish whole-firmware AVB policy, installed keys, rollback acceptance, encryption access or tablet boot.
- **Evidence:** Read-only avbtool info_image on the verified OEM source from archive SHA-256 `f811ae6255b7535d32f80548d800487a6494a87ddb4cca592799337fab24cd0d`; [operation contract](../../recovery-uke-ofox/docs/STOCK-BOOT-PREFLIGHT.md) and [build record](../../recovery-uke-ofox/reports/URE-STOCK-PREFLIGHT-BUILD.md). The existing pinned host-only tool purpose is documented in [HOST-TOOLS.md](../../recovery-uke-ofox/docs/HOST-TOOLS.md).
- **Practical consequence:** Use native whole-partition source-derived checks on the tablet, retain the independent installed KeyMint/TEE gate and never introduce tablet Python. Keep firmware, commercial model, SKU and physical results separate.
- **Remaining uncertainty:** No installed AVB chain or Android FBE access has been accepted. An embedded release fingerprint is not an installed OS-version measurement.
- **Next validation:** Inspect the exact installed boot/security chain after device identity and firmware provenance are established; preserve the independent trust gate.
- **Supersedes / superseded by:** No installed trust or physical-support result is superseded.

## REC-P003: complete programming checks must detect gap and footer corruption

- **Lesson ID:** REC-P003
- **Date:** 2026-10-03
- **Environment scope:** actual installer helpers / native preflight policy / disposable host files
- **Evidence class:** implementation / reference-host tests
- **Status:** documented finding
- **Question or previous assumption:** Can only source-content corruption tests establish the corrected whole-partition policy?
- **Finding:** The host installer fixture independently copies the pinned source, leaves a fresh zero gap and writes the source footer at the larger partition end. The actual `require_stock` helper accepts the reviewed complete checksum and refuses an altered DT byte, a nonzero gap byte, a changed end footer or truncation. Its original source-prefix checksum still matches before corruption but is explicitly different from the complete checksum. Native fixtures compare all five compiled boot policies with the independently generated catalog.
- **Evidence:** [actual installer test](../../recovery-uke-ofox/tests/installer_test.cpp), [native pin/catalog checks](../../recovery-uke-ofox/tests/ure/image_ranges.cpp), [Bash reconstruction/refusal check](../../recovery-uke-ofox/tests/check-stock-boot-programming.sh). Production block-device selection and writes are not invoked by these fixtures.
- **Practical consequence:** The installer and common preflight use the same named whole-partition policy. Continue hashing exact partition capacity and retain slot, merge, fallback and host-refusal tests. A failed tail check provides no authority to rewrite the partition.
- **Remaining uncertainty:** Host regular-file helpers do not establish UFS reads, live writer correctness or forced-reboot durability. Neither tablet's installed layout has been measured.
- **Next validation:** Run the strict source-bound host/sanitizer gates and inspect the compiled ARM64 policy, then validate real installed read-only preflight before any live write acceptance.
- **Supersedes / superseded by:** Corrects the checksum scope without relaxing geometry or introducing a prefix-only exception.

## REC-P004: fixture-input manifests must include standalone test bodies

- **Lesson ID:** REC-P004
- **Date:** 2026-10-03
- **Environment scope:** host verification / OrangeFox build/package
- **Evidence class:** provenance inspection / corrected build and test inputs
- **Status:** corrected
- **Question or previous assumption:** Did hashing the standalone installer runner also bind its included C++ test body in the narrow native receipt?
- **Finding:** The narrow manifest included check-installer.sh but omitted installer_test.cpp. Earlier source archives and complete PROJECT-INPUTS.sha256 included the test body; their evidence remains intact. The new native input manifest explicitly hashes that body, the independent programming-catalog recipe/check and the reviewed generated catalog. Fresh receipts are required after this addition.
- **Evidence:** [input manifest generator](../../recovery-uke-ofox/scripts/native-inputs.sh), [native runner](../../recovery-uke-ofox/tests/run-native.sh), [candidate gates](../../recovery-uke-ofox/scripts/describe-prerelease.sh) and reviewed build/artifact records. The extracted CLI and installer are checked for the new compiled whole-partition pin, without inventing runtime or device success from a string check.
- **Practical consequence:** Seal this work as a separate candidate with fresh input-bound native/sanitizer receipts and a new ARM64 build/payload audit. Preserve the sealed six-LUN and combined-partition candidates. Do not attach their different-CLI reset records to this build.
- **Remaining uncertainty:** QEMU user is host-backed image execution; compiled policy markers establish build inclusion only. Exact UFS, physical model/SKU, rendered GUI and stock boot remain untested.
- **Next validation:** Verify the new candidate's complete checksums and source identity; continue the ordered live writer/model/SKU/forced-reboot work without opening the unaccepted backend.
- **Supersedes / superseded by:** Extends the narrow native-receipt coverage for current source; does not overwrite earlier project-input hashes, archives or dated results.
