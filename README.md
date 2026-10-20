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
> **Not suitable for daily use.** Boot reliability, shutdown, power management
> and several hardware functions remain incomplete. Suspend now selects s2idle;
> physical wake, resume reliability and sleep power remain under validation.

## Project status

**20 October 2026:** the tested development installation uses **POCO Pad X1,
8 GB / 512 GB**, Fedora Rawhide, original KDE and **Linux 7.2.11-6** with the
stock Android bootloader. KDE boots with display, touch, Wi-Fi, rotation and
automatic brightness. Fixed refresh modes work; VRR remains disabled after
input/display faults.

The table below records the functions that work and the problems still open.
Charge cutoff/bypass, shutdown reliability, sleep, powered HDMI and internal
audio remain incomplete. Offline charging currently starts KDE instead of the
charging screen. Detailed changes and test limits are in the
[development record](CHANGELOG.md).

**The public Alpha 1 images are older and have not been validated as complete
exported artifacts on the tablet.** The development installation is separate.
Xiaomi Pad 7 and other memory/storage variants remain untested. OEM firmware
and device calibration are not distributed.

## Release readiness

For a stable/OEM release, these items remain:

- **Charging:** verify cutoff, restart hysteresis and thermal behavior; resolve offline entry and qualify any advertised bypass.
- **Display and touch:** resolve multitouch/VRR faults, blanking failures and repeated DPMS transitions.
- **Boot and recovery:** reliable cold boot, reboot, shutdown, fastboot USB detection and a tested rollback route.
- **Sleep:** repeated s2idle, physical wake, restored devices and measured sleep power.
- **USB-C dock:** correct power/data roles, powered HDMI, storage and Ethernet together.
- **Internal audio:** working protected speaker playback and microphone recording.
- **Performance:** resolve scrolling stutter and complete memory, thermal and endurance tests.
- **Release image:** validate the complete image, first boot, signed updates, rollback, security defaults and installation instructions.

Experimental alphas can retain clearly documented limitations. Optional hardware
and unfinished features remain listed below; an untested feature is not Working.
See the [release checklist and status evidence](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/UKE-RELEASE-READINESS-2026-10-20.md).

## Downloads

