# Device status: POCO Pad X1 and Xiaomi Pad 7 / uke

Target family: **POCO Pad X1 and Xiaomi Pad 7 (`uke`)**. Primary physical validation hardware: **POCO Pad X1 8 GB / 512 GB**. Kernel product: **senemos-uke-kernel-mainline**. Target sequence: OrangeFox, Project Aloha, then Fedora Rawhide AArch64.

This document is generated from `manifests/device-status.json`. Source evidence identifies a candidate component or capability; it does not establish that our software works on it.

Ledger updated: **2026-09-29**. Physical device available: **false**. Tracked capabilities: **143**.

No own-device acceptance has been performed. A missing implementation or an untested feature is not a measured hardware failure. Third-party results are recorded separately.

## Reading the results

- **working**: acceptance passed on the recorded build, firmware and physical variant.
- **partial**: some tested functions work; limitations must be recorded.
- **not-working**: a real test observed failure.
- **not-tested**: no success or failure claim.
- **not-applicable**: the function is outside that environment's scope, with a recorded reason.

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
| ID-01 | POCO Pad X1 / Xiaomi Pad 7 / uke / SM7675 | Identify model, SKU, RAM, storage and firmware | not-tested | not-tested | not-tested | SPEC, XIAOMI-SPEC, DTS: Both commercial models are Uke project targets; every SKU and installed hardware variant requires its own physical record. Pad 7 Pro / muyu is a different board. |
| SOC-01 | SM7675 / Cliffs | CPU topology and all cores online | not-tested | not-tested | not-tested | DTS, DONOR: Shared SM8635 filenames do not change the target SoC. |
| SOC-02 | ARM64 CPU | Frequency, voltage and cpufreq | not-tested | not-tested | not-tested | DTS, PLAN: Compare stock OPP tables and power limits. |
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
| SOC-14 | LPDDR5X 8 / 12 GB | Memory map, high memory and reserved regions | not-tested | not-tested | not-tested | SPEC, XIAOMI-SPEC, DTS: POCO Pad X1 targets 8 GB; Xiaomi Pad 7 advertises 8 GB and 12 GB variants. Boot firmware and the physical memory map determine valid addresses. |
| SOC-15 | Watchdog / RTC / pstore | Crash retention, watchdog and timekeeping | not-tested | not-tested | not-tested | DTS, PLAN: Validate ramoops against the real memory map. |
| SOC-16 | Hexagon / CDSP / AI Engine | DSP compute and accelerator APIs | not-tested | not-tested | not-tested | SPEC, BLOBS: Android AI marketing does not prove native Linux compute support. |

## Storage and filesystems

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| STO-01 | 512 GB UFS 4.0 target | Controller, PHY and read-only access | not-tested | not-tested | not-tested | SPEC, DTS: The target capacity is defined by the SKU, but controller identity, geometry and health require physical inspection. |
| STO-02 | Xiaomi Pad 7 128 GB UFS 3.1 / 256 GB UFS 4.0 | Controller, PHY and read-only access | not-tested | not-tested | not-tested | XIAOMI-SPEC, DTS: Keep each Xiaomi Pad 7 capacity and storage generation separate from the POCO Pad X1 512 GB profile. |
| STO-03 | UFS | Write, flush, discard and interruption recovery | not-tested | not-tested | not-tested | PLAN: Later physical tests use a designated test area. |
| STO-04 | Qualcomm ICE | Inline encryption and wrapped-key capabilities | not-tested | not-tested | not-tested | DTS, OFOX: Kernel capability does not establish Android key access. |
| STO-05 | ext4 | Rootfs and backup creation, reading and repair | not-tested | not-tested | not-tested | OFOX, PLAN: Synthetic disk and physical tests are separate. |
| STO-06 | F2FS | Format, mount, checkpoint and restore | not-tested | not-tested | not-tested | OFOX: The recovery donor reports broken data formatting. |
| STO-07 | EROFS / dynamic partitions | Read-only Android partition inspection | not-tested | not-tested | not-tested | OFOX: Validate logical partition and slot selection. |
| STO-08 | FAT / exFAT / NTFS | USB media and ESP filesystems | not-tested | not-tested | not-tested | NABU, PLAN: Test firmware and OS drivers separately. |
| STO-09 | Android metadata / userdata | Installed Android FBE compatibility | not-tested | not-tested | not-tested | OFOX: Requires firmware-matched KeyMint and TEE evidence. |
| STO-10 | UFS health | Lifetime writes, health and error counters | not-tested | not-tested | not-tested | NABU, PLAN: Verify counter units and kernel interfaces. |

