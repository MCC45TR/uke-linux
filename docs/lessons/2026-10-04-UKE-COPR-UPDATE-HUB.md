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
- **Further scope evidence:** The signed Plasma runtime binaries from 11075200
  passed Python/privacy checks. Its optional `-doc` HTML subpackage triggered
  the conservative path scan on public upstream Klipper tutorial examples, not
  a leaked build/owner identity; it is excluded from the admitted tablet runtime.
  Dolphin's embedded optional manuals were similarly classified, excluded from
  its lean `1.uke2` runtime and retained in complete source. Native job 11075201
  passed the corrected signed payload gate. Offline transaction preparation
  first failed on an incorrect assumed Fedora key path, then correctly stopped
  because the reused 600-RPM download cache lacked the external OpenH264
  provider. Neither failed source plan installed the desktop. The key is
  obtained from official Fedora source and matched to the already present
  Rawhide fingerprint; missing official dependency inputs must be completed
  before replay, with no skip-broken or dependency-policy bypass.

## UKE-PKG-L011 — validate deferred inputs and nonempty records before replay

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Frozen official/COPR RPM cache and isolated Rawhide AArch64 userspace.
- **Evidence class:** Failed preparation trials, complete source-deferred transaction and host extracted payload audit.
- **Status:** Exact 603-RPM transaction stored and audited before installation.
- **Finding:** `dnf install --store` resolves and copies the exact signed inputs
  without installing the desktop. The recovered official cache needed one
  missing OpenH264 provider. After completing that official input, all 603
  signatures, dependency names/Requires and complete extracted payload passed
  the no-Python gate. The optional Plasma HTML documentation subpackage is not
  in the selected tablet runtime. The corrected native runtime packages retain
  ordinary UI translations and upstream sources/licensing.
- **Record correction:** An initial attempt embedded raw JSON braces in RPM's
  query-format grammar. RPM printed a format diagnostic while returning zero,
  producing empty JSON input; an empty lock is invalid evidence. The corrected
  generator reads explicit TSV fields, JSON-escapes them with jq, requires
  nonempty fields and exactly 603 records, and checks every SHA-256. The invalid
  draft was never published. Query exit status alone is insufficient when a tool
  can emit an empty successful result.
- **Practical consequence:** The public runtime lock records actual NEVRAs,
  licenses and hashes; the local transaction/root exports remain ignored test
  artifacts. A native source build, selected closure and installed root require
  their own gates. No skip-broken, ignore-installed or dependency bypass is used.
- **Remaining uncertainty:** Actual replay, meta upgrade, installed-root audit and
  removal remain separate required results. QEMU userspace fixtures do not
  establish a Plasma session, plugin rendering, Uke boot or physical support.
- **Next validation:** Replay the stored transaction with network disabled,
  inspect the installed root, execute native migration fixtures and complete
  actual signed meta-package upgrade/removal.
- **Completed bounded checks:** Offline replay, all six native capabilities,
  admitted RPM verification and real AArch64 C++ migration fixtures passed.
  Actual signed meta release-1 to release-2 upgrade and complete admitted
  package removal passed. These results are independent of complete-root
  acceptance, which was rejected by the next lesson.

## UKE-PKG-L012 — inherited base files are part of target acceptance

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Pinned Rawhide AArch64 base plus the complete 603-input desktop transaction.
- **Evidence class:** Failed full installed-root audit, RPM file ownership and native source correction.
- **Status:** Complete installed root rejected; seventh native runtime source build in progress.
- **Finding:** The selected 603 inputs contained no recognized Python payload.
  The installed-root scan nevertheless found 15 Python/PYC GDB helper files in
  the preinstalled `libstdc++-16.2.1-2.fc46.1`. The library declares no Python
  interpreter dependency; installed package-name checks therefore passed while
  the full file gate correctly failed. No complete desktop acceptance is claimed.
