# Additional Uke donors: source, archive and reuse review

Reviewed on 4 October 2026. All 13 requested repository URLs have local,
component-owned Git clones. Seven are new catalog entries; six were already
present and were reverified without changing their pins. Selected branches have
full reachable history, not shallow clones. Git object checks and network-free
bundle restores passed for every parent repository. Twelve archives satisfy
their recorded Git/LFS/submodule checks; `uke-linux` still has 19 unresolved
parent dependency links.

This review covers committed source, configuration, binary metadata and local
archives. No donor script, recovery service, installer or flashing command was
executed. No donor image was deployed. Source acquisition does not add a kernel
build, recovery build, VM result or physical capability result.

The [machine-readable inventory](UKE-EXPANDED-DONOR-INVENTORY.json) records full
commit/tree IDs, selected-tree statistics, Python paths, module groups, license
paths and archive receipts. The [catalog](../../manifests/sources.yaml) preserves
every selected ref; the [archive lock](../../manifests/sources.lock.json) and
[archive report](../../reports/source-archive.md) remain the acquisition authority.
The earlier [Xiaomi Uke audit](XIAOMI-UKE-DONOR-AUDIT.md) remains a dated record of
the six organization sources and their binary/input/security findings.
The [validation receipt](../../reports/UKE-EXPANDED-DONOR-VALIDATION.md) records
archive checks, repeatable audits and host tests with their explicit limits.

## 1. Repository placement and classification

Paths below are relative to the workspace root. Reference worktrees and bundles
are excluded from public project payloads. A complete reference archive is not
a redistribution license or a complete Android build dependency set.

