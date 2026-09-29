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

## Downloads and compatibility

**No Uke Linux image or RPM has been released.** A [local OrangeFox recovery build](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/main/reports/FIRST-RECOVERY-BUILD.md) exists, but it has not been boot-tested on either model and is not an installation download. The COPR test channel is reserved for reviewed development packages. Release downloads and installation instructions will appear here once builds and device tests meet their gates. A source checkout or passing CI run is not a tablet compatibility result.

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