- **Correction:** `libstdcxx-uke-runtime` compiles the shared GNU C++ library from
  the exact official `gcc-16.2.1-2.fc46.1.src.rpm`, SHA-256
  `b8f6cc1f055a057233a3b807bf5e9cc2a43836c025ba664b1231c79d86271175`.
  Its standalone native build excludes debugger scripts from the installed
  selection and requires all 6,100 original versioned symbols plus a native
  C++ concurrency/exception/filesystem/ranges/calendar fixture. The complete
  source RPM is retained for provenance. Local SRPM generation, patch
  preparation and GitHub validation passed; real native job 11076609 is tracked
  separately. Host GCC/Python build-policy pins are documented before use.
- **Practical consequence:** Core candidate release 3 requires the native GNU
  C++ capability. The former seven-capability graphical candidate was
  superseded by the owner policy in L013; desktop release 3 is metadata only.
  Replacement must remove old RPM-owned helper files through an ordinary signed
  package upgrade, with no manual target file deletion or solver bypass.
- **Superseding scope:** Earlier kernel/recovery/core package payload and
  package-name checks retain their bounded results. They do not certify the
  entire inherited Fedora base as Python-free. Only a subsequent full root
  inspection can supersede this rejection.
- **Remaining uncertainty:** New native build, signatures, ABI, full corrected
  root and lifecycle remain required. QEMU userspace is separate from a KDE
  session, graphics, Uke boot and physical operation.
- **Next validation:** Accept the native library, publish the matching meta
  revisions, resolve a new signed transaction and repeat complete root and
  upgrade/removal tests.
- **Further native rejection:** Job 11076609 failed at final linking under
  generic RPM LTO flags. Clearing only `_lto_cflags` allowed 11076668 to link,
  but the unchanged ABI gate correctly rejected missing thread symbols. Its
  standalone configure probe lacked GCC's generated POSIX threading header.
  Preparation now creates that header and requires the thread macro before
  compiling. Job 11076770 tracks the corrected native trial; the 6,100-symbol
  baseline is not weakened.
- **Header and recursion correction:** Job 11076770 restored thread exports
  but rejected two standard-module exports after missing C fenv declarations
  made upstream compile empty module fallbacks. A host GCC 16.2.1 experiment
  reproduced 81 diagnostic lines with the default installed C++ header search,
  zero with `-nostdinc++`, and both real module initialization exports. Trial
  11076948 still failed because upstream clears `MAKEOVERRIDES` and drops the
  top-level CXX override. Forward isolation through its explicit CXXFLAGS path;
  retain all 6,100 symbols and require new native and complete-root evidence.

## UKE-PKG-L013 — original KDE applications take precedence over variant work

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Owner instruction, source contracts, GitHub workflow and COPR publication.
- **Evidence class:** Explicit policy correction and actual automation withdrawal.
- **Status:** KDE source records and seven completed derivative builds removed.
- **Finding:** The owner explicitly forbids cloning KDE desktop applications.
  The project therefore withdraws Plasma/Dolphin application variants, uses
  original distribution applications and rejects their derivative source
  targets before archive retrieval. Automatic source records were first
  disabled and then removed; active jobs 11076607, 11076665 and 11076667 were
  canceled because this new requirement supersedes their earlier build scope.
- **Practical consequence:** Five non-KDE runtime source families remain in the
  shared workflow. Existing variant outputs/logs/source are archived per build
  before active repository withdrawal. A draft archive that reused the same
  output directory could overwrite equal-NEVRA results from different jobs;
  corrected archives use one directory per exact build ID.
- **Withdrawal evidence:** Builds 11075174, 11075190, 11075200, 11075175,
  11075191, 11075201 and 11076608 were deleted only after per-ID RPM/SRPM and
  available-log archives were complete. A first source-count guard wrongly
  expected one SRPM; actual builds provide factory and native SRPMs, so it was
  corrected before any deletion. The oldest available builder log was fetched
  separately. Fresh COPR metadata contains no Plasma/Dolphin derivative binary
  names. Remote inventory has 11 records, all automatic, with neither KDE
  source name present. Both local source targets fail before build preparation.
