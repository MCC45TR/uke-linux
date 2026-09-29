# Xiaomi Pad 7: recovery, firmware and Fedora development plan

Revision 3 — 29 September 2026. Target: **Xiaomi Pad 7 (`uke`, SM7675 / Cliffs)**. First distribution: **Fedora Rawhide AArch64**. Kernel product: **`senemos-uke-kernel-mainline`**. Initial kernel baseline: **Linux 7.2.8**.

This is an implementation plan and an evidence contract. Preparation is underway; no project recovery, UEFI or kernel image has been built or tested on a Pad 7. A physical device is not available. Current results are recorded in [the preparation report](reports/PREPARATION-REPORT.md) and [DEVICE-STATUS.md](DEVICE-STATUS.md).

## 1. What we are building

The first deliverable is a reproducible OrangeFox recovery for Uke with the management capabilities found in the ArKT Nabu recovery. Recovery establishes the inventory, backup, diagnostics and controlled installation foundation. Project Aloha follows, providing a Uke-specific UEFI path and return to Android. The mainline kernel and Fedora system then use these foundations.

The long-term goal is an integrated tablet: reliable boot, complete support for physically present hardware, responsive input, good battery life, bounded diagnostics and maintainable updates. “OEM quality” is an acceptance target, not a statement about today's software. Every advertised function must have a variant-specific test record.

Current preparation includes architecture, source research, selected reference clones, an archive manager, feature and hardware inventories, public project repositories and the COPR test channel. Full Android sync, firmware extraction, recovery compilation, UEFI porting, kernel compilation and image publication are subsequent implementation work. No live partitioning, flashing, Android key access or remote package build is part of this preparation delivery.

### Fixed decisions

| Area | Decision |
|---|---|
| Work order | Recovery foundations → Project Aloha → mainline integration → Fedora → full hardware acceptance |
| Recovery reference | Official OrangeFox `fox_16.0`, source release R12.0; pin the complete manifest before building |
| Feature minimum | All 34 groups in [FEATURE-PARITY.md](recovery-uke-ofox/docs/FEATURE-PARITY.md), including conditional Windows/second-Android tools |
| First recovery kernel | Firmware-matched OEM/GKI kernel and modules after stock layout analysis |
| Mainline baseline | Linux `v7.2.8`, commit `9a66fdc0d7fd55f54235524a73435af99051e46f` |
| Native project code | C++; upstream kernel/EDK II retain their required C and assembly |
| Automation | Bash first; Go where shell becomes unsuitable; no project-owned Python when alternatives exist |
| Tablet Python | No Python runtime or scripts in project-managed tablet payloads, services or tests |
| Host-only exceptions | Unavoidable upstream build tools require a documented, pinned exception and must not enter target payloads |
| Source history | Full reachable history of selected refs; no shallow/partial archive presented as complete |
| Archive backup | Git bundles with actual offline restore checks; LFS and submodules tracked separately |
| Firmware profiles | Separate CN and Global baselines; never mix their modules, DTs or calibration |
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

The pinned official OrangeFox core identifies itself as R12.0 in `orangefox.mk`, on `fox_16.0`. The wiki changelog still described R11.3 during research. Preserve that distinction; source version, published release and a successful Uke build are different facts. The official manifest includes a Mondrian/SM84xx device target that must be replaced by a researched Uke target. Cloning the manifest does not resolve or download all Android build dependencies. See [the recovery audit](recovery-uke-ofox/docs/UKE-SOURCE-AUDIT.md).

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
| CN | `OS3.0.302.0.WOZCNXM` | URL and length inspected; full download and SHA-256 pending |
| Global | `OS3.0.303.0.WOZMIXM` | URL and length inspected; full download and SHA-256 pending |

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
| 009 | P0 | 008 | Clone selected preparation refs with full reachable history and preserve their archive refs. | 29 repositories acquired |
| 010 | P0 | 009 | Resolve each nested submodule and LFS object at its pinned identity; record licenses and missing dependencies. | Open; three source archives have pending submodules |
| 011 | P0 | 009 | Verify Git objects and restore self-contained bundles offline; compare commit and tree identities. | 29 Git restores passed; dependency completion is separate |
| 012 | P0 | 009 | Inventory all Nabu branches, UI actions and tools into a minimum feature parity matrix. | 34 feature groups recorded |
| 013 | P0 | 008,012 | Create the variant-aware hardware ledger without promoting third-party or untested results. | 143 capabilities recorded |
| 014 | P0 | 004,007,011,013 | Test negative evidence/archive/privacy cases and publish reviewed preparation records. | Preparation acceptance gate |

### B. Stock analysis and reproducible recovery

