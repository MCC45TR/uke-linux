# Uke hardware status: evidence summary

**Published:** 4 October 2026. **Physical observations:** 3 October 2026. **Observed target:** POCO Pad X1 8 GB / 512 GB, model 25099RP08G, `uke_p_global` / `ukepgl`, stock Android 15 Global `OS2.0.205.0.VOZMIXM`. Installed kernel: `6.1.118-android14-11-ga3b9c44908dd-ab13320413`.

This is a condensed public transcription of the reviewed stock inventory, development hardware inventory and calibration audit. Raw logs and unit calibration remain private. Xiaomi Pad 7 variants and the Global OS3 recovery alpha require separate compatibility records.

## Reading status

| Status | Required evidence |
|---|---|
| Fully working / `working` | Complete acceptance workload passed on the named physical build, firmware and variant |
| Partial / `partial` | A tested part of that workload works, with limitations recorded |
| Not working / `not-working` | An actual workload observed a failure |
| Not tested / `not-tested` | No functional acceptance result; descriptors or source candidates alone are insufficient |

The [project matrix](../../DEVICE-STATUS.md) tracks 143 capabilities. Recovery, UEFI and Fedora/Linux each remain **143 not-tested, zero working, zero partial and zero measured failures**. No own-device PenguinOS/CLO or Lineage/AOSP acceptance is recorded. An unavailable implementation is distinct from a measured physical failure.

## Sensors

Stock exposes **61 descriptors: 53 HAL and eight framework interfaces**, including software fusion and wake/non-wake variants. This is not a physical-chip count.

| Function | Observed family / interface | Stock observation | Project functional status | Next workload |
|---|---|---|---|---|
| Accelerometer | `lsm6dso`, STMicro | Descriptor and retained events | Not tested | Six-face axes/sign/scale, motion and timestamps |
| Gyroscope | `lsm6dso`, STMicro | Descriptor and retained events | Not tested | Stationary bias, measured rotations and sampling |
| Magnetometer | `qmc630x`, QST | Calibrated/uncalibrated descriptors | Not tested | Axis mapping, reference orientation and interference |
| Front ambient light | `stk_stk3bcx`, Sensortek | Partial observation: last-event timestamp advanced | Not tested | Controlled light, reference lux, saturation and brightness policy |
| Proximity | `stk_stk3bcx`, Sensortek | Descriptor and retained events | Not tested | Near/far transitions, cover interference and wake |
| Front CCT | `stk_stk3bcx`, Sensortek | Descriptor and retained events | Not tested | Reference illuminants, channel validity and saturation |
| Rear light | `sip1328`, SI | Back ALS and back-lux stream descriptors | Not tested | Front/rear occlusion, reference lux and sampling |
| Flicker | `sip1328`, SI | Flicker descriptor | Not tested | Controlled 50/60 Hz sources and invalid signals |
| SAR / grip | `semtech_sx937x_0`, Semtech; `sar_detector` | Vendor interface and algorithm descriptors | Not tested | Approved electrode mapping and controlled grip stimulus |
| Hall cover / position | Input interfaces and OEM lid/table definitions | Exact chip unidentified; no actuation test | Not tested | Cover attach/detach and polarity |
| Orientation / rotation / gravity / steps | Xiaomi/QTI and AOSP fusion | Software descriptors | Not tested | All four orientations, selected algorithms and wake/resume |
| Thermal / PMIC ADC | Thermal channels; PMK8550 VADC / PMIC GLINK ADC | 63 zones, 46 cooling devices and 33 bindings | Not tested | Per-driver units, reference temperature and controlled load |

Only the front non-wakeup STK ambient-light last-event timestamp advanced across two passive snapshots. Fourteen named interfaces retained recent records; the other retained timestamps did not advance in that comparison. This is a partial observation, not calibrated light response, an accepted continuous stream, rotation policy or automatic brightness.

QMI8658 is an alternate ODM IMU configuration candidate; the observed HAL advertises LSM6DSO. QMC630x does not establish QMC6308. STK3BCx and SX937x suffixes remain unresolved. Generic ToF/ultrasound candidates do not establish populated hardware. PMIC IIO nodes do not establish direct IMU access. SSC configuration bus/rail fields are not measured wiring or interchangeable Linux adapter numbers.

## Other hardware

