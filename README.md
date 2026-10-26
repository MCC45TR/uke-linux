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

**Updated 26 October 2026.** Fedora Rawhide and the original KDE Plasma desktop
run on the tested POCO Pad X1. The current development series is **Linux 7.3**;
the latest recorded normal boot is **7.3.0-15**, from signed
[COPR build 11207395](https://copr.fedorainfracloud.org/coprs/build/11207395/).
Matching modules, boot-image readback and the existing boot-health checks pass.

Display, normal touch, Wi-Fi, Bluetooth mouse/stereo playback, rotation and
automatic brightness have recorded working results. **HDMI works on Linux 7.3**,
confirmed on 26 October. Earlier Juo trials also establish monitor audio and
Gigabit Ethernet connectivity. KDE Connect discovery works after the signed
local-network policy update. Bounded RGB colors, seven VA decode modes and
basic native H.264 encode output have passed; wider coverage remains open.

Charging protection, sleep, display/input lifecycle, internal audio, cameras
and broader hardware video remain incomplete. VRR is disabled after input
regressions; external DSC/FEC is experimental and disabled by default.
Development packages are delivered through
[COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/).
See the [development notes](CHANGELOG.md) for dated updates and remaining work.

**Published images are separate from the tested development installation.**
Complete exported-image validation on the tablet remains open. Xiaomi Pad 7
and other memory/storage variants remain untested. See [Downloads](#downloads)
for each image's device and installation scope.

## Release readiness

A stable release needs further work on charging, boot and shutdown, sleep,
display and input reliability, dock lifecycle, internal audio, cameras and
sustained performance. The native FFmpeg H.264 High path still fails despite a
zero process exit, while the separate VA path passes its bounded frame test.
Browser hardware video and the GPU sandbox/rendering combination remain open.
Installation, updates and recovery also need complete testing on the tablet.
The [hardware support tables](#hardware-support) show the current limitations.

## Downloads

**Published 26 October 2026.** The [KDE EXT4 singleboot testing image](https://github.com/MCC45TR/uke-linux/releases/tag/prebuild-fedora-kde-singleboot-ext4-20261026-k7.3.0-16-testing)
uses signed **Linux 7.3.0-16**, matching modules and original Fedora KDE.
Host content, metadata, SELinux, sparse-decoder and compression checks pass.
Read the [package/source and validation record](https://github.com/MCC45TR/uke-linux-images/tree/main/releases/prebuild-fedora-kde-singleboot-ext4-20261026-k7.3.0-16-testing)
and local setup requirement below. These exact files remain untested on a tablet.

| File | Download size | Installation target |
| --- | ---: | --- |
| [boot.img](https://github.com/MCC45TR/uke-linux/releases/download/prebuild-fedora-kde-singleboot-ext4-20261026-k7.3.0-16-testing/boot.img) | 96 MiB | `boot_b` |
| [system.img.zst](https://github.com/MCC45TR/uke-linux/releases/download/prebuild-fedora-kde-singleboot-ext4-20261026-k7.3.0-16-testing/system.img.zst) | 991 MiB | Decompress to `system.img`, then write to `userdata` |

The selected image profile uses a Zstandard-compressed Android sparse image
with an initial **16 GiB EXT4 filesystem**. Decompress it before flashing.
Read the release's checksums, capacity requirements and installation/recovery
instructions. **Writing `userdata` destroys Android apps, files and encryption
metadata; this is not a data-preserving dual-boot route.** After the first
Fedora boot, run `sudo dnf update --refresh`.

**Local input remains device-specific:** this generic image omits the private
touch reference. Provision the target tablet's own accepted reference locally
before touchscreen account setup; the release gives the path, size and mode.
Do not reuse another tablet's reference. USB-only first setup is not qualified.
The original KDE Connect package, autostart/daemon and desktop discovery policy
are included. First setup, growth, updates, recovery and exact-export tablet
validation remain open. OEM firmware and its licensing scope are recorded separately.

- [Older Fedora Rawhide Alpha 1 — images and checksums](https://github.com/MCC45TR/uke-linux/releases/tag/fedora-rawhide-alpha-1) — Linux 7.2.9, revision 1.39; predates the current native display and sensor work.
- [Development RPMs on COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) — kernel and platform packages, with validation recorded per build.
- [All Uke Linux releases](https://github.com/MCC45TR/uke-linux/releases) · [Archived image releases](https://github.com/MCC45TR/uke-linux-images/releases) · [Experimental OrangeFox releases](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases).

## Hardware support

**Test scope:** POCO Pad X1, 8 GB / 512 GB; Fedora Rawhide AArch64; stock Android
bootloader; current normal kernel `7.3.0-15`. Reviewed **26 October 2026** using
14–26 October observations across Linux 7.2 and 7.3. Older successful tests have
not all been repeated on the current kernel. The dated
[engineering records](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/lessons/FEDORA-INDEX.md)
retain each result's scope; access to that repository is restricted.
These results do not validate the published images.

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
| Fedora boot | 🟢 **Working** | Normal Linux 7.3.0-15 boot, matched modules and boot-health acceptance recorded on 26 October. | Complete published images and other variants. |
| CPU — Snapdragon 7+ Gen 3 (SM7675) | 🟢 **Working** | All eight cores online. | Sustained heavy loads. |
| CPU frequency policies | 🟢 **Working** | All three CPU policies respond to power-profile changes. | Sustained performance and energy use. |
| RAM | 🟡 **Partial** | Linux reports 7.21 GiB; memory stress stops at the 65 °C guard. | Complete sustained memory test. |
| UFS storage | 🟢 **Working** | 256 MiB write/readback passes; bounded direct read about 1.7 GB/s. | Bounded workloads only. |
| UFS scaling / WriteBooster | 🟢 **Working** | Gear scaling, WriteBooster and runtime idle states respond to load. | MCQ and inline encryption disabled. |
| Memory-pressure telemetry | 🟢 **Working** | CPU, memory and I/O pressure counters available. | Effective OOM policy. |
| UFS I/O scheduler | 🟢 **Working** | mq-deadline retained across two boots without the earlier switch errors. | Two-boot sample. |
| Linux partition / EXT4 | 🟢 **Working** | Dedicated EXT4 linux boots recorded; current userdata-root boot uses its matching profile. | Power-loss recovery and each exported layout. |
| Bootloader entry | 🟢 **Working** | FASTBOOT screen visible. | USB detection assessed separately. |
| Fastboot USB connection | 🟡 **Partial** | Successful sessions and external recovery recorded; host/cable enumeration has varied. | Repeat the exact host/cable path. |
| Normal reboot | 🟢 **Working** | Latest recorded restart returns to normal Linux 7.3.0-15. | Shutdown and unattended lifecycle assessed separately. |
| Shutdown / poweroff | 🟡 **Partial** | USB-powered shutdown can restart the tablet; intermittent shutdown hang. | Reliable shutdown with and without USB. |
| Reboot to recovery | ⚪ **Not tested** | No validated entry from the current Fedora kernel. | Physical recovery-entry test. |
| Hardware information / Fastfetch | 🟢 **Working** | All-module capture completes. | Some hardware fields unavailable. |
| Project Aloha / UEFI boot | ⚪ **Not qualified** | Native core passes 12 host tests; Fedora still uses the stock bootloader. | Bootable Uke firmware and separate device validation. |

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
| GPU — Adreno 732 | 🟡 **Partial** | Desktop GL works; 730 selected GLES precision/loop/compute cases pass on recorded 7.2 kernels. | Complete API coverage, sustained load and current-kernel lifecycle. |
| KDE GPU statistics | 🟡 **Partial** | KSystemStats exposes idle usage and frequency. | Active-load accuracy and GUI presentation. |
| Xwayland / OpenGL | 🟢 **Working — desktop OpenGL** | Earlier backend output checks and Chrome 156 GL pixels/context restoration on Linux 7.3.0-15 pass. | Bounded tests; physical presentation and endurance remain separate. |
| Vulkan / Turnip | 🟡 **Partial** | Transfer/fence/readback works; three native image cases fail. | Validate the source correction without the diagnostic UBWC override; full API/lifecycle coverage. |
| OpenCL / Rusticl | 🟡 **Partial** | Selected uncached integer/float compute and readback pass. | Complete capability, numerical/API coverage and applications. |
| Browser graphics / WebGPU | 🟡 **Partial** | Chromium 154 X11/Vulkan compute/raster passes; Chrome 156/kernel15 GL pixels pass. | Current normal Chrome has no WebGPU adapter; GPU sandbox and working GL do not yet pass together. |
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
| KDE Connect | 🟢 **Working — discovery** | Signed desktop firewall policy installed; POCO F5 discovered on 24 October. | Pairing, transfers and the separate laptop Wi-Fi route issue. |
| NFC | ⚪ **Not qualified** | OEM tag evidence does not establish an active Linux NFC reader. | Actual reading, transfer or emulation. |
| USB overall | 🟡 **Partial** | Device mode and dock mouse operational. | Role changes and combined dock workloads. |
| Manual CDC ACM management | 🟢 **Working — manual** | Manual on/off control; default off. | Current-cable reconnect and suspend. |
| USB ECM / SSH | 🟢 **Working — manual** | Earlier SSH and verified 16 MiB transfers pass. | Default off; earlier-test scope. |
| USB host / accessory power (VBUS) | 🟡 **Partial** | Dock devices enumerate. | Accessory power budget and earlier ESP32 power failure. |
| USB-C switch / role control | 🟡 **Partial** | PC sink/device and dock host/sink states reported. | Broader role switching. |
| USB reconnect / driver lifecycle | 🟡 **Partial** | Software reconnect functional in earlier tests. | Physical reconnect and driver-reload recovery. |
| USB SuperSpeed | 🟡 **Partial** | Hub and RTL8153 enumeration at 5 Gbit/s. | Storage throughput. |
| DisplayPort / USB-C video output | 🟢 **Working — HDMI** | HDMI works on Linux 7.3, confirmed 26 October; earlier 2560×1440/75 Hz through Juo recorded. | Current mode/precision not remeasured; reconnect, HDR, DSC/FEC and MST remain separate. |
| External-monitor DDC/CI brightness | 🔴 **Broken — recorded reads** | Brightness queries fail with monitor DDC/CI enabled. | Receiver forwarding and actual monitor brightness control. |
| USB hubs | 🟢 **Working — tested dock** | Juo USB 2/3 enumeration and powered-dock mouse input functional. | Storage and Ethernet assessed separately. |
| USB Ethernet | 🟢 **Working — connectivity** | RTL8153 negotiates 1 Gbit/s full duplex; DHCP, DNS, interface-bound ping and HTTPS pass on kernel 7.2.12-31. | Later RX drops, sustained throughput, hotplug and cover lifecycle. |

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
| DisplayPort / HDMI audio | 🟢 **Working — tested monitor** | Native 48 kHz/16-bit stereo and Chromium video sound through Juo physically confirmed on 24 October; dynamic ELD monitor labels work. | Repeat on current kernel, other monitors, reconnect and endurance. |
| USB audio | ⚪ **Not tested** | No playback/recording test result. | Physical playback and capture. |
| Front camera | ⚪ **Not tested** | No capture device or verified frame. | Functional capture pipeline. |
| Rear camera | ⚪ **Not tested** | No capture pipeline or verified frame. | Functional capture pipeline. |
| Hardware video decoding / encoding | 🟡 **Partial — bounded output** | Iris on Linux 7.3.0-15 produces 30 exact H.264 baseline frames; a 640×360 H.264 Main encode yields 30 independently decoded frames and correct SPS timing. | Native FFmpeg High/B-frame decode still fails; encoding color metadata, rate control, larger modes and endurance remain open. |
| VA-API / browser video | 🟡 **Partial — bounded decode** | VA 0.4 on Linux 7.3.0-15: H.264 Baseline/Main/High, HEVC Main/Main10 and VP9 Profile0/2 each produce 30 exact-reference 320×240 frames, including ten-bit references. | CPU readback only; Chrome/WebCodecs/WebRTC, DMA-BUF presentation, larger modes, lifecycle and sustained operation remain open. |

### Power, thermal management and platform services

| Feature | Status | Observed result | Remaining validation / limits |
|---|---|---|---|
| Battery percentage / voltage / temperature | 🟢 **Working — readings** | Readings available after normal boot. | Independent accuracy checks. |
| Battery current / net power | 🟢 **Working — readings** | Signed current, net battery power and charge counter available. | Protection effectiveness assessed separately. |
| Charging from computer USB | 🟡 **Partial** | USB input detected; system load can exceed the supply. | Sustained net charging under the tested load. |
| USB Power Delivery / fast charging | 🟡 **Partial — powered dock** | Battery charging through the powered dock observed. | Negotiated protocols and protection. |
| Charge limits / charge stop | 🟡 **Partial — effect unverified** | 70/80 setting retained. | Physical cutoff and restart hysteresis. |
| Battery bypass / direct system supply | ⚪ **Not qualified** | No verified bypass or battery isolation. | Physical power-path qualification. |
| Native device management | 🟡 **Partial** | Installed Control 1.14 reports status/inventory; expanded 2.3 CLI and charging/NFC views have source/host checks. | New source is separate from installed and physically validated controls. |
| RGB notification LED | 🟢 **Working — bounded color test** | Signed Control 1.12.0-5 on Linux 7.3.0-5 passes a visible ten-second color test and returns off. | Real low-battery/camera policy, calibrated colors, electrical/thermal endurance and suspend. |
| Torch / flashlight | ⚪ **Not qualified** | Guarded native controls and unprivileged slider source exist. | Signed extension delivery, actual light output, protections and lifecycle. |
| Charging protection | ⚪ **Not qualified** | Conservative admission and software refusal fixtures exist. | Electrical cutoff/restart/restore, moisture/thermal/fault response and endurance. |
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

26 October 2026: `./ukelinux.sh` offers image and native kernel builds on Ubuntu,
Fedora, openSUSE, Arch Linux and Alpine hosts. Image selections cover multiboot
or singleboot, EXT4/F2FS/Btrfs/XFS, original KDE/GNOME and stable/testing/unstable
package channels. Output defaults to `out` in the invoking directory.

[Public build and manual installation guide](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/PUBLIC-BUILD.md)
includes source pins, prerequisite confirmation, local-data boundaries and
output verification. The 26 October Linux 7.3.0-16 KDE EXT4 singleboot export
passes host image checks with the [frozen release recipe](https://github.com/MCC45TR/uke-fedora-builder/blob/b0fd2380b07dbaaf37403c057b74796faf8f5ed3/docs/PUBLIC-BUILD.md).
Other combinations and exact exported-image tablet acceptance remain separate.
**Run `sudo dnf update --refresh`
after the first Fedora boot and use the configured signed repositories for updates.**
Keep the kernel, modules, device trees and boot profile matched, retain a working
rollback, and verify `uname -r` after the planned restart. Automatic slot
activation remains disabled; a DNF transaction alone does not prove a new boot.

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
