# Uke Linux for POCO Pad X1 and Xiaomi Pad 7

**Fedora Rawhide and mainline Linux for POCO Pad X1 and Xiaomi Pad 7.** Uke Linux is building a maintainable, recovery-first platform for the Snapdragon 7+ Gen 3 tablet family identified by Xiaomi sources as `uke`. The implementation covers device recovery, a Uke-specific UEFI path, mainline Linux and Fedora AArch64.

[Development plan](PLAN.md) · [Hardware status](DEVICE-STATUS.md) · [Downloads](docs/RELEASES.md) · [Test channel](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) · [Build checks](https://github.com/MCC45TR/uke-linux/actions/workflows/records.yml)

## The platform

| Project | Purpose |
|---|---|
| [OrangeFox Recovery for Uke](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) | Recovery, diagnostics, backup and installation management |
| [Project Aloha for Uke](https://github.com/MCC45TR/uke-project-aloha) | UEFI boot, Android return and selectable Fedora boot profiles |
| [Senemos Uke kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | Mainline SM7675 support, beginning with Linux 7.2.8 |
| [Fedora builder](https://github.com/MCC45TR/uke-fedora-builder) | Rawhide AArch64 kernel RPMs, root filesystem and boot artifacts |

The target includes display, touch and pen, keyboard, connectivity, audio, sensors, cameras, graphics, power management, secure boot choices and reliable updates. [The hardware matrix](DEVICE-STATUS.md) lists each capability and its actual test state. Dual boot and Fedora as the single user OS are both planned.

The [UKE Recovery Environment roadmap](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/codex/ure-rescue-framework/docs/COMPREHENSIVE-ROADMAP.md)
extends OrangeFox with planned Linux/Windows rescue, a native transaction engine,
LUKS/BitLocker access, Btrfs management, a GUI text editor, one-shot OS boot and
USB/SSH network rescue. Its sixteen phases are linked to the existing platform
plan; these are development targets with separate host and physical gates.
The [native checkpoint](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/codex/ure-rescue-framework/docs/URE-NATIVE.md)
now includes file journals, storage usage checks, identity-bound backup streams
and GPT repair plus raw-image restoration with host fixtures; the full roadmap and live-device
acceptance remain open.

The local recovery checkpoint also adds staged filesystem-image jobs,
distribution-aware isolated chroot, installed kernel/initramfs/module/DT/UKI/BLS
auditing and native Btrfs snapshot/send/maintenance controls. Btrfs has 14
operation checks in a separate generic ARM64 VM; the preserved stock recovery
kernel still lacks Btrfs support. These changes are not yet published, and live
storage writes and both tablets' physical acceptance remain open.

## Downloads and compatibility

Download the **[experimental OrangeFox alpha](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases/tag/r12.0-uke.20260930-alpha1)**: separate temporary-boot IMG, dedicated recovery IMG and slot-safe installer ZIP, with source snapshots and SHA-256 hashes. Read the [firmware constraints and installation/rollback instructions](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/main/docs/PRE-RELEASE.md) first. **No physical-device tests; Global OS3.0.303.0.WOZMIXM only.** These unsigned development files are not a supported recovery release.

**No Uke Linux/Fedora image, UEFI image or RPM has been released.** The generic Linux 7.2.8 ARM64 baseline compiles Image, DTBs and 1,655 modules; it has no Uke DTB and is not a bootable Uke port. The COPR test channel remains reserved for reviewed development packages. A source checkout or passing CI run is not a tablet compatibility result.

The project targets **POCO Pad X1** and **Xiaomi Pad 7**. POCO Pad X1 8 GB / 512 GB is the primary physical validation target; Xiaomi Pad 7 variants share the `uke` source target but require their own compatibility evidence. Each release records its tested model, memory/storage SKU, region firmware, panel and touch variant independently. Xiaomi Pad 7 Pro (`muyu`) and Xiaomi Pad 5 (`nabu`) are not compatible targets.

Global and China fastboot baselines are preserved for platform analysis. The Turkey recovery OTA is tracked as a separate regional reference. Firmware profiles are never mixed, and no package is treated as flashable merely because it can be downloaded or unpacked.

## Source and development

Clone this workspace with its four component repositories:

```sh
git clone --recurse-submodules https://github.com/MCC45TR/uke-linux.git
```

Each component keeps source, patches, configuration, documentation and tests in its own repository. Pinned upstream references and offline archives live locally in its `referances/` directory. [The source report](reports/source-archive.md) shows what has been acquired and which dependencies are still open.

New native device tools use C++; host automation prefers Bash. Python is excluded from tablet payloads. Linux and EDK II retain their upstream-required languages. See [contributing rules](AGENTS.md), [test requirements](docs/testing/TEST-CONTRACT.md), [security reporting](SECURITY.md) and [diagnostics](docs/security/SECURITY-AND-OBSERVABILITY.md).

Uke Linux is an independent community project. OrangeFox, Xiaomi, Fedora, Qualcomm and Project Aloha retain their own trademarks and licenses. Original project documentation is MIT-licensed; imported upstream sources retain their own licenses.
