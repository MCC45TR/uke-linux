# Uke Linux

**Recovery, UEFI and Fedora Linux development for POCO Pad X1 and Xiaomi Pad 7.** This workspace brings together OrangeFox recovery, Project Aloha boot integration, the Senemos mainline kernel and the Fedora AArch64 builder for the Snapdragon 7+ Gen 3 / SM7675 tablet family (`uke`).

[Hardware status](#hardware-and-sensors) · [Downloads](#downloads-and-compatibility) · [Development plan](PLAN.md) · [Engineering records](docs/lessons/PLATFORM-INDEX.md) · [Build checks](https://github.com/MCC45TR/uke-linux/actions/workflows/records.yml)

**Development status:** an experimental OrangeFox alpha is available. UEFI, mainline Linux and Fedora remain under development, with no published bootable Uke system image. Project recovery, UEFI and Linux acceptance on either tablet is still pending. Current source changes and downloadable artifacts have separate validation records.

## Platform components

| Component | Scope | Current checkpoint |
|---|---|---|
| [OrangeFox Recovery](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) | Tablet interface, storage planning, backup, diagnostics and Linux recovery | R12.0 source development; older experimental alpha available |
| [Project Aloha](https://github.com/MCC45TR/uke-project-aloha) | Uke UEFI startup, boot profiles and return to Android | Platform integration; no Uke image release |
| [Senemos kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | Mainline SM7675 adaptation, device tree and matching modules | Linux 7.2.9 Image, Uke DTB and 1146 modules compiled; RPM/SRPM and first native COPR build passed; physical boot pending |
| [Fedora builder](https://github.com/MCC45TR/uke-fedora-builder) | Fedora Rawhide AArch64 kernel packages, root filesystem and boot artifacts | Kernel RPM lifecycle validated; package/update hub active; no bootable Uke system image |
| [Package and update hub](docs/PACKAGE-HUB.md) | Component repositories, COPR builds, stable-source tracking and DNF image delivery | Kernel and recovery delivery packages; eleven additional initial package-family repositories |

Recovery source features include selectable interface scale, display controls, regular-image partition and stock-layout jobs, verified raw and Linux/home backups, filesystem inspection and repair, distribution-aware rescue, kernel/boot auditing, and Btrfs management. [The recovery feature overview](https://github.com/MCC45TR/orangefox_device_xiaomi_uke#feature-overview) describes the implementation and its limits. Live tablet storage admission, encrypted userdata migration, shipping-kernel Btrfs support and physical accessory acceptance remain open. A feature implemented in current source is not automatically present in the older alpha download.

## Hardware and sensors

**Latest physical evidence: 3 October 2026**, POCO Pad X1 8 GB / 512 GB running stock Android 15, Global `OS2.0.205.0.VOZMIXM`. A read-only collection established descriptors and exposed driver bindings. Controlled sensor measurements and project-environment tests have not yet been performed.

The status vocabulary is **Fully working**, **Partial**, **Not working** and **Not tested**. Fully working requires the recorded acceptance workload; Not working requires an observed failure. Stock inventory observations are shown separately below. An advancing event timestamp is a partial observation, not calibrated sensor or automatic-brightness acceptance.

| Function | Reported sensor / interface | Stock Android evidence | OrangeFox | Fedora Linux |
|---|---|---|---|---|
| Accelerometer | STMicro LSM6DSO | Descriptor and cached events; function not tested | Not tested | Not tested |
| Gyroscope | STMicro LSM6DSO | Descriptor and cached events; function not tested | Not tested | Not tested |
| Compass / magnetometer | QST QMC630x | Descriptor; exact suffix and function not tested | Not tested | Not tested |
| Front ambient light | Sensortek STK3BCx | Partial observation: last-event timestamp advanced | Not tested | Not tested |
| Proximity / front color temperature | Sensortek STK3BCx | Descriptors and cached events; function not tested | Not tested | Not tested |
| Rear ambient light / flicker | SIP1328 | Descriptors; light response and 50/60 Hz detection not tested | Not tested | Not tested |
| SAR / grip sensing | Semtech SX937x | Descriptor; electrodes and response not tested | Not tested | Not tested |
| Magnetic cover / tablet position | Hall interfaces; chip unknown | Input/source interfaces; cover response not tested | Not tested | Not tested |
| Rotation, gravity and steps | Xiaomi / QTI fusion interfaces | Software descriptors; behavior not tested | Not tested | Not tested |

The collection exposes **61 sensor interfaces**, including software and wake/non-wake variants; this is not a count of physical chips. QMI8658 is an alternate configuration candidate, and QMC6308 is an unconfirmed suffix. Neither is presented as an additional installed sensor.

The [hardware evidence summary](docs/research/UKE-HARDWARE-STATUS-2026-10-04.md) also covers the 3200 × 2136 display, Novatek touch, dual KTZ8866 backlight controllers, FS16xx speaker amplifiers, Nanosic keyboard interface, storage, cameras, USB and power. The [complete capability matrix](DEVICE-STATUS.md) tracks 143 capabilities independently for Recovery, UEFI and Linux. It currently records no project hardware success or measured failure. PenguinOS/CLO observations remain a separate evidence track.

## Downloads and compatibility

| Download | Intended use | Validation scope |
|---|---|---|
| [Experimental OrangeFox alpha](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases/tag/r12.0-uke.20260930-alpha1) | Separate temporary-boot IMG, recovery IMG and installer ZIP, with source snapshots and SHA-256 hashes | Unsigned prerelease for the Global OS3.0.303.0.WOZMIXM package profile; no physical boot acceptance |
| [Fedora development channel](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) | Linux 7.2.9 kernel RPMs and DNF-managed OrangeFox image data | Rawhide AArch64 package builds and local transactions verified; recovery retains its alpha/firmware profile; no physical boot acceptance |

Read the [recovery installation and rollback guidance](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/PRE-RELEASE.md) and [release policy](docs/RELEASES.md) before choosing an artifact. The stock OS2 device inventory does not establish compatibility with the OS3 alpha. Generic ARM64 build results do not establish a bootable Uke port.

POCO Pad X1 8 GB / 512 GB is the primary physical validation target. Xiaomi Pad 7 memory/storage, regional firmware, panel and touch variants require their own records. Pad 7 Pro (`muyu`) and Pad 5 (`nabu`) are different boards. Global, China and Turkey firmware references stay separate; stock early firmware and a documented recovery route must be preserved.

## Development and validation

Clone the workspace and its pinned component repositories:

```sh
git clone --recurse-submodules https://github.com/MCC45TR/uke-linux.git
```

Each component maintains its own source, patches, configuration, tests and licenses. Reference archives live below the owning component's `referances/` directory; [the source archive report](reports/source-archive.md) records acquisition and remaining dependencies.

The single host build entry is `./senemeos.sh --build 7.2.9 --distro=fedora --test`.
Use `--help` for stable/latest aliases, offline reuse and resource options. The
[package hub](docs/PACKAGE-HUB.md) maps source repositories, automatic COPR builds,
stable release gates and DNF updates without automatic device flashing.

Build, package, host fixture, emulation, third-party and own-device results are recorded separately. A hardware result needs its build revision, firmware, model/SKU, timestamp, workload and evidence. Source changes and VM results cannot promote physical status. Public reports contain reviewed summaries; private logs and unit calibration stay out of GitHub.

Native device tools use C++. Host automation prefers Bash, and tablet payloads exclude Python. Linux and EDK II retain their upstream implementation languages. See [project guidance](AGENTS.md), [test requirements](docs/testing/TEST-CONTRACT.md), [security reporting](SECURITY.md) and [diagnostics](docs/security/SECURITY-AND-OBSERVABILITY.md).

## Project and licensing

Uke Linux is an independent community project. Original workspace documentation is [MIT-licensed](LICENSE); imported sources and component repositories retain their own licenses. Xiaomi, POCO, OrangeFox, Fedora, Qualcomm and Project Aloha retain their respective trademarks. Component links and source references do not imply vendor endorsement.
