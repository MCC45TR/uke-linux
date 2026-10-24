<table>
<tr>
<td width="65%" valign="top">
<h1>Uke Linux</h1>
<p><strong>Fedora Rawhide for Xiaomi Pad 7 and POCO Pad X1</strong></p>
<p>A community Linux port for the Snapdragon 7+ Gen 3 (SM7675), with the original Fedora KDE Plasma desktop.</p>
<p><strong>Experimental alpha</strong> · AArch64 · <code>uke</code></p>
</td>
<td width="35%" valign="top" align="center">
<br>
<img src="assets/images/uke-fedora-mockup.png" width="240" alt="Xiaomi Pad 7 mockup with Fedora KDE Plasma">
</td>
</tr>
<tr>
<td colspan="2" align="center">
<img src="assets/screenshots/Lastest_Rawhide_Screen_Shot_Ref.png" width="100%" alt="Fedora Rawhide KDE and Fastfetch on the Uke development installation, 17 October 2026">
</td>
</tr>
</table>

[Downloads](#downloads) · [Hardware support](#hardware-support) · [Release readiness](#release-readiness) · [Development changes](CHANGELOG.md) · [Documentation](#documentation) · [Repositories](#project-repositories) · [Report a problem](CONTRIBUTING.md)

> [!WARNING]
> **Work in Progress — Unofficial Project.** This independent community project
> is not affiliated with or endorsed by the device manufacturer. Installing or
> modifying this software may affect your device warranty. The software is
> provided "as is", without warranty. Use it at your own risk. To the extent
> permitted by applicable law, the maintainers accept no liability for device
> damage, data loss or other consequences of its use.

## Project status

**Updated 21 October 2026.** Fedora Rawhide and the standard KDE Plasma desktop
run on the tested POCO Pad X1. Display, touch, Wi-Fi, screen rotation and
automatic brightness are available.

Charging, power management, sleep, USB-C docks and internal audio remain under
development. Variable refresh rate (VRR) is currently disabled. Development
packages are delivered through [COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/);
see the [development notes](CHANGELOG.md) for recent changes.

**Published images are separate from the tested development installation.**
Complete exported-image validation on the tablet remains open. Xiaomi Pad 7
and other memory/storage variants remain untested. See [Downloads](#downloads)
for each image's device and installation scope.

## Release readiness

A stable release needs further work on charging, boot and shutdown, sleep,
display and input reliability, docks, audio and sustained performance.
Installation, updates and recovery also need complete testing on the tablet.
The [hardware support tables](#hardware-support) show the current limitations.

## Downloads

**Updated 24 October 2026.** The [Fedora KDE EXT4 singleboot testing release](https://github.com/MCC45TR/uke-linux/releases/tag/prebuild-fedora-kde-singleboot-ext4-20261024-k7.2.12-22-testing)
uses original Fedora KDE and the signed `7.2.12-22` kernel RPM family from
`mcc45tr/uke-linux-test`.

| File | Download size | Installation target |
| --- | ---: | --- |
| [boot.img](https://github.com/MCC45TR/uke-linux/releases/download/prebuild-fedora-kde-singleboot-ext4-20261024-k7.2.12-22-testing/boot.img) | 96 MiB | `boot_b` |
| [system.img.zst](https://github.com/MCC45TR/uke-linux/releases/download/prebuild-fedora-kde-singleboot-ext4-20261024-k7.2.12-22-testing/system.img.zst) | 1.19 GiB | Decompress to `system.img`, then write to `userdata` |

The system archive uses Zstandard compression and contains an Android sparse
image with an initial **16 GiB EXT4 filesystem**. Decompress it before flashing.
Read the release's checksums, capacity requirements and installation/recovery
instructions. **Writing `userdata` destroys Android apps, files and encryption
metadata; this is not a data-preserving dual-boot route.** After the first
Fedora boot, run `sudo dnf update --refresh`.

**Device-specific test image:** OEM firmware and a device-local touch reference
are included. Use it only on the device that supplied that reference. This exact
exported image has not completed tablet validation; see the
[package/source and validation records](https://github.com/MCC45TR/uke-linux-images/tree/4e8d0df65ab80862ffd6e0554962aa94e8ee1034/releases/prebuild-fedora-kde-singleboot-ext4-20261024-k7.2.12-22-testing)
for its scope and remaining limits.

- [Older Fedora Rawhide Alpha 1 — images and checksums](https://github.com/MCC45TR/uke-linux/releases/tag/fedora-rawhide-alpha-1) — Linux 7.2.9, revision 1.39; predates the current native display and sensor work.
- [Development RPMs on COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) — kernel and platform packages, with validation recorded per build.
- [All Uke Linux releases](https://github.com/MCC45TR/uke-linux/releases) · [Archived image releases](https://github.com/MCC45TR/uke-linux-images/releases) · [Experimental OrangeFox releases](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases).

## Hardware support

**Test scope:** POCO Pad X1, 8 GB / 512 GB; Fedora Rawhide AArch64; stock Android
bootloader; development kernel `7.2.11-6`. Reviewed **20 October 2026** using
14–20 October observations, including earlier development kernels. The
[evidence record](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/UKE-RELEASE-READINESS-2026-10-20.md)
identifies their scope. These results do not validate the published images.

<details>
<summary><strong>View all hardware support tables</strong></summary>

Each row separates the observed result from remaining validation. Status applies
only to the function and test scope stated in that row.

- 🟢 **Working:** the listed function was used successfully on the tested tablet;
  the stated limits still apply.
- 🟡 **Partial:** some functions work, with incomplete integration or validation.
- 🔴 **Broken:** the function is not currently operational in this Linux stack;
  this does not imply a physical hardware defect.
- ⚪ **Not tested / not qualified:** the needed functional or calibration result is unavailable.
- ⏸️ **Disabled:** kept off while a known fault is investigated.

### Boot, CPU and storage

| Feature | Status | Observed result | Remaining validation / limits |
|---|---|---|---|
| Fedora boot | 🟢 **Working** | KDE starts with display and touch on Linux 7.2.11-6. | Complete published images. |
| CPU — Snapdragon 7+ Gen 3 (SM7675) | 🟢 **Working** | All eight cores online. | Sustained heavy loads. |
| CPU frequency policies | 🟢 **Working** | All three CPU policies respond to power-profile changes. | Sustained performance and energy use. |
| RAM | 🟡 **Partial** | Linux reports 7.21 GiB; memory stress stops at the 65 °C guard. | Complete sustained memory test. |
| UFS storage | 🟢 **Working** | 256 MiB write/readback passes; bounded direct read about 1.7 GB/s. | Bounded workloads only. |
| UFS scaling / WriteBooster | 🟢 **Working** | Gear scaling, WriteBooster and runtime idle states respond to load. | MCQ and inline encryption disabled. |
| Memory-pressure telemetry | 🟢 **Working** | CPU, memory and I/O pressure counters available. | Effective OOM policy. |
| UFS I/O scheduler | 🟢 **Working** | mq-deadline retained across two boots without the earlier switch errors. | Two-boot sample. |
| Linux partition / EXT4 | 🟢 **Working** | Fedora boots from the dedicated EXT4 linux partition. | Power-loss recovery. |
| Bootloader entry | 🟢 **Working** | FASTBOOT screen visible. | USB detection assessed separately. |
| Fastboot USB connection | 🟡 **Partial** | Earlier sessions functional; current PC connection not detected. | Restore and repeat USB enumeration. |
| Normal reboot — kernel 6 | 🟢 **Working** | Tested normal reboots return to KDE. | Shutdown assessed separately. |
| Shutdown / poweroff | 🟡 **Partial** | USB-powered shutdown can restart the tablet; intermittent shutdown hang. | Reliable shutdown with and without USB. |
| Reboot to recovery | ⚪ **Not tested** | No validated entry from the current Fedora kernel. | Physical recovery-entry test. |
| Hardware information / Fastfetch | 🟢 **Working** | All-module capture completes. | Some hardware fields unavailable. |
| Project Aloha / UEFI boot | ⚪ **Not tested** | Fedora test path uses the stock Android bootloader. | Separate UEFI development and device validation. |

### Display, graphics and input

| Feature | Status | Observed result | Remaining validation / limits |
|---|---|---|---|
| Tablet screen / local TTY | 🟢 **Working** | KDE and local console at 3200×2136. | Internal display only. |
| Manual backlight brightness | 🟢 **Working** | Smooth manual adjustment. | Optical calibration. |
| Screen-off backlight / DPMS | 🟡 **Partial** | Scanout returns after off/on; one DPU frame-done timeout in ten cycles. | Resolve timeout and repeat transitions. |
| Native DPU / DSI / DSC display | 🟢 **Working** | Native KDE scanout on the internal screen. | Display lifecycle tests. |
| Refresh-rate switching | 🟢 **Working** | Fixed 30/48/50/60/90/120/144 Hz modes functional. | VRR assessed separately. |
| Adaptive sync / dynamic refresh | ⏸️ **Disabled — input regression** | Multitouch/display faults and touch watchdogs with VRR. | Disabled; no supported physical 1 Hz path. |
| Display color depth | 🟡 **Partial** | Active 10-bit framebuffer and DSC link. | Selectable 8/12/16-bit output not implemented. |
| Firmware DRM fallback | 🟡 **Partial** | Earlier firmware-framebuffer operation recorded. | Current fallback behavior. |
| Original Fedora KDE / Wayland | 🟡 **Partial** | Desktop and applications operational. | Clipboard-related shutdown deadlock. |
| Desktop scrolling | 🟡 **Partial** | Settings-list scrolling stutters. | Content-frame pacing; display Hz alone is insufficient. |
| Manual display rotation | 🟢 **Working** | Rotation with matching touch coordinates. | — |
| GPU — Adreno 732 | 🟡 **Partial** | Desktop OpenGL operational. | OpenGL ES failures and lifecycle coverage. |
| KDE GPU statistics | 🟡 **Partial** | KSystemStats exposes idle usage and frequency. | Active-load accuracy and GUI presentation. |
| Xwayland / OpenGL | 🟢 **Working — desktop OpenGL** | 27 output checks per backend plus bounded workloads pass. | Desktop OpenGL only. |
| Vulkan / Turnip | 🟡 **Partial** | 9,000-frame cube completes; vulkaninfo display-extension query fails. | Resolve query failure and broaden validation. |
| Touchscreen — Novatek NT36532 | 🟡 **Partial** | Normal-use touch operational. | Ten-contact/VRR faults and continuous-contact reliability. |
| Stylus / pen | 🔴 **Broken** | No pen input, pressure or tilt. | Functional pen implementation and tests. |
| Power / volume buttons | 🟢 **Working** | Buttons respond during normal Fedora use. | Wake from real suspend. |
| Power-button screen toggle | 🟡 **Partial** | Display-only policy configured. | Physical toggle test. |
| USB receiver mouse | 🟢 **Working** | Mouse input through powered Juo dock on 7.2.10-27. | Tested dock/kernel only. |
| USB keyboard | ⚪ **Not tested** | No physical input result. | Keyboard input test. |
| Pogo keyboard / touchpad | ⚪ **Not tested** | No keyboard available. | Native transport, authentication and hardware tests. |

### Networking and USB

| Feature | Status | Observed result | Remaining validation / limits |
|---|---|---|---|
| Wi-Fi — WCN6750 | 🟢 **Working** | Automatic connection, SSH and file transfers; factory WLAN address retained across restarts. | — |
| Signed network updates | 🟢 **Working** | Signed Fedora/COPR packages install over Wi-Fi. | Kernel updates require matching boot/modules. |
| Bluetooth | 🟢 **Working — mouse and audio** | Mouse pairing/reconnection and Space Q45 LDAC playback functional. | Broader device coverage. |
| NFC | ⚪ **Not tested** | No exposed controller. | Confirm fitted hardware. |
| USB overall | 🟡 **Partial** | Device mode and dock mouse operational. | Role changes and combined dock workloads. |
| Manual CDC ACM management | 🟢 **Working — manual** | Manual on/off control; default off. | Current-cable reconnect and suspend. |
| USB ECM / SSH | 🟢 **Working — manual** | Earlier SSH and verified 16 MiB transfers pass. | Default off; earlier-test scope. |
| USB host / accessory power (VBUS) | 🟡 **Partial** | Dock devices enumerate. | Accessory power budget and earlier ESP32 power failure. |
| USB-C switch / role control | 🟡 **Partial** | PC sink/device and dock host/sink states reported. | Broader role switching. |
| USB reconnect / driver lifecycle | 🟡 **Partial** | Software reconnect functional in earlier tests. | Physical reconnect and driver-reload recovery. |
| USB SuperSpeed | 🟡 **Partial** | Hub and RTL8153 enumeration at 5 Gbit/s. | Storage throughput. |
| DisplayPort / USB-C video output | 🟡 **Partial** | No successful tablet HDMI output. | Powered test requires charging-protection qualification. |
| External-monitor DDC/CI brightness | 🟡 **Partial** | PowerDevil/ddcutil initializes. | Actual monitor brightness control. |
| USB hubs | 🟢 **Working — tested dock** | Juo USB 2/3 enumeration and powered-dock mouse input functional. | Storage and Ethernet assessed separately. |
| USB Ethernet | 🟡 **Partial** | RTL8153 and firmware detected. | Cable carrier and real traffic. |

### Sensors and desktop integration

Sensor startup uses native readiness dependencies. Factory calibration remains
on read-only persist; runtime registry writes use RAM. Some endpoints still
lack a validated physical mapping.

| Feature | Status | Observed result | Remaining validation / limits |
|---|---|---|---|
| SSC sensor startup | 🟢 **Working** | Automatic motion, light and proximity service startup. | DSP restart recovery. |
| Accelerometer — LSM6DSO | 🟢 **Working — rotation** | Four physical orientations with matching touch alignment. | Rotation only. |
| Gyroscope — LSM6DSO | 🟡 **Partial** | Readable XYZ angular rates. | Physical motion response and drift. |
| Magnetometer / compass — QMC630x family | 🟡 **Partial** | Heading responds to movement; absolute-heading comparison fails. | Absolute-heading accuracy. |
| Front light sensor — STK3BCx family | 🟢 **Working — ambient light** | Front illumination changes lux and KDE brightness. | Ambient light only. |
| Rear light sensor — SIP1328 | 🟢 **Working — ambient light** | Rear illumination changes brightness with the front dark. | Ambient light only. |
| Ambient color temperature | ⚪ **Not qualified** | No valid startup color sample. | Calibrated Kelvin conversion. |
| Front proximity sensor — STK3BCx family | 🟢 **Working — near/far** | Cover/release sequence reports far → near → far. | Near/far response only. |
| SAR / body proximity — SX937x family | ⏸️ **Disabled** | No usable endpoint or physical response. | Endpoint mapping and physical validation. |
| Automatic rotation / sensor fusion | 🟢 **Working — four poses** | KDE and touch alignment follow all four orientations. | Four poses. |
| Automatic brightness | 🟢 **Working** | Brightness follows front/rear illumination changes. | Long-run and sunlight behavior. |
| Magnetic cover / lid detection | 🟢 **Working — switch events** | Front cover and rear fold generate expected switch events. | Cover-triggered blanking. |
| Temperature telemetry | 🟢 **Working** | Standard interfaces and KDE expose PMIC/thermal readings. | Absolute calibration and protection effectiveness. |

### Audio, cameras and media

| Feature | Status | Observed result | Remaining validation / limits |
|---|---|---|---|
| Internal speakers | 🔴 **Broken** | No usable ALSA playback route. | Protected speaker playback. |
| Microphones | 🔴 **Broken** | No usable ALSA recording route. | Functional recording route and capture. |
| Bluetooth audio / LDAC | 🟢 **Working — stereo playback** | Clear stereo LDAC playback reported on Space Q45. | Microphone/HFP and suspend. |
| USB audio | ⚪ **Not tested** | No playback/recording test result. | Physical playback and capture. |
| Front camera | ⚪ **Not tested** | No capture device or verified frame. | Functional capture pipeline. |
| Rear camera | ⚪ **Not tested** | No capture pipeline or verified frame. | Functional capture pipeline. |
| Hardware video decoding / encoding | ⚪ **Not tested** | No usable codec device or verified workload. | Hardware decode/encode workloads. |

### Power, thermal management and platform services

| Feature | Status | Observed result | Remaining validation / limits |
|---|---|---|---|
| Battery percentage / voltage / temperature | 🟢 **Working — readings** | Readings available after normal boot. | Independent accuracy checks. |
| Battery current / net power | 🟢 **Working — readings** | Signed current, net battery power and charge counter available. | Protection effectiveness assessed separately. |
| Charging from computer USB | 🟡 **Partial** | USB input detected; system load can exceed the supply. | Sustained net charging under the tested load. |
| USB Power Delivery / fast charging | 🟡 **Partial — powered dock** | Battery charging through the powered dock observed. | Negotiated protocols and protection. |
| Charge limits / charge stop | 🟡 **Partial — effect unverified** | 70/80 setting retained. | Physical cutoff and restart hysteresis. |
| Battery bypass / direct system supply | ⚪ **Not qualified** | No verified bypass or battery isolation. | Physical power-path qualification. |
| Native device management | 🟡 **Partial** | Status, sensor reports and inventory functional. | Swap-partition preference and advanced controls. |
| Battery runtime estimates | 🟡 **Partial — software checks** | Model checks pass. | Qualified device forecasts unavailable. |
| Offline charging | 🔴 **Broken — charger-mode entry** | USB-triggered starts return to KDE without the charging screen. | Charger-mode entry and physical screen operation. |
| Plasma battery indicator | 🟢 **Working** | Battery icon and readings visible in KDE. | Readings only; protection separate. |
| Desktop power profiles | 🟢 **Working** | All three profiles selectable without an error. | Sustained energy and thermal behavior. |
| Thermal protection / throttling | 🟡 **Partial** | Emulated events lower CPU/GPU limits. | Actual heat response and protective shutdown. |
| Display-only soft sleep | 🟡 **Partial** | Scanout returns after off/on; one DPU timeout recorded. | Resolve timeout and repeat cycles. |
| Suspend-to-idle / s2idle | 🟡 **Partial — RTC wake tested** | One successful RTC-wake cycle. | Display, touch, power-key wake, repetition and sleep energy. |
| Deep suspend | ⚪ **Not tested** | No physical sleep/resume result. | Suspend and resume tests. |
| Power-key IRQ wake | ⚪ **Not tested** | No physical suspend-wake result. | Power-key wake from real suspend. |
| USB cable wake | 🔴 **Broken** | Required USB wake interrupts missing from the device tree. | Wake interrupt integration and physical test. |
| USB keyboard / mouse wake | ⚪ **Not tested** | No physical input-wake result. | Input wake from real suspend. |
| RTC / persistent clock | 🟡 **Partial** | Saved-time restoration and NTP functional; hardware startup time incorrect. | Hardware clock correctness. |
| Watchdog | 🟡 **Partial** | Driver starts. | Recovery behavior. |
| PMIC / regulators | 🟡 **Partial** | Essential storage/USB resources operational. | Remaining PMIC probe failures. |
| DMA / IOMMU resources | 🟡 **Partial** | Essential device paths operational. | Broader clients and lifecycle coverage. |
| Interconnect / platform power control | 🟡 **Partial** | Basic operation functional. | Provider errors and measured power/performance. |
| DSPs — ADSP / CDSP / QSH | 🟡 **Partial** | Charger and sensor services start. | Audio, other workloads and restart recovery. |
| FastRPC sensor transport | 🟢 **Working** | ADSP contexts serve sensor registry requests. | General DSP compute and restart recovery. |
| CoreSight tracing | ⏸️ **Disabled** | Autoload blocked after earlier resets. | Cause and recovery investigation. |

The current boot handoff is **EL1**. EL2/KVM work remains on a separate
experimental branch, and Project Aloha/UEFI is not the boot path used for the
reported Fedora tests.

</details>

## Build from public source

23 October 2026: `./ukelinux.sh` offers image and native kernel builds on Ubuntu,
Fedora, openSUSE, Arch Linux and Alpine hosts. Image selections cover multiboot
or singleboot, EXT4/F2FS/Btrfs/XFS, original KDE/GNOME and stable/testing/unstable
package channels. Output defaults to `out` in the invoking directory.

[Public build and manual installation guide](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/PUBLIC-BUILD.md)
includes source pins, prerequisite confirmation, local-data boundaries and
output verification. The new workflow has source and shell checks only; full
builds and tablet acceptance remain untested. **Run `sudo dnf update --refresh`
after the first Fedora boot.**

```sh
git clone --recurse-submodules https://github.com/MCC45TR/uke-linux.git
cd uke-linux
./ukelinux.sh
# Kernel only:
./ukelinux.sh --build kernel
```

## Documentation

| Topic | Guide |
|---|---|
| Build Fedora images | [Public image build guide](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/PUBLIC-BUILD.md) |
| Build the kernel | [Native kernel worker](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/PUBLIC-BUILD.md) |
| Boot requirements and rollback | [Public prerequisites and manual installation](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/PUBLIC-BUILD.md#output-and-manual-installation) |
| Development plan | [Milestones and remaining work](https://github.com/MCC45TR/uke-linux-docs/blob/main/PLAN.md) — private, access required |
| Engineering records | [Documentation index](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/README.md) — private, access required |
| Desktop screenshots | [Fedora KDE gallery](assets/screenshots/README.md) |
| Contributing and bug reports | [Reporting guide](CONTRIBUTING.md) · [Open an issue](https://github.com/MCC45TR/uke-linux/issues/new?template=bug_report.yml) |
| Security reports | [Security policy](SECURITY.md) |

## Project repositories

| Component | Current development branch |
|---|---|
| Kernel and device trees | [senemos-uke-kernel-mainline / main](https://github.com/MCC45TR/senemos-uke-kernel-mainline/tree/main) |
| Hardware integration and packages | [uke-linux-hardware-support / main](https://github.com/MCC45TR/uke-linux-hardware-support/tree/main) |
| Fedora image builder | [uke-fedora-builder / main](https://github.com/MCC45TR/uke-fedora-builder/tree/main) |
| Image distribution | [uke-linux-images / main](https://github.com/MCC45TR/uke-linux-images/tree/main) |
| OrangeFox Recovery | [orangefox_device_xiaomi_uke / R12.0](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/tree/R12.0) |
| Experimental UEFI | [uke-project-aloha / main](https://github.com/MCC45TR/uke-project-aloha/tree/main) |

These links always open the current development branches. GitHub's file list
shows the exact submodule commits saved in this workspace. An hourly workflow
refreshes those snapshots after the workspace checks pass; it can also be run
manually from **Actions → Validate workspace links → Run workflow**. GitHub may
delay scheduled runs. Each workspace commit retains its exact source snapshot;
these updates do not qualify a new build or change published release images.

## License

Original files use the [MIT License](LICENSE). Components retain their own
licenses and attribution. Uke Linux is an independent community project,
unaffiliated with Fedora, Xiaomi, POCO or Qualcomm.
