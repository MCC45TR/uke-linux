# Preparation report — 29 September 2026

## Delivered

The workspace now has four separately versioned component repositories, each with its own `referances/`, source/configuration/patch/test directories and ignored build/artifact/private-log areas. The root pins their commits and owns the shared source catalog, hardware evidence ledger and 100-step English plan.

- **50** source repositories cataloged at explicit commit pins, covering **60** selected refs.
- **50** repositories acquired with full reachable history for every locked ref.
- **50** Git object, bundle checksum and empty-directory offline restoration checks passed.
- **47** archives are self-contained at the Git-object layer. `orangefox-vendor` (1 submodule), `uke-linux` (19) and `aloha-platforms` (10) retain explicit submodule dependency records; their parent bundles do not silently claim to embed those repositories.
- Three Android vendor repositories include separately checksummed Git LFS object archives and passed offline object restoration.
- **143** hardware capabilities recorded with separate recovery, UEFI and Linux results; all own-device results remain not-tested.
- **34** minimum recovery feature groups mapped from six Nabu branches and **686** relevant source UI actions.
- Official OrangeFox `fox_16.0` / source R12.0 pinned, with the stale wiki-release distinction recorded.
- Uke recovery F2FS formatting, image layout, spoofed security metadata, settings placement and module ABI risks documented.
- Nearby tablet, same-family multiboot, postmarketOS and Aloha references cloned for source comparison.
- Xiaomi OEM kernel, device-tree, display, camera, audio and WLAN sources plus current/Lineage Uke device and vendor repositories are cloned, pinned and archived.
- The OrangeFox Android 16 checkout resolved to **399** clean projects after removing the Mondrian/SM84xx examples, retaining the Uke donor as a reference and explicitly resolving the OrangeFox theme gitlink. Exact commits are stored in a resolved manifest.
- The project-owned `device/xiaomi/uke` target is staged in the build checkout with the SHA-256-locked Global stock kernel. Android 16 accepts `lunch twrp_uke-bp2a-eng`; a first local OrangeFox recovery image has now compiled and is documented in [the build report](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/main/reports/FIRST-RECOVERY-BUILD.md).
- China and Global fastboot packages passed size and SHA-256 verification. The Turkey recovery OTA also passed pinned size, MD5 and SHA-256 verification. A bounded extractor preserved both raw fastboot archives and extracted **38** boot/GPT metadata entries from each without running stock flash scripts; the OTA remains an intact seven-entry payload reference.
- Five public GitHub repositories and the `mcc45tr/uke-linux-test` COPR channel created and read back.

## Validation performed

`bash tests/run.sh` passed 19 host checks: evidence validation, wrong-environment evidence rejection, duplicate/missing identities, archive restoration, path traversal, dirty-reference preservation, immutable pins, corrupt bundles, historical LFS, target Python entrypoints/symlinks, target build-identity/path privacy, staged-content privacy and 100 ordered plan steps.

`scripts/sources.sh verify` and `scripts/sources.sh restore-check` passed for all 50 cataloged references. Restores used file-only Git transport and matched commit/tree identities. Git LFS object tars were also restored and content-address verified for the three vendor sources. Missing nested dependencies remain visible rather than being declared complete.

The pinned host-only Android `repo` client synchronized the 399-project OrangeFox tree, and `repo status` reported a clean checkout. The resolved manifest locks each project revision, but this large build checkout is not represented as 399 independent offline bundles. That distinction remains an open reproducibility gate.

The project-owned Python helpers were replaced by Bash and jq. New native device applications target C++; Linux and EDK II retain upstream-required languages. All repositories carry the no-tablet-Python policy. The extracted-payload checker detects known Python file names, shebangs, symlinks and dynamic libpython dependencies; future build integration must also inspect package closure and compressed inputs before extraction.

The first successful recovery build followed two failed packaging attempts and a reviewed project-owned Makefile patch. A second build from an empty output directory completed successfully in 41 minutes 15 seconds; a pristine source re-sync and byte-for-byte reproducibility remain unverified. Image headers, ramdisk identities, ZIP integrity and absence of Python executables/scripts in both staged recovery roots were checked offline; no hardware result was inferred. A payload privacy scan found build-host identifiers and absolute paths in both runs, so the images and ZIPs remain private release-blocked artifacts.

Publication checks inspect the complete Git index and the configured no-reply identity. Initial project-owned bootstrap commits were rewritten to remove personal author metadata and public home-directory paths. This updates branch history; it cannot guarantee removal of old objects from GitHub caches or existing clones. No credential or private firmware payload was intentionally published. This limited check is not a completed security audit.

COPR readback shows only Fedora Rawhide AArch64, network disabled for builds and no submitted builds. The channel does not contain tested kernel packages. CI runs the Bash host checks and publication guardrail; its actual run status is available in the repository's Actions view.

## Still pending

Independent offline archives for every project in the Android manifest, complete recursive donor submodule archives, file-level license review and independent physical-device backups remain open. The Global stock layout is measured; CN boot/header/partition analysis is still pending even though its archive and bounded extraction are verified. The host build container, package closure and SBOM are not yet pinned.

No UEFI, mainline kernel, RPM, rootfs or Fedora boot image has been produced. The local recovery image has not been released or tested on either physical model. No physical device, flash, format, slot change, userdata mount or Android decryption test has been used. No complete security audit, performance baseline, battery measurement or OEM-quality acceptance is claimed.

The next implementation gate is to reproduce from a pristine pinned checkout, eliminate payload build-host metadata, complete the CN and Turkey boot/recovery analysis, pin the host toolchain and package closure, and audit module/vendor-boot dependencies. Project Aloha follows the recovery foundation.
