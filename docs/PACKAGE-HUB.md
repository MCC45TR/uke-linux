# Uke package and update hub

This workspace coordinates the [Fedora development COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/), source repositories and independent build/package records for Uke/SM7675. The enabled target is Fedora Rawhide AArch64. Other RPM, native DEB and Alpine APK targets need their own distribution rules and acceptance tests.

## Package families

| Source repository | Packages | Current evidence |
|---|---|---|
| [Senemos Uke kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | `senemos-uke-linux-kernel-mainline`, `-core`, `-modules`, `-dtbs` | 7.2.9-1.3: real Uke source build, signed native COPR 11075043, Image/DTB/1,146 modules, signatures/ABI, fresh installation, actual 1.2 → 1.3 upgrade and removal passed |
| [OrangeFox delivery](https://github.com/MCC45TR/uke-orangefox-packaging) | `uke-orangefox-recovery` | Published Global OS3 alpha delivered as checksummed data; native 11074373, signed installation/removal and local upgrade passed |
| [Uke core selection](https://github.com/MCC45TR/uke-core-meta) | `uke-core-meta` | Native release 2; signed console dependency transaction, verification, Python solver guard and removal passed |
| [Desktop selection](https://github.com/MCC45TR/uke-desktop-metas) | `uke-desktop-metas`, `kde-plasma-uke-meta` | Native release 2; complete corrected Plasma runtime acceptance in progress |
| [Desktop source variants](https://github.com/MCC45TR/uke-desktop-packaging) | `material-decoration`, `plymouth-uke` | Native stable decoration and original optional theme; signed payload/ELF checks passed; theme installs without enabling itself |
| Same desktop repository | `at-spi2-core`, `gstreamer1`, `libaccounts-glib`, `libwacom`, `plasma-workspace`, `dolphin` | Exact official Fedora sources rebuilt with optional Python tools/bindings excluded and required C++ migrations; source-family and complete runtime gates recorded separately |
| [Uke firmware](https://github.com/MCC45TR/xiaomi-uke-firmware) | `xiaomi-uke-firmware` | Repository/admission record published; no firmware RPM until every Uke file has an approved source, hash, redistribution license and matching kernel request |
| [Sensors](https://github.com/MCC45TR/uke-sensors), [platform runtime](https://github.com/MCC45TR/uke-platform-runtime) | `uke-sensors`, `uke-platform-runtime`, `hexagonrpc-uke`, `libssc-uke` | Initial repositories; Uke transport, firmware and wiring gates open |
| [Boot](https://github.com/MCC45TR/uke-boot) | `uke-boot-integration` | Initial repository; independent Uke EFI/RAM/storage/rollback gates open |
| [Desktop integration](https://github.com/MCC45TR/uke-desktop-integration), [KCM](https://github.com/MCC45TR/plasma-uke-kcm) | `uke-desktop-integration`, `plasma-uke-kcm` | Initial repositories; measured Uke input/suspend/routing and capability gates open |
| [Camera](https://github.com/MCC45TR/uke-camera) | `uke-camera-support`, `libcamera-uke` | Initial repository; exact Uke graph, license/calibration and capture gates open |
| [Hardware provenance](https://github.com/MCC45TR/uke-hardware-provenance) | `uke-hardware-provenance` | Initial repository; qualified public device evidence payload required |

The [machine-readable catalog](../manifests/package-catalog.json) maps all screenshot reference families from `mcc45tr/nabu-linux`. Roles organize the work; Nabu firmware, panel dimensions, ICC profiles, calibration, offsets and service assumptions do not establish Uke behavior. Fedora's shared PowerDevil and Plymouth engines remain dependencies. Unstable and EL2 kernel channels require separate Uke source admission. A scaffold has no fake RPM or broken automatic COPR job.

## Source and automatic build flow

```sh
./senemeos.sh --build 7.2.9 --distro=fedora --test
./senemeos.sh --build latest --distro=fedora
./senemeos.sh --build lastest --distro=fedora --offline --test
./senemeos.sh --help
```

The sole executable host build entry prepares official prerequisites and a rootless container environment, verifies signed source, limits jobs and queues or pauses its work behind active recovery/native builds. Caches, source/config/patch/toolchain identities and package manifests remain separate. Unreviewed stable versions and unimplemented targets fail explicitly.

Twelve real COPR source families have automatic rebuilds configured on their `main` branches. Shared native desktop recipes also have an explicit GitHub workflow: changes to their common adapter/manifest request all six approved source builds, avoiding reliance on package-subdirectory detection alone. One push hook serves each shared repository; custom hook credentials remain encrypted secrets. Source workers may retrieve verified archives; binary builds run without network access.

Daily kernel, Material and recovery workflows inspect published stable releases. Kernel updates require an approved version-specific Uke port; no generic ARM64 fallback is allowed. Material pins its published stable commit/hash and builds its native C++ plugins. Recovery requires stable status, the reviewed firmware profile, complete asset/source hashes and payload audits. The existing initial recovery remains an explicitly labeled alpha. Native Fedora runtime variants use reviewed source/tool pins; changing an upstream recipe needs a reviewed update.

The first complete Plasma transaction failed because optional Fedora bindings/utilities pulled six Python packages; a file-list audit also found undeclared Dolphin scripts. The corrected source variants remove optional Python consumers and provide native C++ migrations. Core release 2 refuses the Python ABI/interpreter packages and Plasma requires six native capabilities. Signed subpackage, whole-runtime and transaction results are independent gates; automatic compilation does not certify a usable graphical session.

## DNF delivery

On the approved test architecture:

```sh
sudo dnf copr enable mcc45tr/uke-linux-test
sudo dnf install uke-core-meta uke-orangefox-recovery
sudo dnf upgrade uke-core-meta uke-orangefox-recovery
```

`uke-core-meta` resolves the matching kernel packages and a minimal console selection. Kernel files live under `/usr/lib/modules/KERNEL_RELEASE/`; no generic Fedora `kernel-headers` replacement or default boot selection is installed. Optional `plymouth-uke` installs theme data without selecting it or regenerating an initramfs. Plasma/decoration evaluation must follow the current [desktop test record](https://github.com/MCC45TR/uke-fedora-builder/blob/main/reports/DESKTOP-RAWHIDE-2026-10-05.json); a native RPM result alone is insufficient.

Recovery IMG/ZIP files and release/source/license/checksum records live under `/usr/share/senemos/recovery/uke/RPM_VERSION/`. The delivery RPM has no scriptlets, flashing service or automatic ZIP installation. DNF updates files without writing Android partitions. The published image's Global OS3 profile remains distinct from later source features and the stock OS2 inventory.

COPR's observed signing key fingerprint is `DAFC3C5A881FB49C7167EE2D6F772E3D487BD13E`. Verify source/build identity, signatures and accepted records. Retain previous accepted artifacts and the stock recovery route. Public repositories exclude credentials, unit identifiers, calibration and private logs.

## Separate acceptance stages

The first real 7.2.9 Uke build/RPM/COPR package stage is complete. Host source verification, native compilation, extracted payloads and QEMU userspace transactions do not run the Uke kernel or recovery. UEFI firmware, firmware-specific RAM handoff, a bootable composed Fedora tablet image, rollback and physical peripherals remain open. No physical boot or full hardware support is claimed. Image composition stays gated on independent Uke boot/storage evidence rather than guessed Nabu layouts.

Records: [kernel automation](https://github.com/MCC45TR/senemos-uke-kernel-mainline/blob/main/docs/AUTOMATION.md), [recovery automation](https://github.com/MCC45TR/uke-orangefox-packaging/blob/main/docs/AUTOMATION.md), [native runtime rules](https://github.com/MCC45TR/uke-desktop-packaging/blob/main/docs/NATIVE-RUNTIME.md), [builder reports](https://github.com/MCC45TR/uke-fedora-builder/tree/main/reports), [engineering lessons](lessons/PLATFORM-INDEX.md).
