# Preparation report — 29 September 2026

## Delivered

The workspace now has four separately versioned component repositories, each with its own `referances/`, source/configuration/patch/test directories and ignored build/artifact/private-log areas. The root pins their commits and owns the shared source catalog, hardware evidence ledger and 100-step English plan.

- **45** source repositories cataloged at explicit commit pins.
- **29** preparation repositories acquired, covering **36** selected refs with full reachable history.
- **29** Git object, bundle checksum and empty-directory offline restoration checks passed again after moving the archives into their component directories.
- **26** archives have no detected missing submodule/LFS dependency. `orangefox-vendor` (1 submodule), `uke-linux` (19) and `aloha-platforms` (10) remain dependency-incomplete.
- **143** hardware capabilities recorded with separate recovery, UEFI and Linux results; all own-device results remain not-tested.
- **34** minimum recovery feature groups mapped from six Nabu branches and **686** relevant source UI actions.
- Official OrangeFox `fox_16.0` / source R12.0 pinned, with the stale wiki-release distinction recorded.
- Uke recovery F2FS formatting, image layout, spoofed security metadata, settings placement and module ABI risks documented.
- Nearby tablet, same-family multiboot, postmarketOS and Aloha references cloned for source comparison.
- Five public GitHub repositories and the `mcc45tr/uke-linux-test` COPR channel created and read back.

## Validation performed

`bash tests/run.sh` passed 17 host checks: evidence validation, wrong-environment evidence rejection, duplicate/missing identities, archive restoration, path traversal, dirty-reference preservation, immutable pins, corrupt bundles, historical LFS, target Python entrypoints/symlinks, staged-content privacy and 100 ordered plan steps.

`scripts/sources.sh verify` and `scripts/sources.sh restore-check` passed for all 29 locally acquired preparation references after migration. Restores used file-only Git transport and matched commit/tree identities. Missing nested dependencies remain visible rather than being declared complete.

The project-owned Python helpers were replaced by Bash and jq. New native device applications target C++; Linux and EDK II retain upstream-required languages. All repositories carry the no-tablet-Python policy. The extracted-payload checker detects known Python file names, shebangs, symlinks and dynamic libpython dependencies; future build integration must also inspect package closure and compressed inputs before extraction.

Publication checks inspect the complete Git index and the configured no-reply identity. Initial project-owned bootstrap commits were rewritten to remove personal author metadata and public home-directory paths. This updates branch history; it cannot guarantee removal of old objects from GitHub caches or existing clones. No credential or private firmware payload was intentionally published. This limited check is not a completed security audit.

COPR readback shows only Fedora Rawhide AArch64, network disabled for builds and no submitted builds. The channel does not contain tested kernel packages. CI runs the Bash host checks and publication guardrail; its actual run status is available in the repository's Actions view.

## Still pending

The 16 larger implementation references are cataloged but not acquired. Full OrangeFox Android dependencies, Aloha/donor submodules, file-level license review and independent physical backups are not complete. CN/Global firmware packages have not been downloaded; their SHA-256 fields remain unset.

No recovery, UEFI, kernel, RPM, rootfs or boot image has been produced. No physical device, flash, format, slot change, userdata mount or Android decryption test has been used. No complete security audit, performance baseline, battery measurement or OEM-quality acceptance is claimed.

The next implementation gate is PLAN.md steps 015–026: stock acquisition and boot/recovery analysis, full OrangeFox source resolution, a pinned host toolchain and the first validated local recovery build. Project Aloha follows the recovery foundation.
