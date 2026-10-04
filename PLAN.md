# POCO Pad X1 and Xiaomi Pad 7: recovery, firmware and Fedora development plan

Revision 11 — 3 October 2026. Target family: **POCO Pad X1 and Xiaomi Pad 7 (`uke`, SM7675 / Cliffs)**. Primary physical validation SKU: **POCO Pad X1 8 GB / 512 GB**. First distribution: **Fedora Rawhide AArch64**. Kernel product: **`senemos-uke-kernel-mainline`**. Initial kernel baseline: **Linux 7.2.8**.

This is an implementation plan and an evidence contract. Experimental OrangeFox assets have been built for the measured Global profile; no project image has been tested on either physical model. Generic upstream Linux 7.2.8 Image, DTBs and 1,655 modules compile and stage successfully, but no Uke-bootable mainline or UEFI image exists. A physical device is not available. Current results are recorded in [the preparation report](reports/PREPARATION-REPORT.md), [the public alpha build report](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/main/reports/PUBLIC-ALPHA-BUILD.md) and [DEVICE-STATUS.md](DEVICE-STATUS.md).

## 1. What we are building

The first deliverable is a reproducible OrangeFox recovery for Uke with the management capabilities found in the ArKT Nabu recovery. Recovery establishes the inventory, backup, diagnostics and controlled installation foundation. Project Aloha follows, providing a Uke-specific UEFI path and return to Android. The mainline kernel and Fedora system then use these foundations.

The expanded recovery product is the **UKE Recovery Environment (URE)**: an
offline Android/Linux/Windows maintenance environment built on OrangeFox, with
project-owned C++ management code. The [comprehensive recovery roadmap](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/COMPREHENSIVE-ROADMAP.md)
retains all topics 0–102 from the supplied 30 September roadmap. Section 6.1
adds its sixteen implementation phases without renumbering the 100 platform
steps. Windows, advanced layouts and optional extensions remain conditional
future capabilities; they do not change the first Fedora target or create
hardware support claims.

The long-term goal is an integrated tablet: reliable boot, complete support for physically present hardware, responsive input, good battery life, bounded diagnostics and maintainable updates. “OEM quality” is an acceptance target, not a statement about today's software. Every advertised function must have a variant-specific test record.

Current preparation includes architecture, source research, pinned reference clones, an archive manager, feature and hardware inventories, public project repositories and the COPR test channel. The Android 16 tree is synchronized; Global and China boot layouts and four base DTBs per profile are inspected, and Turkey OTA metadata is hash-verified. A privacy-clean recovery build and native active-slot installer pass offline checks. Unsigned, explicitly untested experimental prereleases may publish these artifacts after source/privacy/package checks; supported releases still require physical boot and stock-return acceptance. UEFI/mainline porting, full build reproduction and physical validation remain open. No live partitioning, flashing, Android key access or remote package build is part of this delivery.

### Fixed decisions

| Area | Decision |
|---|---|
| Work order | Recovery foundations → Project Aloha → mainline integration → Fedora → full hardware acceptance |
| Recovery reference | Official OrangeFox `fox_16.0`, source release R12.0; pin the complete manifest before building |
| Feature minimum | All 34 groups in [FEATURE-PARITY.md](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/FEATURE-PARITY.md), including conditional Windows/second-Android tools |
| Recovery expansion | URE-00–URE-15 and URE-C01–URE-C24 extend the donor minimum with native rescue, crypto, Btrfs, boot routing, networking and transaction contracts |
| First recovery kernel | Firmware-matched OEM/GKI kernel and modules after stock layout analysis |
| Mainline baseline | Linux `v7.2.8`, commit `9a66fdc0d7fd55f54235524a73435af99051e46f` |
| Native project code | C++; upstream kernel/EDK II retain their required C and assembly |
| Automation | Bash first; Go where shell becomes unsuitable; no project-owned Python when alternatives exist |
| Tablet Python | No Python runtime or scripts in project-managed tablet payloads, services or tests |
| Host-only exceptions | Unavoidable upstream build tools require a documented, pinned exception and must not enter target payloads |
| Source history | Full reachable history of selected refs; no shallow/partial archive presented as complete |
| Archive backup | Git bundles with actual offline restore checks; LFS and submodules tracked separately |
| Firmware profiles | Separate China and Global fastboot baselines plus the Turkey recovery OTA; never mix modules, DTs or calibration |
| Boot profiles | Android with Fedora dual boot, or Fedora as the single user OS; preserve firmware and recovery in both |
| Publication | Human-written English; privacy review before every push or artifact upload |
| COPR | `mcc45tr/uke-linux-test`, Fedora Rawhide AArch64; production channel follows physical acceptance |
| Hardware claims | Own-device tests only; third-party reports remain separate |

## 2. Workspace and ownership

The root repository coordinates the four component repositories. They are pinned as Git submodules so a workspace revision identifies the corresponding component revisions. Each component can be cloned and reviewed independently. The kernel repository currently contains preparation records; its future upstream development checkout belongs in `src/upstream/`, with the resulting commit and exported patches recorded in its manifest.

```text
uke-linux/
├── PLAN.md
├── DEVICE-STATUS.md
├── AGENTS.md
├── manifests/                 # workspace catalog, evidence and publication records
├── docs/                      # shared architecture, testing and privacy contracts
├── scripts/                   # host-only Bash orchestration
├── tests/                     # host-only contract and negative tests
├── reports/                   # public summaries; private/ is ignored
├── recovery-uke-ofox/         # OrangeFox device adaptation and management tools
├── senemos-uke-kernel/        # senemos-uke-kernel-mainline source and patch workflow
├── uke-fedora-builder/        # RPM, rootfs, initramfs and image production
└── uke-project-aloha/         # Uke UEFI platform and Android return path
```

Each component uses the same directory contract:

| Directory | Responsibility |
|---|---|
| `src/` | Project code; ignored `src/upstream/` for large active upstream checkouts |
| `configs/` | Reviewed build and runtime configuration |
| `patches/` | Ordered patches with upstream origin and author/license attribution |
| `scripts/` | Component-specific host automation; target scripts require explicit classification |
| `tests/` | Host tests, fixtures and physical test definitions |
| `docs/` | Component architecture, research and operator documentation |
| `manifests/` | Build, firmware and artifact identities owned by the component |
| `referances/` | Unmodified reference clones, raw inputs and `bundles/`; ignored except its README |
| `build/` | Disposable build products and temporary restore tests |
| `artifacts/` | Identified local release candidates; published only through an explicit artifact selection |
| `reports/` | Reviewed results; `private/` contains unredacted local logs and stays ignored |

A reference has one owner. Cross-component consumers use the catalog and its exact commit rather than silently copying an independent version. Recovery owns Nabu/OrangeFox/device-product and Android image tools; the kernel owns OEM/ACK/mainline and hardware donors; Aloha owns firmware donors; Fedora owns rootfs/packaging references. The intentionally retained spelling is `referances`.

