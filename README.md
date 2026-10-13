# Uke Linux

Linux development for Xiaomi Pad 7 and POCO Pad X1 (`uke`, Snapdragon 7+ Gen 3 / SM7675).

**Fedora displays the original KDE desktop on the tablet using software rendering.** Wi-Fi
connects automatically and provides SSH,
DNS, time synchronization and signed Fedora/COPR updates. Bluetooth, touch,
accelerated graphics and audio do not work yet. This is an early development
build, with a usable console and software desktop for bringing up the remaining hardware.
USB networking remains available as a manual development feature and is now off by default.

**Latest device trial, 13 October:** A matched signed 1.27 RAM start reaches
the existing 64 GiB EXT4 Fedora root, software-rendered KDE and Wi-Fi SSH.
The revised initramfs preloads QRTR and the domain mapper; fresh RAM trials
now bring up ADSP charger services automatically. Battery percentage, voltage,
temperature, full/design charge and the desktop battery icon are observed.
A manual bounded 500 mA computer-USB budget is accepted; automatic budgeting and
sustained charging with the screen on remain unqualified.

One automatic display off/on cycle now turns the backlight fully off and restores
the requested brightness. Sleep and touch still do not work. A live battery-driver
reload exposed a USB lifetime fault and left shutdown stuck; that session is
rejected for further USB testing. The owner restored fastboot and a fresh matched
RAM session is now collecting passive battery/temperature data with the display
off. Corrected USB driver lifecycle still needs a separate test. SLIMbus and
automatic DSP recovery stay contained.
The validated DT candidate is written to boot B with full readback equality.
Android A stays selected; the current session is a matched RAM start. A cold
start from selected slot B still needs testing.

Touch DT supplier and chip-select fixes now identify the physical NT36532
controller. Firmware-info validation still fails, so finger and stylus input
remain unavailable. Experimental RAM boots now return acceleration, gyro and
rear-light data through native SSC tools. Motion samples reach high reported
accuracy after settling; front light, compass, SAR and desktop sensor integration
remain unavailable. OEM calibration stays private on a read-only persist mount;
the sensor framework writes only to a temporary RAM copy. The existing
Linux filesystem passes a modern offline consistency check after orphan repair.

