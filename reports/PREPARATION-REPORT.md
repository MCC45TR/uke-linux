# Preparation report — 30 September 2026

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

A subsequent neutral-path new-output build and reviewed incremental fixes
produce the [experimental public alpha](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases/tag/r12.0-uke.20260930-alpha1).
The final staged and extracted ramdisks pass privacy/Python scans, including the
remaining embedded certificate ZIP. The raw upstream dual-slot ZIP is withheld;
the project ZIP uses a static C++ installer with boot-stack hashes on both slots,
snapshot/identity/fallback checks, a volatile backup and active-slot-only write
verification. Three distinct assets repeat-package to identical hashes. AVB is
`NONE`, ZIP unsigned, and no device boot or stock return has been rehearsed.
The exact GKI source/config snapshot, identified Magisk utility source and
recursive dependencies, Android source pins and public artifact/file manifests
accompany the build. Generic firmware/security-write addons and font binaries
without established redistribution terms are omitted, not claimed supported.

China and Global rawprogram layouts are byte-identical, but their ramdisk/DTB
inputs remain separately pinned. Native-DTC decoding finds four base trees per
profile; it does not select the installed SKU/DTBO. Turkey full-OTA metadata
passes its declared SHA-256 check; payload extraction/signature verification is
still pending. The upstream Linux 7.2.8 ARM64 Image/1,847 DTBs and 1,655 modules
compile, strip/install locally and generate dependency indexes. This generic
baseline has no Uke DTB and cannot be used as the stock recovery's module ABI.

Publication checks inspect the complete Git index and the configured no-reply identity. Initial project-owned bootstrap commits were rewritten to remove personal author metadata and public home-directory paths. This updates branch history; it cannot guarantee removal of old objects from GitHub caches or existing clones. No credential or private firmware payload was intentionally published. This limited check is not a completed security audit.

COPR readback shows only Fedora Rawhide AArch64, network disabled for builds and no submitted builds. The channel does not contain tested kernel packages. CI runs the Bash host checks and publication guardrail; its actual run status is available in the repository's Actions view.

## Still pending

Independent offline archives for every project in the Android manifest, complete recursive donor submodule archives, full file-level license review and independent physical-device backups remain open. Global/CN stock layouts and base DTBs are measured; installed variants, DTBO selection and runtime module/vendor-boot dependencies remain unverified. The host build container, full package closure and dependency SBOM are not yet pinned.

No UEFI, Uke-bootable mainline kernel, RPM, rootfs or Fedora boot image has been produced. The recovery alpha is an experimental host-validated candidate, not a physically validated product. No physical device, flash, format, slot change, userdata mount or Android decryption test has been used. No complete security audit, performance baseline, battery measurement or OEM-quality acceptance is claimed.

Remaining offline work includes pristine pinned-checkout reproduction, Turkey
partition extraction, complete source dependencies, host package closure,
runtime/module ABI analysis, synthetic storage/restore tests and recovery UI
integration. Aloha platform work, Uke-specific mainline porting and Fedora
packaging remain separate engineering tasks; they are not made complete by
publishing the recovery alpha. Physical tests remain explicitly gated on a device.
