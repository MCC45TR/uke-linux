# 2026-10-04: Uke COPR, recovery delivery and stable source tracking

## UKE-PKG-L001 — package families need Uke admission

- **Date:** 2026-10-04 (UTC).
- **Environment scope:** GitHub component repositories and Fedora COPR inventory.
- **Evidence class:** Source/catalog and GitHub host CI; no hardware execution.
- **Status:** Initial repositories published and manifest checks passed.
- **Question or previous assumption:** Every Nabu COPR package could be copied into Uke.
- **Finding:** The current Nabu inventory has 20 source-package families. Eleven additional Uke repositories now cover core metas, sensors, boot, platform runtime, desktops, camera, firmware, KCM and provenance. Kernel channels and shared upstream packages retain explicit admission gates. All eleven initial GitHub validation jobs passed. A twelfth new repository implements real recovery image delivery.
- **Evidence:** `manifests/package-catalog.json`, component manifests, public GitHub repository heads and their validation workflows.
- **Practical consequence:** Missing Uke payloads fail their `srpm` target and are not registered as broken COPR builds. Firmware licensing, SSC/IIO mapping and boot profiles remain Uke-specific work.
- **Remaining uncertainty:** Initial source structure proves no sensor, desktop, camera, firmware or boot support.
- **Next validation:** Implement each real Uke payload and audit its target dependency closure before admitting automatic publication.

## UKE-PKG-L002 — recovery DNF updates deliver explicit image data

