# Uke package and update hub

This workspace coordinates the [Fedora development COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/), component source repositories and build records for Uke/SM7675. It currently enables Fedora Rawhide AArch64. Fedora 45, openSUSE, Debian-family and Alpine formats remain planned until their own native build rules and package tests pass.

## Package families

| Repository | Packages | Readiness |
|---|---|---|
| [Senemos Uke kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | `senemos-uke-linux-kernel-mainline`, `-core`, `-modules`, `-dtbs` | Linux 7.2.9 Image, Uke DTB, 1146 modules, RPM/SRPM and local lifecycle verified; first COPR job 11074297 succeeded |
| [OrangeFox delivery](https://github.com/MCC45TR/uke-orangefox-packaging) | `uke-orangefox-recovery` | Verified alpha image delivery; first COPR job 11074344 succeeded; local DNF install/upgrade/removal passed |
| [uke-core-meta](https://github.com/MCC45TR/uke-core-meta) | `uke-core-meta` | Initial repository; Uke payload gates open |
| [uke-sensors](https://github.com/MCC45TR/uke-sensors) | `uke-sensors` | Initial repository; Uke payload gates open |
| [uke-boot](https://github.com/MCC45TR/uke-boot) | `uke-boot-integration` | Initial repository; Uke payload gates open |
| [uke-platform-runtime](https://github.com/MCC45TR/uke-platform-runtime) | `uke-platform-runtime`, `hexagonrpc-uke`, `libssc-uke` | Initial repository; Uke payload gates open |
| [uke-desktop-metas](https://github.com/MCC45TR/uke-desktop-metas) | `uke-desktop-metas`, `kde-plasma-uke-meta` | Initial repository; Uke payload gates open |
| [uke-desktop-integration](https://github.com/MCC45TR/uke-desktop-integration) | `uke-desktop-integration` | Initial repository; Uke payload gates open |
| [uke-camera](https://github.com/MCC45TR/uke-camera) | `uke-camera-support`, `libcamera-uke` | Initial repository; Uke payload gates open |
| [xiaomi-uke-firmware](https://github.com/MCC45TR/xiaomi-uke-firmware) | `xiaomi-uke-firmware` | Initial repository; Uke payload gates open |
| [plasma-uke-kcm](https://github.com/MCC45TR/plasma-uke-kcm) | `plasma-uke-kcm` | Initial repository; Uke payload gates open |
| [uke-hardware-provenance](https://github.com/MCC45TR/uke-hardware-provenance) | `uke-hardware-provenance` | Initial repository; Uke payload gates open |
| [uke-desktop-packaging](https://github.com/MCC45TR/uke-desktop-packaging) | `powerdevil-uke`, `plymouth-uke`, `material-decoration` | Initial repository; Uke payload gates open |

The [machine-readable catalog](../manifests/package-catalog.json) maps current Nabu reference package families to Uke components. Nabu's unstable and EL2 kernel channels need separate Uke admission. Camera/libcamera packages share the camera repository; KDE meta packages share desktop metas; PowerDevil, Plymouth and decoration derivatives share desktop packaging. Shared upstream software stays in Fedora when it needs no demonstrated Uke change. Firmware admission requires file-level redistribution rights and exact Uke provenance; creating its repository does not publish OEM blobs.

## Build and update flow

```sh
./senemeos.sh --build 7.2.9 --distro=fedora --test
./senemeos.sh --build latest --distro=fedora
./senemeos.sh --build lastest --distro=fedora --offline --test
```

The sole executable host build entry prepares official prerequisites, a rootless Podman/Docker environment and signed source verification. It reuses caches, limits jobs to host resources and queues or pauses its own work behind active native/recovery builds. Separate inspectable manifests, config fragments, patches, Containerfiles and RPM rules identify the build. Unreviewed stable versions and unimplemented distribution targets fail explicitly.

COPR builds source RPMs from the accepted kernel and recovery delivery repositories. Source-generation chroots may fetch and verify upstream archives; binary builds run offline. GitHub push webhooks rebuild changes on the configured `main` branches. Daily workflows track upstream stable versions and avoid admitting prereleases as stable. Kernel updates require a reviewed version-specific Uke port. Recovery updates require its reviewed firmware profile, exact asset hashes, source snapshots and host payload audits. Same-version payload changes increase the RPM release. Host/source-generation tools are excluded from tablet payloads; the tested target dependency closures contain no Python.

Initial repositories include their manifest contracts, source/archive policy, English roadmap, license and GitHub validation workflow. Their `srpm` target fails until a real package exists. They are not registered as broken automatic COPR jobs or represented as hardware support packages.

## DNF delivery

```sh
sudo dnf copr enable mcc45tr/uke-linux-test
sudo dnf install senemos-uke-linux-kernel-mainline uke-orangefox-recovery
sudo dnf upgrade senemos-uke-linux-kernel-mainline uke-orangefox-recovery
```

The kernel lives under `/usr/lib/modules/KERNEL_RELEASE/`; there is no replacement for Fedora's general userspace `kernel-headers`. Recovery images and release/source/checksum records live under `/usr/share/senemos/recovery/uke/RPM_VERSION/`. Recovery has no scriptlets or flashing service. DNF updates image files without installing them to Android partitions or choosing a boot target. The initial recovery is the published Global OS3 alpha, not later source work or a stable artifact. The stock OS2 inventory does not establish compatibility with that OS3 profile.

COPR signs distributed RPMs with its project key. Verify the configured repository key and package source/build identity before evaluation. Retain prior accepted artifacts and the documented stock recovery route. Repositories and COPR jobs are public; credentials, local paths, unit identifiers, private logs and calibration data remain excluded.

## Evidence and admission

Local signed-source compilation, extracted RPM/ramdisk checks, SRPM preparation, AArch64 DNF transactions and native COPR builds have separate records. QEMU userspace package tests do not execute the Uke kernel or recovery. No physical Uke boot, UEFI firmware, rollback or peripheral acceptance is claimed. A package family's automated publication is enabled after its real payload and applicable package checks pass.

Links: [kernel automation](https://github.com/MCC45TR/senemos-uke-kernel-mainline/blob/main/docs/AUTOMATION.md), [recovery automation](https://github.com/MCC45TR/uke-orangefox-packaging/blob/main/docs/AUTOMATION.md), [builder evidence](https://github.com/MCC45TR/uke-fedora-builder/tree/main/reports), [engineering lessons](lessons/PLATFORM-INDEX.md).