- **Target scope:** Original Fedora KDE packages currently contain Python
  components incompatible with the separate target requirement. Complete KDE
  admission remains blocked; desktop release 3 supplies policy metadata and
  obsoletes the former derivative-dependent selection. No file deletion or
  dependency bypass is used to manufacture acceptance.
- **Remaining uncertainty:** Native console/GNU C++ acceptance is independent
  and continues. Neither earlier bounded desktop tests nor this policy change
  establishes a graphical session, Uke boot or physical support.
- **Next validation:** Verify disabled remote source settings, absent active
  derivative outputs, source rejection and compatible console lifecycle tests.

## UKE-PKG-L014 — accept the separate signed console root

- **Date:** 2026-10-05 (UTC).
- **Environment scope:** Native Rawhide AArch64 COPR and pinned AArch64 userspace
  under QEMU; GNU readelf/nm inspection in the separate host compiler container.
- **Evidence class:** Native compilation, signed payloads, complete inherited
  root, actual metadata upgrade and removal; no graphical or physical execution.
- **Status:** Console package/root gates passed. Original KDE admission blocked.
- **Finding:** Native GNU C++ trial 11076968 retained all 6,100 original versioned
  exports and passed its real native smoke test, then rejected an absolute
  Source3 pathname mixed with relative RPM license entries. Copying the exact
  Boost license into prepared source corrected packaging in build 11077014.
  Core/desktop policy metadata release 3 succeeded in 11077017/11077018.
- **Exact package evidence:** The 52-input console transaction has SHA-256
  `1a0e7140a45ef021bb7f99f49be23a069475687676a2b5d8aeae69f264691e22`.
  All signatures, dependency names and complete extracted Python/ELF payloads
  passed. Both fresh and actual signed release-2 to release-3 upgraded roots
  passed complete installed `usr/`/`etc/` scans and the unchanged GNU C++ ABI.
  Ordinary library upgrade removed all inherited optional Python helpers.
  The actual available official Python provider was rejected by core conflicts.
  Removing admitted metadata/kernel/recovery/theme records and payload passed
  in a separate immutable accepted snapshot; mandatory base libstdc++ stayed
  installed and verified. Exact binary/native-source/factory-source identities
  and local export hashes are in the public console report and 52-input lock.
- **Failed solver trial:** Rawhide refused the Fedora-to-COPR vendor transition.
  Initial installation explicitly uses `--allow-vendor-change` for the reviewed,
  signed native library. Dependency and interpreter conflicts remain enforced;
  no broken-dependency or RPM-owned-file deletion shortcut is used.
- **Excluded fixture mistake:** After successful upgrade, export and host audit,
  the test launcher accidentally restarted its old-baseline fixture on the same
  already-upgraded container. That restart downgraded only metadata and correctly
  stopped at the expected original-library helper assertion. It is excluded from
  acceptance. The successful pre-restart exported root was unchanged; removal
  used the immutable accepted fresh snapshot. A fixture restart is not evidence
  of another successful upgrade or a native package defect.
- **Superseding consequence:** The console result resolves L012's inherited GNU
  C++ gate for this exact selection. The historical 603-input desktop root stays
  rejected; L013's owner policy continues to prohibit KDE application derivatives.
  Eleven remaining COPR source families are automatic. Earlier KDE selection
  builds 11075045/11075167 were also withdrawn after archive and successful
  data-only replacement; active metadata contains no derivative selection.
- **Remaining uncertainty:** No Uke kernel boot, graphical session, image
  composition, firmware redistribution, rollback or peripheral acceptance ran.
- **Next validation:** Independently admitted Uke boot/firmware/storage profiles,
  physical validation and native rules/tests for later distribution formats.