## Display and graphics

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| DIS-01 | ABL framebuffer / simplefb | Early framebuffer console | not-tested | not-tested | not-tested | FB: Third-party results apply to a particular stock profile. |
| DIS-02 | CSOT / TM panel variants | Identify the installed panel and initialization sequence | not-tested | not-tested | not-tested | DTS, DISPLAY: Keep panel firmware and power sequencing separate. |
| DIS-03 | Dual DSI / DSC | DSI links, timings and compression | not-tested | not-tested | not-tested | DISPLAY, DONOR: Validate both links and all DSC parameters. |
| DIS-04 | 3200 x 2136 LCD | Resolution, color order and orientation | not-tested | not-tested | not-tested | SPEC, DISPLAY: A framebuffer console is not a full panel driver. |
| DIS-05 | 30/48/50/60/90/120/144 Hz | Refresh modes and transitions | not-tested | not-tested | not-tested | SPEC, DISPLAY: These are vendor capabilities; native modes need measurement. |
| DIS-06 | Two KTZ8866 controllers | Backlight range and left/right consistency | not-tested | not-tested | not-tested | DISPLAY, DONOR: An upstream driver alone does not establish board support. |
| DIS-07 | LCD blank / unblank | Display off, on and resume | not-tested | not-tested | not-tested | DISPLAY, PLAN: Test rail and clock handoff independently. |
| DIS-08 | Color / P3 / HDR | Color accuracy and userspace color management | not-tested | not-tested | not-tested | SPEC, PLAN: Branded HDR capabilities depend on licensing and the full pipeline. |
| DIS-09 | DPU / DRM | Fences, underruns, tearing and corruption | not-tested | not-tested | not-tested | PLAN: Correlate raw logs with visible output and workload. |
| GPU-01 | Adreno 732 | Chip ID and GMU/SQE/ZAP firmware matching | not-tested | not-tested | not-tested | BLOBS, DONOR: Do not select firmware for other GPUs from shared vendor trees. |
| GPU-02 | DRM MSM / Freedreno | Render node and OpenGL acceleration | not-tested | not-tested | not-tested | PLAN: Record software rendering separately. |
| GPU-03 | Mesa Turnip | Vulkan workloads and recovery | not-tested | not-tested | not-tested | PLAN: Android container drivers do not prove native DRM support. |
| GPU-04 | GPU devfreq / idle | Performance, energy and thermal throttling | not-tested | not-tested | not-tested | DTS, PLAN: Do not invent OPP tables from guessed speedbins. |
| GPU-05 | GPU reset / resume | Repeated load and suspend recovery | not-tested | not-tested | not-tested | PLAN: Every hangcheck and fault must be explained and resolved. |
| DIS-10 | USB-C video output | Determine whether DP alt-mode exists | not-tested | not-tested | not-tested | DTS, PLAN: USB 3.2 capability alone does not establish DisplayPort support. |

