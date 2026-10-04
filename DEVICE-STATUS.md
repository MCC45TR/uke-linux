# Device status: POCO Pad X1 and Xiaomi Pad 7 / uke

Target family: **POCO Pad X1 and Xiaomi Pad 7 (`uke`)**. Primary physical validation hardware: **POCO Pad X1 8 GB / 512 GB**. Kernel product: **senemos-uke-kernel-mainline**. Target sequence: OrangeFox, Project Aloha, then Fedora Rawhide AArch64.

This document is generated from `manifests/device-status.json`. Source evidence identifies a candidate component or capability; it does not establish that our software works on it.

Ledger updated: **2026-10-04**. Physical device available: **true**. Tracked capabilities: **143**.

No recovery, UEFI or Linux own-device acceptance has been performed. A missing implementation or an untested feature is not a measured hardware failure. Third-party results are recorded separately.

## Reading the results

- **working**: acceptance passed on the recorded build, firmware and physical variant.
- **partial**: some tested functions work; limitations must be recorded.
- **not-working**: a real test observed failure.
- **not-tested**: no success or failure claim.
- **not-applicable**: the function is outside that environment's scope, with a recorded reason.


Stock Android has a separate [read-only inventory](docs/research/UKE-HARDWARE-STATUS-2026-10-04.md#stock-record-receipts) recorded as **STOCK-ADB-20261003-03** on **2026-10-03T14:22:11Z**. It establishes observed stock metadata and device availability; it does not promote the recovery, UEFI or Linux results below.

## Coverage

| Environment | Working | Partial | Not working | Not tested | Not applicable |
|---|---:|---:|---:|---:|---:|
| recovery | 0 | 0 | 0 | 143 | 0 |
| uefi | 0 | 0 | 0 | 143 | 0 |
| linux | 0 | 0 | 0 | 143 | 0 |

## Variant rules

- Support covers POCO Pad X1 and Xiaomi Pad 7; keep every memory, storage, panel, touch and region variant as a separately recorded compatibility target.
- Keep CSOT/TM panel and Novatek firmware profiles separate.
- China OS3.0.302.0.WOZCNXM and Global OS3.0.303.0.WOZMIXM fastboot packages plus Turkey OS3.0.303.0.WOZTRXM recovery OTA are separate reproducible baselines, not interchangeable images.
- Conflicting or generic vendor text about IR or SD eject tools does not establish physical components.
- Pad 7 Pro, SM8650 and SM8550 projects are subsystem donors, not equivalent boards.
- Not-tested in all three environments does not mean every peripheral needs a recovery or UEFI driver.

## Identity, SoC and platform

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| ID-01 | POCO Pad X1 / Xiaomi Pad 7 / uke / SM7675 | Identify model, SKU, RAM, storage and firmware | not-tested | not-tested | not-tested | SPEC, XIAOMI-SPEC, DTS, STOCK-ADB: Both commercial models are Uke project targets; every SKU and installed hardware variant requires its own physical record. Pad 7 Pro / muyu is a different board. Stock record STOCK-ADB-20261003-01 observes POCO Pad X1 25099RP08G/ukepgl with OS2.0.205.0.VOZMIXM; other variants remain separate. |
| SOC-01 | SM7675 / Cliffs | CPU topology and all cores online | not-tested | not-tested | not-tested | DTS, DONOR, STOCK-ADB: Shared SM8635 filenames do not change the target SoC. Stock record observes SM7675 and CPUs 0-7 online; this does not validate project kernels. |
| SOC-02 | ARM64 CPU | Frequency, voltage and cpufreq | not-tested | not-tested | not-tested | DTS, PLAN, STOCK-ADB: Compare stock OPP tables and power limits. Stock qcom-cpufreq-hw/walt policies expose 1.9008/2.6112/2.8032 GHz maxima for the three CPU groups; sustained performance is untested. |
| SOC-03 | ARM64 CPU | Idle states and residency | not-tested | not-tested | not-tested | DTS, PLAN: Clock ignore parameters are temporary bring-up aids. |
| SOC-04 | GIC / arch timer / PSCI | Interrupts, timekeeping, SMP, reboot and poweroff | not-tested | not-tested | not-tested | DTS, DONOR: Cold boot and repeated reboot need separate tests. |
| SOC-05 | GCC / TCSRCC | Clock providers and firmware handoff | not-tested | not-tested | not-tested | USB: Donor source exists; our port has not been built. |
| SOC-06 | RPMh / RSC / ARC / VRM | Voltage votes and power domains | not-tested | not-tested | not-tested | USB: Test error paths and reference lifetimes. |
| SOC-07 | TLMM / GPIO | Pin multiplexing and reserved GPIO ranges | not-tested | not-tested | not-tested | DTS, USB: Preserve trusted firmware GPIO ownership. |
| SOC-08 | NoC / BCM | Interconnect bandwidth and QoS | not-tested | not-tested | not-tested | USB: The donor covers a limited USB sub-topology. |
| SOC-09 | Apps SMMU | USB DMA domains and inherited mappings | not-tested | not-tested | not-tested | USB: Limit support to audited stream IDs. |
| SOC-10 | GPU SMMU | GPU address translation and isolation | not-tested | not-tested | not-tested | DTS, PLAN: USB SMMU acceptance does not cover the GPU. |
| SOC-11 | SMEM / SCM / QMI / GLINK | Firmware communication and service discovery | not-tested | not-tested | not-tested | DTS, DONOR: Android services do not prove native Linux support. |
| SOC-12 | PMIC / SPMI | PMK8550, PM8550VS, PM8550VE and PM7550BA mapping | not-tested | not-tested | not-tested | DTS, DONOR: Confirm population against stock profiles and the actual board. |
| SOC-13 | GENI QUP I2C / SPI / UART | Bus consumers, probing and recovery | not-tested | not-tested | not-tested | DTS, DONOR: Do not reuse Nabu bus numbers or pins. |
| SOC-14 | LPDDR5X 8 / 12 GB | Memory map, high memory and reserved regions | not-tested | not-tested | not-tested | SPEC, XIAOMI-SPEC, DTS, STOCK-ADB: POCO Pad X1 targets 8 GB; Xiaomi Pad 7 advertises 8 GB and 12 GB variants. Boot firmware and the physical memory map determine valid addresses. Stock MemTotal is 7,674,232 KiB; this is OS-visible memory, not measured physical DDR density. |
| SOC-15 | Watchdog / RTC / pstore | Crash retention, watchdog and timekeeping | not-tested | not-tested | not-tested | DTS, PLAN: Validate ramoops against the real memory map. |
| SOC-16 | Hexagon / CDSP / AI Engine | DSP compute and accelerator APIs | not-tested | not-tested | not-tested | SPEC, BLOBS: Android AI marketing does not prove native Linux compute support. |

## Storage and filesystems

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| STO-01 | 512 GB UFS 4.0 target | Controller, PHY and read-only access | not-tested | not-tested | not-tested | SPEC, DTS, STOCK-ADB: The target capacity is defined by the SKU, but controller identity, geometry and health require physical inspection. Stock exposes six disk names and 121 labels but denies exact UFS capacity/sector/health reads; mounted data filesystem capacity is 497,533,562,880 bytes. |
| STO-02 | Xiaomi Pad 7 128 GB UFS 3.1 / 256 GB UFS 4.0 | Controller, PHY and read-only access | not-tested | not-tested | not-tested | XIAOMI-SPEC, DTS: Keep each Xiaomi Pad 7 capacity and storage generation separate from the POCO Pad X1 512 GB profile. |
| STO-03 | UFS | Write, flush, discard and interruption recovery | not-tested | not-tested | not-tested | PLAN: Later physical tests use a designated test area. |
| STO-04 | Qualcomm ICE | Inline encryption and wrapped-key capabilities | not-tested | not-tested | not-tested | DTS, OFOX: Kernel capability does not establish Android key access. |
| STO-05 | ext4 | Rootfs and backup creation, reading and repair | not-tested | not-tested | not-tested | OFOX, PLAN: Synthetic disk and physical tests are separate. |
| STO-06 | F2FS | Format, mount, checkpoint and restore | not-tested | not-tested | not-tested | OFOX, STOCK-ADB: The recovery donor reports broken data formatting. Stock /data is mounted as F2FS with inlinecrypt; no project formatting, mount or decryption was attempted. |
| STO-07 | EROFS / dynamic partitions | Read-only Android partition inspection | not-tested | not-tested | not-tested | OFOX, STOCK-ADB: Validate logical partition and slot selection. Stock lpdump exposes eight allocated slot-a logical extents and reported filesystem types; super is 11,274,289,152 bytes. Physical GPT remains unread. |
| STO-08 | FAT / exFAT / NTFS | USB media and ESP filesystems | not-tested | not-tested | not-tested | NABU, PLAN: Test firmware and OS drivers separately. |
| STO-09 | Android metadata / userdata | Installed Android FBE compatibility | not-tested | not-tested | not-tested | OFOX: Requires firmware-matched KeyMint and TEE evidence. |
| STO-10 | UFS health | Lifetime writes, health and error counters | not-tested | not-tested | not-tested | NABU, PLAN: Verify counter units and kernel interfaces. |

## Display and graphics

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| DIS-01 | ABL framebuffer / simplefb | Early framebuffer console | not-tested | not-tested | not-tested | FB: Third-party results apply to a particular stock profile. |
| DIS-02 | CSOT / TM panel variants | Identify the installed panel and initialization sequence | not-tested | not-tested | not-tested | DTS, DISPLAY, STOCK-ADB: Keep panel firmware and power sequencing separate. Stock panel supplier/property reads were denied; neither CSOT nor TM is selected by this record. |
| DIS-03 | Dual DSI / DSC | DSI links, timings and compression | not-tested | not-tested | not-tested | DISPLAY, DONOR: Validate both links and all DSC parameters. |
| DIS-04 | 3200 x 2136 LCD | Resolution, color order and orientation | not-tested | not-tested | not-tested | SPEC, DISPLAY, STOCK-ADB: A framebuffer console is not a full panel driver. Stock compositor observes 3200 x 2136; project display acceptance remains untested. |
| DIS-05 | 30/48/50/60/90/120/144 Hz | Refresh modes and transitions | not-tested | not-tested | not-tested | SPEC, DISPLAY, STOCK-ADB: These are vendor capabilities; native modes need measurement. Stock lists seven refresh modes and reports an active 120 Hz mode; controlled transitions are untested. |
| DIS-06 | Two KTZ8866 controllers | Backlight range and left/right consistency | not-tested | not-tested | not-tested | DISPLAY, DONOR: An upstream driver alone does not establish board support. |
| DIS-07 | LCD blank / unblank | Display off, on and resume | not-tested | not-tested | not-tested | DISPLAY, PLAN: Test rail and clock handoff independently. |
| DIS-08 | Color / P3 / HDR | Color accuracy and userspace color management | not-tested | not-tested | not-tested | SPEC, PLAN: Branded HDR capabilities depend on licensing and the full pipeline. |
| DIS-09 | DPU / DRM | Fences, underruns, tearing and corruption | not-tested | not-tested | not-tested | PLAN: Correlate raw logs with visible output and workload. |
| GPU-01 | Adreno 732 | Chip ID and GMU/SQE/ZAP firmware matching | not-tested | not-tested | not-tested | BLOBS, DONOR, STOCK-ADB: Do not select firmware for other GPUs from shared vendor trees. Stock KGSL/GLES identify Adreno 732; installed firmware hashes and project rendering remain unverified. |
| GPU-02 | DRM MSM / Freedreno | Render node and OpenGL acceleration | not-tested | not-tested | not-tested | PLAN: Record software rendering separately. |
| GPU-03 | Mesa Turnip | Vulkan workloads and recovery | not-tested | not-tested | not-tested | PLAN: Android container drivers do not prove native DRM support. |
| GPU-04 | GPU devfreq / idle | Performance, energy and thermal throttling | not-tested | not-tested | not-tested | DTS, PLAN: Do not invent OPP tables from guessed speedbins. |
| GPU-05 | GPU reset / resume | Repeated load and suspend recovery | not-tested | not-tested | not-tested | PLAN: Every hangcheck and fault must be explained and resolved. |
| DIS-10 | USB-C video output | Validate DP Alt Mode and external display | not-tested | not-tested | not-tested | DTS, PLAN, POCO-FAQ: POCO Pad X1 FAQ declares DP 1.2 and DP Alt Mode. JH925 HDMI/MST testing is planned; each environment and Xiaomi Pad 7 variant still require physical evidence. |

## Touch, pen, keyboard and keys

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| INP-01 | Novatek NT36532 / NVT-ts-spi | Finger input, IRQ, reset and firmware loading | not-tested | not-tested | not-tested | DTS, BLOBS, STOCK-ADB: Keep CSOT and TM firmware variants separate. Stock loaded nt36532_touch and registered NVT input paths; no controlled touch experiment was performed. |
| INP-02 | Novatek touch | Multitouch, edges and coordinate transforms | not-tested | not-tested | not-tested | DTS, PLAN: Test all four display orientations. |
| INP-03 | Novatek touch | Suspend, resume and touch wake | not-tested | not-tested | not-tested | DTS, PLAN: Measure energy cost if wake is supported. |
| INP-04 | Focus Pen / Novatek pen input | Pen position and hover | not-tested | not-tested | not-tested | DTS, BLOBS, STOCK-ADB: The pen accessory is not available for testing. Stock registers NVTCapacitivePen; this does not establish an attached or tested pen specimen. |
| INP-05 | Stylus | Pressure, tilt and sample rate | not-tested | not-tested | not-tested | SPEC, PLAN: Validate each capability from actual input events. |
| INP-06 | Stylus | Buttons, palm rejection and application behavior | not-tested | not-tested | not-tested | DTS, PLAN: Kernel events and desktop usability require separate acceptance. |
| INP-07 | Nanosic 803 / pogo | Keyboard attach and detach | not-tested | not-tested | not-tested | DTS, DONOR: Do not assume the Nabu pogo protocol applies. |
| INP-08 | Keyboard / touchpad accessory | Keymap, function keys, pointer and gestures | not-tested | not-tested | not-tested | DTS, PLAN: Record accessory model and keyboard layout. |
| INP-09 | Power / volume keys | Input events and recovery navigation | not-tested | not-tested | not-tested | DTS, OFOX: Recovery and UEFI need their own keymaps. |
| INP-10 | Hall / cover | Lid events, sleep and wake | not-tested | not-tested | not-tested | SPEC, DTS: Confirm IC identity and signal polarity. |
| INP-11 | UI rotation | Match display and touch at 0/90/180/270 degrees | not-tested | not-tested | not-tested | NABU, OFOX: Display rotation alone does not transform touch coordinates. |
| INP-12 | Stylus accessory | Pairing, battery, charging and firmware reporting | not-tested | not-tested | not-tested | DTS, PLAN: Determine the actual Focus Pen transport and charging path. |

## USB and wired connectivity

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| USB-01 | eUSB2 PHY / PMIC repeater | USB2 peripheral physical layer | not-tested | not-tested | not-tested | USB: Donor source exists; physical USB acceptance is still open. |
| USB-02 | WCD939x | D+/D- routing and reset/power sequencing | not-tested | not-tested | not-tested | USB: This is narrower than full Type-C and PD support. |
| USB-03 | DWC3 gadget | Host enumeration and serial transfer | not-tested | not-tested | not-tested | USB: Creating ttyGS0 alone is not sufficient evidence. |
| USB-04 | ADB / sideload | Host connection and installation transfer | not-tested | not-tested | not-tested | OFOX, PLAN, STOCK-ADB: Require checksum and disconnect tests. Stock ADB read-only acquisition succeeded; recovery ADB/sideload remains untested. |
| USB-05 | MTP | File listing and large transfers | not-tested | not-tested | not-tested | OFOX, PLAN: Record access restrictions imposed by Android FBE. |
| USB-06 | Fastbootd | Logical partitions and mode transitions | not-tested | not-tested | not-tested | OFOX: Distinguish userspace fastbootd from bootloader fastboot. |
| USB-07 | USB mass storage | Read-only export of a selected disk image | not-tested | not-tested | not-tested | NABU, PLAN: Prevent local mount and host write conflicts. |
| USB-08 | USB OTG / host | HID, storage and hubs | not-tested | not-tested | not-tested | SPEC, PLAN: Host and gadget acceptance are independent. |
| USB-09 | USB 3.2 Gen1 | SuperSpeed link and throughput | not-tested | not-tested | not-tested | SPEC, DTS: USB2 success cannot establish SuperSpeed support. |
| USB-10 | Type-C / PD | Orientation, role switching and power negotiation | not-tested | not-tested | not-tested | DTS, PLAN, STOCK-ADB: Test combinations of ports, cables and chargers. Stock snapshot is a configured USB sink; battery-service maximums are 5 V/0.5 A for this connection, not negotiated RC1001/PD proof. |
| USB-11 | USB-C Ethernet / audio | External adapter classes | not-tested | not-tested | not-tested | PLAN: Depends on a working USB host path. |
| USB-12 | USB reconnect | Cable reconnect, mode changes and resume | not-tested | not-tested | not-tested | PLAN: Correlate host and device logs with timestamps. |

## Wi-Fi and Bluetooth

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| NET-01 | WCN6750 | Firmware, board data, QMI and driver startup | not-tested | not-tested | not-tested | DONOR, BLOBS: Calibration and board files belong to specific profiles. |
| NET-02 | Wi-Fi | 2.4/5 GHz, WPA2/WPA3 and DHCP | not-tested | not-tested | not-tested | SPEC, PLAN: Validate antenna, band and regulatory region. |
| NET-03 | Advertised Wi-Fi 6E | Determine 6 GHz SKU and regulatory support | not-tested | not-tested | not-tested | SPEC: The official page says 6E but lists 2.4/5 GHz; resolve this discrepancy. |
| NET-04 | Wi-Fi MIMO | Throughput, latency and packet loss | not-tested | not-tested | not-tested | SPEC, PLAN: Compare stock using the same AP and channel. |
| NET-05 | Wi-Fi power management | Power saving, roaming and resume | not-tested | not-tested | not-tested | PLAN: Connectivity alone does not prove battery or resume behavior. |
| NET-06 | Advertised Bluetooth 5.4 | Transport, firmware, scanning, pairing and bonds | not-tested | not-tested | not-tested | SPEC, DONOR: Query actual controller capabilities. |
| NET-07 | Bluetooth HID | Mouse, keyboard and wake | not-tested | not-tested | not-tested | PLAN: Test BLE and classic devices separately. |
| NET-08 | Bluetooth audio | A2DP, HFP and microphone | not-tested | not-tested | not-tested | SPEC, PLAN: Track codec licensing and userspace support. |
| NET-09 | Wi-Fi / Bluetooth coexistence | Concurrent workloads and interference | not-tested | not-tested | not-tested | PLAN: Measure audio dropouts and latency. |
| NET-10 | Wi-Fi Direct / screen sharing | Userspace protocol support | not-tested | not-tested | not-tested | SPEC, PLAN: A Miracast feature name is not native Linux evidence. |

## Audio, DSP and microphones

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| AUD-01 | ADSP / CDSP / QSH | Remoteproc startup and crash recovery | not-tested | not-tested | not-tested | DONOR, BLOBS: Pin firmware versions and service dependencies. |
| AUD-02 | FastRPC / QRTR / GLINK | DSP userspace communication | not-tested | not-tested | not-tested | DONOR, PLAN: Do not copy Nabu SLPI settings. |
| AUD-03 | Four speakers / FS16xx candidates | Amplifier identity and channel mapping | not-tested | not-tested | not-tested | SPEC, DONOR: Shared FS19xx, CS35L or AW files do not prove installed components. |
| AUD-04 | Speakers | Channel orientation, gain and clipping | not-tested | not-tested | not-tested | PLAN: Each channel needs listening and measurement tests. |
| AUD-05 | Amplifier protection / DSP | Temperature, excursion and safe gain | not-tested | not-tested | not-tested | PLAN: Do not assume full output power without protection firmware. |
| AUD-06 | Advertised four microphones | Capture, channels and sample rates | not-tested | not-tested | not-tested | SPEC, PLAN: Map stock ADC, codec and routing. |
| AUD-07 | Microphones | Noise, gain, echo cancellation and beamforming | not-tested | not-tested | not-tested | PLAN: Native DSP algorithms and licenses need separate investigation. |
| AUD-08 | ALSA UCM / PipeWire | Profile selection, hotplug and desktop audio | not-tested | not-tested | not-tested | PLAN: Successful codec probing is not end-user acceptance. |
| AUD-09 | Audio suspend / resume | DSP health and stream recovery | not-tested | not-tested | not-tested | PLAN: Investigate DSP health before restarting audio services. |
| AUD-10 | USB / Bluetooth audio | External routing and return to internal audio | not-tested | not-tested | not-tested | PLAN: Separate from internal speaker acceptance. |

## Sensors and candidate variants

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| SNS-01 | LSM6DSO observed HAL / QMI8658 alternate configuration | Accelerometer raw XYZ, units and scale | not-tested | not-tested | not-tested | BLOBS, STOCK-ADB: Do not assume both candidate IMUs are installed. This specimen's stock HAL advertises lsm6dso accelerometer/uncalibrated forms; register identity and project data path remain unverified. |
| SNS-02 | LSM6DSO observed HAL / QMI8658 alternate configuration | Gyroscope XYZ, bias and sampling | not-tested | not-tested | not-tested | BLOBS, STOCK-ADB: Require IC identity and mounting matrix. This specimen's stock HAL advertises lsm6dso gyro/uncalibrated forms; cached events do not prove a current stream or accuracy. |
| SNS-03 | QMC630x reported family / QMC6308 unconfirmed | Magnetometer and compass | not-tested | not-tested | not-tested | BLOBS, STOCK-ADB: Validate axes and hard/soft iron calibration. Stock HAL family text is qmc630x; exact QMC6308 suffix remains unconfirmed. |
| SNS-04 | SIP1328 candidate | Determine ALS/CCT role and channels | not-tested | not-tested | not-tested | BLOBS, STOCK-ADB: Filenames alone cannot establish sensor function. Stock HAL advertises sip1328 back ALS, flicker and back-lux stream; optical channel/accuracy tests remain open. |
| SNS-05 | STK3BCX candidate family | Distinguish ALS, proximity and flicker capabilities | not-tested | not-tested | not-tested | BLOBS, STOCK-ADB: Exact submodel and channel population are unknown. Stock HAL advertises stk_stk3bcx front ALS, proximity, CCT and factory streams; exact chip suffix remains unknown. |
| SNS-06 | SX937X candidate family | SAR/grip raw capacitive channels | not-tested | not-tested | not-tested | BLOBS, STOCK-ADB: Do not label it display proximity or invent electrode positions. Stock HAL advertises semtech_sx937x_0 and sar_detector; electrode mapping and physical SAR acceptance remain open. |
| SNS-07 | Hall sensor | Magnetic cover events and polarity | not-tested | not-tested | not-tested | SPEC, DTS: Exact part number remains unknown. |
| SNS-08 | Ambient light | Lux, dynamic range and automatic brightness | not-tested | not-tested | not-tested | SPEC, PLAN, STOCK-ADB: Raw sensor behavior and desktop policy are separate. Front non-wakeup ALS last-event time advanced across stock snapshots; lux metrology and project brightness acceptance remain open. |
| SNS-09 | Color temperature | Raw color channels, CCT and adaptation | not-tested | not-tested | not-tested | SPEC, PLAN, STOCK-ADB: Saturated values are not valid calibration evidence. Stock front CCT descriptors and retained events are present; raw channel mapping and calibrated response are untested. |
| SNS-10 | Flicker | Sampling, 50/60 Hz detection and validity | not-tested | not-tested | not-tested | SPEC, BLOBS, STOCK-ADB: Confirm hardware and driver transport. Stock SIP1328 flicker descriptors are present; 50/60 Hz validity was not tested. |
| SNS-11 | Proximity | Physical sensor or algorithm and near/far events | not-tested | not-tested | not-tested | SPEC, BLOBS, STOCK-ADB: Do not automatically equate proximity with SAR. Stock STK3BCx proximity descriptors/retained events are present; controlled near/far stimulus was not performed. |
| SNS-12 | Orientation / fusion | Autorotation and vibration stability | not-tested | not-tested | not-tested | PLAN: Establish IMU health before SensorProxy integration. |
| SNS-13 | Sensor hub / QSH | Batching, timestamps, wake and resume streams | not-tested | not-tested | not-tested | BLOBS, DONOR, STOCK-ADB: Test re-registration after firmware reset. Stock has QSH config and ADSP/CDSP/WPSS names; exact sensor-DSP ownership/state/firmware is unverified. Visible IIO symlinks are PMIC ADCs. |
| SNS-14 | Thermal sensors | Channel identity, millidegrees and consistent readings | not-tested | not-tested | not-tested | DTS, OFOX, STOCK-ADB: Do not reuse the fixed thermal_zone48 index. Stock thermal HAL reports CPU/GPU/NSP/battery/SoC channels and non-temperature vbat; cached and current readings must remain distinct. |
| SNS-15 | Advertised IR remote | Verify that an IR component actually exists | not-tested | not-tested | not-tested | SPEC: No board evidence yet; do not mark supported. |

## Battery, charging and power

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| PWR-01 | 8850 mAh typical battery | State of charge, health, current, voltage and temperature | not-tested | not-tested | not-tested | SPEC, DTS: Validate units and current sign conventions. |
| PWR-02 | Battery GLINK | Firmware telemetry and Linux power_supply | not-tested | not-tested | not-tested | DTS, DONOR: Do not copy Nabu LN8000 or PM8150 settings. |
| PWR-03 | USB-C charging | Basic charging, reconnect and low battery | not-tested | not-tested | not-tested | SPEC, PLAN: Keep measurement and control paths separate. |
| PWR-04 | Advertised 45 W / PD / QC / Mi FC | Negotiation and safe power limits | not-tested | not-tested | not-tested | SPEC, PLAN, POCO-FAQ: POCO Pad X1 FAQ excludes PPS and declares PD 2.0/3.0. Direct/docked RC1001 negotiation is untested; adapter rating is not continuous battery input power. |
| PWR-05 | Charging while powered off | Recovery/bootloader charging and low-battery boot | not-tested | not-tested | not-tested | PLAN: The first test requires a human operator. |
| PWR-06 | Suspend-to-idle / deep sleep | Power consumption and wake sources | not-tested | not-tested | not-tested | PLAN: Remove reliance on ignore-unused debug parameters. |
| PWR-07 | Resume | Display, touch, network, audio and sensors recover together | not-tested | not-tested | not-tested | PLAN: Target at least 100 controlled cycles. |
| PWR-08 | CPU / GPU / PMIC thermal | Throttling and protection | not-tested | not-tested | not-tested | DTS, PLAN: Do not remove OEM limits without evidence. |
| PWR-09 | Battery endurance | Idle, video, web and stylus energy | not-tested | not-tested | not-tested | PLAN: Compare stock and the previous build under equal conditions. |
| PWR-10 | Charger with USB host | OTG power and charging interactions | not-tested | not-tested | not-tested | PLAN: Test specific dock and cable combinations. |

## Camera and video

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| CAM-01 | Rear OV13B10 candidate / 13 MP | Sensor ID, I2C, clocks, power and capture | not-tested | not-tested | not-tested | CAM, BLOBS, SPEC: O82 Ofilm inventory needs physical confirmation. |
| CAM-02 | Front camera / 8 MP | Identify the sensor and capture path | not-tested | not-tested | not-tested | CAM, BLOBS, SPEC: Shared QSH IMX688 files do not identify the front camera. |
| CAM-03 | ISP / CAMSS | Pipeline, buffers, IOMMU and formats | not-tested | not-tested | not-tested | CAM, PLAN: An Android HAL binary is not native libcamera support. |
| CAM-04 | Autofocus / EEPROM | Actuator and device calibration | not-tested | not-tested | not-tested | CAM, BLOBS: Do not publish unit-specific calibration. |
| CAM-05 | Flash / torch | GPIO, regulator and controlled activation | not-tested | not-tested | not-tested | DONOR: Donor reports success; no own-device test exists. |
| CAM-06 | libcamera / applications | Camera selection, orientation and color | not-tested | not-tested | not-tested | PLAN: Sensor probing is only the first step. |
| VID-01 | Video decoder | Hardware codecs, firmware and V4L2 | not-tested | not-tested | not-tested | DTS, PLAN: Query codec and resolution capabilities separately. |
| VID-02 | Video encoder | Recording and sustained stability | not-tested | not-tested | not-tested | SPEC, PLAN: Depends on the camera and buffer pipeline. |
| VID-03 | Video playback | A/V sync, dropped frames and energy | not-tested | not-tested | not-tested | PLAN: Report software and hardware decoding separately. |

## Boot, recovery, UEFI and security

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| BOOT-01 | Stock XBL / ABL / TEE | Boot chain and recovery path | not-tested | not-tested | not-tested | DTS, PLAN: Preserve stock early firmware. |
| BOOT-02 | Boot / init_boot / vendor_boot / dtbo | Header, slot and payload relationships | not-tested | not-tested | not-tested | OFOX, DONOR, STOCK-GLOBAL: Global boot/recovery/DTBO/GPT layout measured; CN and actual device slot remain open. |
| BOOT-03 | OrangeFox Uke | Clean source build and first recovery boot | not-tested | not-tested | not-tested | OFOX, PLAN: The experimental Global OS3 alpha has separate host/package/privacy records; it has not completed physical boot acceptance. Current P1 source changes require fresh matching target/package and combined guest receipts. The installed OS2 specimen is a separate firmware profile. |
| BOOT-04 | Recovery backup / restore | Source/target validation and readback hashes | not-tested | not-tested | not-tested | NABU, PLAN: Donor features are not Uke acceptance results. |
| BOOT-05 | GPT planner | Handle 128/256 GB and unknown layouts | not-tested | not-tested | not-tested | NABU, PLAN: Do not reuse Nabu offsets. |
| BOOT-06 | Android with Fedora | Dual boot with separate OS data and boot paths | not-tested | not-tested | not-tested | PLAN: A/B slots do not isolate userdata. |
| BOOT-07 | Fedora single boot | Single user OS with retained firmware and recovery | not-tested | not-tested | not-tested | PLAN: Removing user data is a separate explicit operation. |
| BOOT-08 | Project Aloha UEFI | Platform startup, GOP and Block I/O | not-tested | not-tested | not-tested | ALOHA: No Uke target was found in the inspected platform tree. |
| BOOT-09 | EFI stub / DT | Linux entry state and ExitBootServices | not-tested | not-tested | not-tested | ALOHA, PLAN: UKI and boot managers follow EFI acceptance. |
| BOOT-10 | Return to Android | Fallback and stock recovery | not-tested | not-tested | not-tested | PLAN: Accept each boot path independently. |
| BOOT-11 | Updates / rollback | Return from a failed candidate to a known-good build | not-tested | not-tested | not-tested | PLAN: Separate Android OTA, Fedora and recovery updates. |
| SEC-01 | AVB / image integrity | Signatures, rollback metadata and hashes | not-tested | not-tested | not-tested | OFOX, PLAN: Do not disable AVB automatically. |
| SEC-02 | KeyMint / Gatekeeper / TEE | Trust with the installed Android firmware | not-tested | not-tested | not-tested | OFOX: Do not copy Nabu security binaries. |
| SEC-03 | SELinux | Fedora enforcing and recovery policy review | not-tested | not-tested | not-tested | PLAN: Permissive debugging is a separate temporary profile. |
| SEC-04 | Kernel hardening | Isolation, module signing and debug boundaries | not-tested | not-tested | not-tested | PLAN: Do not silently remove protection for performance. |
| SEC-05 | Log privacy | Exclude private identifiers, keys and calibration | not-tested | not-tested | not-tested | PLAN: Keep raw private logs separate from publication reports. |
| BOOT-12 | Boot duration | Bootloader, kernel, userspace and session p50/p95 | not-tested | not-tested | not-tested | PLAN: A physical baseline has not been measured. |
| BOOT-13 | Log health | Resolve every unexplained error and warning | not-tested | not-tested | not-tested | PLAN: Suppressing messages does not fix their causes. |

## Hardware presence to confirm

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| OPT-01 | Haptics / vibration | Identify an installed actuator and driver | not-tested | not-tested | not-tested | OFOX, BLOBS: Shared modules and TW_NO_HAPTICS do not prove presence or absence. |
| OPT-02 | GNSS / positioning | Determine whether independent GNSS exists | not-tested | not-tested | not-tested | DTS, PLAN: Require firmware or board evidence for this Wi-Fi device. |
| OPT-03 | NFC | Determine controller, antenna and transport presence | not-tested | not-tested | not-tested | DTS, PLAN: No board evidence yet; implementation depends on actual hardware. |
| OPT-04 | Fingerprint reader | Determine biometric hardware and trusted interface | not-tested | not-tested | not-tested | DTS, PLAN: Do not assume another tablet's sensor is fitted. |
| OPT-05 | microSD / SIM / modem | Verify physical slots and cellular hardware | not-tested | not-tested | not-tested | SPEC, DTS: Generic SD eject-tool packaging text is not hardware evidence. |

## Third-party observations

- ztsubaki/uke-linux reports a Linux 6.12 framebuffer console and torch. We have not reproduced these builds or tested them on a device.
- The same donor leaves USB enumeration, transfer and reconnect acceptance open.
- Thanick50 describes broken F2FS data formatting; this is a donor report, not our hardware result.
- GPU, audio and resume reports for nearby devices do not change Uke acceptance status.

## Evidence needed next

- Match the installed OS2 boot/DTBO/firmware hashes and complete physical GPT/sector geometry before project boot or live storage admission.
- Identify installed panel/touch and sensor variants and establish a firmware-matched recovery/rollback route.
- Finish ordered recovery P1 remediation, then generate fresh matching target/package and combined guest receipts.
- Validate the Uke mainline board adaptation and packaged runtime dependencies independently of generic ARM64 compilation.
- Record each physical workload with build, firmware, model/SKU, timestamp and evidence before changing an acceptance result.

## Source key

- **SPEC:** [POCO Pad X1 official specifications](https://www.mi.com/my/product/poco-pad-x1/specs/) — Manufacturer capability statement; not a physical SKU inspection.
- **XIAOMI-SPEC:** [Xiaomi Pad 7 official specifications](https://www.mi.com/es/product/xiaomi-pad-7/specs/) — Manufacturer capability statement for the second target commercial model; not a physical SKU inspection.
- **DTS:** [MiCode Uke board DTS](https://github.com/MiCode/kernel_devicetree/blob/94c84aeb9e517dbde546fc732033c184094c8e57/qcom/uke-sm8635.dtsi) — Source-level identity evidence; installed variants require verification.
- **DISPLAY:** [MiCode Uke display DTS](https://github.com/MiCode/vendor_qcom_proprietary_display-devicetree/blob/4a3e1c391130237c5e8c2b250d1c94f3e25b9b11/display/uke-sde-display.dtsi) — Source-level identity evidence; installed variants require verification.
- **CAM:** [MiCode camera device tree](https://github.com/MiCode/vendor_qcom_proprietary_camera-devicetree) — Source-level identity evidence; installed variants require verification.
- **BLOBS:** [Uke proprietary file inventory](https://github.com/Uke-resources/device_xiaomi_uke/blob/56daab9f882c1aded83251abbaa794c464f27905/proprietary-files.txt) — Source-level identity evidence; installed variants require verification.
- **DONOR:** [Uke Linux FDT analysis](https://github.com/ztsubaki/uke-linux/blob/32cad9ccd383ff4b37d8a5e7f88a8bfdcc07307e/docs/UKE_FDT_DEVICE_LIST.md) — Third-party source or report; no own-device validation.
- **USB:** [Uke Linux USB analysis](https://github.com/ztsubaki/uke-linux/blob/32cad9ccd383ff4b37d8a5e7f88a8bfdcc07307e/docs/UKE_USB_SOURCE_FIXES.md) — Third-party source or report; no own-device validation.
- **FB:** [Uke Linux framebuffer analysis](https://github.com/ztsubaki/uke-linux/blob/32cad9ccd383ff4b37d8a5e7f88a8bfdcc07307e/docs/UKE_SIMPLEFB.md) — Third-party source or report; no own-device validation.
- **OFOX:** [Uke OrangeFox donor BoardConfig](https://github.com/Thanick50/ofox_device_xiaomi_uke/blob/ad9bf4ed034455663a71f61eb214322806f9f1fd/BoardConfig.mk) — Third-party source or report; no own-device validation.
- **NABU:** [Nabu recovery feature reference](https://github.com/ArKT-7/twrp_device_xiaomi_nabu) — Third-party source or report; no own-device validation.
- **ALOHA:** [Project Aloha sources](https://github.com/Project-Aloha/mu_aloha_platforms) — Third-party source or report; no own-device validation.
- **PLAN:** [Uke development plan](PLAN.md) — Future implementation and acceptance goals; no physical evidence.
- **STOCK-GLOBAL:** [Global stock boot and partition profile](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/STOCK-LAYOUT.md) — Verified package and offline layout evidence; physical device state remains untested.
- **POCO-FAQ:** [POCO Pad X1 official FAQ](https://www.mi.com/global/support/faq/details/KA-628084/) — OEM declarations for POCO Pad X1 DP 1.2, DP Alt Mode and charging protocols; no project hardware acceptance.
- **STOCK-ADB:** [First own-device stock Android ADB inventory](docs/research/UKE-HARDWARE-STATUS-2026-10-04.md#stock-record-receipts) — POCO Pad X1 ukepgl running OS2.0.205.0.VOZMIXM on 2026-10-03; read-only descriptors/layout and explicit access limits, no project-environment acceptance.
- **STOCK-DEV:** [Development hardware inventory, 2026-10-03](docs/research/UKE-HARDWARE-STATUS-2026-10-04.md#other-hardware) — 15 live I2C/SPI clients and development interfaces; OS3 package pin/address definitions and source contracts remain separate from installed OS2 and project acceptance..
- **STOCK-CAL:** [Calibration and bring-up evidence audit, 2026-10-03](docs/research/UKE-HARDWARE-STATUS-2026-10-04.md#sensors) — Installed ODM sensor connection/orientation definitions, QDCM/camera/audio inputs and thermal topology; unit calibration remains unread and physical metrology is not-tested..

## Updating this document

Edit the ledger, then run `scripts/device-status.sh`. Each working, partial or failed result requires a test record for that environment with build ID, physical variant, firmware profile, UTC timestamp and evidence. `scripts/device-status.sh --check` rejects unsupported results and stale generated Markdown. Automated source checks never promote a physical result.
