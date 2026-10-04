# Xiaomi Uke donor source audit

Reviewed on **4 October 2026**. Scope: the six public repositories listed by the
[xiaomi-uke organization](https://github.com/xiaomi-uke), their pinned Git
objects, selected configuration/source files and static binary metadata.

All six repositories have been cloned below their owning component's
`referances/donors/` directory. Their selected branches retain full reachable
history. Git integrity, bundle creation and network-disabled restoration passed.
The two vendor repositories additionally passed LFS object hashing and offline
restoration. No donor script, service, kernel, module or firmware was executed,
built, flashed or deployed. This audit does not establish device functionality.

The [machine-readable inventory](XIAOMI-UKE-INVENTORY.json) records commit/tree
identities, archive receipts, file classes, directory totals and selected paths.
The workspace [catalog](../../manifests/sources.yaml),
[Git lock](../../manifests/sources.lock.json) and
[LFS lock](../../manifests/lfs.lock.json) remain the acquisition authority.

## Repository inventory and ownership

| Source and locked branch | Full commit | Local reference path | Classification |
|---|---|---|---|
| [Android Uke device](https://github.com/xiaomi-uke/android_device_xiaomi_uke/tree/d828b0ce3ef0ed19a358002ad3f81b9865754f3e), `main` | `d828b0ce3ef0ed19a358002ad3f81b9865754f3e` | `recovery-uke-ofox/referances/donors/xiaomi-uke-device` | Android product tree and proprietary-file inventory |
| [Uke recovery](https://github.com/xiaomi-uke/android_device_xiaomi_uke-recovery/tree/d037467a1643d64979337ad79267c8b8f2e4ca17), `twrp-14.1` | `d037467a1643d64979337ad79267c8b8f2e4ca17` | `recovery-uke-ofox/referances/donors/xiaomi-uke-recovery` | TWRP device configuration, init glue and prebuilts |
| [SM8635 common device](https://github.com/xiaomi-uke/android_device_xiaomi_sm8635-common/tree/d3e10662e157f273a43755a296db98063ace01f0), `main` | `d3e10662e157f273a43755a296db98063ace01f0` | `senemos-uke-kernel/referances/donors/xiaomi-uke-common-device` | Shared Android product, native helper and policy sources |
| [Uke kernel prebuilts](https://github.com/xiaomi-uke/android_device_xiaomi_uke-kernel/tree/446629e5d30c76848bfde9e3a67bcf6386ac24fa), `main` | `446629e5d30c76848bfde9e3a67bcf6386ac24fa` | `senemos-uke-kernel/referances/donors/xiaomi-uke-kernel-prebuilts` | Compiled kernel, DTB/DTBO, modules and exported headers |
| [Uke vendor](https://github.com/xiaomi-uke/android_vendor_xiaomi_uke/tree/a1507a1f691d9de0df31c2986bdccc448bd41731), `lineage-23.2` | `a1507a1f691d9de0df31c2986bdccc448bd41731` | `uke-fedora-builder/referances/donors/xiaomi-uke-vendor` | Proprietary Uke HAL/configuration/firmware inventory |
| [SM8635 common vendor](https://github.com/xiaomi-uke/android_vendor_xiaomi_sm8635-common/tree/ed3b98c5c4d06c75413b8a58ff6a6fee4eab9f7d), `lineage-23.2` | `ed3b98c5c4d06c75413b8a58ff6a6fee4eab9f7d` | `uke-fedora-builder/referances/donors/xiaomi-uke-common-vendor` | Proprietary shared Android components; latest import is from Muyu |

There is no UEFI/EDK II or Project Aloha implementation among these six trees.
They remain available to Aloha research through this shared index; no duplicate
checkout or unsupported Uke UEFI target was created.

| Source ID | Tracked files | Git-tracked bytes | Reachable commits | Main contents |
|---|---:|---:|---:|---|
| `xiaomi-uke-device` | 19 | 72,266 | 30 | Product makefiles, overlays, extraction lists and two Python host tools |
| `xiaomi-uke-recovery` | 171 | 62,157,985 | 292 | One kernel, eleven module files, 94 shared libraries, init/fstab and native bridge prebuilt |
| `xiaomi-uke-common-device` | 169 | 333,833 | 396 | Common product, audio/USB/power policy, pen/keyboard sources and two Python host tools |
| `xiaomi-uke-kernel-prebuilts` | 1,849 | 215,039,919 | 13 | Kernel, four compiled DTBs, DTBO, 1,032 header-tree files and 788 module file instances |
| `xiaomi-uke-vendor` | 1,101 | 1,539,751,115 | 4 | 150 shared libraries, 73 sensor-configuration files, eleven firmware-directory paths and 21 radio images |
| `xiaomi-uke-common-vendor` | 1,669 | 1,403,432,798 | 9 | 1,035 shared libraries, 86 firmware-directory paths and Android services |

Git-tracked byte totals count LFS pointer text rather than external LFS payloads.
They are not checkout disk usage. The 788 module file instances contain 507
distinct basenames and 509 distinct Git blobs; duplicate locations and alternate
bytes must not become 788 claimed drivers.

## Archive completion and provenance

The six Git bundles total **1,793,082,424 bytes**. LFS archives add
**811,438,080 bytes**, including historical objects: four modem-image objects for
the Uke vendor tree and one `libvpnr_enroll_pad.so` object for common vendor.
Git checkouts retain LFS pointer files because automatic smudging is disabled.
Verified payloads reside in their Git LFS object stores and separate LFS archives.
No smudge/checkout conversion was required to inspect configuration evidence.

For every selected branch, the manager rejected shallow history, protected the
pin with an archive ref, ran `git fsck`, verified the bundle and restored its
commit/tree into a new empty repository without network access. LFS archives
were separately extracted and every object hashed against its OID. Both vendor
Git restoration checks were then repeated with their LFS archives present.
No submodules were found. All six lock records now have `archive_complete=true`.
This describes the local archive only, not a separate physical backup or license
clearance for public redistribution.

The vendor repositories are forks of `Xiaomi-Pad-7-Pro-Resources`. Ancestry
checks established that the previously archived Uke vendor commit
`3f3cfe588cbdbfede71cd3e142314d2c1ca81900` and common vendor commit
`bf664e7ef94d4530ec0d2f7f4e3945fbe3ac10b5` are ancestors of these new pins.
The Uke device history also contains the earlier `6aa70ea` import. These are
related revisions, not independent reports of hardware functionality.

## Android Uke product tree

The [device BoardConfig](https://github.com/xiaomi-uke/android_device_xiaomi_uke/blob/d828b0ce3ef0ed19a358002ad3f81b9865754f3e/BoardConfig.mk)
inherits `device/xiaomi/sm8635-common/BoardConfigCommon.mk`, consumes kernel,
DTBs, DTBO and module-load lists from `device/xiaomi/uke-kernel`, and imports
the Uke vendor makefile. `TARGET_KERNEL_SOURCE` points to the **exported header
directory** as a Soong workaround; that setting is not evidence of kernel source.
The Uke tree has no `lineage.dependencies` file at this pin, so a complete
Android checkout requires explicit resolution of these makefile dependencies.

`lineage_uke.mk`, `proprietary-files.txt` and `proprietary-firmware.txt` identify
Global Android 16 **OS3.0.301.0.WOZMIXM** as their import profile. The declared
model is `2410CRP4CG`. This is a donor product declaration, not a measurement of
the attached device. Do not combine it silently with the project's OS3.0.303
Global, OS3.0.302 China or separately documented installed OS2 profiles.

Useful material includes:

- Proprietary paths for camera sensors, audio routing, sensor registries,
  panel calibration filenames, thermal policy and touch firmware.
- A 3/4/1 CPU-cluster power-profile model. These are Android accounting inputs;
  they do not provide our measured power consumption or Linux energy model.
- Android extraction fixups for camera allocator dependencies, audio route
  libraries and symbol versions. Blobs can already be altered for LineageOS;
  do not label them byte-identical stock without comparison to the OEM package.
- An updater URL belonging to another ROM project. It must never become our
  updater default or trust root merely because this device tree contains it.

The README advertises Adreno 735. The recovery BoardConfig also uses an Adreno
735 string. This does not resolve the project's outstanding GPU identification
question; driver chip IDs, OEM DTS and measured firmware/device evidence take
precedence over README and Android build-family strings.

## Recovery donor: useful implementation clues and limits

The [recovery BoardConfig](https://github.com/xiaomi-uke/android_device_xiaomi_uke-recovery/blob/d037467a1643d64979337ad79267c8b8f2e4ca17/BoardConfig.mk)
declares boot header v4, 4 KiB pages, LZ4 ramdisk, kernel-excluded recovery,
100 MiB recovery capacity, A/B/dynamic partitions, FBE v2/wrapped keys,
fastbootd, repack/lp tools, NTFS support, extra languages, 270-degree rotation,
120 frame-rate target and a panel0 brightness range of 0–2047. Those declarations
need actual profile/capacity/kernel checks before reuse.

Its super size is **9,126,805,504 bytes**, while the common device BoardConfig
declares **8,321,499,136 bytes**. This disagreement is sufficient to reject a
shared hard-coded storage geometry. It does not determine which value matches
any installed tablet. Its fstab includes F2FS and `mifs` userdata entries and
maps cache to `rescue`; those entries must not authorize mounts or formatting.

The latest commit is titled `uke: Fix touchscreen`. Static inspection found:

1. Eleven packaged modules, including `xiaomi_touch`, `nt36532_touch`, `metis`,
   `msm_drm`, `miev`, panel notifier, GENI buses and battery/haptic dependencies.
2. A boot fallback that tries to load the touch chain with `xiaomi_touch` ahead
   of `nt36532_touch`, then fixes available-node permissions and starts the HAL.
3. A HAL trigger waiting for `twrp.modules.loaded=true` and
   `touch_dev/abnormal_event`, followed by a one-second delay.
4. A static ARM64 `xiaomi-uinput` prebuilt and a 20-second service watchdog.
   The watchdog comment attributes active-mode keepalive behavior to the bridge;
   the tree supplies no corresponding C/C++ bridge source, so the comment is not
   an independently reproduced protocol implementation.
5. CSOT/Tianma Novatek NT36532 normal/manufacturing firmware names, two THP INI
   variants and palm/water/film/glove inference assets and libraries.

These are good leads for a profile-aware native touch readiness state machine,
module dependency graph and observable failure reporting. They are not proof
that the donor boots, that touch works on our device, or that an Android THP HAL
can run on native Fedora.

Security and reliability issues to preserve as audit findings:

- `init.recovery.qcom.rc` writes SELinux enforce to zero. This must not become
  the default security policy for our recovery.
- `touch_perms.sh` gives `/dev/xiaomi-touch` mode 0666. A future native service
  should use narrowly scoped ownership and permissions after its real ioctl
  requirements are established.
- Synthetic `2127-12-31` security-patch and `99.87.36` platform values are build
  declarations, not patch level, authentication or installed-KeyMint trust.
- Watchdog restarts have no overall attempt bound. Source comments about recovery
  keepalive require device/ABI validation; repeated restarts can hide a persistent
  probe or protocol failure and consume battery.
- A declared service references `/odm/etc/tp_kmsg_init.sh`, which is absent from
  the tracked tree. The boot script also calls an externally supplied log-pruning
  helper. Resolve dependency closure rather than suppressing missing-file logs.
- `TW_NO_HAPTICS=true` coexists with haptic firmware/modules. Neither presence
  nor this disable flag establishes populated hardware or accepted vibration.
- The uinput prebuilt is static ARM64 with debug information and no companion
  source in this tree. Do not import it as a reviewed, rebuildable native tool.

USB configfs/ADB/MTP/sideload/fastboot recipes use the Qualcomm controller and
Android properties. Their configured IDs and 900 mA gadget declaration do not
prove negotiated USB speed, charging current or host enumeration.

## Kernel-named repository: binary reference only

The [tree](https://github.com/xiaomi-uke/android_device_xiaomi_uke-kernel/tree/446629e5d30c76848bfde9e3a67bcf6386ac24fa)
contains no C/C++/assembly implementation or DTS/DTSI sources. Its header
Makefile installs exported headers and has a no-op `all` target. It cannot build
`senemos-uke-kernel-mainline` or the supplied Android kernel.

The Image banner is **6.1.118-android14-11-gca0ef6d17716-ab13624819**. Sampled
vendor touch/DRM modules declare **6.1.68-android14-11-g0abfeb4f023e-dirty**;
the sampled Cliffs clock module declares **6.1.68-android14-11-maybe-dirty**.
These different labels are not sufficient to conclude an Android KMI failure,
but they require symbol/version/config and firmware checks. They are certainly
not a compatibility contract for mainline Linux 7.2.8.

Module directories contain 348 ramdisk, 320 vendor and 120 system file instances.
They include Qualcomm clock/interconnect/UFS/USB, Novatek touch, Nanosic input,
QCA6750 WLAN and multiple audio codec families. Lists and `.modinfo` dependencies
help reconstruct the OEM boot graph; module existence does not establish which
alternatives are populated on Uke.

Four DTBs have Cliffs/Cliffs 7/Cliffs7P/CliffsP filenames. Their root metadata
is an OEM binary reference, not an independent mainline binding. The extraction
script fetches a pinned third-party Python DTB extractor and invokes AOSP Python
boot/DTBO tools. We inspected the script without running it.

More importantly, the script edits `qcom,dsi-supported-dfps-list` to
**120, 144, 90, 60** for two Uke panel symbol names before regenerating DTBO.
Consequently, the archived DTBO must be treated as a potentially modified
community artifact until its exact bytes and decoded trees are compared with a
profile-matched stock DTBO. A ROM-derived filename alone is insufficient.

The recovery kernel and this repository's kernel are byte-identical:
SHA-256 `6144d19de9c1f1915819b53fcb05424ee283a2f6b0dea725f4a05c1934974d61`.
The kernel-tree DTBO SHA-256 is
`7afe1c987f7220c8f4fbbe0399234d27933946fb9252d5218f5e9690776eecc3`.
These hashes establish artifact identity, not suitability for flashing.

## Shared device tree and native accessory sources

The common product lists Android sensor multihal, QTI audio/graphics/thermal/USB
services, qca6750/kiwi Wi-Fi alternatives, charging control and policy overlays.
Its proprietary-file list explicitly attributes the latest import to **Pad 7
Pro OS3.0.301.0.WOYMIXM**. `lineage.dependencies` declares `android_hardware_xiaomi`
without pinning its branch/commit; QCOM/Lineage/AOSP sources are additional
makefile dependencies. This organization is not a self-contained Android build.

Useful native donor files include `parts/xiaomi-pen.cpp`,
`parts/xiaomi-focus-pen-filter.c` and `power/power-mode.cpp`:

- Pen mode and double-tap control describe Xiaomi touch ioctls, including touch
  selection and a 128-element data buffer. The helpers do not check their
  `open`/`ioctl` return values before reporting success; retain the protocol lead,
  then design explicit C++ errors, ABI tests and resource cleanup for new code.
- The Focus Pen filter merges an M80p touchscreen stream with 15-byte HID reports
  through uinput. It hard-codes coordinate maxima 21359/31999 and pressure 8191.
  These are donor constants, not the accepted ranges of any connected accessory.
- Hidraw discovery scans indices 0–15 by name and initially waits indefinitely.
  It should be replaced by bounded, hotplug-aware identity validation if used in
  a new service. Parser bounds and incomplete reads need independent review.
- `init.pen.events.sh` deletes matching input event nodes. Preserve normal input
  discovery and reversible device ownership; never import this deletion behavior
  as a shortcut to preventing duplicate stylus events.
- Java/Kotlin Android keyboard/pen apps, framework permissions and SELinux policy
  are platform integration examples, not native Fedora implementations.

The common BoardConfig uses AVB test-key paths and `--flags 3`. Those development
choices must not be adopted as a production verified-boot policy. Generic GPS,
IR, SD-card or external-backlight declarations do not add those capabilities to
the Uke hardware ledger.

## Vendor inventory: subsystem leads

| Subsystem | Pinned evidence | How it helps | What it does not establish |
|---|---|---|---|
| Panel/touch | Uke QDCM filenames for `o82_36_02_0a` and `o82_42_02_0b`; CSOT/Tianma NT36532 firmware/THP configurations | Compare OEM panel IDs and variant-specific configuration with DTBO and touch init | Selected panel, timing acceptance, native DRM or touch operation |
| IMU | `lsm6dso_0.json`, `sm7675_lsm6dso_0.json`, `sm7675_qmi8658_0.json` | Candidate sensor families, typed SSC bus/rail/IRQ/orientation configuration | Populated IMU, host-bus ownership or calibrated Linux events |
| Magnetometer | `qmc6308_0.json` and `sm7675_qmc6308_0.json` | Registry-family and transform comparison | Installed chip or magnetic calibration |
| Other sensors | `sm7675_stk3bcx_0.json`, `sm7675_sx937x_0.json`, `sm7675_sip1328.json`, algorithm registries | Variant-selection and SSC topology leads | Every listed alternative fitted to every SKU; direct Linux IIO access |
| Camera | OV13B10 wide and OV08D10 front sensor plugin paths plus EEPROM/actuator plugins | Cross-reference OEM sensor DTS, tuning and ISP/DSP dependencies | Working V4L2 camera or private per-unit calibration |
| Audio | Forte ACDB, Cliffs resource manager/mixer configuration, common codec-family files | Reconstruct routing/DSP/amp hypotheses and compare SKUs | Accepted codec population, ALSA/UCM routing or speaker safety |
| Thermal/power | 69 Uke thermal-related paths, region maps and Android power accounting | Preserve policy units and profile provenance while defining instrumentation | Safe imported thresholds, measured performance or battery life |
| WLAN/BT | Common qca6750 and kiwi config alternatives, kernel QCA6750 module, Uke radio images | Firmware/driver/board-data dependency mapping | Linux networking, regulatory suitability or RF calibration |
| Keyboard/stylus | Common keyboard/touchpad upgrade binaries and pen services; Nanosic module in kernel tree | Compare protocol and event identities with Uke-specific source/evidence | Accessory firmware compatibility, pressure or hotplug acceptance |
| Security/boot | Uke ABL/XBL/TEE/UEFI/keymaster images; Android boot/KeyMint/Weaver/Gatekeeper HAL dependencies | Record profile identity and expected interfaces | Secure boot, data decryption, UEFI boot support or permission to replace firmware |

Sensor registry values use typed `data` fields and platform/SoC selectors.
The listed families are source candidates only. Preserve SSC routing and compare
to the [hardware ledger](../../DEVICE-STATUS.md)
and separately classified stock evidence. This source audit does not update
physical working/not-working results.

The touchfeature service is an Android ARM64 ELF using `/system/bin/linker64`,
Binder/HIDL and Android libraries. `readelf` confirms dependencies such as
`libbinder_ndk.so`, `libhidlbase.so`, Android sensors and the vendor touchfeature
interface. Copying this ELF into Fedora is not a native integration strategy.

## Reuse priorities and optimization work

| Priority | Next work | Dependency / acceptance |
|---|---|---|
| P0 | Compare donor storage/header declarations with independent stock catalogs and installed-profile evidence | No donor constant authorizes a live write; retain existing write gates |
| P0 | Decode and compare the community DTBO with its exact stock import | Identify any timing edit and every panel/board combination before using it |
| P0 | Map touch module dependencies and HAL readiness to existing recovery code | Native/source tests first; hardware probe/order/rotation acceptance separately |
| P0 | Audit ELF dependencies, license and kernel ABI for every proposed recovery import | Resolve missing scripts; no opaque bridge or security-HAL transplant |
| P1 | Compare two panel/THP variants, sensor registries and camera paths to MiCode Uke DTS | Profile/SKU and private-calibration boundaries remain explicit |
| P1 | Design a C++ pen/touch prototype from reviewed protocols | Bounded discovery, exact reports/ioctls, disconnect handling and event fixtures |
| P1 | Preserve thermal/power units and define idle/load measurements | No copied Android thresholds or accounting values become measured defaults |
| P2 | Add reviewed firmware selection to Fedora packaging | File-level redistribution terms, mainline driver support and board data required |
| P2 | Use Uke radio-image identity for Aloha compatibility research | Existing framework needs a separately reviewed/rebuildable Uke target |

Optimization candidates are hypotheses to measure: event-driven readiness rather
than fixed sleeps and unlimited restarts; bounded hotplug discovery rather than
repeated full scans; explicit module dependency sorting; correct Android/Fedora
ABI boundaries; and size reduction only after unused-library closure is proven.
Keep mandatory storage revalidation, fsync, readback and rollback checks.

Existing VM measurements and open optimization items remain in the recovery
[VM review](../../recovery-uke-ofox/reports/URE-VM-REVIEW.md) and
[functional review](../../recovery-uke-ofox/reports/URE-FUNCTION-VM-REVIEW.md).
This acquisition introduced no new recovery payload or VM acceptance result;
the donor's Qualcomm hardware and Android security services are not emulated by
the generic guest. Re-run relevant tests after an actual implementation change.

## Language, licensing and publication

Four donor Python files remain in ignored reference checkouts. The kernel
extraction shell also invokes upstream Python tools. None was run in this audit,
added as a project-owned script or packaged for recovery/Fedora/tablet use.
New device management remains C++; project host automation remains Bash.

GitHub metadata reports no repository-wide license for these six repositories,
and no LICENSE/COPYING/NOTICE-named files were found in their pinned trees.
Some source files carry Apache-2.0/BSD notices; several proprietary files carry
vendor rights statements. Retain those notices and review each proposed copied
file. A public blob repository is not blanket redistribution permission.
Checkouts, bundles, LFS objects and raw private logs stay ignored. Publish only
our catalog, checksums, reviewed inventories, reports and engineering lessons.

## Reproducing the inventory

From the workspace root, acquire/archive the six source IDs with
`scripts/sources.sh archive`. The vendor sources need the reviewed host Git LFS
client: fetch all objects reachable from their selected local refs, run
`scripts/archive-lfs.sh` for each vendor ID and repeat `restore-check`.

Run `scripts/audit-xiaomi-uke.sh > docs/research/XIAOMI-UKE-INVENTORY.json` to
regenerate the source inventory. It reads Git objects at catalog pins and refuses
mismatched checkout identity, dirty tracked files or shallow history. It executes
no reference code. Existing archive receipt timestamps remain unchanged until a
separate archive verification operation is deliberately performed.
