# Uke Linux

Linux development for Xiaomi Pad 7 and POCO Pad X1 (`uke`, Snapdragon 7+ Gen 3 / SM7675).

This repository is the project landing page and workspace. Development sources
live in the component repositories below; engineering records are private.

| Repository | Purpose | Status |
|---|---|---|
| [OrangeFox Recovery](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) | Recovery and storage management | Experimental alpha; physical acceptance pending |
| [Senemos kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | Mainline Linux and matching Uke DTB/modules | Linux 7.2.9 compiled; RPM/SRPM and COPR package checks passed |
| [Project Aloha](https://github.com/MCC45TR/uke-project-aloha) | Uke UEFI and boot integration | UEFI port and firmware handoff under development |
| [Hardware support](https://github.com/MCC45TR/uke-linux-hardware-support) | Twelve platform/package source directories | Native boot/ESP32 CDC packages verified; reviewed COPR automatic builds |
| [Fedora builder](https://github.com/MCC45TR/uke-fedora-builder) | Fedora AArch64 build environment and packaging | Rawhide kernel and console package validation complete |
| [Linux images](https://github.com/MCC45TR/uke-linux-images) | Fedora image releases and checksums | Local Core EXT4/ESP candidate verified; tablet boot gates open, no release assets |
| [Engineering documentation](https://github.com/MCC45TR/uke-linux-docs) | Research, plans and validation records | Private; access required |

## Status

Kernel compilation and package installation are verified separately from tablet
boot. Uke UEFI, Linux peripheral support and complete Fedora boot have not passed
physical acceptance. Firmware variants retain separate compatibility records.
Nabu boot binaries, storage geometry and firmware are not reused for Uke.

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
initramfs before Aloha is complete; stock DT handoff and own-device first TTY
remain unverified. Build recipes perform no flashing or slot activation.
Use `./ukelinux.sh --build boot-pair --distro=fedora --help` for the root-capable
stock-ABL Core route: paired `boot_b` and GPT `linux` images, runtime Uke DT
adaptation and a local tablet-screen TTY1 candidate. The
[October 9 pair](https://github.com/MCC45TR/uke-fedora-builder/blob/test/stock-abl-core-pair/reports/FEDORA-BOOT-PAIR-2026-10-09.json)
passed image and generic VM root/TTY checks. Physical tablet boot remains
untested; the `linux` partition must be prepared independently (at least 3 GiB).
Run `./ukelinux.sh --check-device --pair DELIVERY_DIRECTORY` for read-only
file, bootloader and target-capacity checks before the owner's manual trial.

This independent community project is not an official Fedora, Xiaomi, POCO or
Qualcomm product. Original files are MIT licensed; components retain their own licenses.
