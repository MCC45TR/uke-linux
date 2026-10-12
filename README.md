# Uke Linux

Linux development for Xiaomi Pad 7 and POCO Pad X1 (`uke`, Snapdragon 7+ Gen 3 / SM7675).

**Fedora now displays the original KDE desktop on the tablet using software rendering.** SSH over a USB cable
works. Wi-Fi also connects automatically and provides SSH,
DNS, time synchronization and signed Fedora/COPR updates. Bluetooth, touch,
accelerated graphics and audio do not work yet. This is an early development
build, with a usable console and software desktop for bringing up the remaining hardware.

**Current installation, 12 October:** Recovery rejected the first KDE write's
root hash and journal. A scoped native recovery rewrite now passes complete
64 GiB readback and filesystem checks. The matching 1.17 RAM boot reaches this
KDE root with USB/Wi-Fi SSH, DNS and synchronized time. Original Fedora PAM/time
packages correct the missing login runtime. A signed Mesa correction removes
the observed SVE crash: the original Fedora KDE desktop is now observed,
and manual Wayland rotation/restoration works. Rendering uses llvmpipe.
A later matched 1.20 RAM start returns KDE and both SSH paths. GPR now binds
and registers three services. An ADSP NoC crash and SLIMbus DMA/restart errors
remain under investigation; a short trial without the SLIMbus driver avoids
that recurrence. ADSP stays manual and offline. Stock slot A, verified
1.17 boot_b and a consistent offline Core rollback are retained.

Signed 1.21 also passes online DNF, all installed module hashes and fresh early
boot/VM checks. A matched 1.21 RAM start on 12 October reaches the real Fedora
root, the original KDE desktop, USB SSH and automatic Wi-Fi. Signed CPUCP 1.22 passes source,
payload, callback/shutdown and all 1,144 native module byte checks. Its fresh
early tuple and physical SCMI qualification remain pending.

This repository is the project landing page and workspace. Component repositories
are linked below; detailed engineering records are private.

[Core](https://github.com/MCC45TR/uke-linux-images/releases/tag/prebuild-fedora-core-20261012-copr1.17)
and [original Fedora KDE](https://github.com/MCC45TR/uke-linux-images/releases/tag/prebuild-fedora-kde-20261012-copr1.17)
prebuild tests are published with checksums and installation/rollback limits.
The clean public root images have separate host qualification and have not
been flashed or booted on this tablet; the owner root observations above are
a different filesystem.

## Hardware support

See [hardware.md](hardware.md) for the hardware support tables, status definitions
and the tested-profile limits.

## Project repositories

| Repository | Purpose | Current stage |
|---|---|---|
| [OrangeFox Recovery](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) | Recovery and storage management | Experimental alpha; full physical acceptance pending |
| [Senemos kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | Linux kernel, Uke device trees and matching modules | Linux 7.2.9; physical TTY, USB/Wi-Fi SSH and signed online COPR delivery recorded |
| [Project Aloha](https://github.com/MCC45TR/uke-project-aloha) | Uke UEFI and boot integration | UEFI port in development |
| [Hardware support](https://github.com/MCC45TR/uke-linux-hardware-support) | Platform integration and device packages | Signed boot/CDC 7 and Mesa host-feature correction pass actual DNF and bounded device checks |
| [Fedora builder](https://github.com/MCC45TR/uke-fedora-builder) | Fedora AArch64 image recipes and checks | Matched boot pair passes build, payload and five VM scenarios |
| [Linux images](https://github.com/MCC45TR/uke-linux-images) | Fedora image releases and checksums | Core and original KDE prebuild tests published; clean roots remain physically untested |
| [Engineering documentation](https://github.com/MCC45TR/uke-linux-docs) | Research, plans and validation records | Private; access required |

Use original distribution KDE applications; do not clone, fork or rebuild them
as Uke variants. Fedora Rawhide AArch64 Core is the qualified console baseline.
Separate original Fedora KDE images pass host filesystem/readback checks;
the private owner root reaches software KDE, while the clean public image
has separate host validation and release boundaries. The owner permits Python only
for its original signed Fedora dependencies; project startup, service and test
helpers remain native or shell. The Core image and early initramfs retain their
no-Python audits. Software Wayland scanout and Adreno acceleration have separate
acceptance gates. Sleep targets and Plasma PowerDevil remain masked until
battery telemetry and repeated-start safety gates pass.
Nabu boot binaries, storage geometry and firmware are not reused for Uke.

## Downloads

- [Experimental recovery releases](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases)
- [Development RPM channel](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/)
- [Fedora image releases](https://github.com/MCC45TR/uke-linux-images/releases)
- [Fedora Core prebuild test, signed kernel 1.17](https://github.com/MCC45TR/uke-linux-images/releases/tag/prebuild-fedora-core-20261012-copr1.17) — firmware DRM console; two existing-root RAM starts and complete boot_b readback. The clean released root has host/VM qualification only.

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