## Touch, pen, keyboard and keys

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| INP-01 | Novatek NT36532 / NVT-ts-spi | Finger input, IRQ, reset and firmware loading | not-tested | not-tested | not-tested | DTS, BLOBS: Keep CSOT and TM firmware variants separate. |
| INP-02 | Novatek touch | Multitouch, edges and coordinate transforms | not-tested | not-tested | not-tested | DTS, PLAN: Test all four display orientations. |
| INP-03 | Novatek touch | Suspend, resume and touch wake | not-tested | not-tested | not-tested | DTS, PLAN: Measure energy cost if wake is supported. |
| INP-04 | Focus Pen / Novatek pen input | Pen position and hover | not-tested | not-tested | not-tested | DTS, BLOBS: The pen accessory is not available for testing. |
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
| USB-04 | ADB / sideload | Host connection and installation transfer | not-tested | not-tested | not-tested | OFOX, PLAN: Require checksum and disconnect tests. |
| USB-05 | MTP | File listing and large transfers | not-tested | not-tested | not-tested | OFOX, PLAN: Record access restrictions imposed by Android FBE. |
| USB-06 | Fastbootd | Logical partitions and mode transitions | not-tested | not-tested | not-tested | OFOX: Distinguish userspace fastbootd from bootloader fastboot. |
| USB-07 | USB mass storage | Read-only export of a selected disk image | not-tested | not-tested | not-tested | NABU, PLAN: Prevent local mount and host write conflicts. |
| USB-08 | USB OTG / host | HID, storage and hubs | not-tested | not-tested | not-tested | SPEC, PLAN: Host and gadget acceptance are independent. |
| USB-09 | USB 3.2 Gen1 | SuperSpeed link and throughput | not-tested | not-tested | not-tested | SPEC, DTS: USB2 success cannot establish SuperSpeed support. |
| USB-10 | Type-C / PD | Orientation, role switching and power negotiation | not-tested | not-tested | not-tested | DTS, PLAN: Test combinations of ports, cables and chargers. |
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
| SNS-01 | LSM6DSO or QMI8658 | Accelerometer raw XYZ, units and scale | not-tested | not-tested | not-tested | BLOBS: Do not assume both candidate IMUs are installed. |
| SNS-02 | LSM6DSO or QMI8658 | Gyroscope XYZ, bias and sampling | not-tested | not-tested | not-tested | BLOBS: Require IC identity and mounting matrix. |
| SNS-03 | QMC6308 candidate | Magnetometer and compass | not-tested | not-tested | not-tested | BLOBS: Validate axes and hard/soft iron calibration. |
| SNS-04 | SIP1328 candidate | Determine ALS/CCT role and channels | not-tested | not-tested | not-tested | BLOBS: Filenames alone cannot establish sensor function. |
| SNS-05 | STK3BCX candidate family | Distinguish ALS, proximity and flicker capabilities | not-tested | not-tested | not-tested | BLOBS: Exact submodel and channel population are unknown. |
| SNS-06 | SX937X candidate family | SAR/grip raw capacitive channels | not-tested | not-tested | not-tested | BLOBS: Do not label it display proximity or invent electrode positions. |
| SNS-07 | Hall sensor | Magnetic cover events and polarity | not-tested | not-tested | not-tested | SPEC, DTS: Exact part number remains unknown. |
| SNS-08 | Ambient light | Lux, dynamic range and automatic brightness | not-tested | not-tested | not-tested | SPEC, PLAN: Raw sensor behavior and desktop policy are separate. |
| SNS-09 | Color temperature | Raw color channels, CCT and adaptation | not-tested | not-tested | not-tested | SPEC, PLAN: Saturated values are not valid calibration evidence. |
| SNS-10 | Flicker | Sampling, 50/60 Hz detection and validity | not-tested | not-tested | not-tested | SPEC, BLOBS: Confirm hardware and driver transport. |
| SNS-11 | Proximity | Physical sensor or algorithm and near/far events | not-tested | not-tested | not-tested | SPEC, BLOBS: Do not automatically equate proximity with SAR. |
| SNS-12 | Orientation / fusion | Autorotation and vibration stability | not-tested | not-tested | not-tested | PLAN: Establish IMU health before SensorProxy integration. |
| SNS-13 | Sensor hub / QSH | Batching, timestamps, wake and resume streams | not-tested | not-tested | not-tested | BLOBS, DONOR: Test re-registration after firmware reset. |
| SNS-14 | Thermal sensors | Channel identity, millidegrees and consistent readings | not-tested | not-tested | not-tested | DTS, OFOX: Do not reuse the fixed thermal_zone48 index. |
| SNS-15 | Advertised IR remote | Verify that an IR component actually exists | not-tested | not-tested | not-tested | SPEC: No board evidence yet; do not mark supported. |

## Battery, charging and power

| ID | Component / candidate variant | Capability and acceptance target | Recovery | UEFI | Linux | Evidence / open work |
|---|---|---|---|---|---|---|
| PWR-01 | 8850 mAh typical battery | State of charge, health, current, voltage and temperature | not-tested | not-tested | not-tested | SPEC, DTS: Validate units and current sign conventions. |
| PWR-02 | Battery GLINK | Firmware telemetry and Linux power_supply | not-tested | not-tested | not-tested | DTS, DONOR: Do not copy Nabu LN8000 or PM8150 settings. |
| PWR-03 | USB-C charging | Basic charging, reconnect and low battery | not-tested | not-tested | not-tested | SPEC, PLAN: Keep measurement and control paths separate. |
| PWR-04 | Advertised 45 W / PD / QC / Mi FC | Negotiation and safe power limits | not-tested | not-tested | not-tested | SPEC, PLAN: Adapter rating is not continuous battery input power. |
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
| BOOT-03 | OrangeFox Uke | Clean source build and first recovery boot | not-tested | not-tested | not-tested | OFOX, PLAN: Global-profile OrangeFox built from incremental and fresh outputs; payload privacy gate fails, and pristine re-sync and physical boot on both models remain untested. |
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

- Extract stock recovery/boot headers, DTBs, partition relationships, module ABI and filesystem profiles.
- When hardware arrives, record SKU, panel/touch identity, sensor population, installed firmware and recovery path.
- Produce the first recovery build with header, size and dependency reports.
- Reproduce the F2FS formatting problem on synthetic filesystems before any device operation.
- Associate every physical result with build, firmware, variant, timestamp and raw evidence.

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
- **STOCK-GLOBAL:** [Global stock boot and partition profile](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/main/docs/STOCK-LAYOUT.md) — Verified package and offline layout evidence; physical device state remains untested.

## Updating this document

Edit the ledger, then run `scripts/device-status.sh`. Each working, partial or failed result requires a test record for that environment with build ID, physical variant, firmware profile, UTC timestamp and evidence. `scripts/device-status.sh --check` rejects unsupported results and stale generated Markdown. Automated source checks never promote a physical result.