The reviewed 1.29 charger-readiness, gauge-ABI and USB-lifetime corrections pass
source, host-contract and ARM64 object checks. Native
[COPR build 11114370](https://copr.fedorainfracloud.org/coprs/build/11114370)
succeeds, and all signed RPMs pass payload checks. The 1.29 drivers are not yet
installed or physically tested; the active unattended session retains 1.27.

This repository is the project landing page and workspace. Component repositories
are linked below; detailed engineering records are private.

[Core](https://github.com/MCC45TR/uke-linux-images/releases/tag/prebuild-fedora-core-20261012-copr1.17)
and [original Fedora KDE](https://github.com/MCC45TR/uke-linux-images/releases/tag/prebuild-fedora-kde-20261012-copr1.17)
prebuild tests are published with checksums and installation/rollback limits.
The clean public root images have separate host qualification and have not
been flashed or booted on this tablet; the owner root observations above are
a different filesystem.

## Hardware support

**Last reviewed: 2026-10-13 — Fedora Rawhide AArch64, Linux `7.2.9-senemos-uke`.**
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
| Fedora boot | 🟡 **Partial** | Repeated matched RAM starts reach the real Fedora filesystem and Wi-Fi SSH. Cold boots and automatic slot-B startup still need testing. |
| CPU — Snapdragon 7+ Gen 3 (SM7675) | 🟢 **Working** | All eight cores are online and run native Linux commands. Heavy workloads have not been tested. |
| CPU frequency control | 🟡 **Partial** | The hardware driver exposes three active schedutil policies: 0.365–1.901, 0.480–2.611 and 0.480–2.803 GHz. Frequency adjustment, voltage behavior and throttling need validation. |
| RAM | 🟡 **Partial** | Linux uses about 7.21 GiB of the installed 8 GB. Memory stress and suspend retention are untested. |
| UFS storage | 🟢 **Working** | Fedora reads and writes its real internal-storage root. Long transfers, power-loss recovery and resume are untested; filesystem health is a separate gate. |
| Linux partition / EXT4 | 🟡 **Partial** | The existing 64 GiB partition mounts by GPT name `linux`, not UUID. Offline e2fsck repairs orphan metadata; its forced read-only postcheck and fresh-boot zero error counter pass. Power-loss resilience and full file integrity remain unqualified. |
| `reboot bootloader` | 🟡 **Partial** | Repeated commands returned to fastboot, but one shutdown took about 106 seconds with a serial-shell timeout. Restart reliability remains open. |
| Normal reboot, recovery command and poweroff | ⚪ **Not tested** | These routes have not been qualified on the current candidate. |
| Project Aloha / UEFI boot | ⚪ **Not tested** | The current Fedora session uses the stock Android bootloader. The Uke UEFI port is still in development. |

### Screen and input

| Feature | Status | What you can expect today |
|---|---|---|
| Tablet screen / local TTY | 🟢 **Working** | A real command prompt is visible at 3200×2136 using the framebuffer left by the bootloader. |
| Backlight brightness | 🟡 **Partial** | Both LED banks respond to manual brightness and power-off/on; about 5% is usable. Full-range calibration and automatic control remain unqualified. |
| Screen-off backlight / DPMS | 🟡 **Partial** | One 1.27 Wayland DPMS cycle turns illumination fully off and restores the previous brightness. Repeated cycles and suspend/resume still need testing. |
| Native panel control / refresh switching | 🔴 **Broken** | The native Linux display path is not usable. The current image relies on the bootloader's fixed display setup. |
| Firmware DRM | 🟡 **Partial** | Connected 3200×2136 simpledrm output, visible console and software Wayland scanout work. Native panel control and accelerated rendering remain unavailable. |
| Original Fedora KDE / Wayland | 🟡 **Partial** | Wallpaper, panel and clock are observed using original Fedora Plasma/KWin 6.8.0. The signed Mesa fix avoids the observed SVE crash. Rendering is llvmpipe; touch and long-term session reliability remain open. |
| Manual display rotation | 🟢 **Working** | Original KScreen rotated the Wayland desktop/lock screen by 90° and restored landscape; both orientations are observed. Sensor-driven rotation is unavailable. |
| GPU — Adreno 732 | 🔴 **Broken** | No hardware render device or acceleration. Firmware DRM supplies software scanout; showing the GPU name in Fastfetch does not enable acceleration. |
| Touchscreen — Novatek NT36532 | 🔴 **Broken** | Identity reads confirm a cascade controller and the OEM supplier strap selects CSOT firmware. Resident firmware-info validation still fails. The Uke cascade memory map and normal input protocol need completion; there is no usable finger input. |
| Stylus / pen | 🔴 **Broken** | No usable pen input, pressure or tilt interface in Fedora. |
| Power / volume buttons | 🟡 **Partial** | Input drivers register; physical key events and navigation have not been verified. |
| USB keyboard / mouse | 🔴 **Broken** | The owner's mouse dongle is not detected. HID/xHCI drivers exist, but the current fixed-device USB route cannot provide host operation. |
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
| USB ECM / SSH | 🟢 **Working — manual** | Earlier matched trials pass SSH and a byte-identical 16 MiB transfer. Automatic activation is now disabled; development uses Wi-Fi SSH. |
| USB host / accessory power (VBUS) | 🔴 **Broken** | The owner's ESP32-S3 received no power from the tablet. Host accessories are not usable through this path yet. |
| USB-C switch / role control | 🟡 **Partial** | The reset GPIO supplier and switch driver now bind; USB device mode works. Automatic role switching and host power remain unqualified. |
| USB reconnect / driver lifecycle | 🟡 **Partial** | Earlier software reconnect works, but removing the live battery provider exposes a stale USB callback fault. The affected session is rejected; corrected driver teardown and physical cable replug need fresh tests. |
| USB SuperSpeed | ⚪ **Not tested** | No validated USB 3 accessory transfer. |
| DisplayPort / USB-C video output | ⚪ **Not tested** | No external-monitor or adapter test has passed. |
| USB Ethernet adapters / hubs | ⚪ **Not tested** | Accessory networking and hub operation still need physical tests. |

### Sensors

Sensor names below come from the earlier stock Android inventory and OEM
configuration, with LSM6DSO and SIP1328 now identified by the running sensor DSP.
Experimental RAM boots provide bounded native readout. These tools are not yet
installed as a permanent desktop sensor service; automatic brightness and
rotation remain unavailable.

| Feature | Status | What you can expect today |
|---|---|---|
| Sensor DSP / SSC discovery | 🟡 **Partial** | Native discovery finds 15 endpoints and motion/rear-light data are readable in RAM trials. Persistent startup, complete firmware lifecycle and IIO/D-Bus integration are not ready. |
| Accelerometer — LSM6DSO | 🟡 **Partial** | Real XYZ samples reach high reported accuracy after settling, with a plausible stationary gravity magnitude. Controlled movement, mounting orientation and desktop rotation still need validation. |
| Gyroscope — LSM6DSO | 🟡 **Partial** | Real XYZ samples reach high reported accuracy and settle close to zero while stationary. Controlled rotation, drift and desktop integration still need validation. |
| Magnetometer / compass — QMC630x family | 🔴 **Broken** | No magnetic-field samples or working compass. |
| Front light sensor — STK3BCx family | 🔴 **Broken** | No usable front ambient-light readings. |
| Rear light sensor — SIP1328 | 🟡 **Partial** | On-change and streaming endpoints return raw channel data. Channel units, illumination response and desktop lux readings are not yet verified. Flicker remains unqualified. |
| Front proximity sensor — STK3BCx family | 🔴 **Broken** | No usable proximity events. |
| SAR / body proximity — SX937x family | 🔴 **Broken** | No usable capacitive proximity readings. |
| Automatic rotation / sensor fusion | 🔴 **Broken** | Native motion data now exist, but no validated fused orientation or desktop rotation service is available. |
| Automatic brightness | 🔴 **Broken** | Front light readings and a validated desktop lux interface are unavailable. Manual paired backlight control is Partial. |
| Hall / cover detection | ⚪ **Not tested** | SSC reports an available oem_hall service, but no Linux cover-state interface or controlled open/close event is verified. |
| Temperature sensors | 🟡 **Partial** | The current snapshot has 37 thermal zones and 38 readable hwmon temperature channels, including battery and Wi-Fi. These overlap and are not chip counts; accuracy and protective actions remain unqualified. |

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
| Battery percentage / voltage / temperature | 🟡 **Partial** | The revised initramfs exposes real readings automatically in one fresh RAM start. Repeated cold starts and long-term readings remain unqualified. |
| Battery current / power / charging indication | 🟡 **Partial** | Current is readable. Exact-Uke current direction and remaining-charge units need the prepared ABI correction; the Charging label alone does not prove net battery gain. |
| Charging from computer USB | 🟡 **Partial** | A manual 500 mA SDP budget reads back correctly, with about 453 mA USB input. Screen-off samples support charging direction; screen-on load can still exceed supply. Automatic budgeting and sustained capacity gain remain unqualified. |
| USB Power Delivery / fast charging | ⚪ **Not tested** | Protocol negotiation, thermal protection and higher-power charging remain unqualified. |
| Plasma battery indicator | 🟡 **Partial** | UPower supplies real battery fields and the tray icon is observed. It still depends on charger-service startup and correct current/counter interpretation. |
| Thermal protection / throttling | ⚪ **Not tested** | Readable temperatures do not establish working throttling or shutdown protection. |
| Display-only soft sleep | 🟡 **Partial** | One automatic DPMS off/on cycle fully disables and restores illumination. Repeated cycles remain unqualified; screen-off alone does not suspend the system. |
| Suspend-to-idle / s2idle | ⏸️ **Disabled** | Sleep targets remain masked. The reported one-second black interval has no confirmed suspend entry. Signed 1.28 diagnostic packages pass payload checks; real sleep and stable resume remain unqualified. |
| Deep suspend | ⚪ **Not tested** | The kernel advertises deep sleep, but CPU, memory and device resume have not been qualified. |
| Power-key IRQ wake | ⚪ **Not tested** | Power-key input and its wake flag are present. Waking a real resident sleep cycle still needs a physical test. |
| USB cable wake | 🔴 **Broken** | The current peripheral-only USB DT does not include the OEM wake IRQs. Cable wake needs the complete controller/PHY/Type-C path. |
| USB keyboard / mouse wake | 🔴 **Broken** | Host accessories do not work yet. HID remote wake will be tested after host power and role switching work. |
| RTC / persistent clock | 🟡 **Partial** | Native network time synchronization works over Wi-Fi. The RTC still supplies an incorrect startup time; persistent clock behavior remains unqualified. |
| Watchdog | 🟡 **Partial** | The Gunyah watchdog driver binds. Recovery behavior has not been tested. |
| PMIC / regulators | 🟡 **Partial** | Enough resources work for storage and USB. Other PMIC probes still report errors. |
| DMA / IOMMU resources | 🟡 **Partial** | Reviewed storage, USB and WLAN paths are usable. GPU and other bus clients still need integration and physical tests. |
| Interconnect / platform power control | 🟡 **Partial** | Basic root and USB operations work, but provider errors remain; performance and power behavior are unverified. |
| DSPs — ADSP / CDSP / QSH | 🟡 **Partial** | Matched RAM boots bring up ADSP charger services; temporary native file delivery enables motion/rear-light readout. SLIMbus and automatic recovery remain disabled. Audio, CDSP/QSH and complete lifecycle remain unqualified. |
| FastRPC | 🟡 **Partial** | The reviewed ADSP root and sensor context banks bind and serve the temporary sensor registry. General DSP compute, other banks and a permanent service lifecycle are not qualified. |
| CoreSight tracing | ⏸️ **Disabled** | Autoload is blocked after earlier resets. The exact failure still needs investigation. |

Work follows four groups: **A — ADSP, battery, Bluetooth and backlight**;
**B — touch, graphics and automatic brightness/rotation**;
**C — complete USB-C, compass and firewall**;
**D — CPU/thermal tables, DT resources, refresh rates and safe sleep/wake**.
Charging and repeat-boot safety come before stress testing. KDE applications
use Fedora's original packages. EL2/KVM remains a separate experimental branch;
the recorded physical firmware handoff is EL1.

The tables describe the recorded development profiles, not a finished tablet
release. Stock slot A and a consistent backup of the earlier root are preserved;
the new `boot_b` image was written and verified, but its normal start fell back
to Android. The private KDE root has complete physical hash/fsck
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
acceptance gates. Original Fedora PowerDevil is running; system sleep targets
remain masked until safe suspend/resume is qualified.
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
