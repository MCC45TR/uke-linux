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
</table>

[Downloads](#downloads) · [Hardware support](#hardware-support) · [Documentation](#documentation) · [Repositories](#project-repositories) · [Report a problem](CONTRIBUTING.md)

> [!WARNING]
> **Not suitable for daily use.** Boot reliability, shutdown, power management
> and several hardware functions remain incomplete. System suspend is disabled.

## Project status

**18 October 2026:** the development installation runs Fedora Rawhide KDE on a
**POCO Pad X1, 8 GB / 512 GB**, using kernel **`7.2.10-8`** and the stock Android
bootloader. Native display output reaches **3200×2136 at 144 Hz**. Xiaomi Pad 7
and other memory/storage variants remain untested.

The hardware results below apply to this separately provisioned development
system. **The public Alpha 1 images use an older kernel and have not been booted
on the tablet as complete exported artifacts.** OEM firmware and device
calibration files are not distributed.

## Downloads

- **[Fedora Rawhide Alpha 1 — images and checksums](https://github.com/MCC45TR/uke-linux/releases/tag/fedora-rawhide-alpha-1)** — Linux 7.2.9, revision 1.39; predates the current native display and sensor work.
- [Development RPMs on COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) — kernel and platform packages, with validation recorded per build.
- [Linux image releases](https://github.com/MCC45TR/uke-linux-images/releases) · [Experimental OrangeFox releases](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases).

Public installation instructions are pending. Read the release requirements and
verify checksums before using an artifact. **The `userdata` variant replaces
Android user data; it is not a data-preserving dual-boot route.**

## Hardware support

**Validation scope:** POCO Pad X1, 8 GB / 512 GB; Fedora Rawhide AArch64; stock
Android bootloader. The persistent development boot is
`7.2.10-8`, reviewed on 18 October 2026. Earlier subsystem tests
are identified where relevant. These are development-system observations, not acceptance of
the downloadable Alpha 1 images.

<details>
<summary><strong>View all hardware support tables</strong></summary>

Each row records the function's current status, observations, and remaining work.

- 🟢 **Working:** the listed function was used successfully on the tested tablet;
  the stated limits still apply.
- 🟡 **Partial:** some functions work, with incomplete integration or validation.
- 🔴 **Broken:** the function is not currently operational in this Linux stack;
  this does not imply a physical hardware defect.
- ⚪ **Not tested:** no functional test result is available.
- ⏸️ **Disabled:** kept off while a known fault is investigated.

### Boot, CPU and storage

| Feature | Status | Validation and remaining work |
|---|---|---|
| Fedora boot | 🟡 **Partial** | The signed COPR 7.2.10-8 slot B bundle reaches native-display KDE. Automatic sensor startup returns after normal persistent boot. Cold-boot endurance and failure recovery remain open. |
| CPU — Snapdragon 7+ Gen 3 (SM7675) | 🟢 **Working** | All eight cores are online. Heavy workloads have not been tested. |
| CPU frequency control | 🟡 **Partial** | Three policies retain their complete firmware tables and reach 1900.8, 2611.2 and 2803.2 MHz requests under the performance profile. Energy, voltage and sustained throttling behavior remain unqualified. |
| RAM | 🟡 **Partial** | About 7.21 GiB of the installed 8 GB is available. Memory stress and sleep retention have not been tested. |
| UFS storage | 🟢 **Working** | The internal Fedora root supports reads and writes. Long transfers, power loss and resume have not been tested. |
| Linux partition / EXT4 | 🟡 **Partial** | The 64 GiB root mounts by `PARTLABEL=linux`. Filesystem checks pass after orphan repair; power-loss recovery and complete file integrity still need testing. |
| `reboot bootloader` | 🟡 **Partial** | Reaches fastboot. USB re-enumeration has required physical reconnects. Shutdown reliability remains affected by the KDE clipboard hang. |
| Normal reboot, recovery command and poweroff | 🟡 **Partial** | Normal KDE reboot reaches the signed persistent 7.2.10-8 bundle. Poweroff stays off without USB; USB-powered poweroff can restart the system. Intermittent full shutdown can hang in KDE. Recovery entry is unqualified. |
| Project Aloha / UEFI boot | ⚪ **Not tested** | The Uke UEFI port is in development. Current Fedora tests use the Android bootloader. |

### Display, graphics and input

| Feature | Status | Validation and remaining work |
|---|---|---|
| Tablet screen / local TTY | 🟢 **Working** | A local console and KDE desktop are visible at 3200×2136. The 17 October native-display boot uses MSM DRM scanout. |
| Manual backlight brightness | 🟢 **Working** | Smooth adjustment was confirmed on 17 October. Both banks use the exact OEM normal-mode mapping through the standard non-linear backlight interface. Active zero requests retain a visible minimum. Optical calibration and automatic control are separate. |
| Screen-off backlight / DPMS | 🟡 **Partial** | Three bounded screen-off/on cycles retain the touch input device. Touch readiness improves from about 1.5 s to 0.65–0.71 s; the user reports normal use. Full suspend remains unqualified. |
| Native DPU / DSI / DSC display | 🟢 **Working** | The persistent development bundle displays KDE through DSI-1 and msm-kmsdrmfb. The earlier seven-rate transition tests remain bounded; long-run and suspend tests remain open. |
| Refresh-rate switching | 🟢 **Working** | KDE exposes 30/48/50/60/90/120/144 Hz. Nine measured transitions passed on 17 October without panel reset, visible blanking or interrupted touch. Long-run and suspend tests remain open. |
| Adaptive sync / dynamic refresh | 🔴 **Broken** | No qualified VRR implementation. Discrete OEM modes do not establish adaptive-sync support. |
| Firmware DRM fallback | 🟡 **Partial** | Revision 1.39 uses simpledrm and the bootloader framebuffer. This older path remains separate from the native-display development track. |
| Original Fedora KDE / Wayland | 🟡 **Partial** | Original Fedora applications run on native scanout. A full-shutdown dump identifies a Wayland clipboard deadlock in KGuiAddons 6.31.0; an original distribution fix and repeat tests are required. |
| Manual display rotation | 🟢 **Working** | KScreen manual rotation works. Automatic four-pose rotation and matching touch coordinates also pass direct user checks. |
| GPU — Adreno 732 | 🟡 **Partial — experimental** | Hardware rendering and bounded OpenGL/Vulkan tests pass. Nine 255–950 MHz states are exposed and residency changes during use. CPU/GPU profiles change limits. Sustained workloads, thermal actions and suspend remain unqualified. |
| Xwayland / OpenGL | 🟡 **Partial — experimental** | A fresh session reports Freedreno and hardware acceleration, with OpenGL 4.6 available. Late GPU loading requires a clean graphical session; broad application testing remains open. |
| Vulkan / Turnip | 🟡 **Partial — experimental** | A bounded Wayland cube completes on the hardware GPU. Vulkan conformance, long workloads and lifecycle tests have not been completed. |
| Touchscreen — Novatek NT36532 | 🟢 **Working** | Single-finger input and multitouch remain usable across all seven refresh rates, confirmed on 17 October. Ten simultaneous contacts worked in the 14 October test. Input starts automatically; suspend/resume remains to be validated. Stylus support is listed separately. |
| Stylus / pen | 🔴 **Broken** | Pen input, pressure and tilt are unavailable. |
| Power / volume buttons | 🟢 **Working** | All power and volume buttons work during normal Fedora use, confirmed on 14 and 17 October. Wake from actual suspend is listed separately. |
| USB keyboard / mouse | 🔴 **Broken** | The USB mouse dongle was not detected. USB host mode does not work. |
| Pogo keyboard / touchpad | ⚪ **Not tested** | No pogo keyboard is available. The OEM Nanosic transport and MiAuth authentication still need a native Linux implementation. The Android [keyboard fix](https://github.com/JohnnyFFM/xiaomi-keyboard-fix/tree/f838a54bd70f84087cd35b54d5d62c7bba489d15) is a protocol reference. No keyboard light control is exposed without hardware. |

### Networking and USB

| Feature | Status | Validation and remaining work |
|---|---|---|
| Wi-Fi — WCN6750 | 🟢 **Working** | Automatic connection, SSH, DNS and a verified 16 MiB transfer work. The protected factory-data reader supplies the device's own WLAN address across restarts. Broader cold-boot and resume testing remains open. |
| Signed network updates | 🟢 **Working** | Fedora and COPR packages install over Wi-Fi with signature checks. Kernel and boot-image updates require matching files. |
| Bluetooth | 🟢 **Working — mouse** | The controller starts automatically. A Bluetooth 5.2 mouse pairs, reconnects and supplies movement, clicks and wheel input. Audio and broader device/lifecycle coverage remain untested. |
| NFC | ⚪ **Not tested** | No controller is exposed. A fitted NFC chip has not been confirmed. |
| USB overall | 🟡 **Partial** | Device mode works with a computer. Automatic host/device data roles and source/sink power roles are incomplete; accessories are not reliable. |
| USB CDC ACM / serial shell | 🟡 **Partial** | Bidirectional development commands work through normal boot and switch-root. Physical reconnect, suspend and role-change reliability remain unqualified. |
| USB ECM / SSH | 🟢 **Working — manual** | SSH and a verified 16 MiB transfer worked in earlier tests. USB networking is now off by default; development uses Wi-Fi. |
| USB host / accessory power (VBUS) | 🔴 **Broken** | The USB port did not supply power to the ESP32-S3. Host accessories are not usable yet. |
| USB-C switch / role control | 🟡 **Partial** | The switch driver starts and device mode works. Data-role and source/sink power-role selection are not yet correct across connections; role changes and accessory power need work. |
| USB reconnect / driver lifecycle | 🟡 **Partial** | Software reconnect worked. A live battery-driver reload caused a USB fault; the correction and physical cable reconnect still need testing. |
| USB SuperSpeed | ⚪ **Not tested** | No USB 3 accessory transfer has been verified. |
| DisplayPort / USB-C video output | ⚪ **Not tested** | No successful external-display test. |
| USB Ethernet adapters / hubs | ⚪ **Not tested** | No functional adapter or hub test. |

### Sensors and desktop integration

The persistent development boot starts SSC and SensorProxy through native readiness
dependencies. Original KDE consumes their standard D-Bus interfaces. Factory
registry and calibration data stay on read-only `persist`; runtime registry
writes use a RAM copy. Not every discovered endpoint has a qualified Linux
event mapping or physical calibration result.

| Feature | Status | Validation and remaining work |
|---|---|---|
| Sensor DSP / SSC discovery | 🟡 **Partial** | Native registry/cache and FastRPC dependencies start automatically. Motion, light, compass and proximity interfaces appear after persistent boot. DSP restart recovery and remaining endpoint mappings are incomplete. |
| Accelerometer — LSM6DSO | 🟢 **Working — rotation** | Four physical poses and touch alignment pass user checks after the orientation correction; the function survives normal persistent boot. Factory registry data is read from read-only persist. Absolute calibration accuracy remains unqualified. |
| Gyroscope — LSM6DSO | 🟡 **Partial** | Finite XYZ angular-velocity samples are available in radians per second. Drift and dynamic accuracy remain unqualified. |
| Magnetometer / compass — QMC630x family | 🟡 **Partial** | SensorProxy returns finite headings that change through physical motion. Absolute heading accuracy is not established; the phone comparison does not pass. Factory calibration remains read-only. |
| Front light sensor — STK3BCx family | 🟢 **Working — ambient light** | Front lux responds to illumination and participates in dual-sensor KDE brightness. Vendor raw channels are retained without invented units; spectral accuracy remains unqualified. |
| Rear light sensor — SIP1328 | 🟢 **Working — ambient light** | Rear-only illumination changes KDE backlight while the front stays dark. Lux response is measured; raw spectral channels and flicker require separate qualification. |
| Front proximity sensor — STK3BCx family | 🟢 **Working — near/far** | Physical open, covered and released trials report far → near → far through standard SensorProxy. Automatic desktop actions and longer lifecycle tests remain unqualified. |
| SAR / body proximity — SX937x family | ⏸️ **Disabled** | Three authorized SAR lookups return no endpoint; no sample vector or physical response is established. It remains disabled. |
| Automatic rotation / sensor fusion | 🟢 **Working — four poses** | Original KDE rotates correctly in all four poses with matching touch coordinates. Normal persistent boot restores the feature. |
| Automatic brightness | 🟡 **Partial** | Original KDE exposes and enables automatic brightness using jointly processed front/rear light and an OEM-derived curve. Dark/front/rear transitions and normal persistent startup pass. A 45-second white / 45-second black trial stays at 22/2047 without runaway. Long-run and sunlight tests remain open. |
| Magnetic cover / lid detection | 🟡 **Partial — input events** | On 7.2.10-8, the Hall module and both input nodes appear automatically. Front close/open and rear fold/unfold generate standard switch events; logind tracks the lid. Cover-triggered display blanking and closed-cover boot remain unqualified. |
| Temperature sensors | 🟡 **Partial** | On 7.2.10-8, 69 hwmon temperature inputs and 51 thermal zones are readable. All 27 PMIC channels expose 17 temperatures, eight voltages and two currents through standard interfaces and KDE. Counts overlap. Internal CHG_TEMP reads 31.29–31.41 °C with USB power; its inactive near-zero input is OEM-clamped to 0 °C without USB power. Conversion checks pass; absolute calibration and complete thermal policy remain unqualified. |

### Audio, cameras and media

| Feature | Status | Validation and remaining work |
|---|---|---|
| Internal speakers | 🔴 **Broken** | No usable ALSA playback route. |
| Microphones | 🔴 **Broken** | No usable ALSA recording route. |
| USB / Bluetooth audio | ⚪ **Not tested** | No playback or recording acceptance. Bluetooth mouse support does not establish an audio route. |
| Front camera | ⚪ **Not tested** | No verified capture pipeline or frame. |
| Rear camera | ⚪ **Not tested** | No verified capture pipeline or frame. |
| Hardware video decoding / encoding | ⚪ **Not tested** | No verified hardware codec workload. |

### Power, thermal management and platform services

| Feature | Status | Validation and remaining work |
|---|---|---|
| Battery percentage / voltage / temperature | 🟡 **Partial** | Readings start automatically on normal slot-B boots. Long-term accuracy and all battery states still need testing. |
| Battery current / power / charging indication | 🟡 **Partial** | Signed current, derived voltage×current power and charge-counter readings reach standard power-supply/hwmon interfaces. External power can be present while the battery discharges; a Charging flag alone does not prove energy gain. |
| Charging from computer USB | 🟡 **Partial** | Revision 1.39 automatically admits the enumerated 500 mA budget; measured input is about 450 mA. Active-system load can exceed this supply, and a three-minute native diagnostic trial lost battery charge. Sustained net charging remains unqualified. |
| USB Power Delivery / fast charging | ⚪ **Not tested** | Higher-power charging and protocol/protection behavior have not been tested. |
| Plasma battery indicator | 🟡 **Partial** | The battery icon and readings were observed through UPower. Startup and current/counter interpretation still need work. |
| Desktop power profiles | 🟡 **Partial** | Three real CPU/GPU profiles are exposed through PPD. Governor and GPU-cap changes pass bounded physical checks. Sustained energy, responsiveness and complete OEM thermal policy remain unqualified. |
| Thermal protection / throttling | 🟡 **Partial** | Software-emulated thermal events lower three CPU policy limits and the GPU limit; PPD respects thermal QoS. All emulation values are cleared afterward. Actual heat, sustained throttling, protective shutdown and full OEM BCL/skin policy remain unqualified. |
| Display-only soft sleep | 🟡 **Partial** | One screen-off/on cycle turned off and restored the backlight. This does not suspend the system. |
| Suspend-to-idle / s2idle | ⏸️ **Disabled** | Sleep remains disabled. The brief black-screen interval did not confirm suspend entry. |
| Deep suspend | ⚪ **Not tested** | Advertised by the kernel; actual sleep and resume have not been verified. |
| Power-key IRQ wake | ⚪ **Not tested** | The input and wake flag exist. Wake from actual sleep has not been tested. |
| USB cable wake | 🔴 **Broken** | Required USB wake interrupts are missing from the current device tree. |
| USB keyboard / mouse wake | 🔴 **Broken** | USB host accessories do not work yet. |
| RTC / persistent clock | 🟡 **Partial** | The raw RTC reports an incorrect startup time. Original chronyd restores its saved drift-file time before readiness, then synchronizes over NTP; a fresh boot confirms this behavior. |
| Watchdog | 🟡 **Partial** | The driver starts. Recovery behavior has not been tested. |
| PMIC / regulators | 🟡 **Partial** | Storage and USB have enough working resources. Other PMIC probes still fail. |
| DMA / IOMMU resources | 🟡 **Partial** | Storage, USB and Wi-Fi paths work. GPU and other clients need integration and testing. |
| Interconnect / platform power control | 🟡 **Partial** | Basic root and USB operations work. Provider errors and power/performance behavior remain unresolved. |
| DSPs — ADSP / CDSP / QSH | 🟡 **Partial** | ADSP charger and SSC services start through native resource/readiness dependencies. Audio, other DSPs and restart reliability remain incomplete. SLIMbus and automatic DSP recovery stay disabled. |
| FastRPC | 🟡 **Partial** | Two admitted ADSP contexts serve the sensor registry after persistent boot. General DSP compute and recovery remain unqualified. |
| CoreSight tracing | ⏸️ **Disabled** | Autoload is blocked after earlier resets. The cause still needs investigation. |

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
