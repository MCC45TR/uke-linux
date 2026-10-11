# Uke Linux

Linux development for Xiaomi Pad 7 and POCO Pad X1 (`uke`, Snapdragon 7+ Gen 3 / SM7675).

This repository is the project landing page and workspace. Development sources
live in the component repositories below; engineering records are private.

| Repository | Purpose | Status |
|---|---|---|
| [OrangeFox Recovery](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) | Recovery and storage management | Experimental alpha; physical acceptance pending |
| [Senemos kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | Mainline Linux and matching Uke DTB/modules | Linux 7.2.9; stock-ABL TTY/USB SSH and one physical fastboot return; ordinary RPM/SRPM validated separately |
| [Project Aloha](https://github.com/MCC45TR/uke-project-aloha) | Uke UEFI and boot integration | UEFI port and firmware handoff under development |
| [Hardware support](https://github.com/MCC45TR/uke-linux-hardware-support) | Twelve platform/package source directories | Signed boot/CDC 0.1.0-5; actual tablet DNF upgrade and opt-in USB network debugging |
| [Fedora builder](https://github.com/MCC45TR/uke-fedora-builder) | Fedora AArch64 build environment and packaging | Matched PARTLABEL boot pair passes build, payload and five VM scenarios |
| [Linux images](https://github.com/MCC45TR/uke-linux-images) | Fedora image releases and checksums | First stock-ABL Fedora screen TTY observed; wider hardware and repeat-boot gates open |
| [Engineering documentation](https://github.com/MCC45TR/uke-linux-docs) | Research, plans and validation records | Private; access required |

## Status

On 2026-10-11 the owner observed the first sustained Fedora Rawhide screen TTY
on Uke with Linux 7.2.9, stock ABL and scoped CoreSight autoload containment.
Actual CDC commands, authenticated SSH over USB ECM, a byte-verified 16 MiB
round trip and expansion of the existing 64 GiB EXT4 root completed. This exact
profile still lacks Wi-Fi, native GPU/display, touch and battery telemetry.
USB host power, repeated cold boots, suspend and UEFI remain unqualified.
Kernel/package/VM results remain separate from these own-device observations.
Firmware variants retain separate compatibility records.
Nabu boot binaries, storage geometry and firmware are not reused for Uke.

The later matched candidate passed two physical RAM starts with automatic USB
SSH. `reboot bootloader` returned bootloader fastboot; only `boot_b` was updated
and read back byte-for-byte. Stock slot A and the existing 64 GiB root were
preserved. This does not qualify unattended slot-B startup or all reboot modes.

| Function | Observed Fedora result | Next correction / acceptance |
|---|---|---|
| CPU / RAM / root storage | Eight CPUs online, native userspace, UFS EXT4 root at 64 GiB | Stress, interruption and resume remain open |
| Tablet screen | Real local TTY on inherited 3200×2136 framebuffer | Native panel/backlight and local input |
| Direct-PC USB | CDC shell and authenticated ECM SSH; byte-matched transfer | Physical cable reconnect and role switching |
| Bootloader return | One actual `reboot bootloader` transition | Repeat boot/recovery/poweroff modes |
| Temperature | 36 thermal channels readable | Channel accuracy, trip actions and safe power telemetry |
| Wi-Fi / Bluetooth | No usable WLAN or HCI interface | Exact firmware, WPSS power/PAS, DT and DMA wiring; Wi-Fi first |
| Motion / light / SAR | No IIO sensor device | Exact chip/bus ownership, drivers and native sampling |
| GPU / touch / audio / cameras | No usable accelerated/render/input/audio/camera pipeline | Per-device firmware, resources and physical function tests |
| Battery / USB host power | Telemetry absent; ESP32 host power not working in the owner's trial | Supported battery ABI, Type-C role and VBUS control |

The private [hardware report](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/FEDORA-HARDWARE-AUDIT-2026-10-11.md)
and [sensor report](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/FEDORA-SENSOR-AUDIT-2026-10-11.md)
contain exact artifact receipts, the complete historical sensor descriptor list,
current interfaces and the correction order. Driver registration, Android
descriptors and firmware filenames do not establish working Fedora hardware.

Use original distribution KDE applications. KDE application clones, forks and
rebuilds are prohibited; incompatible Python payloads currently block a complete
graphical image. The first Fedora target is a Rawhide AArch64 Core development console.

## Downloads

- [Experimental recovery releases](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases)
- [Development RPM channel](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/)
- [Fedora image releases](https://github.com/MCC45TR/uke-linux-images/releases)

Consult the producing repository for exact compatibility and validation limits.
Package installation does not flash Android partitions or change boot selection.

## Workspace

```sh
git clone --recurse-submodules https://github.com/MCC45TR/uke-linux.git
cd uke-linux
./senemos-uke-kernel/senemos.sh --build 7.2.9 --distro=fedora --test
```

The hardware sources are checked out directly as `uke-linux-hardware-support/`.
All twelve components are ordinary directories inside that shared repository.
The kernel repository owns `senemos.sh` and its pinned build rules; it also works
from a standalone clone. Use `./senemos-uke-kernel/senemos.sh --help`.
Use `./ukelinux.sh --build core --distro=fedora --test` for the local Core filesystem candidate. See the [image guide](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/IMAGES.md) for the ESP32 debug profile and device release gates.
Use `./ukelinux.sh --build boot --distro=fedora --help` for the additional
stock ABL `fedora_boot.img` development route. It uses a built-in Fedora debug
initramfs before Aloha is complete. The current physical result belongs to the
root-capable pair profile below. Build recipes perform no flashing or slot activation.
Use `./ukelinux.sh --build boot-pair --distro=fedora --help` for the root-capable
stock-ABL Core route: paired `boot_b` and GPT `linux` images, runtime Uke DT
adaptation and a local tablet-screen TTY1 candidate. The
[October 9 pair](https://github.com/MCC45TR/uke-fedora-builder/blob/test/stock-abl-core-pair/reports/FEDORA-BOOT-PAIR-2026-10-09.json)
passed image and generic VM root/TTY checks. The later v5-plus-containment
profile reached the physical TTY; the October 9 artifact does not inherit that
result. New candidates select the unique physical `PARTLABEL=linux` rather than
a fixed UUID. The partition must be prepared independently (at least 3 GiB).
Run `./ukelinux.sh --check-device --pair DELIVERY_DIRECTORY` for read-only
file, bootloader and target-capacity checks before the owner's manual trial.

This independent community project is not an official Fedora, Xiaomi, POCO or
Qualcomm product. Original files are MIT licensed; components retain their own licenses.