| Local path | GitHub repository |
|---|---|
| `.` | [MCC45TR/uke-linux](https://github.com/MCC45TR/uke-linux) |
| `recovery-uke-ofox` | [MCC45TR/orangefox_device_xiaomi_uke](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) |
| `senemos-uke-kernel` | [MCC45TR/senemos-uke-kernel-mainline](https://github.com/MCC45TR/senemos-uke-kernel-mainline) |
| `uke-fedora-builder` | [MCC45TR/uke-fedora-builder](https://github.com/MCC45TR/uke-fedora-builder) |
| `uke-project-aloha` | [MCC45TR/uke-project-aloha](https://github.com/MCC45TR/uke-project-aloha) |

## 3. Research findings that shape the implementation

### Recovery and source versions

The pinned official OrangeFox core identifies itself as R12.0 in `orangefox.mk`, on `fox_16.0`. The wiki changelog still described R11.3 during research. Preserve that distinction; source version, published release and a successful Uke build are different facts. The original manifest included a Mondrian/SM84xx device target; the resolved 399-project Uke build tree excludes that example and stages project-owned Uke configuration. See [the recovery audit](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/main/docs/UKE-SOURCE-AUDIT.md).

The Thanick50 Uke recovery is useful but reports broken F2FS data formatting. Its flags include a claimed 100 MiB recovery partition, header v4 and exclusion of the kernel from the recovery image. Verify these against stock images. `FIXED_DECRYPT`, spoofed future security patch levels, missing-dependency allowances, a shared Adreno735 identifier and a fixed thermal zone are not proof of correctness. Recovery settings must not occupy a calibration partition.

The Nabu reference spans six branches and 686 relevant UI action records. It contains hard-coded Nabu UFS offsets, GPT backups, whole-LUN USB export, side effects when sourcing common scripts and security-related prebuilts. Preserve the user-facing capabilities, but implement Uke discovery and validation from Uke evidence. Do not run those scripts against a tablet.

### Hardware and donors

The target is SM7675, not the Pad 5 SM8150 or Pad 7 Pro platform. Shared `sm8635`, `pineapple` and `Cliffs` names can be legitimate OEM dependencies. They are not sufficient evidence that another board's pins, firmware or timings apply.

[DEVICE-STATUS.md](DEVICE-STATUS.md) tracks 143 capabilities with separate recovery, UEFI and Linux outcomes. Candidate parts include CSOT/TM dual-DSI panels, two KTZ8866 backlight controllers, Novatek NT36532 touch, Nanosic 803 keyboard transport, WCN6750 connectivity, FS16xx amplifier candidates, LSM6DSO/QMI8658 IMUs, QMC6308, SIP1328, STK3BCX and SX937X sensor candidates. A filename is not proof that a part is installed on every SKU. SAR/grip must not be mislabeled as display proximity. Front-camera identity remains unresolved.

The ztsubaki Uke Linux donor provides a Linux 6.12 port with reported framebuffer-console and torch results. Its USB source work still lacks physical enumeration/transfer/reconnect acceptance. Its 74-file change needs subsystem decomposition before forward-porting. Nearby SM8650 TB520FU and SM8550 Tab S9 projects can inform driver/API work, but their hardware results do not transfer to Uke. The inspected TB520FU repository is a small patch/script reference with a missing advertised config, not a complete kernel tree. Peridot multiboot is an Android GKI/boot reference, not proof of a working Uke mainline port.

The inspected Project Aloha platform tree has no Uke/SM7675 target. It requires a real platform port, including memory ownership, GOP, storage and Linux handoff. Renaming a nearby-device binary is not acceptable. More detail is in [DONORS.md](docs/research/DONORS.md).

### Firmware baselines

| Profile | Version | Acquisition state |
|---|---|---|
| CN | `OS3.0.302.0.WOZCNXM` | Download, SHA-256, bounded extraction, boot headers/layout and base DTBs inspected |
| Global | `OS3.0.303.0.WOZMIXM` | Download, SHA-256, bounded extraction, boot headers/layout and base DTBs inspected; experimental recovery build profile |
| Turkey OTA | `OS3.0.303.0.WOZTRXM` | Download and metadata hash verified; partition extraction/signature validation pending |

Exact URLs are recorded in `recovery-uke-ofox/manifests/firmware.lock.json`. CDN ETags are not content SHA-256 values. Keep raw packages and every derived image tied to the package hash and extraction command. Do not run included flash scripts. Extract boot/init_boot/vendor_boot/recovery/dtbo/vbmeta, partition metadata, module lists/vermagic, DTB/DTBO variants, firmware names and HAL/service relationships. Record unavailable fields explicitly.

## 4. The 100-step implementation sequence

Each row has a stable ID, a priority, dependencies and a concrete completion test. “Ready” means work may start after its dependencies; it does not claim completion. Preparation results below describe the delivered architecture and records only. Steps involving a physical unit stay pending until hardware is available. Independent source and host work may continue around those gates.

Priority meanings: **P0** establishes identity, recoverability or basic operation; **P1** enables the usable console/tablet; **P2** completes hardware and optimization; **P3** expands optional platforms and publication maturity. Test classes U0–U3 and H0–H3 are defined in section 8.

### A. Workspace, sources and evidence

| Step | Priority | Depends on | Work and completion evidence | State |
|---|---|---|---|---|
| 001 | P0 | — | Fix Uke identity, product names, first distribution and recovery-first scope in this plan. | Prepared |
| 002 | P0 | 001 | Apply English contribution, C++/Bash and no-tablet-Python rules to all project repositories. | Prepared |
| 003 | P0 | 001 | Create four component directories with explicit source, archive, build and publication boundaries. | Prepared |
| 004 | P0 | 002,003 | Establish ignored private areas, no-reply commit identity and a pre-publication privacy check. | Prepared |
| 005 | P0 | 004 | Create the five GitHub repositories and pin component commits from the workspace. | Prepared |
| 006 | P0 | 001,004 | Create `uke-linux-test` for Rawhide AArch64 with no automatic unvalidated package publication. | Prepared |
| 007 | P0 | 003 | Define source, firmware, toolchain, hardware evidence and artifact identity contracts. | Prepared |
| 008 | P0 | 007 | Catalog canonical upstream/OEM/ACK/community references with full commit pins and ownership. | Prepared |
| 009 | P0 | 008 | Clone selected preparation refs with full reachable history and preserve their archive refs. | 50 repositories acquired |
| 010 | P0 | 009 | Resolve each nested submodule and LFS object at its pinned identity; record licenses and missing dependencies. | Open; three source archives have pending submodules |
| 011 | P0 | 009 | Verify Git objects and restore self-contained bundles offline; compare commit and tree identities. | 50 Git restores passed; dependency completion is separate |
| 012 | P0 | 009 | Inventory all Nabu branches, UI actions and tools into a minimum feature parity matrix. | 34 feature groups recorded |
| 013 | P0 | 008,012 | Create the variant-aware hardware ledger without promoting third-party or untested results. | 143 capabilities recorded |
| 014 | P0 | 004,007,011,013 | Test negative evidence/archive/privacy cases and publish reviewed preparation records. | Preparation acceptance gate |

### B. Stock analysis and reproducible recovery

| Step | Priority | Depends on | Work and completion evidence | State |
|---|---|---|---|---|
| 015 | P0 | 007,014 | Download China and Global fastboot baselines plus the Turkey recovery OTA separately; verify length and compute full SHA-256. | All three packages verified |
| 016 | P0 | 015 | Extract stock images with bounded, traversal-safe tools; preserve raw packages and extraction provenance. | 38 bounded entries extracted per profile |
| 017 | P0 | 016 | Map recovery/boot/vendor_boot/init_boot, headers, slots, AVB, dynamic partitions and image limits. | Global and CN mapped; Turkey metadata only |
| 018 | P0 | 016,017 | Define immutable firmware/SKU profiles and reject mixed DT, modules, keys or payload identities. | Global/CN locked separately; Global installer enforces boot-stack hashes |
| 019 | P0 | 016,018 | Identify panel, touch, audio and sensor variants through DTS, modules, firmware and stock configs. | Four base DTBs decoded per region; installed DTBO/SKU and module ABI review open |
| 020 | P0 | 017,018 | Reproduce the donor F2FS formatting problem on synthetic images; identify incompatible flags/tool versions. | Pending U1 |
| 021 | P0 | 008,010,017 | Resolve the complete OrangeFox Android 16 manifest, replace Mondrian selection and archive every required revision. | 399 projects synced and locked; per-project offline archives pending |
| 022 | P0 | 021 | Pin host container, compiler, packages and unavoidable upstream host-only tools; produce a dependency SBOM. | Pending |
| 023 | P0 | 017,018,021 | Build a clean Uke device configuration with matching kernel/module ABI and auditable partition definitions. | Global configuration staged; module ABI review open |
| 024 | P0 | 023 | Compile OrangeFox without masking missing dependencies; save full build logs and source/config identities. | Neutral-path new-output and incremental builds passed; static native installer built; pristine re-sync open |
| 025 | P0 | 024 | Unpack the result; validate headers, section sizes, module architecture, payload paths and absence of Python. | Staged and extracted ramdisk/privacy/Python/ZIP/header checks passed; runtime module dependency open |
| 026 | P0 | 025 | Repeat the build from pinned offline inputs and explain every output difference. | Pending U2 |
| 027 | P0 | 013,017 | Create C++ read-only device inventory with explicit model, LUN, GUID, slot and snapshot state. | PARTUUID inventory and installer slot/snapshot policy fixtures pass; full live inventory pending |
| 028 | P0 | 027 | Define a typed management API separating discovery, plan validation and execution; make failures visible to the UI. | Native mount planning and check/install policy implemented; complete UI/API pending |
| 029 | P0 | 028 | Implement backup manifests, hashes, free-space checks and dry-run restore validation on synthetic disks. | Pending U1 |
| 030 | P0 | 020,028,029 | Implement GPT/filesystem planning with overflow, overlap, unknown-layout and interruption tests. | Pending U1 |
| 031 | P1 | 025,028 | Add management settings and screens: identity, diagnostics, backup, profile, image selection and explicit operation plan. | Pending U0/U1 |
| 032 | P1 | 031 | Integrate all four rotations, matching touch transforms, brightness and English/Turkish UI layout checks. | Pending U1/H1 |
| 033 | P0 | 017,025,028 | Configure ADB, sideload, MTP and fastbootd with clear ownership and firmware-dependent data visibility. | Pending U0/H1 |
| 034 | P1 | 028,033 | Implement selected-image mass storage, default read-only export and local/host write exclusion. | Pending U1/H1 |
| 035 | P1 | 029,030 | Add Fedora rootfs/ESP installation and controlled chroot management with cleanup and rollback records. | Pending U1 |
| 036 | P1 | 017,028,029 | Add OTA payload extraction, dynamic-partition inspection and snapshot-merge conflict rejection. | Installer rejects non-none/unknown snapshot state; Turkey metadata hash verified; extractor pending |
| 037 | P0 | 018,025 | Audit Android FBE/KeyMint/TEE compatibility; keep decryption unavailable until the installed firmware trust path is proven. | Pending U0/H1 |
| 038 | P1 | 028,031 | Implement private raw logs, bounded collection and redacted export with user-visible operation results. | Pending U1 |
| 039 | P1 | 012,034,035,036 | Reconcile every Nabu feature group; document implemented, blocked and conditional features individually. | Pending |
| 040 | P3 | 030,039 | Define disabled NTFS/WIM/Windows and second-Android interfaces and fixture tests; enable them only after the later platform/isolation gate 056 passes. | Pending |
| 041 | P0 | 025,029,038 | Conduct H0 inventory and stock-return rehearsal on the exact device without starting destructive tests. | Device required |
| 042 | P0 | 026,041 | Perform the first controlled recovery boot; capture display, keys, touch, USB and thermal observations. | Device required H1 |
| 043 | P0 | 032,033,037,042 | Validate recovery essentials, USB transfers, reconnect and the actual FBE support state. | Device required H1 |
| 044 | P0 | 029,030,043 | Validate backup/restore on a designated test area, including failure recovery; sign off the recovery gate. | Device required H2 |

### C. Project Aloha and boot profiles

| Step | Priority | Depends on | Work and completion evidence | State |
|---|---|---|---|---|
| 045 | P0 | 010,017,026 | Pin Aloha and all submodules; compare SM7675 requirements with the closest platform implementations. | Pending |
| 046 | P0 | 018,019,045 | Document memory reservations, clocks, interrupt state, MMU/cache state and retained firmware ownership. | Pending |
| 047 | P0 | 022,046 | Create a minimal Uke platform target and compile its initialization path without invented peripheral support. | Pending U0 |
| 048 | P0 | 047 | Implement early diagnostics and a conservative console path with crash/timeout information. | Pending U0/H1 |
| 049 | P1 | 019,046,048 | Implement GOP with profile-matched framebuffer ownership, stride, format and reservations. | Pending |
| 050 | P1 | 019,048 | Implement required UEFI key/touch input with correct orientation and bounded timeouts. | Pending |
| 051 | P0 | 046,048 | Establish UFS Block I/O read-only operation and exact partition identities before write support. | Pending |
| 052 | P0 | 049,051 | Validate ExitBootServices, DT handoff and ARM64 Linux entry requirements; prepare EFI-stub diagnostics. | Pending U2/H1 |
| 053 | P0 | 041,048 | Implement and verify return to Android and recovery without replacing XBL, ABL or trusted firmware. | Device required H1 |
| 054 | P0 | 030,035,052,053 | Define Android+Fedora dual boot with independent rootfs, explicit boot selection and shared-storage constraints. | Pending |
| 055 | P1 | 030,052,053 | Define Fedora single-user-OS mode while retaining required firmware, recovery and stock restoration material. | Pending |
| 056 | P0 | 044,054,055 | Exercise normal, failed, interrupted and fallback boot paths; sign off the firmware/profile gate. | Device required H2 |

### D. Mainline kernel foundation

| Step | Priority | Depends on | Work and completion evidence | State |
|---|---|---|---|---|
| 057 | P0 | 008,010,014 | Acquire the remaining OEM, ACK, OnePlus, Lineage, stable and Qualcomm full-history source sets. | Pending |
| 058 | P0 | 057 | Analyze dependencies and semantic differences; distinguish Android product trees, prebuilts, firmware and source drivers. | Pending |
| 059 | P0 | 022,057 | Lock a kernel toolchain and compile untouched Linux 7.2.8 for ARM64 before adding port changes. | U0 passed: Image, 1,847 DTBs, 1,655 modules and local module staging; no Uke DTB |
| 060 | P0 | 010,018,058 | Reproduce the donor's pinned Linux 6.12 tree, configuration and local artifacts; report its tests separately. | Pending U0/U2 |
| 061 | P0 | 059,060 | Create `senemos7/uke-7.2.8-bringup` from the fixed baseline; record its commit in the component manifest. | Pending |
| 062 | P0 | 058,060,061 | Split the donor into attributed binding, TLMM, clock, power, interconnect, SMMU and USB patch groups. | Pending |
| 063 | P0 | 019,062 | Port identities, bindings and TLMM while preserving secure GPIO reservations; run binding/compile checks. | Pending U0 |
| 064 | P0 | 063 | Port GCC/TCSRCC and test handoff references, deferred parents and repeated probe behavior. | Pending U0/U1 |
| 065 | P0 | 064 | Port RPMh, regulators and GDSC; test votes, failures and resources that cannot safely power down. | Pending U0/U1 |
| 066 | P0 | 065 | Port the required USB interconnect graph, node/BCM mapping and missing-provider behavior. | Pending U0/U1 |
| 067 | P0 | 066 | Port narrowly scoped SMMU handoff; reject unsupported stream IDs and protect inherited mappings. | Pending U0/U1 |
| 068 | P0 | 065,067 | Port eUSB2 PHY/repeater and WCD939x routing with explicit reset and power sequencing. | Pending U0/U1 |
| 069 | P0 | 068 | Port DWC3/gadget changes and test cleanup, retries and module load/unload behavior. | Pending U0/U1 |
| 070 | P0 | 018,063,069 | Build stock DTB+DTBO transition profiles; merge each allowed base and validate fixups, providers and memory. | Pending U0/U2 |
| 071 | P1 | 019,063,065 | Start independent mainline SoC/board DTS; reuse suitable upstream definitions and keep unverified nodes disabled. | Pending U0 |
| 072 | P0 | 064,070 | Configure profile-specific simplefb/fbcon with reserved memory and single-driver ownership. | Pending U0/H1 |
| 073 | P0 | 061,069,071 | Create debug, Rawhide and test fragments using ARM64 4 KiB pages and explicit built-in/module choices. | Pending U0 |
| 074 | P0 | 067,069,073 | Test generic clock/SMMU/DWC3 changes with target and non-target configs and meaningful failure-path tests. | Pending U0/U1 |
| 075 | P0 | 070,072,073 | Build a minimal diagnostic initramfs with no Python and no automatic internal-storage mounts. | Pending U0/U2 |
| 076 | P0 | 017,018,074,075 | Produce local Android boot candidates; unpack and verify header, size, hashes, DT and module identity. | Pending U2 |
| 077 | P0 | 043,052,076 | Test mainline console, USB enumeration/data/reconnect and read-only UFS, recording each result separately. | Device required H1 |

### E. Fedora packages and reproducible rootfs

| Step | Priority | Depends on | Work and completion evidence | State |
|---|---|---|---|---|
| 078 | P1 | 002,022 | Resolve a console-only Rawhide AArch64 package set; reject target Python and retain repository metadata/RPMs. | Pending U0/U2 |
| 079 | P1 | 018,058,078 | Map firmware licenses, board data and driver loading; separate private calibration from redistributable packages. | Pending |
| 080 | P1 | 073,078 | Define core/modules/devel RPMs for `senemos-uke-kernel-mainline`, with one build identity and unique ABI namespace. | Pending U0 |
| 081 | P1 | 074,080 | Validate Image/config/DT/modules and vermagic; enforce strip → sign → compress for modules. | Pending U2 |
| 082 | P1 | 078,079,081 | Build a console rootfs archive with systemd, SELinux, networking and native diagnostics; inspect every target payload. | Pending U2 |
| 083 | P1 | 052,075,082 | Integrate the validated rootfs with selected boot profiles; keep large userspace outside small boot partitions. | Pending U2 |
| 084 | P1 | 082 | Solve RPM dependencies in isolated AArch64 userspace and run selected programs under QEMU; label emulation limits. | Pending U2 |
| 085 | P1 | 081,082,084 | Rebuild offline from locked inputs; compare package/rootfs outputs and document nondeterministic files. | Pending U2 |
| 086 | P0 | 006,085 | Submit a reviewed SRPM to COPR; require terminal build success, downloaded signatures, payload checks and solver validation. | Pending |
| 087 | P0 | 056,077,083,086 | Boot Fedora console on hardware and demonstrate updates plus rollback without changing unselected OS data. | Device required H2 |

### F. Full hardware, performance and release

| Step | Priority | Depends on | Work and completion evidence | State |
|---|---|---|---|---|
| 088 | P1 | 019,071,077 | Complete native panel/DSI/DSC/backlight and touch; test all modes, rotations, edges, stylus basics and display recovery. | Pending U0/H1/H3 |
| 089 | P2 | 019,067,079,088 | Integrate Adreno732 DRM/firmware/Mesa; test GL/Vulkan, faults, IOMMU isolation, devfreq and video workloads. | Pending U0/H3 |
| 090 | P2 | 019,065,079,087 | Bring up WCN6750 Wi-Fi/BT, regulatory handling, coexistence, reconnect and power saving. | Pending H1/H3 |
| 091 | P2 | 019,065,079,087 | Establish DSP health, speaker protection, microphone routing and UCM/PipeWire before full-power audio tests. | Pending H1/H3 |
| 092 | P2 | 019,065,091 | Identify actual sensors and implement raw channels, units, timestamps, mounting matrices, fusion and desktop policy. | Pending H1/H3 |
| 093 | P2 | 065,088,090,091,092 | Validate charging, thermal policy, idle and suspend; run at least 100 resume cycles and investigate every failed peripheral. | Pending H3 |
| 094 | P3 | 019,088,093 | Complete keyboard, touchpad, pen pairing/charging/buttons/pressure and lid behavior across detach and resume. | Pending H3 |
| 095 | P3 | 019,067,079,093 | Develop camera/ISP/libcamera and hardware video encode/decode with calibration and license boundaries. | Pending H1/H3 |
| 096 | P2 | 087,089,093,094 | Measure boot p50/p95, UI latency, throughput, thermals and energy against stock/previous builds; set evidence-based budgets. | Pending H3 |
| 097 | P0 | 038,074,084,093,096 | Perform threat-driven code review and soak/fault tests; resolve all unexplained warnings, crashes and stability regressions. | Pending U1/H3 |
| 098 | P1 | 085,086,087,097 | Prepare signed candidates, source/patch/SBOM/license records and tested install/rollback documentation for each accepted SKU. | Pending |
| 099 | P1 | 098 | Promote tested releases from `uke-linux-test` to a separately reviewed `uke-linux` channel; retain prior working candidates. | Pending |
| 100 | P1 | 099 | Maintain upstream/CVE/Rawhide watch, gated update branches, regression baselines and reproducible archive refreshes. | Ongoing after release |

## 5. Source archive and provenance contract

`sources.yaml` uses the JSON subset of YAML 1.2. Each entry records its owner, purpose, canonical URL, checkout ref, full SHA and selected history scope. `sources.lock.json` records what was actually acquired: commit/tree pairs, time, object checks, license paths, dependencies, bundle checksum and restore result. These documents must not silently advance when a branch changes.

The host Bash manager provides `validate`, `sync`, `verify`, `bundle`, `restore-check`, `archive` and `report`. An unknown ID, invalid path, changed pin, unavailable commit, edited reference, shallow clone, wrong checksum or failed restore is an error. Failed work remains visibly incomplete. The tools do not execute upstream scripts. Sync does not touch component development checkouts.

A complete archive requires full selected history, no missing objects, pinned nested submodules, required LFS objects, a self-contained bundle, a successful empty-directory offline restore and identical commits/trees. The present 50 cataloged Git archives include three with separately unarchived submodule dependencies; their dependency completeness remains false. File-level license review is still open. Bundles on the same disk provide restore material, not an independent physical backup.

Start with at most two large downloads, one large extraction/build at a time, and an 80 GiB free-space reserve. Maintain a disk budget before Android sync, ROM extraction and kernel builds. Prefer selected refs over every unrelated branch. Report excluded refs explicitly rather than using shallow history to fit a budget.

Use merge-base-aware comparisons. Without a meaningful common ancestor, combine patch-ID, file-tree, symbol/API and behavior analysis; a three-dot diff alone is misleading. Keep source drivers distinct from `.ko` prebuilts, HALs, firmware, product trees and physical logs. Preserve authorship and licenses when exporting donor changes.

## 6. Recovery management architecture

The recovery manager has three separate operations: read-only discovery, deterministic plan construction and explicit execution. New native logic is C++. Shell glue must not mutate storage merely by being sourced. UI controls show the detected model, firmware profile, target, planned changes, backup identity and current result. Unknown layouts disable dependent operations with a useful explanation.

Settings cover diagnostics verbosity and retention, display rotation, input calibration, backup destinations, selected boot profile, candidate image selection and rollback. Settings use a dedicated project location after filesystem validation; they must not reuse `persist` or other calibration storage. First defaults must preserve installed Android data and firmware.

Every storage plan includes device/LUN identity, sector size, GUIDs, old/new ranges, expected free space, filesystem features, affected slots, snapshot merge state, backup hashes and interruption recovery. Immediately before execution, discovery must still match the plan. Post-operation verification reads back metadata and content checksums. Synthetic fixtures cover overflow, truncated media, unknown layouts, failed writes, stale plans and power-loss boundaries before H2 tests.

The feature parity matrix retains all donor capabilities: normal install/backup, terminal, file manager, rotations, language selection, brightness, ADB/sideload/MTP/fastbootd, log export, decryption diagnostics, partition health/planning, Linux/ESP format, chroot, stock restore, GPT backup/repair, AVB inspection, mass storage, NTFS/WIM tools, panel identification, UEFI selection, second Android, OTA extraction and reproducible builds. Conditional features remain visible as planned or unavailable until dependencies pass. Do not substitute a menu entry for a working implementation.

### 6.1 URE implementation milestones

The [detailed roadmap](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/COMPREHENSIVE-ROADMAP.md#91-recommended-implementation-roadmap)
owns feature design; this table owns scheduling and acceptance dependencies.
The existing 001–100 steps continue to track the wider platform. URE host work
may proceed alongside them; device write and supported-release gates still
require the exact physical recovery/return path. Existing installer and
read-only fixture evidence is a baseline, not completion of the new phases.
The recovery [native checkpoint](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/URE-NATIVE.md)
now records a library/JSON API, live read-only selection, GPT image
backup/repair/restore, OS discovery, diagnostics, regular-file transactions,
inspected journals, storage usage/mapper policy, identity-bound storage stream
software, host reception, host-assisted raw-image restore and native GUI pages.
The host-assisted path keeps bounded verified pairs locally and avoids complete
image scans per ordinary chunk while retaining initial/reconnect/final scans.
Live-source capture requires
complete unit/boot/usage evidence and a retained read-only kernel claim; positive
device acceptance, atomic snapshots and cross-boot continuation remain open.
These are partial implementations;
the complete milestones and physical gates below remain open.

The 1 October scope expansion also requires a comprehensive partition manager
and restoration of the device's default partition layout. The recovery
[partition-manager contract](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/PARTITION-MANAGER.md)
records discovery, capacity-derived layouts, filesystem/migration operations,
multi-LUN journals, preview/recovery UI and exact stock-return requirements.
Stock reconstruction must use Uke's verified GPT/patch inputs and actual LUN
capacity; open-ended userdata must not inherit a guessed SKU size. Bounded I/O,
memory and cache use apply across the expanded scope. The native stock engine
now reconstructs all six LUNs at selected capacity, preserves verified original
GUIDs and provides reviewed per-image metadata execution/readback/rollback.
Host tests compare it with the exact OEM XML patches at two capacities per LUN.
The complete manager, filesystem/data migration, multi-LUN orchestration and
physical stock-layout restoration remain unfinished. Source updates pass their
validation and privacy gates before publication; VM evidence is recorded against
the corresponding source and binary identities.

The additional Linux backup requirement is mandatory: whole Linux partition
content, a selected home tree with numeric ownership, permissions, ACLs,
accessible xattrs, links, sparse files and timestamps, and Btrfs subvolume
full/incremental send streams. Source consistency, parent identity, private
external destinations, verification and isolated restore must be explicit.
Existing raw chunked backup remains the partition-byte foundation. The native
directory engine now provides Linux/home tree plans, sparse data, paged metadata,
hardlinks/symlinks, xattrs/ACLs, file-boundary capture resume, independent backup
verification and isolated restore to a new directory. Its CLI and GUI share the
engine; snapshot consistency, physical acceptance, in-place recovery and direct
host tree streaming remain open. Btrfs snapshot/send/receive workflows and
stock-profile Btrfs kernel support remain separate work. The
[tree backup contract](recovery-uke-ofox/docs/TREE-BACKUP.md) records the boundary.
The [tree backup checkpoint](recovery-uke-ofox/reports/URE-TREE-BACKUP-BUILD.md)
records the local image, exact hashes and source/host/emulation evidence.
The tablet GUI additionally requires adjustable uniform interface density,
full-screen anchors and matching touch rectangles, a visible percentage and
reset, private settings on validated storage, and separate rendering/touch
acceptance. The native 50–100 percent implementation uses a 75 percent tablet
default and a render-thread reload that performs no settings flush or mount.
Read-only native partition maps now expose protected reservations, bounded
offset signature probes and healthy-GPT-only free gaps; label hints do not
authorize OS management or Android FBE access.

The partition layout designer now allocates ESP, Linux and Windows only inside
the original userdata extent. GUI and CLI share exact GB/GiB/MiB/percentage
arithmetic, filesystem selections, proportional graphs, warnings and sealed
review. Standard mode preserves userdata start and existing identities.
Advanced mode permits explicit GUID/content requests; placement before userdata
requires erase/recreate and declares Android data loss. Unselected GPT records
and every non-userdata partition range remain unchanged. Image metadata
execution/readback/rollback is available; supported filesystem shrink/recreate,
formatting, multi-LUN orchestration and model-specific physical acceptance are
still required before a complete device job. See the
[layout checkpoint](recovery-uke-ofox/reports/URE-PARTITION-LAYOUT-BUILD.md).

USB-C display and input expand the recovery UI scope: one HDMI/DP monitor,
selectable EDID-backed resolution/refresh through 2560x1440 at nominal 75 Hz,
visible active mode, enable/disable, aspect-preserving mirroring and USB HID
mouse/keyboard hotplug. The native DRM sink and reviewed input hooks have host
fixtures; the Juo JH925 hub and a QHD75 monitor are the intended physical test
setup. Compile/host evidence remains separate from tablet scanout, Type-C/PD,
module loading and simultaneous USB input acceptance. Source publication retains
these explicit physical acceptance boundaries.
The local artifact and validation scope are recorded in the
[external display checkpoint](recovery-uke-ofox/reports/URE-EXTERNAL-DISPLAY-BUILD.md).

The 3 October boot manager adds registered EFI target/default inventory, exact
loader/context binding, owned private-fixture requests, single consumption and
correlated fixture receipts. Its GUI reviews requests and inspects interrupted
history before any recovery action. A retired request ID cannot be reused through
a different journal. Missing `BootNext` and interrupted consumption are recorded
as unknown observations, not boot failures. The
[boot-routing contract](recovery-uke-ofox/docs/BOOT-ROUTING.md) and
[dated engineering lessons](docs/lessons/2026-10-03-RECOVERY-BOOT-ROUTER.md)
preserve the failed replay/retirement trials and corrections. Real firmware
variable writes, EFI execution, OS acknowledgement trust, default bootability,
Uke/Aloha routing and physical dual/single boot acceptance remain open. Full
current-source build/package verification is tracked independently.

Priorities here follow the recovery matrix: P0 identity/recoverability, P1 core
rescue, P2 conditional multi-OS management, P3 optional extensions. They express
recovery value separately from the wider platform priorities in section 4.
Recovery owns these phases; kernel, Aloha and Fedora dependencies are explicit.

| ID / roadmap phase | Priority | Dependencies / platform steps | Deliverable and acceptance | Current state |
|---|---|---|---|---|
| URE-00 / 0 | P0 | 015–043 | Preserve the native active-slot installer, read-only identity checks and stock firmware; accept recovery boot and stock return on each model/profile at H0/H1. | Existing source/host/package baseline; physical gate blocked by device absence |
| URE-01 / 1 | P0 | URE-00 safety contracts; 029 | Extract `libuke-recovery`, structured errors/results, versioned JSON and Storage Graph; retain CLI behavior and reject ambiguous identities at U0/U1. | PARTIAL source/host: shared API, graph and read-only block selector; full live identity/ownership closure and HIL open |
| URE-02 / 2 | P0 | URE-01; 027,030 | Add R000–R100 stages, pstore preservation where available, kernel/module/display/touch/USB/UFS diagnostics and scrubbed reports; U0/U1 redaction and H1 correlation. | PARTIAL source/host: bounded diagnostic reads and scrubbed reports; R-stage producers and HIL correlation open |
| URE-03 / 3 | P0 | URE-01; 031,032,038 | Implement serialized plans, stale-state revalidation, backup manifests, durable journals, readback and rollback; U1 partial-write/power-loss cases must distinguish safe and uncertain failure. | PARTIAL source/host: file, GPT and raw-image plans, journals and rollback; verified readback and partial raw-write continuation; general live writes and electrical power-loss acceptance open |
| URE-04 / 4 | P0 | URE-01,URE-03; 033 | Inspect/compare both GPT copies and filesystem metadata; back up GPT and slot boot chains with geometry, firmware and hashes; reject wrong-LUN/size backups at U1. | PARTIAL source/host: GPT metadata backup/verification and image repair/restore; multi-LUN/slot boot-chain orchestration and live acceptance open |
| URE-05 / 5 | P1 | URE-01,URE-03,URE-04; 029,033 | Discover Linux distributions, package databases, kernels/initramfs/modules/DT/BLS/UKI; add metadata-aware files, atomic editor, controlled chroot, offline logs and Fedora rescue; U1/U2 before H1/H2. | PARTIAL source/host: bounded discovery, file metadata and native editor; semantic repair/chroot and HIL open |
| URE-06 / 6 | P1 | URE-00 profile contracts,URE-04; kernel 018,058,073 | Build and probe a profile-matched recovery kernel for Btrfs, dm-crypt/crypto, NTFS and optional pstore; validate drivers on disposable images at U1/U2 before H1. | PLANNED; stock-profile Btrfs mounting remains BLOCKED |
| URE-07 / 7 | P1/P2 | URE-03,URE-06 | Add LUKS unlock/lock/metadata/header backups, then conditional BITLK activation; no secrets in argv/logs/reports, U1 wrong-key/layering tests, H1/H2 access gates. | PLANNED; Android FBE uses a separate trust gate |
| URE-08 / 8 | P1 | URE-03,URE-05,URE-06; URE-07 for encrypted roots | Manage Btrfs subvolumes/snapshots, file restore, scrub, filtered balance and send/receive; test rollback plans at U1 and require URE-09 plus H2 for one-shot snapshot boot. | BLOCKED by current kernel; userspace design PLANNED |
| URE-09 / 9 | P1/P2 | URE-03,URE-05; Aloha 044–056 for EFI routes | Discover targets and validate consumed one-shot Android/Linux/Windows requests, fallback and history; U1 invalid/version/replay cases, U2 where possible, H2 actual routing. | PARTIAL source/host: registered EFI inventory, native GUI review, consumed private-fixture requests, retirement/replay refusal, interrupted history and fallback decisions; real Uke/Aloha routing and HIL open, Windows also URE-12 |
| URE-10 / 10 | P1/P2 | URE-01,URE-02; 027,030,042 | Add USB networking, opt-in key-authenticated SSH and separately packaged SFTP/SCP; verified host fingerprint, gadget ownership and reconnect/chunked backup tests at U1/U2/H1/H3. | PARTIAL source/host: chunked transfer/receiver and optimized host-assisted image restore/rollback with duplex transport mocks, packaged key-only Dropbear; managed service/SFTP/gadget ownership and HIL open; Wi-Fi is URE-14 |
| URE-11 / 11 | P1 | URE-03,URE-04; 036,037 | Extend A/B, Virtual A/B, super and OTA inspection; writes reject active/unknown merges; FBE stays blocked until installed Uke KeyMint/TEE trust and credential/read-only tests. | Advanced management PLANNED; FBE BLOCKED |
| URE-12 / 12 | P2 | URE-03,URE-04,URE-06; URE-07 for BitLocker | Add Windows detection, NTFS, WIM/ESD, ESP/BCD inspection and backup; U1 metadata/archive/target tests, isolated restore at H2; advanced BCD editing is P3. | PARTIAL source/host: installation indicators and read-only NTFS/WIM wrappers; managed restore/BCD/ESP work and Uke Windows acceptance open |
| URE-13 / 13 | P2 | URE-03,URE-04 and accepted backup/restore; URE-05,URE-11,URE-12 for affected OSes; 034,039,043 | Implement the comprehensive partition manager, stock/default reconstruction and Android/Fedora/Windows/custom layouts from measured capacity; bounded migration/filesystem operations, multi-LUN journals, full preview/recovery UI, U1 interruption tests and exact human-reviewed H2 plans. | PARTIAL source/host: six-LUN stock reconstruction, original-userdata-only size/filesystem planner, graph/review GUI, advanced GUID/content requests, front erase/recreate policy and per-image metadata execution/readback/rollback; complete filesystem/migration job, multi-LUN orchestration and model-specific physical stock return remain open |
| URE-14 / 14 | P2 | URE-10; kernel/firmware 079,090 | Add profile-matched WLAN, regulatory policy, network UI, secret handling and SSH over Wi-Fi; U2 config tests and H1/H3 reconnect/transfer acceptance. | PLANNED |
| URE-15 / 15 | P0/P1 | Relevant URE phases; 038,097,098 | Complete parser fuzzing, long-operation fault/cancel tests, privacy/payload closure, independent reproduction, signing, SBOM/licenses and per-SKU acceptance. | PLANNED; existing alpha checks cover only their recorded scope |

### 6.2 Shared URE contracts

`libuke-recovery` owns identity, the Storage Graph, plans, transactions,
filesystems, crypto, OS managers, boot targets, networking and reports.
`uke-recoveryctl`, the installer and OrangeFox adapters share that engine. The
expanded command tree and JSON examples are proposed APIs; preserve documented
current commands during migration. Discovery does not replay journals, unlock
crypto, change slots/EFI variables or mount writable as a side effect.

Transactions follow discover → identify → diagnose → plan → back up →
revalidate → execute → read back → commit → record recovery path. Journal
intent and verified boundaries durably. An uncertain partial write is
`FAILED_UNCERTAIN`, never “nothing changed”; interrupted transactions are
inspected before any safe resume or rollback. Check capacity, power/temperature,
snapshot merges, active mounts/mappers, target identity and source hashes again
immediately before execution. Long operations declare cancel-safe,
cancel-at-boundary or not-cancellable behavior and safe cleanup before reboot.

Linux rescue includes distribution/package detection, a kernel/initramfs/module/
DT/boot-entry consistency matrix, offline logs, chroot and an atomic GUI editor
that preserves ownership, modes, ACLs, xattrs, SELinux contexts and capabilities.
Chroot repair tools and their dependency closure must satisfy the tablet Python
prohibition. LUKS/BITLK secrets use bounded secret buffers and fd/API input;
Android FBE requires its installed-firmware trust path independently. Btrfs
snapshots do not replace external backups; expert repair is a separate gated
plan. NTFS preliminary repair is not Windows `chkdsk`, and WIM deployment must
validate metadata preservation and handle ESP/BCD as separate phases.

Direct OS reboot means no interactive boot menu, using a proven stock/EFI/Aloha
backend. Prefer a consumed one-shot request with exact target IDs, validated
root/kernel/initramfs/DT/ESP or Windows loader/BCD, and a preserved default and
Android/recovery fallback. A recovery re-entry is an observation, not proof of
boot failure; correlate an acknowledgment or crash evidence. Shared ESP changes
preserve every OS's files and unknown applications. Firmware and calibration
remain protected in every layout.

Public and engineering UI profiles show detected systems, locked/unlocked
volumes, explicit change/risk summaries and actionable missing dependencies.
USB export and local storage have exclusive ownership; remote access is visible.
SSH starts disabled, uses explicit public-key import and a displayed host-key
fingerprint, and keeps keys session-scoped unless persistence is chosen. USB
networking precedes Wi-Fi; SFTP needs its own reviewed server/helper closure.
Diagnostic stages, monotonic timelines, pstore and test annotations produce
scrubbed reports without credentials, keys, private content or calibration.

Recovery self-tests, known-good profiles, external USB/host backups, bounded
search/diff, time/power/thermal diagnostics and session cleanup are covered by
[URE-C01–URE-C24](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/docs/FEATURE-PARITY.md#ure-capability-extension).
QR sessions, a permissioned extension model, forensic tools, remote UI and
broader distro/filesystem modules remain optional P3 work. Do not reduce boot
health to an invented percentage.

Track PLANNED, SOURCE PRESENT, BUILT, HOST TESTED, EMULATION TESTED, DEVICE
READ-ONLY TESTED, DEVICE WRITE TESTED, SUPPORTED and BLOCKED by evidence
dimension. A blocker may coexist with a passing build; support requires the
feature's exact SKU/firmware/device gate. The physical hardware ledger retains
its existing result vocabulary and evidence rules.

## 7. Boot, kernel and package contracts

### Source intake checkpoint: Xiaomi Uke organization, 4 October 2026

Six additional donor repositories are pinned, cloned under their component-owned
`referances/donors/` directories and verified through Git integrity and offline
bundle restoration. The two vendor archives additionally include five verified
historical LFS objects. The [source audit](docs/research/XIAOMI-UKE-DONOR-AUDIT.md),
[inventory](docs/research/XIAOMI-UKE-INVENTORY.json) and
[engineering lessons](docs/lessons/DONOR-INDEX.md) define their reuse boundaries.

Continue source implementation work in this order:

1. Compare donor storage/header declarations with independent firmware-profile
   evidence; conflicting super sizes must not reach write plans.
2. Compare the potentially modified community DTBO to its exact stock origin
   before selecting any board/panel transition profile.
3. Map the recovery touch module, THP HAL and uinput readiness chain to project
   source; review ABI, missing-file closure and observable failure behavior.
4. Review native pen/power protocol sources for C++ implementation with bounded
   discovery and explicit error/cleanup paths; omit destructive input-node glue.
5. Match panel/sensor/audio/camera alternatives to Uke OEM and installed-profile
   evidence, retaining Muyu import provenance and private-calibration boundaries.
6. Select firmware only after native driver requirements and file-level licenses
   are established; then rerun relevant source/build/package/VM gates.

This checkpoint completes donor acquisition and static analysis only. It creates
no new recovery payload, mainline driver, VM result, physical acceptance record
or Uke UEFI implementation. Earlier roadmap gates retain their independent scope.

### Expanded source intake: thirteen requested URLs, 4 October 2026

The additional Resources, Delano, Perry, Vember, ztsubaki, btidor and Stampy
sources are locally cloned under their owning components. Seven new catalog
entries and six reused sources bring the catalog to 66 entries. All thirteen
parent Git bundles passed offline restoration; twelve archives meet their
recorded dependency gates. The direct `uke-linux` donor retains nineteen open
gitlinks, mapped to exact commits in the
[dependency map](docs/research/UKE-LINUX-DEPENDENCY-MAP.json).

The [expanded audit](docs/research/UKE-EXPANDED-DONOR-AUDIT.md) and
[lessons](docs/lessons/2026-10-04-UKE-EXPANDED-DONORS.md) add these prerequisites
to the existing ordered roadmap without promoting any build or hardware gate:

1. Close the v6.12 donor's exact dependency graph before reproduction; matching
   catalog pins alone do not close parent dependencies.
2. Resolve prebuilt header/DT layout and stock-profile provenance before using
   any recovery/kernel binary as a development input.
3. Review touch and pen startup/protocol paths using project-native contracts;
   retain separate ABI, permission, error-path and HIL acceptance.
4. Translate Android power/display/charging policy requirements only after
   native interface semantics are known, then measure performance and energy.
5. Develop ARM64/Fedora boot packaging independently of the generic x86-64
   `ukefi` scripts; they supply no Uke-specific Project Aloha platform.
6. Build clean rootfs artifacts from locked inputs. A README describing a
   private-state desktop image supplies neither source closure nor a safe
   distribution payload. Keep foreign signing templates outside project trust.

Mirror identity, Android product claims and third-party desktop descriptions
remain source evidence. This intake runs no donor code and changes no tablet
Python, storage-write, firmware-preservation or publication privacy policy.

Dual boot means Android and Fedora have defined boot routes and independently managed OS data. A/B slots are update slots and do not isolate shared userdata. Single boot means Fedora is the only user OS; it does not mean deleting XBL/ABL/TEE or required firmware. Windows/second-Android workflows are additional conditional features, not initial OS support claims. The actual installation mechanism depends on real bootloader behavior: do not assume `fastboot boot` can temporarily replace boot, init_boot and dtbo together.

The kernel has an unchanged-baseline build, a donor-reproduction build and a forward-port build. Keep those results separate. Android 6.1 vendor modules cannot be loaded into mainline 7.2 as a portability shortcut. Kernel patch commits and exported patches must reproduce the same tree. Record `SOURCE_DATE_EPOCH`, toolchain/container digests, config SHA-256 and final kernel commit.

The stock-DT transition profile and standalone mainline DTS have different validation contracts. Merge each permitted base DTB with its matched overlay; validate fixups, phandles, providers and reserved memory. Independently develop `sm7675.dtsi` and `sm7675-xiaomi-uke.dts` only if upstream does not already have a suitable definition. Unknown hardware stays disabled. Simplefb is an early console, not DRM/GPU/suspend acceptance; framebuffer addresses must be firmware-profile inputs.

Fedora begins with a console rootfs, not GNOME or Plasma. Pin repository metadata, retain exact RPM NEVRAs and packages, and solve a target package set without Python. Standard package groups may pull Python transitively; inspect the full closure and choose native alternatives or defer incompatible features. Upstream Python tooling needed on the build host must never leak into the tablet rootfs, recovery or initramfs. A host exception does not override the tablet prohibition.

RPMs use `senemos-uke-kernel-mainline` with core/modules/devel subpackages. Image, DT, config and modules must come from one build; strip, sign, then compress modules. Installation scripts do not write Android partitions or silently replace the chosen boot profile. Source/SRPM success, remote COPR completion, downloaded payload validation, AArch64 package solving and physical boot are independent gates.

## 8. Human and unattended testing

| Class | Where | Permitted work | Required evidence |
|---|---|---|---|
| U0 | Unattended host/CI | Source validation, compile, bindings, configs, payload and privacy checks | Exact source/toolchain, command, exit status and log |
| U1 | Unattended disposable fixtures | GPT/filesystem planning, parsers, corruption, interrupted-operation simulation, negative tests | Fixture identity, expected result and cleanup verification |
| U2 | Unattended containers/QEMU | AArch64 userspace, RPM solving, image round trips and reproducibility | Package closure, artifact hashes and emulator limitations |
| U3 | Previously accepted device fixture | Bounded read-only telemetry and repeatable non-destructive regression runs | Known device/build/profile, stop conditions and operator recovery route |
| H0 | Human with device | SKU inventory, bootloader/slot inspection, stock backups and return-path rehearsal | Physical identity and verified recovery material |
| H1 | Human observed | First boot, display/touch/USB, temperatures, charging and basic peripherals | Timestamped host/device logs and observations |
| H2 | Human controlled | Partition/format/restore, boot switching, rollback and update recovery | Reviewed exact plan, backup/readback checks and interruption behavior |
| H3 | Human plus bounded automation | Battery, thermal, suspend, long workloads, perceptual audio/display/input quality | Controlled conditions, metrics, raw logs and anomalies |

No unattended test changes partition layout, formats userdata, disables trust controls or flashes early firmware. U3 starts only after the exact fixture's recovery path has passed H0/H1. Device absence blocks physical acceptance; it does not block host builds or evidence preparation. Synthetic success is never labeled physical success.

Every test record contains a test ID, environment, build ID, source/config hashes, firmware profile, SKU/accessory identities, UTC and monotonic time, command/workload, expected/observed results, exit status, evidence locations and privacy classification. Hardware status changes require this record. Track source-found, archive-complete, reviewed, built, static-check, emulation, third-party and own-device results independently.

## 9. Security, privacy and observability

Privacy review applies to files, history, author metadata, screenshots, logs, workflow artifacts, releases and COPR metadata. Exclude credentials, signing keys, Android keys, unit serials, addresses, Wi-Fi details, calibration, private mount paths and raw user data. Public manifests use workspace-relative paths. Use GitHub no-reply commit identity. A clean current tree does not prove clean history; inspect the exact publication range. Automated pattern checks are a guardrail, not a completed security audit.

Retain SELinux enforcement as the Fedora target, review recovery policy, use least-privilege services and make debug exceptions explicit and temporary. Require image identity and integrity before use. Do not equate an unlocked bootloader or matching KMI with a trusted Android decryption path. Never publish spoofed security patch dates as actual security state. Review parser bounds, archive traversal, device selection, race conditions, stale plans, command execution and image signing boundaries in the implementation.

Collect recovery operations, kernel/dmesg, pstore, systemd journal, remoteproc, GPU/DRM, USB, UFS, power and sensor events on one correlated timeline. Preserve raw sensor channels, units, sequence numbers, timestamps, sample rates and saturation flags. Capture suspend transitions and simultaneous DSP/GPU/display faults before guessing causes. A diagnosis report separates observation, hypothesis, supporting evidence, competing explanations and the next discriminating test.

Use bounded ring buffers, configurable retention, rate limits and an incident mode so extensive diagnostics do not become a battery or storage problem. Keep unredacted logs private and export a scrubbed report with a reproducible collection recipe. Never hide faults by lowering the log level. The release target is zero unexplained errors/warnings; each known external/benign message needs an owner, justification, expiry and regression test. An exception does not count as a fixed defect.

## 10. Performance, stability and update policy

Measure bootloader, kernel, initramfs, system services and desktop readiness separately. Use p50/p95 across repeat boots with controlled firmware, temperature, battery charge, package set and storage state. A numerical boot-time target is set after the first baseline; no invented “fast enough” result is accepted. Keep optimization changes attributable and reversible.

Measure idle drain, suspend drain, video/web/stylus energy, frame timing, input latency, network throughput and sustained thermal behavior against stock and the previous accepted build under matching conditions. Do not disable protections or overclock to manufacture a score. Recovery and debug logging have separate energy budgets from production. Remove bring-up clock/power overrides before normal battery acceptance.

Use at least 100 controlled suspend/resume cycles after core peripherals work, repeated cold/warm boots, USB reconnect cycles, low-battery behavior and 24–72 hour workload soaks. Any crash, corrupted frame, stuck sensor stream, audio DSP failure, filesystem error or unexplained warning is investigated with correlated logs. Report failures by subsystem and build; do not average them away.

“Always current” means continuously evaluating upstream stable/security updates, Qualcomm changes, OrangeFox, Aloha, firmware advisories, Mesa and Rawhide. It does not mean silently advancing a pin or installing an untested rolling build. Update candidates use dedicated branches, source/license/privacy checks, host regression and relevant hardware gates. Retain a known-good kernel/system, rollback metadata and archived prior inputs. Configure monitoring only as a separate explicit operational task; this plan does not claim a running update service.

## 11. Stage acceptance and remaining boundaries

| Gate | Required output | Does not establish |
|---|---|---|
| Preparation | Architecture, English plan, source catalog/archive evidence, hardware/feature ledger, repositories and test channel | A buildable or bootable tablet image |
| Recovery source | Complete pinned manifest, build toolchain, device configuration and clean repeated build | Decryption, storage safety or device boot |
| Recovery device | H0/H1 essentials and H2 backup/restore acceptance | UEFI or mainline support |
| Aloha | Uke platform, boot contracts, Android return and accepted profiles | Full Linux peripheral support |
| Kernel source | Baseline/donor/port builds, patch identity, DT and failure-path tests | Physical boot or battery quality |
| Fedora package | SRPM/RPM/rootfs, payload/solver/reproducibility checks and terminal COPR success | Uke hardware acceptance |
| Tablet acceptance | Variant-specific hardware, stability, performance, energy and rollback evidence | Untested SKU/accessory compatibility |
| Release | Signed artifacts, licenses/SBOM, source reproduction and verified installation instructions | Future rolling updates passing automatically |

If a gate fails, retain the last successful inputs, classify the failure, publish the reproduction command and continue independent work. Do not overwrite failed evidence with a generic success summary. No hardware support claim or production promotion occurs solely because a repository, package channel, compile or CI check exists.

The public alpha report records passing staged payload privacy checks. Immediate
work is independent reproduction from a pristine pinned checkout, vendor-boot/
module and package-closure audits, and remaining regional boot-profile analysis.
URE-01/02 source and host work can extend the existing safe baseline while
physical recovery and stock-return acceptance wait for a device. Aloha platform
work follows that recovery foundation; direct Linux/Windows boot requests need
its proven handoff and fallback.
