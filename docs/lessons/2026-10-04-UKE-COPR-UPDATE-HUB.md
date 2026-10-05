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
- **Remaining uncertainty:** Kernel SCM build 11074370 and queued `1.1` build 11074417 subsequently succeeded. The later fresh-install builtin timestamp correction is tracked by UKE-K729-L014; a webhook receipt alone is insufficient.
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

## UKE-PKG-L007 — screenshot priorities require real Uke source families

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Current Nabu COPR source inventory, GitHub and Uke Rawhide source factories.
- **Evidence class:** Reference inspection, original source/package implementation and local extracted RPM tests.
- **Status:** Four additional real source families registered with automatic rebuilds; native and full target acceptance pending.
- **Question or previous assumption:** Renaming every Nabu binary or enabling a scaffold's webhook produced a qualified Uke counterpart.
- **Finding:** The user's screenshot prioritizes core metas, desktop metas, Material Decoration, Plymouth and firmware. The current reference project is `mcc45tr/nabu-linux`. Its core and desktop specs contain Nabu firmware, boot, panel, calibration and service assumptions. Independent Uke core/stock-Plasma selection RPMs now use explicit candidate profiles. Plymouth is an original optional renderer-size-aware theme with no boot activation. Material uses the published `26-09-18` upstream release, commit `7bf62f142c17902f4afe04d0be408b5dfef27982`, archive SHA-256 `06450723b575cf848576fe0f65960d2e7a876c41241fe0a289f244eab96ef328`, retaining GPL/LGPL and the attributed small KPlugin metadata correction. Local core/desktop/theme RPM payloads passed architecture, no-scriptlet, Python and privacy checks. Existing Fedora PowerDevil/Plymouth engines remain shared dependencies.
- **Evidence:** Component Make/spec/profile/lock files, current COPR inventory, local source/package audit and the firmware repository's `ADMISSION-2026-10-05.json`.
- **Practical consequence:** Source roles transfer; hardware assertions do not. Firmware cannot enter COPR without a file-level Uke source/hash/license/kernel-request allowlist. No empty firmware package or Nabu blob substitute is published.
- **Remaining uncertainty:** Package solving, native decoration compilation, theme rendering and all Uke hardware gates are separate. The firmware admission record describes missing project evidence, not proof that redistributable firmware cannot exist.
- **Next validation:** Complete native builds and signed target install/upgrade/remove and closure audits; qualify exact firmware files independently.

## UKE-PKG-L008 — one root source factory and one push hook per shared repository

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Two desktop source families sharing one GitHub repository.
- **Evidence class:** Failed source jobs, corrected remote SRPM collection and webhook observations.
- **Status:** Corrected source factories collected both SRPMs; binary jobs queued.
- **Question or previous assumption:** COPR's source factory follows its configured package subdirectory, and each source family needs its own GitHub push hook.
- **Finding:** Jobs 11075047/11075048 and repeated 11075049/11075050 failed before SRPM collection: COPR selected repository-root `.copr/Makefile` while working inside each package subdirectory. One root dispatcher now validates the package directory and invokes ordinary source generation; replacement 11075055/11075056 collected both complete SRPMs. Two hooks on the same repository created duplicate matching source builds, including 11075057/11075058. One redundant push hook was removed; the remaining hook serves both source families. Healthy native jobs were not cancelled.
- **Evidence:** Public source command/logs, root source dispatcher, safe hook IDs/configuration and replacement source RPM URLs.
- **Practical consequence:** COPR source-generation paths and actual result collection are tested separately. Repositories sharing multiple source families need a single project push event; per-package custom hooks remain available for stable tracking.
- **Remaining uncertainty:** Removing the duplicate hook is not inferred to cancel existing jobs. Native compilation and target acceptance must be collected independently.
- **Next validation:** Verify the corrected jobs and a subsequent single push event, and retain failed trials as historical evidence.

