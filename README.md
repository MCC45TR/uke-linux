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

**Last reviewed: 2026-10-12 — Fedora Rawhide AArch64, Linux `7.2.9-senemos-uke`.**
These results come from the owner's POCO Pad X1, 8 GB / 512 GB, using the stock
Android bootloader. Linux displays the requested name **Xiaomi Pad 7**. Other
models and firmware versions need their own tests. The initial physical boot
candidate was `pair-0242a33799d12541`; subsequent matched RAM profiles added Wi-Fi
without replacing the root or stock slot A. Detailed artifact identities are in
the private reports.

| Status | What it means |
|---|---|
| 🟢 **Working** | The function described in the row was used successfully on the tablet. |
| 🟡 **Partial** | Some functionality works; the row explains the limitation. |
| 🔴 **Broken** | The function is unavailable or fails in this Linux build. This does not mean the hardware is defective. |
| ⚪ **Not tested** | We have no physical functional result for this feature. |
| ⏸️ **Disabled** | Deliberately kept off while a known problem is investigated. |

### Boot, processor and storage

| Feature | Status | What you can expect today |
|---|---|---|
| Fedora boot | 🟡 **Partial** | Repeated matched RAM starts reached the real Fedora filesystem and automatic USB/Wi-Fi SSH. Cold boots and automatic slot-B startup still need testing. |
| CPU — Snapdragon 7+ Gen 3 (SM7675) | 🟢 **Working** | All eight cores are online and run native Linux commands. Heavy workloads have not been tested. |
| CPU frequency control | 🟡 **Partial** | The hardware driver exposes three active schedutil policies: 0.365–1.901, 0.480–2.611 and 0.480–2.803 GHz. Frequency adjustment, voltage behavior and throttling need validation. |
| RAM | 🟡 **Partial** | Linux uses about 7.21 GiB of the installed 8 GB. Memory stress and suspend retention are untested. |
| UFS storage | 🟢 **Working** | Fedora reads and writes its real internal-storage root filesystem. Long transfers, power-loss recovery and resume are untested. |
| Linux partition / EXT4 | 🟢 **Working** | The existing 64 GiB partition is fully usable. Root is selected by GPT partition name `linux`, not by UUID. |
| `reboot bootloader` | 🟡 **Partial** | Repeated commands returned to fastboot, but one shutdown took about 106 seconds with a serial-shell timeout. Restart reliability remains open. |
| Normal reboot, recovery command and poweroff | ⚪ **Not tested** | These routes have not been qualified on the current candidate. |
| Project Aloha / UEFI boot | ⚪ **Not tested** | The current Fedora session uses the stock Android bootloader. The Uke UEFI port is still in development. |

### Screen and input

| Feature | Status | What you can expect today |
|---|---|---|
| Tablet screen / local TTY | 🟢 **Working** | A real command prompt is visible at 3200×2136 using the framebuffer left by the bootloader. |
| Backlight | 🟡 **Partial** | Three normal levels pass paired readback and restoration. A relative visible brightness increase is observed. Calibrated brightness, full range, blanking and desktop integration remain untested. |
| Native panel control / refresh switching | 🔴 **Broken** | The native Linux display path is not usable. The current image relies on the bootloader's fixed display setup. |
| Firmware DRM | 🟡 **Partial** | Connected 3200×2136 simpledrm output, visible console and software Wayland scanout work. Native panel control and accelerated rendering remain unavailable. |
| Original Fedora KDE / Wayland | 🟡 **Partial** | Wallpaper, panel and clock are observed using original Fedora Plasma/KWin 6.8.0. The signed Mesa fix avoids the observed SVE crash. Rendering is llvmpipe; touch and long-term session reliability remain open. |
| Manual display rotation | 🟢 **Working** | Original KScreen rotated the Wayland desktop/lock screen by 90° and restored landscape; both orientations are observed. Sensor-driven rotation is unavailable. |
| GPU — Adreno 732 | 🔴 **Broken** | No hardware render device or acceleration. Firmware DRM supplies software scanout; showing the GPU name in Fastfetch does not enable acceleration. |
| Touchscreen | 🔴 **Broken** | No usable touch input device in Fedora. |
| Stylus / pen | 🔴 **Broken** | No usable pen input, pressure or tilt interface in Fedora. |
| Power / volume buttons | 🟡 **Partial** | Input drivers register; physical key events and navigation have not been verified. |
| USB keyboard / mouse | ⚪ **Not tested** | Tablet host mode is not ready; no successful physical input test. |
| Pogo keyboard / touchpad | ⚪ **Not tested** | Attachment, key events and touchpad input still need testing. |