- **[Fedora Rawhide Alpha 1 — images and checksums](https://github.com/MCC45TR/uke-linux/releases/tag/fedora-rawhide-alpha-1)** — Linux 7.2.9, revision 1.39; predates the current native display and sensor work.
- [Development RPMs on COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) — kernel and platform packages, with validation recorded per build.
- [Linux image releases](https://github.com/MCC45TR/uke-linux-images/releases) · [Experimental OrangeFox releases](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases).

Public installation instructions are pending. Read the release requirements and
verify checksums before using an artifact. **The `userdata` variant replaces
Android user data; it is not a data-preserving dual-boot route.**

## Hardware support

**Test scope:** POCO Pad X1, 8 GB / 512 GB; Fedora Rawhide AArch64; stock Android
bootloader; development kernel `7.2.11-6`. Reviewed **20 October 2026** using
14–20 October observations, including earlier development kernels. The
[evidence record](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/UKE-RELEASE-READINESS-2026-10-20.md)
identifies their scope. These results do not validate the downloadable Alpha 1 images.

<details>
<summary><strong>View all hardware support tables</strong></summary>

Each row records the function's current status, observations, and remaining work.

- 🟢 **Working:** the listed function was used successfully on the tested tablet;
  the stated limits still apply.
- 🟡 **Partial:** some functions work, with incomplete integration or validation.
- 🔴 **Broken:** the function is not currently operational in this Linux stack;
  this does not imply a physical hardware defect.
- ⚪ **Not tested / not qualified:** the needed functional or calibration result is unavailable.
- ⏸️ **Disabled:** kept off while a known fault is investigated.

### Boot, CPU and storage

| Feature | Status | Observed result / remaining work |
|---|---|---|
| Fedora boot | 🟢 **Working** | I can boot KDE with working display and touch on kernel 6. Published-image validation is separate. |
| CPU — Snapdragon 7+ Gen 3 (SM7675) | 🟢 **Working** | All eight cores are online. Sustained heavy-load testing remains open. |
| CPU frequency policies | 🟢 **Working** | All three CPU policies accept power-profile changes. Sustained performance and energy remain unverified. |
| RAM | 🟡 **Partial** | Linux uses 7.21 GiB. Sustained memory tests stopped at the 65 °C guard before completion. |
| UFS storage | 🟢 **Working** | A 256 MiB write/readback passes; a bounded direct read reaches about 1.7 GB/s. |
| UFS scaling / WriteBooster | 🟢 **Working** | Gear scaling, WriteBooster and runtime idle states change under load. MCQ and inline encryption remain disabled. |
| Memory-pressure telemetry | 🟢 **Working** | CPU, memory and I/O pressure counters are available. Effective OOM policy is not validated. |
| UFS I/O scheduler | 🟢 **Working** | mq-deadline stays active across two boots without the earlier scheduler-switch errors. |
| Linux partition / EXT4 | 🟢 **Working** | Fedora boots from the dedicated EXT4 linux partition. Power-loss recovery remains untested. |
| Bootloader entry | 🟢 **Working** | I can reach the FASTBOOT screen. USB detection is listed separately. |
| Fastboot USB connection | 🟡 **Partial** | Earlier sessions worked; the current PC connection is not detected. |
| Normal reboot — kernel 6 | 🟢 **Working** | The tested normal reboots return to KDE. Shutdown reliability remains a separate issue. |
| Shutdown / poweroff | 🟡 **Partial** | USB-powered shutdown can restart the tablet. An intermittent shutdown hang remains unresolved. |
| Reboot to recovery | ⚪ **Not tested** | Recovery entry from the current Fedora kernel is not validated. |
| Hardware information / Fastfetch | 🟢 **Working** | The all-module capture completes; some hardware fields remain unavailable. |
| Project Aloha / UEFI boot | ⚪ **Not tested** | Development continues separately. These Fedora tests use the stock Android bootloader. |

### Display, graphics and input

| Feature | Status | Observed result / remaining work |
|---|---|---|
| Tablet screen / local TTY | 🟢 **Working** | KDE and the local console display at 3200×2136. |
| Manual backlight brightness | 🟢 **Working** | I can adjust brightness smoothly. Optical calibration remains unverified. |
| Screen-off backlight / DPMS | 🟡 **Partial** | Off/on cycles work, but one of ten cycles logs a DPU frame-done timeout. |
| Native DPU / DSI / DSC display | 🟢 **Working** | Native scanout displays KDE on the internal screen. Lifecycle testing remains open. |
| Refresh-rate switching | 🟢 **Working** | I can switch fixed modes between 30/48/50/60/90/120/144 Hz. VRR is separate. |
| Adaptive sync / dynamic refresh | ⏸️ **Disabled — input regression** | VRR causes multitouch/display faults and touch watchdogs. It remains off; physical 1 Hz is unsupported. |
| Display color depth | 🟡 **Partial** | The 10-bit framebuffer and DSC link are active. Selectable 8/12/16-bit output is not implemented. |
| Firmware DRM fallback | 🟡 **Partial** | The older firmware framebuffer path worked. Current fallback behavior remains untested. |
| Original Fedora KDE / Wayland | 🟡 **Partial** | The desktop and applications run. A clipboard-related shutdown deadlock remains unresolved. |
| Desktop scrolling | 🟡 **Partial** | Settings-list scrolling still stutters. Stable display Hz does not establish smooth content frames. |
| Manual display rotation | 🟢 **Working** | Display rotation works with matching touch coordinates. |
| GPU — Adreno 732 | 🟡 **Partial** | Desktop OpenGL works; OpenGL ES validation failures and lifecycle checks remain open. |
| KDE GPU statistics | 🟡 **Partial** | Idle usage and frequency reach KSystemStats. Active-load accuracy and GUI presentation remain unverified. |
| Xwayland / OpenGL | 🟢 **Working — desktop OpenGL** | Wayland and Xwayland each pass 27 output checks plus bounded rendering workloads. |
| Vulkan / Turnip | 🟡 **Partial** | A 9,000-frame cube completes, but vulkaninfo fails a display-extension query. |
| Touchscreen — Novatek NT36532 | 🟡 **Partial** | Touch works in normal use. Ten-contact/VRR faults and continuous-contact reliability remain unresolved. |
| Stylus / pen | 🔴 **Broken** | Pen input, pressure and tilt are unavailable. |
| Power / volume buttons | 🟢 **Working** | Power and volume buttons respond in normal Fedora use. Suspend wake is separate. |
| Power-button screen toggle | 🟡 **Partial** | Display-only behavior is configured; physical toggle validation is pending. |
| USB receiver mouse | 🟢 **Working** | The receiver mouse works through the powered Juo dock on 7.2.10-27. |
| USB keyboard | ⚪ **Not tested** | Keyboard input has not been physically tested. |
| Pogo keyboard / touchpad | ⚪ **Not tested** | No keyboard is available. Native transport and authentication remain incomplete. |

### Networking and USB

| Feature | Status | Observed result / remaining work |
|---|---|---|
| Wi-Fi — WCN6750 | 🟢 **Working** | Automatic connection, SSH and file transfers work. The factory WLAN address is retained across restarts. |
| Signed network updates | 🟢 **Working** | Signed Fedora and COPR packages install over Wi-Fi. Kernel updates retain matched boot/module checks. |
| Bluetooth | 🟢 **Working — mouse and audio** | The mouse pairs and reconnects; Space Q45 LDAC playback works. Broader device coverage remains open. |
| NFC | ⚪ **Not tested** | No controller is exposed; fitted hardware is not confirmed. |
| USB overall | 🟡 **Partial** | Device mode and dock mouse operation work. Role changes and combined dock workloads remain incomplete. |
| USB CDC ACM / serial shell | 🟢 **Working — manual** | Manual serial commands work. CDC defaults off; current-cable reconnect and suspend coverage remain open. |
| USB ECM / SSH | 🟢 **Working — manual** | Earlier SSH and verified 16 MiB transfers pass. USB networking defaults off. |
| USB host / accessory power (VBUS) | 🟡 **Partial** | Dock devices enumerate, but accessory power budget and the earlier ESP32 power failure remain unverified. |
| USB-C switch / role control | 🟡 **Partial** | PC sink/device and dock host/sink states are reported. Broader role switching remains incomplete. |
| USB reconnect / driver lifecycle | 🟡 **Partial** | Software reconnect worked. Physical reconnect and driver-reload fault recovery remain open. |
| USB SuperSpeed | 🟡 **Partial** | Hub and RTL8153 devices enumerate at 5 Gbit/s. Storage throughput remains untested. |
| DisplayPort / USB-C video output | 🟡 **Partial** | No successful tablet HDMI output yet. Powered testing awaits the charging-protection gate. |
| External-monitor DDC/CI brightness | 🟡 **Partial** | PowerDevil/ddcutil initializes. Actual monitor brightness control remains untested. |
| USB hubs | 🟢 **Working — tested dock** | Juo USB 2/3 hubs enumerate and the powered-dock mouse works. Storage and Ethernet are separate. |
| USB Ethernet | 🟡 **Partial** | RTL8153 and its firmware are detected. Cable carrier and real network traffic remain untested. |

### Sensors and desktop integration

Sensor startup uses native readiness dependencies. Factory calibration remains
on read-only persist; runtime registry writes use RAM. Some endpoints still
lack a validated physical mapping.

| Feature | Status | Observed result / remaining work |
|---|---|---|
| SSC sensor startup | 🟢 **Working** | Motion, light and proximity services start automatically. DSP restart recovery remains open. |
| Accelerometer — LSM6DSO | 🟢 **Working — rotation** | All four physical orientations work with matching touch alignment. |
| Gyroscope — LSM6DSO | 🟡 **Partial** | XYZ rates are readable. Physical motion response and drift still need validation. |
| Magnetometer / compass — QMC630x family | 🟡 **Partial** | Heading changes with movement, but the absolute-heading comparison did not pass. |
| Front light sensor — STK3BCx family | 🟢 **Working — ambient light** | Lux responds to front illumination and controls KDE brightness. |
| Rear light sensor — SIP1328 | 🟢 **Working — ambient light** | Rear illumination changes brightness while the front remains dark. |
| Ambient color temperature | ⚪ **Not qualified** | No valid startup color sample or calibrated Kelvin conversion is available. |
| Front proximity sensor — STK3BCx family | 🟢 **Working — near/far** | Covering and uncovering the sensor produces far → near → far. |
| SAR / body proximity — SX937x family | ⏸️ **Disabled** | No usable endpoint or physical response is established. |
| Automatic rotation / sensor fusion | 🟢 **Working — four poses** | KDE rotates correctly in all four orientations, including touch alignment. |
| Automatic brightness | 🟢 **Working** | Brightness follows front/rear light changes. Long-run and sunlight behavior remain untested. |
| Magnetic cover / lid detection | 🟢 **Working — switch events** | Front cover and rear fold produce the expected switch events. Cover-triggered blanking is unverified. |
| Temperature telemetry | 🟢 **Working** | PMIC and thermal readings reach standard interfaces and KDE. Absolute calibration and protection are separate. |

### Audio, cameras and media

| Feature | Status | Observed result / remaining work |
|---|---|---|
| Internal speakers | 🔴 **Broken** | No usable ALSA playback route. |
| Microphones | 🔴 **Broken** | No usable ALSA recording route. |
| Bluetooth audio / LDAC | 🟢 **Working — stereo playback** | LDAC playback sounds clear on the Space Q45. Microphone/HFP and suspend remain untested. |
| USB audio | ⚪ **Not tested** | USB playback and recording have not been tested. |
| Front camera | ⚪ **Not tested** | No capture device or verified frame is available. |
| Rear camera | ⚪ **Not tested** | No capture pipeline or verified frame is available. |
| Hardware video decoding / encoding | ⚪ **Not tested** | No usable hardware codec device or workload is established. |

### Power, thermal management and platform services

| Feature | Status | Observed result / remaining work |
|---|---|---|
| Battery percentage / voltage / temperature | 🟢 **Working — readings** | Battery percentage, voltage and temperature are available after normal boot. Accuracy remains independently unverified. |
| Battery current / net power | 🟢 **Working — readings** | Signed current, net battery power and charge-counter readings are available. Protection is separate. |
| Charging from computer USB | 🟡 **Partial** | USB input is detected, but system load can still discharge the battery. Sustained net charging is unverified. |
| USB Power Delivery / fast charging | 🟡 **Partial — powered dock** | Powered-dock charging is observed. Negotiated protocols and protection remain unverified. |
| Charge limits / charge stop | 🟡 **Partial — effect unverified** | The 70/80 setting persists, but actual cutoff and restart hysteresis are not established. |
| Battery bypass / direct system supply | ⚪ **Not qualified** | No verified bypass or battery-isolation result. |
| Native device management | 🟡 **Partial** | Status, sensor reports and inventory work. Swap-partition preference and advanced control paths still need testing. |
| Battery runtime estimates | 🟡 **Partial — software checks** | Model checks pass, but qualified device forecasts remain unavailable. |
| Offline charging | 🔴 **Broken — charger-mode entry** | USB-triggered starts return to KDE. The native charging screen is not reached. |
| Plasma battery indicator | 🟢 **Working** | The battery icon and readings appear in KDE. |
| Desktop power profiles | 🟢 **Working** | I can switch all three power modes without an error. Sustained energy and thermal behavior remain unverified. |
| Thermal protection / throttling | 🟡 **Partial** | Emulated events lower CPU/GPU limits. Actual heat and protective shutdown remain unverified. |
| Display-only soft sleep | 🟡 **Partial** | Off/on cycles restore scanout, but one DPU timeout remains. |
| Suspend-to-idle / s2idle | 🟡 **Partial — RTC wake tested** | One RTC-wake cycle returns successfully. Display, touch, power-key wake, repeated cycles and sleep energy remain unverified. |
| Deep suspend | ⚪ **Not tested** | Actual sleep and resume have not been tested. |
| Power-key IRQ wake | ⚪ **Not tested** | Power-key wake from real suspend has not been tested. |
| USB cable wake | 🔴 **Broken** | Required USB wake interrupts are missing from the current device tree. |
| USB keyboard / mouse wake | ⚪ **Not tested** | Input wake from actual suspend has not been tested. |
| RTC / persistent clock | 🟡 **Partial** | Hardware startup time is wrong. Saved-time restoration and NTP synchronization work. |
| Watchdog | 🟡 **Partial** | The driver starts; recovery behavior remains untested. |
| PMIC / regulators | 🟡 **Partial** | Essential storage/USB resources work; other PMIC probe failures remain. |
| DMA / IOMMU resources | 🟡 **Partial** | Essential device paths work. Broader client and lifecycle coverage remains incomplete. |
| Interconnect / platform power control | 🟡 **Partial** | Basic operation works; provider errors and measured power/performance remain unresolved. |
| DSPs — ADSP / CDSP / QSH | 🟡 **Partial** | Charger and sensor services start. Audio, other workloads and restart recovery remain incomplete. |
| FastRPC sensor transport | 🟢 **Working** | ADSP contexts serve sensor registry requests. General DSP compute and restart recovery remain unverified. |
| CoreSight tracing | ⏸️ **Disabled** | Autoload remains blocked after earlier resets. |

The current boot handoff is **EL1**. EL2/KVM work remains on a separate
experimental branch, and Project Aloha/UEFI is not the boot path used for the
reported Fedora tests.

</details>

## Documentation

| Topic | Guide |
|---|---|
| Build Fedora images | [Image recipes and validation](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/IMAGES.md) |
| Build the kernel | [Kernel build automation](https://github.com/MCC45TR/senemos-uke-kernel-mainline/blob/main/docs/AUTOMATION.md) |
| Boot requirements and rollback | [Stock-bootloader boot pair](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/testing/FEDORA-BOOT-PAIR.md) — private, access required |
| Development plan | [Milestones and remaining work](https://github.com/MCC45TR/uke-linux-docs/blob/main/PLAN.md) — private, access required |
| Engineering records | [Documentation index](https://github.com/MCC45TR/uke-linux-docs/blob/main/docs/README.md) — private, access required |
| Desktop screenshots | [Fedora KDE gallery](assets/screenshots) |
| Contributing and bug reports | [Reporting guide](CONTRIBUTING.md) · [Open an issue](https://github.com/MCC45TR/uke-linux/issues/new?template=bug_report.yml) |
| Security reports | [Security policy](SECURITY.md) |

## Project repositories

| Component | Repository |
|---|---|
| Kernel and device trees | [senemos-uke-kernel-mainline](https://github.com/MCC45TR/senemos-uke-kernel-mainline) |
| Hardware integration and packages | [uke-linux-hardware-support](https://github.com/MCC45TR/uke-linux-hardware-support) |
| Fedora image builder | [uke-fedora-builder](https://github.com/MCC45TR/uke-fedora-builder) |
| Image distribution | [uke-linux-images](https://github.com/MCC45TR/uke-linux-images) |
| OrangeFox Recovery | [orangefox_device_xiaomi_uke](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) |
| Experimental UEFI | [uke-project-aloha](https://github.com/MCC45TR/uke-project-aloha) |

## License

Original files use the [MIT License](LICENSE). Components retain their own
licenses and attribution. Uke Linux is an independent community project,
unaffiliated with Fedora, Xiaomi, POCO or Qualcomm.