| Step | Priority | Depends on | Work and completion evidence | State |
|---|---|---|---|---|
| 015 | P0 | 007,014 | Download CN and Global stock packages separately; verify length and compute full SHA-256. | Ready |
| 016 | P0 | 015 | Extract stock images with bounded, traversal-safe tools; preserve raw packages and extraction provenance. | Pending |
| 017 | P0 | 016 | Map recovery/boot/vendor_boot/init_boot, headers, slots, AVB, dynamic partitions and image limits. | Pending |
| 018 | P0 | 016,017 | Define immutable firmware/SKU profiles and reject mixed DT, modules, keys or payload identities. | Pending |
| 019 | P0 | 016,018 | Identify panel, touch, audio and sensor variants through DTS, modules, firmware and stock configs. | Pending |
| 020 | P0 | 017,018 | Reproduce the donor F2FS formatting problem on synthetic images; identify incompatible flags/tool versions. | Pending U1 |
| 021 | P0 | 008,010,017 | Resolve the complete OrangeFox Android 16 manifest, replace Mondrian selection and archive every required revision. | Pending |
| 022 | P0 | 021 | Pin host container, compiler, packages and unavoidable upstream host-only tools; produce a dependency SBOM. | Pending |
| 023 | P0 | 017,018,021 | Build a clean Uke device configuration with matching kernel/module ABI and auditable partition definitions. | Pending |
| 024 | P0 | 023 | Compile OrangeFox without masking missing dependencies; save full build logs and source/config identities. | Pending U0 |
| 025 | P0 | 024 | Unpack the result; validate headers, section sizes, module architecture, payload paths and absence of Python. | Pending U0/U2 |
| 026 | P0 | 025 | Repeat the build from pinned offline inputs and explain every output difference. | Pending U2 |
| 027 | P0 | 013,017 | Create C++ read-only device inventory with explicit model, LUN, GUID, slot and snapshot state. | Pending U1 |
| 028 | P0 | 027 | Define a typed management API separating discovery, plan validation and execution; make failures visible to the UI. | Pending U1 |
| 029 | P0 | 028 | Implement backup manifests, hashes, free-space checks and dry-run restore validation on synthetic disks. | Pending U1 |
| 030 | P0 | 020,028,029 | Implement GPT/filesystem planning with overflow, overlap, unknown-layout and interruption tests. | Pending U1 |
| 031 | P1 | 025,028 | Add management settings and screens: identity, diagnostics, backup, profile, image selection and explicit operation plan. | Pending U0/U1 |
| 032 | P1 | 031 | Integrate all four rotations, matching touch transforms, brightness and English/Turkish UI layout checks. | Pending U1/H1 |
| 033 | P0 | 017,025,028 | Configure ADB, sideload, MTP and fastbootd with clear ownership and firmware-dependent data visibility. | Pending U0/H1 |
| 034 | P1 | 028,033 | Implement selected-image mass storage, default read-only export and local/host write exclusion. | Pending U1/H1 |
| 035 | P1 | 029,030 | Add Fedora rootfs/ESP installation and controlled chroot management with cleanup and rollback records. | Pending U1 |
| 036 | P1 | 017,028,029 | Add OTA payload extraction, dynamic-partition inspection and snapshot-merge conflict rejection. | Pending U1 |
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
| 059 | P0 | 022,057 | Lock a kernel toolchain and compile untouched Linux 7.2.8 for ARM64 before adding port changes. | Pending U0 |
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

A complete archive requires full selected history, no missing objects, pinned nested submodules, required LFS objects, a self-contained bundle, a successful empty-directory offline restore and identical commits/trees. The present 29 Git archives include three with unresolved submodules; their dependency completeness remains false. File-level license review is still open. Bundles on the same disk provide restore material, not an independent physical backup.

Start with at most two large downloads, one large extraction/build at a time, and an 80 GiB free-space reserve. Maintain a disk budget before Android sync, ROM extraction and kernel builds. Prefer selected refs over every unrelated branch. Report excluded refs explicitly rather than using shallow history to fit a budget.

Use merge-base-aware comparisons. Without a meaningful common ancestor, combine patch-ID, file-tree, symbol/API and behavior analysis; a three-dot diff alone is misleading. Keep source drivers distinct from `.ko` prebuilts, HALs, firmware, product trees and physical logs. Preserve authorship and licenses when exporting donor changes.

## 6. Recovery management architecture

The recovery manager has three separate operations: read-only discovery, deterministic plan construction and explicit execution. New native logic is C++. Shell glue must not mutate storage merely by being sourced. UI controls show the detected model, firmware profile, target, planned changes, backup identity and current result. Unknown layouts disable dependent operations with a useful explanation.

Settings cover diagnostics verbosity and retention, display rotation, input calibration, backup destinations, selected boot profile, candidate image selection and rollback. Settings use a dedicated project location after filesystem validation; they must not reuse `persist` or other calibration storage. First defaults must preserve installed Android data and firmware.

Every storage plan includes device/LUN identity, sector size, GUIDs, old/new ranges, expected free space, filesystem features, affected slots, snapshot merge state, backup hashes and interruption recovery. Immediately before execution, discovery must still match the plan. Post-operation verification reads back metadata and content checksums. Synthetic fixtures cover overflow, truncated media, unknown layouts, failed writes, stale plans and power-loss boundaries before H2 tests.

The feature parity matrix retains all donor capabilities: normal install/backup, terminal, file manager, rotations, language selection, brightness, ADB/sideload/MTP/fastbootd, log export, decryption diagnostics, partition health/planning, Linux/ESP format, chroot, stock restore, GPT backup/repair, AVB inspection, mass storage, NTFS/WIM tools, panel identification, UEFI selection, second Android, OTA extraction and reproducible builds. Conditional features remain visible as planned or unavailable until dependencies pass. Do not substitute a menu entry for a working implementation.

## 7. Boot, kernel and package contracts

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

The immediate next implementation work is steps 015–026: stock profile acquisition and boot analysis, complete OrangeFox manifest resolution, a pinned host toolchain and the first locally validated recovery build. Aloha follows that recovery foundation; its physical boot gate still waits for a device.