### Networking and USB

| Feature | Status | What you can expect today |
|---|---|---|
| Wi-Fi — WCN6750 | 🟢 **Working** | Automatic association, Wi-Fi SSH, DNS and a byte-identical 16 MiB transfer passed in the matched RAM profile. A 15-minute functional check passed; cold-boot and suspend reliability remain open. |
| Signed network updates | 🟢 **Working** | Fedora and COPR packages were installed through DNF over Wi-Fi with signature checks. Kernel updates remain pinned to manually reviewed matched tuples. |
| Bluetooth | 🔴 **Broken** | No Bluetooth controller appears; scanning and pairing are unavailable. |
| NFC | ⚪ **Not tested** | No NFC controller is exposed. OEM pin states alone do not establish a fitted NFC chip; controller provenance and tag exchange remain unqualified. |
| USB overall | 🟡 **Partial** | Device mode works with a computer. Host power, accessories and role switching are not ready. |
| USB CDC ACM / serial shell | 🟡 **Partial** | The composite ACM endpoint and native shell service register. Bidirectional serial commands remain unqualified; the terminal stop correction passed two bounded physical trials. |
| USB ECM / SSH | 🟢 **Working** | SSH over the USB cable works. A previous matched profile also passed a byte-identical 16 MiB round trip and software gadget reconnect. |
| USB host / accessory power (VBUS) | 🔴 **Broken** | The owner's ESP32-S3 received no power from the tablet. Host accessories are not usable through this path yet. |
| USB-C switch / role control | 🟡 **Partial** | The reset GPIO supplier and switch driver now bind; USB device mode works. Automatic role switching and host power remain unqualified. |
| Physical USB unplug / replug | ⚪ **Not tested** | Software reconnect passed; a physical cable-disconnect test is still needed. |
| USB SuperSpeed | ⚪ **Not tested** | No validated USB 3 accessory transfer. |
| DisplayPort / USB-C video output | ⚪ **Not tested** | No external-monitor or adapter test has passed. |
| USB Ethernet adapters / hubs | ⚪ **Not tested** | Accessory networking and hub operation still need physical tests. |

### Sensors

Sensor names below come from the earlier stock Android inventory and OEM
configuration. Exact populated variants still need confirmation. Fedora currently
exposes no usable motion, light or SAR sensor interface.

| Feature | Status | What you can expect today |
|---|---|---|
| Accelerometer — LSM6DSO family | 🔴 **Broken** | No acceleration samples in Fedora. |
| Gyroscope — LSM6DSO family | 🔴 **Broken** | No angular-rate samples in Fedora. |
| Magnetometer / compass — QMC630x family | 🔴 **Broken** | No magnetic-field samples or working compass. |
| Front light sensor — STK3BCx family | 🔴 **Broken** | No usable front ambient-light readings. |
| Rear light sensor — SIP1328 | 🔴 **Broken** | No usable rear light or flicker readings. |
| Front proximity sensor — STK3BCx family | 🔴 **Broken** | No usable proximity events. |
| SAR / body proximity — SX937x family | 🔴 **Broken** | No usable capacitive proximity readings. |
| Automatic rotation / sensor fusion | 🔴 **Broken** | Motion data and fused orientation are unavailable. |
| Automatic brightness | 🔴 **Broken** | Ambient-light samples are unavailable. Paired Linux backlight control exists, but visible response and desktop integration still need validation. |
| Hall / cover detection | ⚪ **Not tested** | No controlled cover-open/close event test. |
| Temperature sensors | 🟡 **Partial** | 36 thermal channels are readable. Their accuracy and protective actions have not been validated. |