All project Recovery, UEFI and Fedora results below remain **Not tested**.

| Component | Stock or source evidence | Remaining functional validation |
|---|---|---|
| SM7675 / Adreno 732 | Stock identity, CPUs 0–7 online and KGSL/GLES identification | Project boot, GPU acceleration, clocks and sustained load |
| 3200 × 2136 display | Stock compositor reports seven refresh modes and active 120 Hz | Installed supplier, DRM, mode changes, color and resume |
| Two KTZ8866 backlights | Two live I2C bindings | Brightness range, both sides and blank/unblank |
| Novatek touch | `NVT-ts` SPI binding, `nt36532_touch` module and NVT input paths | Edges, multitouch, rotation, firmware and resume |
| Pen | `NVTCapacitivePen` registered | Accessory unavailable; pressure, tilt, hover and rejection |
| Nanosic 803 keyboard | `nanosic,803` binding | Attach/detach, keys, pointer and gestures |
| Four FS16xx amplifiers | Four live `fs16xx` I2C clients | Channel map, playback, safe gain and protection |
| Cameras | Rear/front HAL entries; sensor and EEPROM clients | Installed sensor identities, capture and image quality; OV13B10 is a source candidate |
| UFS / Android data | Six disk names, 121 labels, eight allocated logical partitions; F2FS `/data` | Physical GPT/sector geometry, hashes, project writes and encryption trust |
| USB / ADB | Read-only stock acquisition succeeded; DWC3 interface observed | Recovery ADB, reconnect, checksum, roles and negotiated speed |
| USB-C display / dock | DP AUX observed; OEM POCO FAQ declares DP 1.2 / Alt Mode | HDMI/MST, resolution/refresh, keyboard/mouse and reconnect |
| Power / charging | Stock service and configuration fields | Gauge accuracy, negotiated charging, thermal limits and suspend |
| Wi-Fi / Bluetooth | Declarations and firmware/configuration references | Project association, transfer, coexistence and suspend |
| IR / NFC tag | Live `ir-spi` and `fm,fm19511` bindings | Emission and tag behavior; full reader/card emulation unestablished |

Enabled package nodes do not establish installed suppliers or functioning hardware. CSOT/TM panels, camera source names and shared fingerprint/haptics configuration remain candidates. BCL/current/voltage proxy channels are not universally temperatures in millidegrees.

## Stock record receipts

These bounded stock collection identifiers also reference separately scoped host analysis. Raw captures and calibration-looking content remain private.

| Record | UTC start | Established scope | Limits |
|---|---|---|---|
| STOCK-ADB-20261003-01 | 2026-10-03T12:01:02Z | Identity, sensor descriptors, labels, logical extents and module/platform metadata | Protected GPT/geometry, panel and remoteproc attributes; no controlled sensor experiment |
| STOCK-ADB-20261003-02 | 2026-10-03T12:29:10Z | Live clients, IRQ/input declarations and development interfaces; separate OS3 package/source analysis | Installed OS2 differs from decoded OS3; wiring and peripheral acceptance unmeasured |
| STOCK-ADB-20261003-03 | 2026-10-03T14:22:11Z | ODM defaults, thermal/cooling topology and camera/audio/display metadata | Persisted calibration inaccessible; no successful private calibration backup or metrology |

The consolidated collection covered **118 stock probes**. Denied, nonzero, empty and semantically unusable outputs were retained as limits. The collector performed no tablet write, privilege escalation, raw block copy, sensor activation, calibration command, mapper/mount operation, slot change or reboot. Host decoding of existing Global OS3 firmware did not change the tablet.

## Accessory evidence

Ricomm RC1001 charging equipment and the Juo JH925 USB-C dock are designated for later tests. Advertised limits and purchase reports do not establish negotiation or compatibility. OrangeFox, Fedora and PenguinOS/CLO need separate results. The 2K/75 Hz monitor, HDMI/MST, mouse/keyboard, hotplug and direct-versus-docked charging remain untested.

## Updating results

Record build revision, firmware, model/SKU, UTC timestamp, workload, expected/observed behavior and evidence before changing a functional result in [the ledger](../../manifests/device-status.json). Regenerate `DEVICE-STATUS.md` with `scripts/device-status.sh`, then run `--check`. Source, build, package, VM and third-party evidence remain separate; a new firmware or supplier variant needs its own physical record.
