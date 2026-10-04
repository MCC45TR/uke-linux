# Source selection and nearby-device donors

The canonical workspace catalog records exact pins and component ownership. Local archives are references, not automatically trusted build inputs. URLs below identify upstream projects; claims are limited to inspected revisions.

| Source | Why it helps | Limitations |
|---|---|---|
| [ztsubaki/uke-linux](https://github.com/ztsubaki/uke-linux) | Direct SM7675/Uke Linux 6.12 platform and USB work | Third-party console/torch reports; USB acceptance open; 19 nested submodules pending |
| [MiCode kernel/devicetree](https://github.com/MiCode/kernel_devicetree/tree/uke-v-oss) | Board wiring and stock driver relationships | Shared SoC names and alternative components need profile-specific interpretation |
| [LineageOS SM8635](https://github.com/LineageOS/android_kernel_xiaomi_sm8635) | Kernel/modules/DT cross-comparison | Android compatibility is not native mainline support |
| [Uke-resources](https://github.com/Uke-resources) | Current Android product and proprietary-file inventory | Prebuilts and HALs are not rebuildable Linux drivers |
| [xiaomi-uke](https://github.com/xiaomi-uke) | Six pinned Android/recovery/common/vendor repositories; touch readiness, accessory source, variant inventory and binary boot dependencies | [Detailed audit](XIAOMI-UKE-DONOR-AUDIT.md); kernel is prebuilt-only, shared imports include Muyu, DTBO extraction edits timings, and permissive/security/storage defaults require independent review |
| [OnePlusOSS](https://github.com/OnePlusOSS) | SM7675 kernel/common/modules second-OEM comparison | Board pins, panel, power and firmware differ |
| [nfe613920-cmyk/tb520fu-linux-kernel](https://github.com/nfe613920-cmyk/tb520fu-linux-kernel) | SM8650 tablet mainline patch/API reference | Three-file patch/script repository; advertised config missing; not a complete tree |
| [TB520FU documentation](https://github.com/nfe613920-cmyk/tb520fu-mainline-docs) | Same project's platform notes | Same author/source is not independent corroboration |
| [Tab S9 Ultra Linux](https://github.com/agcarbajo/postmarketos-galaxy-tab-s9-ultra) | SM8550 display/GPU/audio/resume integration | Different panel, Goodix input and WCN7850; microSD layout does not apply to Uke |
| [Peridot multiboot](https://github.com/dimivelev/peridot-multiboot) | SM8635 GKI boot/preinit/kexec comparison | Experimental workflow; do not execute flashing scripts |
| [Project Aloha](https://github.com/Project-Aloha/mu_aloha_platforms) | UEFI platform framework and Android return patterns | No Uke target in inspected platform tree; 10 submodules pending |
| [DualBootKernelPatcher](https://github.com/Project-Aloha/DualBootKernelPatcher) | Boot integration research | Not evidence of a working Uke boot route |
| [pmaports](https://gitlab.postmarketos.org/postmarketOS/pmaports) | Packaging and device bring-up conventions | Research donor; Fedora packaging and target dependencies are evaluated separately |
| [Google Novatek touch](https://android.googlesource.com/kernel/google-modules/touch/novatek_touch) | Protocol and driver implementation reference | Compare IC, firmware and bus protocol before reuse |
| [MCC45TR/nabu-linux-kernel](https://github.com/MCC45TR/nabu-linux-kernel) | Build, packaging and evidence workflow lessons | SM8150 hardware definitions are not Uke definitions |

Upstream stable, Torvalds and Qualcomm trees are separate references. Xiaomi's nine OEM repositories, Android common/manifest, and OnePlus kernel/common/modules must be evaluated as related source sets. As of 4 October 2026, the catalog includes 59 sources. The six newly added `xiaomi-uke-*` sources have complete local Git/LFS archives and offline restore receipts; other acquisition states remain individually recorded in the [archive report](../../reports/source-archive.md). The earlier 45-source/29-preparation count was a historical checkpoint, not the current inventory.

See the [donor lesson index](../lessons/DONOR-INDEX.md) for findings that affect source reuse. Read-only archive completion does not establish build, VM or hardware acceptance.

A kernel-named repository may contain only prebuilts. Inspect files, build entrypoints and licenses before calling it rebuildable. Distinguish firmware, calibration, Android services, kernel modules, source drivers and physical evidence. Do not count mirrors of the same commit as independent results.