### Audio and media

| Feature | Status | What you can expect today |
|---|---|---|
| Internal speakers | 🔴 **Broken** | No usable ALSA sound card or playback route. |
| Microphones | 🔴 **Broken** | No usable ALSA recording route. |
| USB / Bluetooth audio | ⚪ **Not tested** | No physical playback or recording test; Bluetooth itself is unavailable. |
| Front camera | ⚪ **Not tested** | No validated camera capture pipeline or captured frame. |
| Rear camera | ⚪ **Not tested** | No validated camera capture pipeline or captured frame. |
| Hardware video decoding / encoding | ⚪ **Not tested** | No validated hardware codec workload. |

### Power, time and platform services

| Feature | Status | What you can expect today |
|---|---|---|
| Battery percentage / voltage / current / temperature | 🔴 **Broken** | Linux exposes no battery telemetry. Charge state and battery temperature cannot be monitored. |
| Charging / USB Power Delivery | ⚪ **Not tested** | Charging behavior and negotiated power are not validated; battery readings are missing. |
| Thermal protection / throttling | ⚪ **Not tested** | Readable temperatures do not establish working throttling or shutdown protection. |
| Suspend / resume | ⚪ **Not tested** | No physical sleep/wake test. |
| RTC / persistent clock | 🟡 **Partial** | Native network time synchronization works over Wi-Fi. The RTC still supplies an incorrect startup time; persistent clock behavior remains unqualified. |
| Watchdog | 🟡 **Partial** | The Gunyah watchdog driver binds. Recovery behavior has not been tested. |
| PMIC / regulators | 🟡 **Partial** | Enough resources work for storage and USB. Other PMIC probes still report errors. |
| DMA / IOMMU resources | 🟡 **Partial** | Reviewed storage, USB and WLAN paths are usable. GPU and other bus clients still need integration and physical tests. |
| Interconnect / platform power control | 🟡 **Partial** | Basic root and USB operations work, but provider errors remain; performance and power behavior are unverified. |
| DSPs — ADSP / CDSP / QSH | 🟡 **Partial** | Matched 1.20 starts ADSP manually and binds GPR with three services. A NoC crash and SLIMbus errors keep ADSP offline; a short trial without SLIMbus avoids recurrence. CDSP/QSH, audio and sensor services remain unavailable. |
| FastRPC | 🔴 **Broken** | No usable native DSP compute interface. Firmware authentication, transport and memory permissions still need separate validation. |
| CoreSight tracing | ⏸️ **Disabled** | Autoload is blocked after earlier resets. The exact failure still needs investigation. |

Work follows three queues: **A — connectivity** (Wi-Fi, Bluetooth, NFC and USB),
**B — GPU/video acceleration and general log errors**, and **C — DSP/FastRPC,
touch, all sensors and remaining hardware**. The OEM LPASS interconnect change has passed
signed-package, matched RAM and initial ADSP startup checks; its dependent
services still need admission. Wi-Fi restart
reliability remains under review. Battery telemetry is a prerequisite for stress,
charging and power-management experiments. KDE applications use Fedora's packages.

The tables describe the recorded development profiles, not a finished tablet
release. Stock slot A and a consistent backup of the earlier root are preserved;
the new `boot_b` image was written and verified, but unattended slot-B startup
is still untested. The private KDE root has complete physical hash/fsck
verification and an observed software desktop.
Build, RPM and virtual-machine checks are tracked separately from physical results.

The private [hardware report](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/FEDORA-HARDWARE-AUDIT-2026-10-11.md)
and [sensor report](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/FEDORA-SENSOR-AUDIT-2026-10-11.md)
contain the detailed evidence and test limits. Access is required. Historical
sensor descriptors are not a count of physical chips or proof of Linux support.

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