| Requested repository | Catalog ID | Local path | Selected commit | Actual material |
|---|---|---|---|---|
| [Resources Uke device](https://github.com/Xiaomi-Pad-7-Pro-Resources/android_device_xiaomi_uke) | `lineage-uke-device` | `recovery-uke-ofox/referances/community/lineage-uke-device` | `6aa70ea5d603b16187dd46cb701f4d91e8fce8f9` | Android product, overlays, extraction declarations; reused |
| [Resources Uke vendor](https://github.com/Xiaomi-Pad-7-Pro-Resources/android_vendor_xiaomi_uke) | `lineage-uke-vendor` | `recovery-uke-ofox/referances/community/lineage-uke-vendor` | `3f3cfe588cbdbfede71cd3e142314d2c1ca81900` | Proprietary Android dependencies and firmware inventory; reused |
| [Resources common device](https://github.com/Xiaomi-Pad-7-Pro-Resources/android_device_xiaomi_sm8635-common) | `lineage-common-device` | `recovery-uke-ofox/referances/community/lineage-common-device` | `f477733d60197b312ab2ed42f6b75dfade54ada2` | Shared Android configuration, pen/power source and Muyu-derived imports; reused |
| [Resources Uke kernel](https://github.com/Xiaomi-Pad-7-Pro-Resources/android_device_xiaomi_uke-kernel) | `resources-uke-kernel-prebuilts` | `senemos-uke-kernel/referances/donors/resources-uke-kernel-prebuilts` | `446629e5d30c76848bfde9e3a67bcf6386ac24fa` | Kernel/DT/module prebuilts and exported headers; new |
| [Resources common vendor](https://github.com/Xiaomi-Pad-7-Pro-Resources/android_vendor_xiaomi_sm8635-common) | `lineage-common-vendor` | `recovery-uke-ofox/referances/community/lineage-common-vendor` | `bf664e7ef94d4530ec0d2f7f4e3945fbe3ac10b5` | Shared proprietary dependencies; reused |
| [Delano Uke device](https://github.com/delano-git/android_device_xiaomi_uke) | `delano-uke-device` | `recovery-uke-ofox/referances/donors/delano-uke-device` | `78812b13d6a04596ed6157668c5d160ee4ca29db` | Android product revisions, Dolby copies and kernel-manager policy; new |
| [Perry Uke device](https://github.com/PerryOnUke/android_device_xiaomi_uke) | `perry-uke-device` | `recovery-uke-ofox/referances/donors/perry-uke-device` | `5c9266c11812c7f64484c2cb76350338c2d3355b` | Android product, Power HAL boost tables and external setup graph; new |
| [Delano Uke recovery](https://github.com/delano-git/android_device_xiaomi_uke-recovery) | `delano-uke-recovery` | `recovery-uke-ofox/referances/donors/delano-uke-recovery` | `d037467a1643d64979337ad79267c8b8f2e4ca17` | Same recovery tree as the Xiaomi Uke mirror; new canonical clone |
| [Xiaomi Uke recovery](https://github.com/xiaomi-uke/android_device_xiaomi_uke-recovery) | `xiaomi-uke-recovery` | `recovery-uke-ofox/referances/donors/xiaomi-uke-recovery` | `d037467a1643d64979337ad79267c8b8f2e4ca17` | Android recovery configuration and opaque prebuilts; reused |
| [Vember Uke kernel](https://github.com/vember31/android_device_xiaomi_uke-kernel) | `vember-uke-kernel-prebuilts` | `senemos-uke-kernel/referances/donors/vember-uke-kernel-prebuilts` | `9bb7c4331be7205fabf5427b5654555763304d20` | Alternate Android kernel/DT/module prebuilts, missing external headers; new |
| [ztsubaki Uke Linux](https://github.com/ztsubaki/uke-linux) | `uke-linux` | `senemos-uke-kernel/referances/community/uke-linux` | `32cad9ccd383ff4b37d8a5e7f88a8bfdcc07307e` | Mainline 6.12 patch, native early userspace and source analysis; reused |
| [btidor ukefi](https://github.com/btidor/ukefi) | `btidor-ukefi` | `uke-project-aloha/referances/donors/btidor-ukefi` | `6a7daff10b4d48aba4d213cc11e1bd434effec77` | Generic x86-64 Unified Kernel EFI tooling; new |
| [Stampy Linux UKE](https://github.com/StampyCat889/Linux-UKE) | `stampy-linux-uke` | `uke-fedora-builder/referances/donors/stampy-linux-uke` | `3eb6ec4437eea0f53b6d23b74bd612e66806a1c8` | One README describing a Debian/GNOME experiment; new |

The default checkout ref is `lineage-23.2` for Android product/vendor/kernel
sources, `twrp-14.1` for both recovery sources, `master` for `uke-linux`, and
`main` for `ukefi` and `Linux-UKE`. Additional archived comparison refs are:

| Source | Ref | Commit | Purpose |
|---|---|---|---|
| Delano device | `main` | `fef1dbfb013afdca915e93126a73335a46a15c76` | Older product/profile comparison |
| Delano device | `test-16` | `0988518a766a9edddd3b18811a2f8e736f0b5edb` | Experimental product/profile comparison |
| Vember kernel | `lunaris-16.2` | `d448f7961cbf979b0eedf801ba61a5836583b131` | Different Image/module/profile revision |

These refs are retained separately. No script silently replaces a lock with a
new branch tip or selects an experimental ref for development.

## 2. Archive results and dependency boundaries

The seven new sources passed `git fsck`, bundle checksum verification and
restoration into empty directories with network access disabled. The six
existing sources passed fresh verification and restoration as well. No new LFS
or submodule requirement was detected in the seven new selected-history sets.
Existing vendor LFS receipts remain separate and were revalidated.

`uke-linux` has a valid parent bundle, but the parent contains 19 gitlinks.
The [dependency map](UKE-LINUX-DEPENDENCY-MAP.json) records their canonical URLs,
exact commits and matches against the workspace catalog. Fourteen gitlink pins
already occur in other catalog entries; five do not. Matching a pin does not
hydrate a submodule or verify the parent build closure, so the archive manager
correctly leaves `archive_complete` false.

The five unmatched gitlinks are BusyBox, Muyu device, Peridot device, Xiaomi
Android hardware and the historical Codelinaro kernel manifest. The `linux`
gitlink is upstream v6.12 at `adc218676eef25575469234709c2d87185ca223a`; it is
not the project's Linux 7.2.8 delivery baseline. The historical Android manifest
is not promoted to a current Uke OEM build manifest.

The current catalog has 66 entries. This count measures source selection,
not 66 complete dependency graphs or validated device features. Archives are
retained on the same disk; no independent/off-site backup is claimed.

## 3. Mirrors, shared ancestry and import profiles

Both recovery URLs resolve to the same commit and tree:
`3102ff0207e5c93f64078c22167eb50e8a83c723`. The Resources kernel source and the
earlier `xiaomi-uke` kernel mirror also have the same selected commit and tree:
`b14cabda429a72abca902b2a0b236ae519cf12ff`. Their separate canonical clones
preserve provenance; they are not independent recovery or hardware evidence.

The older Resources Uke product header identifies Global
OS3.0.8.0.WOZMIXM. Its common device proprietary-file header identifies Pad 7 Pro
OS3.0.7.0.WOYMIXM. The earlier Xiaomi Uke organization audit instead records
newer OS3.0.301 imports. These are distinct reference profiles, not conflicting
claims about one installed tablet. Common source history also explicitly names
a graphics update from `OPD2403_16.0.3.501` in commit `c6dc428`; that commit
subject is provenance evidence, not proof that every imported blob is Uke stock.

The Resources common tree contains native `xiaomi-pen.cpp` and `power-mode.cpp`
alongside Android/Kotlin integration. It is useful for protocol comparison.
Android property services, framework overlays, HAL APIs and OEM sysfs controls
need independent native Linux contracts before reuse. Panel, pen, sensor,
thermal and audio alternatives still require board/profile matching.

Proprietary vendor inventory is useful for firmware names, sensor alternatives,
service dependencies and module relationships. It does not license copied
firmware or turn Android HAL binaries into Fedora drivers. No calibration
contents, device identifiers, private keys or original author identities are
copied into this report.

## 4. Delano product: current changes and limits

The selected Delano product contains 21 tracked files. Compared with the
Resources Uke product pin, eight files change with 102 insertions and seven
deletions. Relevant additions are:

- Global OS3.0.303.0.WOZMIXM extraction headers and build description.
- Device-specific Dolby DAX configuration copies from proprietary vendor paths.
- `configs/ax_kernel_manager.xml`, selecting CPU policies 0, 3 and 7 and
  Qualcomm KGSL controls/frequency values.
- Wi-Fi-only tablet telephony/voice/SMS declarations and framework overlays.
- Advertised 60/90/120/144 Hz, HBM and charging toggles in the Android product.

`HBM_NODE` refers to `/data/vendor/display/hbm_mode`, and the purported bypass
toggle refers to `/sys/class/xm_power/charger/smart_charge/smart_night`.
The macro name does not establish real bypass charging; the path requires
driver semantics, installed-profile evidence and controlled measurements.
Likewise, a refresh-rate list is not a validated panel mode set, and KGSL paths
do not identify the mainline DRM/devfreq interface.

`device.mk` includes external common/vendor/prebuilt makefiles. No
`lineage.dependencies` exists in this product checkout. Successful archive
restore therefore does not establish that an Android product can be built from
this repository alone. The `main` and `test-16` refs advertise different build
descriptions; they remain separate comparison inputs.

Reuse order: extract candidate hardware-independent policy requirements,
establish matching native driver interfaces, test error and unavailable cases,
and only then benchmark performance, thermals and battery use. No frequency,
boost, HBM or charging setting was applied to a host or tablet.

## 5. Perry product: boost policy and external setup

The Perry product contains 27 tracked files. Against the same Resources base,
14 files change with 1,081 insertions and ten deletions. It adds
`power/powerhint.xml` (589 lines), `power/perfboostselection.xml` (357 lines),
desktop/freeform overlays and ROM-specific settings. Product copy declarations
place the power tables before common-product inheritance to select overrides.
These are Android Power HAL policies with Cliffs/120/144 FPS selections and
boost opcodes, not native Fedora power-management implementations.

The setup script names eight additional repositories:

| Dependency group | Declared ref | Build role |
|---|---|---|
| Five Delano device/common/kernel/vendor repositories | `lineage-23.2` | Android product dependency set |
| LineageOS Xiaomi hardware | `lineage-23.2` | Android hardware helpers |
| AxionAOSP LunarisDolby | `16.0` | Android application integration |
| External signing-key template | `master` | Build signing configuration |

The script uses `git clone --depth 1` and moving branch names. It does not pin
those dependencies. It was inspected, never executed. The requested Delano
device was independently acquired through the project archive manager; other
external declarations are recorded as dependencies, not silently adopted.
No signing-key repository, private key or foreign trust configuration was
imported. A template is not a project signing authority.

The boost tables contain no independent latency, energy or thermal validation.
For optimization, first measure idle drain, frame delivery, input latency,
thermal throttling and workload energy with conservative native defaults.
Android policy values become research candidates only after their native
consumer and units are understood.

## 6. Kernel prebuilts: same Image, different closure and DT layout

Neither the Resources nor Vember kernel-named repository contains rebuildable
kernel implementation/DTS source. Both selected default Images have SHA-256:

```text
6144d19de9c1f1915819b53fcb05424ee283a2f6b0dea725f4a05c1934974d61
```

The banner is `6.1.118-android14-11-gca0ef6d17716-ab13624819`. Each contains
788 module file instances; sampled vendor modules advertise a 6.1.68 release.
Release labels do not alone decide Android KMI compatibility, and none of these
binary modules is a mainline 7.2 driver input.

The Resources archive has 1,032 exported header-tree files and four individual
DTBs under `dtbs/`; its extraction script edits panel refresh-rate properties
before regenerating DTBO. See the earlier audit for the transformation and
artifact hashes. Vember instead contains a `kernel-headers` Git symlink to
`../../../kernel/xiaomi/sm8635-kernel-headers`. That target is absent from the
repository and unpinned. It has `dtb.img`, not the `dtbs/` layout expected by the
product makefiles. Those are concrete missing-input/layout problems.

Vember's default `dtb.img` is a 1,885,897-byte concatenation. A read-only FDT
header walk consumed four records with these offsets/sizes:

| Offset | Header total size |
|---|---|
| 0 | 475,410 |
| 475,410 | 474,859 |
| 950,269 | 467,674 |
| 1,417,943 | 467,954 |

This validates the header framing only. It does not validate board IDs, bindings,
overlay fixups, reserved memory or panel applicability.

| Vember artifact | SHA-256 |
|---|---|
| Default `dtb.img` | `d91cc75a790e958afca06256b5e1f4f5c130d5a0f3e58d0a07d033d2dc7cb6f8` |
| Default `dtbo.img` | `b339d682a36f9542b4cfd38241367ffdf280d688226ff5db87b4d509f165c50e` |
| `lunaris-16.2` Image | `97b2c53022e8c0bd0b279c4c592a196126a6eb0a93647c2957b39dcd5f2dc1c9` |

The Lunaris ref has a different Image banner,
`6.1.138-android14-11-g0c3d559bcd85-ab14529422`, and no `kernel-headers` entry.
Its advertised OS3.0.301 origin is a donor declaration, not a completed stock
package comparison. Preserve per-ref hashes and module/config/profile
relationships; do not mix them with the default branch or Resources DTBO.

## 7. Direct mainline donor and remaining reproduction work

`ztsubaki/uke-linux` supplies real port material: a Linux 6.12 patch affecting
74 kernel paths, native early userspace, DT transition inputs and detailed
platform research. The patch covers Cliffs TLMM, GCC/TCSR clocks, RPMh/regulator
handoff, USB interconnects, selected SMMU handoff streams, eUSB2/repeater,
WCD939x USB2 routing and DWC3/gadget paths, plus clock-handoff KUnit work.

The intended early scope is simplefb console, torch and USB2 peripheral
bring-up. This is not full DRM/GPU, suspend, USB3/host/PD, charging or desktop
acceptance. Donor console/torch reports remain third-party reports; this review
did not reproduce them. A gadget node does not prove host enumeration or data
transfer. Donor checkpatch/test statements are not project test results.

The transition build uses a fixed framebuffer at `0xe3940000` and debug
resource-retention settings. These require firmware/RAM/profile-specific
comparison before use. The 19-gitlink graph and host-only Python validation
helpers require explicit reproduction planning. No Python helper was executed
or admitted to a tablet payload.

Next: verify the exact dependency closure in development-owned directories,
reproduce the untouched v6.12 donor build, inspect generic clock/SMMU/USB error
paths, then forward-port focused changes to the locked 7.2.8 baseline. Keep
the unmodified baseline, donor reproduction and forward-port results separate.

## 8. ukefi is generic x86-64 tooling

At this pin, `ukefi` is a 21-file MIT-licensed project with Bash/Autotools and
Debian integration. It hardcodes
`/usr/lib/systemd/boot/efi/linuxx64.efi.stub`, adds kernel/initrd/command-line/OS
release sections with `objcopy`, and produces current/fallback EFI images.
There is no ARM64 stub selection, SM7675 platform, board DTS or EDK II Uke port.

Its installer changes EFI entries through `efibootmgr` and writes the ESP.
Debian post-install hooks configure boot entries. Signing is optional, with
unsigned fallback when inputs are absent; smart-card/signing loops can wait
without a bound. None of these scripts or hooks was run, and host firmware/boot
entries were not changed.

Useful ideas are current/fallback artifacts and explicit image sections.
Reuse would require ARM64 architecture checks, Fedora-native initramfs inputs,
content-based identity, bounded failure handling and project signing policy.
This repository does not remove the need for a Uke-specific Project Aloha
platform or validate a dual-boot route.

## 9. Linux-UKE is a documentation-only distribution claim

The selected tree contains exactly one 3,193-byte `README.md`. It describes a
Debian/GNOME experiment based on China OS3.0.302, but contains no kernel source,
build recipe, init implementation, patch series, referenced flash script,
image payload or image checksums. The inspected `v0.1-test` prerelease had no
attached assets. No license file was found in the selected tree.

The README explicitly describes retained personal state and a shared login.
Those details are not reproduced here. No userdata image or credential-bearing
payload was downloaded. Treat the project as third-party documentation and an
example of why distribution images must be built from clean, traceable inputs.
Its desktop claims are not independent proof of a reproducible port or project
hardware acceptance.

## 10. Implementation priorities and acceptance gates

| Priority | Action | Required evidence before promotion |
|---|---|---|
| P0 | Close the donor v6.12 dependency graph | Exact gitlinks, licenses, complete archives, offline closure check |
| P0 | Compare prebuilt DT/profile artifacts with stock inputs | Package digest, board/overlay mapping and transformations |
| P0 | Review recovery THP/uinput/module startup | ABI/library closure, native readiness/error handling, separate HIL |
| P1 | Extract pen/power protocol requirements | Native interface contract, permissions, unavailable/cleanup cases |
| P1 | Port mainline infrastructure in dependency order | Clean patch application, build/static checks and error-path tests |
| P1 | Prepare clean Fedora/ARM64 boot artifacts | Package closure without tablet Python, hashes, explicit boot/fallback policy |
| P2 | Evaluate performance, display and charging candidates | Native control semantics, metrics, thermal/energy limits and HIL |
| P2 | Expand Android dependency research only when needed | Independently pinned source/license review; no foreign key adoption |

For a fresh inventory of these 13 selected checkouts, run the host-only helper:

```sh
scripts/audit-xiaomi-uke.sh \
  lineage-uke-device lineage-uke-vendor lineage-common-device \
  resources-uke-kernel-prebuilts lineage-common-vendor \
  delano-uke-device perry-uke-device delano-uke-recovery \
  xiaomi-uke-recovery vember-uke-kernel-prebuilts \
  uke-linux btidor-ukefi stampy-linux-uke
```

The inventory reads committed Git objects and emits metadata only. Archive
receipts contain verification timestamps, so a later verification creates a
new receipt rather than a byte-identical historical snapshot. Keep the dated
inventory and lessons as evidence of this intake.

Run `scripts/audit-uke-linux-dependencies.sh` to regenerate the dependency map
from the parent's committed gitlinks and `.gitmodules`, comparing exact pins
to catalog/archive records without initializing or executing submodules.
