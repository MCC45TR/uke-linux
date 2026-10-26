# Uke Linux

Fedora Rawhide AArch64 for Xiaomi Pad 7 and POCO Pad X1 (`uke`, Qualcomm SM7675), using the original Fedora KDE Plasma desktop.

**Status updated: 26 October 2026. Experimental alpha.**

[Project status](#project-status) · [Recent changes](#recent-changes) · [Downloads](#downloads) · [Hardware support](#hardware-support) · [Updating Fedora](#updating-fedora) · [Build from source](#build-from-source) · [Repositories](#project-repositories)

![Fedora Rawhide KDE on the development installation, 17 October 2026](assets/screenshots/Lastest_Rawhide_Screen_Shot_Ref.png)

## Project status

POCO Pad X1 boots Fedora through the stock Android bootloader and runs the original KDE Wayland session. Recorded working functions include native internal display output, fixed refresh-rate selection, normal touch input, Wi-Fi, Bluetooth mouse and stereo audio, sensor-driven rotation and automatic brightness. These results come from the development installation, with the limitations below.

The current development kernel series is **Linux 7.3**. The latest recorded normal boot is **7.3.0-15**, installed from signed [COPR build 11207395](https://copr.fedorainfracloud.org/coprs/build/11207395/). Boot-image readback and the existing boot-health checks passed on 26 October. **HDMI output is working on Linux 7.3**, confirmed in the 26 October device-use report. The exact mode and output precision of that report were not remeasured.

Charging protection, suspend, display/input lifecycle, internal audio, cameras and hardware video remain incomplete. Working HDMI output does not establish HDR, DDC/CI monitor control or compressed transport. External DSC/FEC is experimental and disabled by default. The current firmware handoff remains EL1; KVM and Project Aloha are separate development work.

**The tested development installation is different from the published images.** Xiaomi Pad 7 and other memory/storage variants have not received equivalent physical validation. This project is not ready for general daily use.

## Recent changes

The following updates cover the development installation and source work recorded through **26 October 2026**:

| Area | Current change | Evidence and remaining work |
|---|---|---|
| Kernel | Development moved from Linux 7.2 to Linux 7.3; signed `7.3.0-15` is the latest recorded normal boot. | Boot readback and boot-health checks passed; older hardware observations retain their original test scope. |
| External display | HDMI output now works with Linux 7.3. | Confirmed in device use on 26 October; HDR, DDC/CI and experimental DSC/FEC remain separate. |
| KDE Connect | Original Fedora KDE Connect starts through normal desktop integration; a packaged local-network firewall policy enables discovery. | POCO F5 was discovered after the signed policy update. Pairing and transfer acceptance remain open. |
| Sensors and Bluetooth | Rotation, ambient-light response, proximity/cover events, mouse input and Space Q45 stereo playback have recorded results. | Accuracy, suspend and broader accessory coverage remain incomplete. |
| Graphics and video | Native GL/browser pixel checks and VA capability enumeration have progressed. | Capability listings do not establish decoded frames, browser hardware video, WebGPU or a working GPU sandbox. |
| Native platform tools | Control, identity, diagnostic and guarded power-management source has expanded. | Source/host/package results are distinguished from installed-device and electrical acceptance. |
| Images | Linux 7.3 KDE EXT4 singleboot replacement is being prepared. | Release assets and acceptance will be updated only after the exact output passes its host checks. |
| Recovery and UEFI | Recovery build-evidence fixtures and native Project Aloha boot-core tests have expanded. | These results do not establish a new recovery image or bootable Uke UEFI. |

See [Development changes](CHANGELOG.md) for dated context and the tables below for each function's current limit.

## Downloads

Availability checked on **26 October 2026**.

| Release | Current availability | Validation and limits |
|---|---|---|
| Linux 7.3 KDE image update | In preparation; replacement assets have not been uploaded | The new matched boot/root pair will retain separate host-image and tablet acceptance results. |
| [Fedora Rawhide Alpha 1, 15 October](https://github.com/MCC45TR/uke-linux/releases/tag/fedora-rawhide-alpha-1) | Three attached boot/root image files | Linux 7.2.9 revision 1.39; historical alpha, predating current display, sensor and Linux 7.3 work. The exact exported files have not completed tablet validation. |
| [KDE EXT4 singleboot test, 24 October](https://github.com/MCC45TR/uke-linux/releases/tag/prebuild-fedora-kde-singleboot-ext4-20261024-k7.2.12-22-testing) | Release notes only; no attached image assets at the time of this update | Original Fedora KDE and signed 7.2.12-22 package composition passed host image checks. Earlier direct `boot.img` and `system.img.zst` links are not available. |
| [Development RPMs](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) | Signed kernel and platform packages | Test channel; source, package and device results are recorded separately. |
| [OrangeFox test releases](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases) | Separate experimental recovery artifacts | Recovery has its own firmware, touch, storage and installation requirements. |

Read each release's exact installation targets, checksums, device scope and rollback instructions. Replacing Android `userdata` destroys Android applications, files and encryption metadata. A userdata-root singleboot image is not a data-preserving dual-boot installation.

Do not reuse calibration or a device-local touch reference on another tablet. Keep stock early firmware and a verified recovery route. After the first Fedora boot, run:

```sh
sudo dnf update --refresh
```

## Hardware support

**Test environment:** POCO Pad X1, 8 GB / 512 GB, Fedora Rawhide AArch64, original Fedora KDE and stock Android bootloader. This summary combines dated observations from 14–26 October, across Linux 7.2.10, 7.2.11, 7.2.12 and 7.3 development kernels. Older successful tests have not all been repeated on 7.3.0-15.

**Working** applies to the named, observed function. **Partial** means useful behavior exists with unresolved defects or incomplete coverage. **Not qualified** means source, enumeration or package evidence does not establish physical operation. No row validates an exported image or a different device variant.

### Boot, storage and updates

| Feature | Status | Observed result | Remaining work / limits |
|---|---|---|---|
| Stock-bootloader Fedora boot | Working — development installation | Normal Linux 7.3.0-15 boot accepted on 26 October. | Exact installation and matched boot/modules required. |
| Signed DNF kernel updates | Working — reviewed transactions | Matching kernel children, boot-image readback and retained rollback verified. | Interrupted updates, broader firmware/variant coverage and unattended lifecycle. |
| UFS and Linux root filesystem | Working — mounted development root | Fedora root, package installation and file transfers operate. | Full storage endurance and fault qualification. |
| Public exported images | Not qualified on tablet | Host filesystem, sparse-image and package checks exist. | Boot and complete acceptance of each exact export. |
| Filesystem/layout management | Host/VM tested | Native planning, filesystem and rollback fixtures are available. | Actual destructive storage operations need separate validation and authorization. |
| RTC and persistent clock | Partial | Saved-time restoration and network time work. | Correct hardware time at startup. |
| Project Aloha / UEFI | Development only | Native core, EFI and platform source work exists. | No complete bootable Uke UEFI or accepted Android-return installer. |
| EL2 / KVM | Not qualified | Separate kernel and firmware-handoff research. | Proven stock-firmware release of EL2 and actual KVM guest execution. |

### Display, input and desktop

| Feature | Status | Observed result | Remaining work / limits |
|---|---|---|---|
| Internal O82 DPU/DSI/DSC output | Working — recorded KDE sessions | Native scanout on the internal display. | Current-kernel lifecycle and sustained physical checks. |
| Fixed refresh rates | Working — recorded modes | 30/48/50/60/90/120/144 Hz selection. | Repeat the complete mode set on the current kernel. |
| Variable refresh rate | Partial — experimental | Bounded cadence policies and fixed-mode fallback exist. | Earlier multitouch/display regressions; no qualified physical 1 Hz path. |
| Internal color depth | Partial | Recorded 10-bpc framebuffer/link operation. | No qualified selectable 8/12/16-bpc output. |
| Brightness control | Working — recorded sessions | Manual and sensor-driven brightness operate. | Sunlight behavior, long-run comfort and current-kernel transitions. |
| Display off/on | Partial | Scanout has returned after software off/on. | Earlier frame-done timeout and wake/lifecycle faults. |
| Firmware framebuffer fallback | Partial | Earlier firmware-framebuffer operation recorded. | Current fallback and handoff reliability. |
| Original Fedora KDE / Wayland | Working — desktop session | Original desktop and applications run. | Clipboard-related shutdown hang and broader session lifecycle. |
| Desktop scrolling | Partial | Normal navigation works. | Previously observed settings-list stutter and content pacing. |
| Novatek NT36532 touch | Partial | Normal finger input and active native touch services. | Continuous contact, ten-contact/VRR regressions and gesture timeouts. |
| Manual rotation | Working — recorded sessions | Display rotation with matching touch coordinates. | Current-kernel transition coverage. |
| Stylus / pen | Not working in recorded tests | No functional pen, pressure or tilt input. | Driver/firmware integration and physical tests. |
| Power and volume buttons | Working — normal use | Button events respond in Fedora. | Wake from real suspend. |
| Double-tap / gesture wake | Not qualified | Guarded control/readiness source exists; gesture entry still times out in the latest boot record. | Actual armed gesture and physical wake. |
| USB receiver mouse | Working — tested powered dock | Recorded motion, clicks and pointer use. | Broader receiver and lifecycle coverage. |
| USB keyboard | Not tested | No accepted physical typing result. | Physical keyboard and wake tests. |
| Pogo keyboard / touchpad | Not tested | No physical accessory result. | Transport, authentication, input and illumination. |

### Graphics and browsers

| Feature | Status | Observed result | Remaining work / limits |
|---|---|---|---|
| Adreno 732 desktop OpenGL | Working — bounded tests | Earlier per-case output checks and 26 October Chrome GL pixels pass. | Full API conformance, sustained load and lifecycle. |
| OpenGL ES | Partial | Selected native probes have passed. | Broader conformance and regression coverage. |
| Vulkan / Turnip | Partial | Transfer, fence and readback paths work in selected tests. | Display-query/presentation issues and image-atomic/barrier failures. |
| Vulkan CTS correction | Package/source work | 113 selected cases passed only with a diagnostic UBWC-hint override. | Validate the actual correction on the tablet without debug overrides. |
| Zink | Partial | Selected GL-on-Vulkan probes exist. | Presentation, mixed workloads and sustained performance. |
| OpenCL / Rusticl | Partial | Selected compute/readback probes passed. | Full capability, conformance and application coverage. |
| KDE GPU statistics | Partial | Idle usage/frequency reporting observed. | Accuracy under load and GUI presentation. |
| Chrome Canvas / WebGL | Working — bounded pixel checks | Chrome 156, ANGLE/FD732 on kernel 7.3.0-14 passed clear, shader and context-restoration checks. | Performance, physical output and lifecycle. |
| Browser GPU sandbox | Unresolved | Latest captured Chrome report still says sandbox disabled. | Diagnose and validate the sandbox; no bypass is a supported fix. |
| WebGPU | Not qualified | Latest normal Chrome trial returned no adapter and performed no compute rounds. | Real adapter, compute and video-import validation. |
| Browser display precision / HDR | Not qualified | Browser and kernel output descriptors differ. | End-to-end precision, metadata, transport and visible HDR. |

### Networking, USB and external displays

| Feature | Status | Observed result | Remaining work / limits |
|---|---|---|---|
| WCN6750 Wi-Fi | Working — development installation | Automatic connection, SSH, file transfer and signed network updates. | Broader power/lifecycle coverage. |
| Bluetooth mouse | Working — tested device | Pairing, movement, clicks and reconnection. | Broader device coverage and suspend. |
| Bluetooth stereo / LDAC | Working — Space Q45 playback | Recorded clear stereo playback. | Microphone/HFP and lifecycle. |
| KDE Connect | Working — discovery | Signed default local-network policy installed; POCO F5 discovered on 24 October. | Pairing, file sharing and post-update reboot; separate laptop Wi-Fi route issue remains. |
| NFC | Not qualified | Source distinguishes the OEM tag from an active Linux NFC reader. | No accepted tag transfer, card reading or emulation result. |
| Manual CDC ACM management | Working — manual | Explicit on/off management; default off. | Current cable/reconnect and suspend tests. |
| USB ECM / SSH | Working — earlier manual path | SSH and verified 16 MiB transfers. | Default off; repeat against the current kernel/cable. |
| USB role control | Partial | PC device/sink and dock host/sink states observed. | Broader transitions and combined loads. |
| USB accessory power | Partial | Powered-dock devices enumerate. | Real current budget and earlier ESP32 power failure. |
| USB reconnect / driver lifecycle | Partial | Software reconnect has worked. | Physical reconnect, fault recovery and reloads. |
| USB SuperSpeed | Partial | Hub and RTL8153 enumeration at 5 Gbit/s. | Sustained storage throughput and combined use. |
| Juo USB hubs | Working — tested dock | USB 2/3 enumeration and receiver mouse operation. | Broader accessories and dock lifecycle. |
| USB Ethernet | Partial | RTL8153 and its firmware are detected. | Cable carrier, traffic and sustained throughput. |
| External HDMI through Juo JH925 | Working — external display | Working HDMI on Linux 7.3 confirmed on 26 October; earlier 1440p/75 Hz output recorded on 24 October. | Current mode/precision were not remeasured; reconnection, sustained use, DDC/CI, HDR and compression have separate limits. |
| External 10-bpc output | Partial | Kernel reports uncompressed 10-bpc DP transport in recent boots. | Actual receiver/HDMI output and optical precision. |
| External DSC / FEC | Experimental — default off | Source, transport fixtures and native kernel-15 package checks pass. | Disconnected policy change, fresh receiver events and sustained visible compressed output. |
| DDC/CI brightness / monitor power | Not working in recorded tests | Standard command attempts did not establish brightness control or wake. | Receiver forwarding and physical monitor behavior. |
| HDR / YCbCr external formats | Not qualified | Source investigation and capability work. | Implemented per-commit state and actual sink/transport/visible results. |

### Sensors and platform controls

| Feature | Status | Observed result | Remaining work / limits |
|---|---|---|---|
| SSC sensor startup | Working — recorded sessions | Motion, light and proximity services start automatically. | DSP restart and current-kernel lifecycle. |
| Accelerometer / automatic rotation | Working — four poses | KDE rotation and matching touch alignment observed. | Repeat on current kernel and longer sessions. |
| Gyroscope | Partial | XYZ angular rates are readable. | Physical response, drift and calibration. |
| Compass | Partial | Heading changes with movement. | Absolute-heading accuracy remains unqualified. |
| Front ambient light | Working — illumination response | Front illumination changes lux and KDE brightness. | Accuracy and long-run behavior. |
| Rear ambient light | Working — illumination response | Rear illumination changes brightness with the front dark. | Accuracy and interaction with cover state. |
| Ambient color temperature | Not qualified | No accepted calibrated startup color sample. | Sensor mapping and Kelvin conversion. |
| Front proximity | Working — near/far | Recorded far → near → far cover/release sequence. | Broader lifecycle and mapping coverage. |
| SAR / body proximity | Disabled / not qualified | No accepted usable endpoint or physical response. | Endpoint mapping and physical validation. |
| Magnetic cover / lid | Working — switch events | Front cover and rear fold events recorded. | Cover-triggered blanking and dock/display interactions. |
| Temperature telemetry | Working — readings | PMIC/thermal interfaces and KDE readings. | Absolute calibration and protection effectiveness. |
| Torch / flashlight | Source available — not qualified | Guarded native driver/Control work and real current-step reporting. | Physical output, thermal limits and failure/lifecycle tests. |
| RGB notification LED | Source available — not qualified | Native multicolor and bounded Control source. | Actual probe, channel/color mapping and measured output. |
| Native Control and KDE integration | Partial | Installed management/reporting and desktop integration; expanded CLI has host checks. | Source-only commands are not automatically installed or physically accepted. |

### Audio, cameras and video

| Feature | Status | Observed result | Remaining work / limits |
|---|---|---|---|
| Internal speakers | Not working in recorded tests | No accepted protected playback route. | Amplifier identity, calibration/protection, routing and physical audio. |
| Microphones | Not working in recorded tests | No accepted usable recording result. | SoundWire/codec route and physical capture. |
| DisplayPort audio | Partial | ALSA card, ELD, DMA and monitor-label integration exist. | Audible playback and sustained sink operation. |
| USB audio | Not tested | No accepted playback/recording workload. | Physical playback and capture. |
| Front camera | Not qualified | No accepted capture pipeline or image frame. | Sensor/CSIPHY/CAMSS integration and actual capture. |
| Rear camera | Not qualified | No accepted capture pipeline or image frame. | Sensor/CSIPHY/CAMSS integration and actual capture. |
| Iris / VA-API initialization | Partial | Default VA initialization and runtime capability queries work with the tested backend. | Boot-time availability, actual codec output and lifecycle. |
| Hardware video decode | Not qualified | H.264, HEVC and VP9 capability enumeration is available in the initialized test stack. | Real decoded frames, pixel references, DMA-BUF/fences and sustained playback. |
| Hardware video encode | Not qualified | Runtime-format and rate checks exist in native package tests. | Actual encoded bitstreams, Main10/P010 output and physical-device validation. |
| Browser video / WebCodecs / WebRTC | Not qualified | Scoped host workloads and independent software references are prepared. | Actual hardware workload, output validation, import and sandbox. |

### Power, charging and lifecycle

| Feature | Status | Observed result | Remaining work / limits |
|---|---|---|---|
| Battery percentage / voltage / temperature | Working — readings | Standard telemetry and KDE battery indicator. | Independent unit/scale/accuracy checks. |
| Battery current / net power / counter | Working — readings | Signed readings and charge counter available. | Exact pack basis and electrical reference. |
| Pack health / aging | Partial — reported values | Software keeps reported SOH, retention and cycle estimates distinct. | Qualified capacity/aging measurements. |
| Individual-cell health / balance | Not available | No qualified per-cell export. | Exact fitted cell/gauge mapping and measured telemetry. |
| Computer USB charging | Partial | USB input is detected; load can exceed supply. | Sustained net charging under measured load. |
| USB-PD / fast charging | Partial | Powered-dock charging and PD state observed. | Exact negotiated session, per-adapter/cable limits and measured power; no qualified 45 W claim. |
| QC / proprietary charging protocols | Not qualified | Read-only source/protocol work remains bounded. | Actual negotiation/authentication and electrical tests. |
| Charge limits / stop / restore | Partial — effect unverified | Guarded threshold/current software and readback paths. | Real cutoff, restart hysteresis, restore and fault response. |
| Battery bypass / direct supply | Not qualified | No accepted battery isolation or bypass. | Physical power-path validation. |
| Charging protection | Not qualified | Software refusal and fault fixtures pass; shipped qualification gates remain. | Thermal, moisture, watchdog, OVP/OCP/short, source changes and endurance. |
| Offline charging | Not working in recorded charger-boot test | Earlier USB-triggered starts returned to KDE. | Correct charger-mode entry, visible UI and key/unplug behavior. |
| Desktop power profiles | Working — selection | Three original desktop profiles are selectable. | Sustained energy/thermal effects. |
| Battery runtime estimates | Partial — software model | Host model/session checks pass. | Calibrated device forecasts and safe reserve. |
| Suspend-to-idle | Partial — earlier RTC wake | One earlier RTC-wake cycle completed. | Repetition, display/touch, power-key wake and sleep energy. |
| Deep suspend | Not tested | No accepted complete cycle. | Suspend/resume and energy measurement. |
| Power-key / USB-input wake | Not qualified | Source and readiness work exist. | Actual wake from real suspend. |
| USB cable wake | Not working in earlier test | Missing wake integration was recorded. | Current-kernel physical wake test. |
| Watchdog | Partial | Driver startup observed. | Recovery behavior and repeated fault tests. |
| PMIC / regulators / interconnect | Partial | Essential storage, sensor, display and USB resources operate. | Remaining probe/power-vote and lifecycle defects. |
| DMA / IOMMU | Partial | Selected clients operate. | Broader clients, translation faults and cleanup. |
| ADSP / CDSP / QSH and FastRPC | Partial | Sensor registry and selected charger services work. | General compute, internal audio and restart recovery. |
| CoreSight tracing | Disabled | Earlier autoload/reset problems. | Cause and safe recovery qualification. |

## Updating Fedora

For an existing compatible Uke Fedora installation, review and install updates from the configured signed repositories:

```sh
sudo dnf update --refresh
```

Keep the kernel core, modules, device trees and selected boot profile from the same build. Retain the working boot image and matching modules for rollback. Automatic boot-slot activation remains disabled; a successful DNF transaction alone does not prove that a new kernel has booted. Follow the package's documented activation procedure and verify the running version with `uname -r` after the planned restart.

The stable and testing COPR channels have different package histories. Do not combine a boot image from a release with unrelated modules, switch channels by copying individual RPMs, or reuse another tablet's local touch data. KDE Connect remains the original Fedora application; discovery requires the devices to share a reachable local network, and pairing still requires user acceptance.

## Development work awaiting acceptance

New source is published on development branches before device acceptance. Its presence does not change the status tables above.

| Workstream | Source / record | Remaining gate |
|---|---|---|
| Native Control NFC, battery and charging views | [Charging/Control source](https://github.com/MCC45TR/uke-linux-hardware-support/tree/feat/charging-completion-20261026) | Signed integrated native package, installation and physical electrical/NFC/gesture tests. |
| Video and browser validation | [Platform source checkpoint](https://github.com/MCC45TR/uke-linux-hardware-support/tree/publish/source-snapshot-20261026) and [native VA backend build](https://copr.fedorainfracloud.org/coprs/build/11206385/) | Actual codec output, corrected driver tests, sandbox and display coexistence. |
| Linux 7.3 integration | [Kernel source](https://github.com/MCC45TR/senemos-uke-kernel-mainline/tree/main) and [test COPR](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) | Per-build device validation; experimental DSC/FEC stays off by default. |
| Recovery and UEFI | [OrangeFox](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) and [Project Aloha](https://github.com/MCC45TR/uke-project-aloha) | Independent firmware, storage, touch, boot and Android-return acceptance. |

## Build from source

The workspace entry point provides image and kernel workflows. Available image selections include multiboot/singleboot, EXT4/F2FS/Btrfs/XFS, original KDE/GNOME and stable/testing/unstable package channels. Advertised host support and source checks are separate from a completed build on each host.

```sh
git clone --recurse-submodules https://github.com/MCC45TR/uke-linux.git
cd uke-linux
./ukelinux.sh
# Kernel workflow:
./ukelinux.sh --build kernel
```

Read the [public build guide](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/PUBLIC-BUILD.md) for prerequisite confirmation, source selection, output checks and manual installation. Output defaults to `out`. The 24 October KDE EXT4 export has host-build evidence; it does not establish tablet acceptance of the exported image or every other build selection.

KDE applications remain original distribution packages. Unmodified Fedora desktop dependencies may retain Fedora-provided Python helpers; project device code, recovery, initramfs and installers do not introduce a Python runtime. Device-local calibration and private firmware inputs are not supplied by a generic source checkout.

## Project repositories

| Component | Development branch |
|---|---|
| Kernel and device trees | [senemos-uke-kernel-mainline / main](https://github.com/MCC45TR/senemos-uke-kernel-mainline/tree/main) |
| Hardware services and packages | [uke-linux-hardware-support / main](https://github.com/MCC45TR/uke-linux-hardware-support/tree/main) |
| Image builder | [uke-fedora-builder / main](https://github.com/MCC45TR/uke-fedora-builder/tree/main) |
| Image records | [uke-linux-images / main](https://github.com/MCC45TR/uke-linux-images/tree/main) |
| OrangeFox Recovery | [orangefox_device_xiaomi_uke / R12.0](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/tree/R12.0) |
| Experimental UEFI | [uke-project-aloha / main](https://github.com/MCC45TR/uke-project-aloha/tree/main) |

Component links open current development branches. Submodule commits record an exact workspace snapshot; scheduled snapshot updates do not qualify a new build or alter published release images.

## Documentation and contributions

- [Build and manual installation guide](https://github.com/MCC45TR/uke-fedora-builder/blob/main/docs/PUBLIC-BUILD.md)
- [Desktop screenshot gallery](assets/screenshots/README.md)
- [Development changes](CHANGELOG.md)
- [Reporting guide and documentation style](CONTRIBUTING.md)
- [Issue tracker](https://github.com/MCC45TR/uke-linux/issues)
- [Security reporting](SECURITY.md)

Include the exact kernel/package or release identity, device variant, date, reproduction steps and relevant redacted output in reports. Keep credentials, device identifiers, calibration and private logs out of public issues.

## License

Original repository material uses the [MIT License](LICENSE). Components retain their original licenses and contributor attribution.

Uke Linux is an independent, unofficial project, unaffiliated with Fedora, Xiaomi, POCO or Qualcomm. The software is experimental and provided without warranty. Installation or modification can cause data loss or device damage.