## UKE-PKG-L009 — native stable decoration needs current Qt imports

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Published Material Decoration stable source and native Rawhide AArch64 COPR.
- **Evidence class:** Failed native CMake trials, corrected source patch and real signed binary audit.
- **Status:** Corrected native job 11075084 succeeded; plugin payload/ELF checks passed.
- **Finding:** Jobs 11075055/11075057 failed because the current KF6 exported an
  I18n QML dependency without a declared Qt QmlIntegration target. A separate
  attributed CMake patch and official Qt declarative BuildRequires correct the
  imports. The first local diff hunk count was rejected; a corrected zero-fuzz
  patch passed preparation, followed by a whitespace-context correction before
  publication. The resulting `20260918.151422-2.uke.fc46` RPM has real AArch64
  decoration and KCM plugins. Signed package and extracted Python/privacy audits
  passed. A first audit assumed a generic KCM directory and stopped on its
  missing glob; the corrected audit uses the RPM's actual
  `org.kde.kdecoration3.kcm/materialdecoration_kcm.so` and passes.
- **Practical consequence:** Stable source, preparation, binary import resolution,
  actual installed paths and complete runtime closure are distinct gates.
- **Remaining uncertainty:** The complete selected graphical runtime and plugin
  rendering remain separate; no tablet display or boot success is inferred.
- **Next validation:** Complete the corrected Python-free dependency transaction.

## UKE-PKG-L010 — complete Plasma closure requires six native source variants

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Isolated AArch64 full desktop transaction, 600 official RPM file lists, host C++ fixtures and native COPR.
- **Evidence class:** Failed dependency acceptance, extracted metadata, native source implementation and explicit corrections.
- **Status:** Initial complete desktop transaction rejected; native variant validation in progress.
- **Finding:** The original complete Plasma transaction installed six Python
  packages through at-spi2-core, GStreamer, libaccounts-glib, libwacom and
  plasma-workspace-libs. A full RPM file-list audit also found Dolphin's two
  Python migrations without a declared interpreter dependency. Six exact
  official Koji source RPMs are now pinned by NEVRA/hash. Optional GI overrides,
  host documentation/debugger utilities and Python Wacom helpers are excluded;
  required Plasma/Dolphin configuration migrations have attributed atomic C++
  replacements. Host fixtures passed transformations, permissions, idempotence
  and malformed/symlink rejection. These are real source recompilations, not
  binary RPM conversions. Unavoidable upstream Meson/GI/Python build tools have
  purpose, official host pins and exclusion documented before native use.
- **Correction evidence:** Job 11075173 failed because the pinning adapter replaced
  `BuildRequires: meson gcc` as a whole and removed GCC. The adapter now retains
  every original requirement and adds exact host pins separately. An initial
  diagnosis incorrectly blamed the inherited spec; the component lesson records
  its explicit correction. Job 11075171 compiled C successfully but the whole
  BUILDROOT audit found optional Python GDB helpers in the SDK; release `1.uke2`
  removes those helpers as well. Healthy KDE jobs are retained while corrected
  failed source families are queued.
- **Practical consequence:** Core release 2 conflicts with the Python ABI and
  interpreter packages; Plasma release 2 requires all six native capabilities.
  This fails safely on changed dependency graphs. An audit must also inspect
  undeclared scripts, every generated subpackage and ELF dependencies. The host
  payload scanner now requires readelf and rejects unreadable ELF rather than
  treating a missing inspection tool as a clean target.
- **Automation:** COPR source records enable rebuilds. One shared GitHub push hook
  serves the source repository; an explicit Actions workflow requests all six
  native builds for shared adapter/manifest changes. The custom hook base lives
  only in an encrypted secret. Native Fedora pins require reviewed updates;
  Material/kernel/recovery stable tracking remains separately scoped.
- **Remaining uncertainty:** Full corrected signed runtime installation, upgrade,
  removal and graphical/hardware qualification remain required. No rejected
  transaction is relabeled as accepted and no firmware blob is inferred from a
  device-tree filename.
- **Next validation:** Complete native binary builds, then audit the entire
  resolved target before installing it in a clean userspace test environment.