- **Date:** 2026-10-04 (UTC).
- **Environment scope:** OrangeFox published alpha and Rawhide AArch64 packaging.
- **Evidence class:** Release source metadata, real RPM/SRPM and QEMU userspace transactions.
- **Status:** Delivery build and local install/upgrade/removal passed.
- **Question or previous assumption:** Current recovery source and the downloadable image had identical features and stable status.
- **Finding:** The published release is `r12.0-uke.20260930-alpha1`, source `96e49e0e602de7b3b734bc07e305efca7bcab0e5`, Global OS3.0.303.0 profile. It remains a prerelease without physical boot or rollback acceptance. The delivery RPM installs IMG/ZIP files and their manifests as data, with no scriptlets or device-writing service. Its real upgrade from `1.fc46` to `1.1.fc46` preserved checksummed images and added pinned standard license texts; removal cleared the version directory.
- **Evidence:** `uke-orangefox-packaging/manifests/release-lock.json`, `reports/RECOVERY-RAWHIDE-2026-10-04.json`; successful first COPR build [11074344](https://copr.fedorainfracloud.org/coprs/build/11074344).
- **Practical consequence:** DNF updates delivered recovery files without executing their installer. Corresponding source snapshots and standard GPL/Apache/MIT/BSD texts accompany the source offer.
- **Remaining uncertainty:** This package rebuilds delivery from published artifacts, not a fresh complete OrangeFox source build. The stock OS2 inventory does not establish OS3 image compatibility.
- **Next validation:** Complete the corrected SCM delivery build and independently qualify the exact firmware/device before any authorized boot test.

## UKE-PKG-L003 — a nonempty decoded ramdisk is a required audit input

- **Date:** 2026-10-04 (UTC).
- **Environment scope:** Host extraction of Android boot-header-v4 alpha images.
- **Evidence class:** Failed host trials and corrected extracted-payload checks.
- **Status:** Corrected checks passed for both image sections.
- **Question or previous assumption:** A file named `ramdisk.gz` contained gzip data, and an empty directory could serve as a payload audit.
- **Finding:** The 33,978,937-byte ramdisk is legacy LZ4. The first gzip/cpio pipeline lacked fail-fast handling and left an empty directory; that apparent empty-directory scan is invalid evidence. The corrected pipeline used `set -Eeuo pipefail`, pinned official host LZ4 tools, checked archive paths and required `system/bin/recovery`. A first `sbin/recovery` assertion also failed because the published payload uses `system/bin`. Both image sections matched ramdisk SHA-256 `9ee6321fcd5df7b92077e0f90706b2227eb8576f1c125de65fc2dae5ee91d471`.
- **Evidence:** Android-v4 header fields, public manifest, 3,708 extracted regular files, `make audit` and separate target Python/privacy gates. ZIP integrity also passed.
- **Practical consequence:** Decode failure or an empty target stops the audit. No target executable or installer runs during inspection.
- **Remaining uncertainty:** Static archive and ELF inspection do not prove recovery startup, kernel reproduction or physical operation.
- **Next validation:** Apply the same nonempty extraction and hash gates to each new accepted release.
- **Supersedes / superseded by:** Explicitly invalidates the initial empty-directory audit attempt; only corrected extraction is accepted.

## UKE-PKG-L004 — source automation needs actual COPR result collection

- **Date:** 2026-10-04 (UTC).
- **Environment scope:** GitHub push hooks and COPR Fedora source-generation mock.
- **Evidence class:** Real webhook delivery and failed remote source result collection.
- **Status:** Failure recorded; corrected source export passed remote collection for both packages.
- **Question or previous assumption:** Successful local `make srpm` guaranteed COPR could collect the results.
- **Finding:** GitHub push delivery returned HTTP 200 and created job [11074362](https://copr.fedorainfracloud.org/coprs/build/11074362). Source generation completed, but collection failed with permission denied on `rpmbuild/gnupg`, whose deliberate mode 0700 excluded the unprivileged collector. `.copr/Makefile` now keeps intermediate verification/payload state under the source workspace and exports only mode-0644 SRPM files to COPR's result directory. The same correction applies to recovery delivery.
- **Evidence:** Public job 11074362 source log and both project-owned `.copr/Makefile` files; HTTP-200 webhook receipts and package `auto_rebuild=true` settings. Replacement kernel source job 11074370 collected its SRPM and reached native compilation; recovery SCM job 11074373 succeeded end to end.
- **Practical consequence:** Never weaken the GPG home's permissions to make it a build result. COPR source-generation and binary-build acceptance remain separate.
- **Remaining uncertainty:** Replacement kernel native compilation remains in progress at this observation; a webhook receipt alone is insufficient.
- **Next validation:** Inspect the replacement SCM jobs and retain their exact source RPM and package identities.

## UKE-PKG-L005 — stable tracking rejects disguised alphas

- **Date:** 2026-10-04 (UTC).
- **Environment scope:** GitHub stable-release workflow and host metadata fixtures.
- **Evidence class:** Live API polling and negative host tests.
- **Status:** Live alpha-only skip and three rejection cases passed.
- **Question or previous assumption:** A non-prerelease GitHub flag alone admitted a stable recovery artifact.
- **Finding:** No stable recovery release exists at this checkpoint. The tracker keeps the explicit alpha pin. Invalid new tags, missing assets and a real alpha manifest relabeled by metadata as stable are rejected before changing the lock. A first invalid-tag fixture accidentally reused the already-pinned tag, correctly exercising the unchanged-pin skip instead of rejection; the corrected new-tag fixture passed. The target scan initially rejected nano's `python.nanorc` syntax data; matching the runtime/script policy instead of every `python*` filename corrected that false positive.
- **Evidence:** `make track-stable` against the live API; alpha-only and invalid-tag/missing-assets/disguised-alpha fixtures; unchanged lock hash; final `make audit`.
- **Practical consequence:** Stable source fetches need exact hashes, all image/evidence assets, corresponding source snapshots, approved firmware and real payload audits. Unsupported kernel stable versions also stop until their reviewed Uke profile exists.
- **Remaining uncertainty:** There is no real stable recovery to exercise positive stable advancement; fixture checks do not constitute a published stable release.
- **Next validation:** Run the complete stable advancement path when the first qualifying project stable release is published.

## UKE-PKG-L006 — remote signatures, config probes and generated indexes differ in scope

- **Date:** 2026-10-04 (UTC).
- **Environment scope:** Native COPR AArch64 kernel packages and isolated Rawhide userspace.
- **Evidence class:** Remote compilation, signed RPM inspection and corrective package tests.
- **Status:** First builds/signatures/payload passed; corrected index verification passed locally.
- **Question or previous assumption:** Native COPR config and installed file timestamps had to be byte-identical to the local cross-build.
- **Finding:** First kernel job [11074297](https://copr.fedorainfracloud.org/coprs/build/11074297) produced all four packages and its SRPM. All 1,146 extracted modules are AArch64, share `7.2.9-senemos-uke SMP preempt mod_unload aarch64` vermagic, and pass dependency/symbol checking. Config differs only in native `CC_CAN_LINK` and host `PAHOLE_VERSION` probes; requested kernel/platform/Fedora settings match. An audit first incorrectly required `modversions` in vermagic and omitted the extraction root's `/lib -> usr/lib` layout; corrected checks use the actual ABI and Fedora filesystem layout. First remote installation then exposed only timestamp differences in depmod-generated indexes. Release `1.1.fc46` marks those indexes `%verify(not mtime)`, retaining content checks, and passes the local offline lifecycle. The first kernel and recovery RPM/SRPM signatures verify against project key fingerprint `DAFC3C5A881FB49C7167EE2D6F772E3D487BD13E`.
- **Evidence:** Public build IDs, corrected extracted ABI audit, local final build/lifecycle manifest and isolated `rpmkeys --checksig` results.
- **Practical consequence:** A same-version packaging fix needs an increasing release so DNF can deliver it. Keep tool capability differences and regenerated metadata explicit rather than claiming binary reproducibility.
- **Remaining uncertainty:** Neither signatures, config, module ABI nor QEMU userspace transactions run the Uke kernel or establish physical hardware support.
- **Next validation:** Verify corrected SCM artifacts and DNF repository transactions, then separately qualify firmware handoff and tablet boot.
