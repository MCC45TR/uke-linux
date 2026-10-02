# 2026-10-02: combined recovery partition jobs

## REC-L001: filesystem signatures do not establish Android encryption trust

- **Lesson ID:** REC-L001
- **Date:** 2026-10-02
- **Environment scope:** OrangeFox / stock; filesystem evidence also applies to Fedora and PenguenOS CLO, without implying their installed policies
- **Evidence class:** source
- **Status:** documented finding
- **Question or previous assumption:** Can an ext4/F2FS signature with no LUKS container signature authorize preserving Android userdata during shrink?
- **Finding:** No. fscrypt encrypts files inside ext4/F2FS, and inode-dependent IV policies can constrain shrinking. The recovery signature probe must distinguish the filesystem encryption feature from a block-container signature. A feature observation does not prove key availability, installed Android trust or permission to resize.
- **Evidence:** [Linux fscrypt documentation](https://docs.kernel.org/filesystems/fscrypt.html), inspected 2026-10-02, including the inode-dependent IV policy; pinned f2fs-tools `0aa5acbbb6c405a2e5cc02bca6f4eb74d146da12`, `include/f2fs_fs.h` (`feature` offset 2180 and `F2FS_FEATURE_ENCRYPT`); pinned e2fsprogs `8df6ce75f219bbc78f0a7fe546615cac3080c814`, `lib/ext2fs/ext2_fs.h` (`EXT4_FEATURE_INCOMPAT_ENCRYPT`). Implementation: [signature probe](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/storage.cpp) and [partition job](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/partition_job.cpp).
- **Practical consequence:** The preserving image job refuses unknown/encrypted userdata and fscrypt-enabled ext4/F2FS; F2FS also checks its second superblock. Advanced erase/recreate keeps explicit data-loss semantics. Live tablet writes remain blocked.
- **Remaining uncertainty:** Neither installed Android KeyMint/TEE trust nor real Pad 7 / POCO Pad X1 userdata resize behavior has been established. An encryption feature bit is a conservative blocker, not a complete inventory of encrypted inodes.
- **Next validation:** Encrypted-feature refusal and actual unencrypted ext4 file retention passed in host fixtures on 2026-10-02; establish installed firmware and key-policy evidence independently on the exact tablet. F2FS preservation and its installed Android policy still require independent acceptance.
- **Supersedes / superseded by:** No older physical result is superseded. This clarifies that `encryption: none` in a signature-only record means no recognized block-container signature.

## REC-L002: forced reboot is the owner's primary interruption scenario

- **Lesson ID:** REC-L002
- **Date:** 2026-10-02
- **Environment scope:** OrangeFox / stock storage operations
- **Evidence class:** requirements correction / source
- **Status:** corrected
- **Question or previous assumption:** Earlier roadmap and candidate reports described physical acceptance mainly in terms of electrical power loss.
- **Finding:** The owner identifies forced reboot as the primary tablet interruption scenario. Transaction intent and before/after bytes must survive reopening after that interruption. Host SIGKILL establishes process/file behavior only; it cannot establish UFS controller durability during a tablet reboot.
- **Evidence:** Owner correction in the 2026-10-02 implementation request; historical [roadmap section 7.2](../../recovery-uke-ofox/docs/COMPREHENSIVE-ROADMAP.md) and [raw restore report](../../recovery-uke-ofox/reports/URE-RESTORE-BUILD.md); [fsync(2)](https://man7.org/linux/man-pages/man2/fsync.2.html), inspected 2026-10-02, distinguishes file synchronization from directory-entry synchronization.
- **Practical consequence:** New partition-job records name `FORCED_REBOOT`; persist intent before writes, synchronize file and directory records, inspect exact current bytes and refuse unrelated divergence. Keep earlier reports unchanged as dated evidence. Plan a separate exact-device forced-reboot acceptance record rather than relabeling a host process test.
- **Remaining uncertainty:** No own-device forced reboot, persistent journal medium or real UFS flush behavior has been tested. A battery does not supply evidence about write ordering during reset.
- **Next validation:** Host SIGKILL/partial-write fixtures and a disposable ARM64 guest emergency reboot passed on 2026-10-02; exact tablet forced reboot still requires live ownership/firmware/FBE gates and verified external backups. See REC-L007 for the emulation boundary.
- **Supersedes / superseded by:** Supersedes electrical power loss as the primary requested interruption scenario in older roadmap wording; preserves all historical evidence and its limitations.

## REC-L003: partition and filesystem writes require one recovery boundary

- **Lesson ID:** REC-L003
- **Date:** 2026-10-02
- **Environment scope:** OrangeFox; disposable host images
- **Evidence class:** source / implementation
- **Status:** documented finding
- **Question or previous assumption:** Does a healthy post-change GPT establish a complete usable multiboot layout?
- **Finding:** The previous `gpt.layout` transaction changes metadata only. A usable image layout additionally needs filesystem preparation inside final partition capacities, verified original userdata, protected-range coverage and one journal covering both payload and GPT writes. Formatting a whole LUN would violate the userdata-only boundary.
- **Evidence:** [existing metadata planner](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/gpt.cpp), prior clean recovery revision `cc3e4d6`; [new combined job](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/partition_job.cpp); [staging adapter](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/filesystems.cpp); [resize2fs(8)](https://man7.org/linux/man-pages/man8/resize2fs.8.html), inspected 2026-10-02, specifies filesystem shrink before reducing the partition.
- **Practical consequence:** Keep the legacy metadata command truthful. New combined jobs prepare/check private filesystem images before any original write, authorize disjoint original-userdata/GPT ranges, apply payload before backup/primary GPT, preserve existing shared ESP bytes and inspect journals before resume/rollback. Use bounded buffers, sparse zero staging and reflinks where available; never assume those optimizations reduce the required free-space estimate.
- **Remaining uncertainty:** The combined regular-image implementation now has host and native generic-VM evidence; live device writes and recreated Android userdata boot compatibility remain unverified.
- **Next validation:** Host file retention, final-capacity checks, both sector sizes, shared ESP preservation, divergence refusal and exact full rollback passed on 2026-10-02. Validate actual installed filesystems and persistent journal media on each exact tablet independently.
- **Supersedes / superseded by:** Does not supersede the valid metadata-only tests or alter their scope; adds a separate complete-image workflow.

## REC-L004: JSON round trips must preserve numeric identity semantics

- **Lesson ID:** REC-L004
- **Date:** 2026-10-02
- **Environment scope:** OrangeFox native library / host image fixtures
- **Evidence class:** implementation / failed host test
- **Status:** corrected
- **Question or previous assumption:** Can a saved positive JSON integer be compared to an in-memory unsigned JsonCpp value using strict `Json::Value` equality?
- **Finding:** The pinned reader can represent small positive numbers as signed integers. Strict value equality can therefore reject numerically identical geometry or inode/ownership fields after reopening a journal. Initial combined-job fixtures failed safely on the journal space estimate, role geometry and target binding before the original-target application. Numeric geometry now requires an integer in range and compares its unsigned numeric value; identity fields use canonical JSON representations.
- **Evidence:** `ure-combined-partition-job-and-interruption` development trial on 2026-10-02; private failure record `reports/private/partition-job-failed-roundtrip.log`; corrected checks in [partition_job.cpp](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/partition_job.cpp). Early warning-as-error compilation also caught an invalid string/JSON comparison and misleading indentation; both were corrected without weakening compiler flags.
- **Practical consequence:** Exercise every saved plan/application/state through reopening in positive tests. Keep hashes and private-file checks; normalize numeric semantics rather than relaxing identity boundaries.
- **Remaining uncertainty:** Host combined-job, saved-plan CLI, actual GUI callback, all 18 sanitizer executables and native ARM64 reboot gates passed on 2026-10-02. No tablet result follows from those separate software stages.
- **Next validation:** Maintain exact source-input binding for later changes and obtain independent tablet acceptance; see REC-L007 for source/build/package/emulation evidence.
- **Supersedes / superseded by:** Supersedes the initial signedness-sensitive implementation only; no device result is affected.

## REC-L005: native filesystem compatibility must be tested before target writes

- **Lesson ID:** REC-L005
- **Date:** 2026-10-02
- **Environment scope:** OrangeFox ARM64 userspace; generic Linux 7.2.8 virt guest; disposable image files
- **Evidence class:** AArch64 build / failed emulation trial / correction
- **Status:** documented finding
- **Question or previous assumption:** Does a host-created ext4 fixture necessarily exercise the same features as the recovery formatter/checker?
- **Finding:** The host e2fsprogs 1.47.4 formatter enabled `orphan_file`, while pinned Android e2fsck 1.46.6 rejected `FEATURE_C12` with exit status 12. The first native combined-job VM trial stopped in filesystem staging as `FAILED_SAFE`; the original disk image SHA-256 was unchanged. The runner then exited before reaching its intended reset boundary, so that trial is a failed reboot test, not reboot acceptance.
- **Evidence:** Android e2fsprogs source `8df6ce75f219bbc78f0a7fe546615cac3080c814`, `version.h` and supported-feature masks; private `build/partition-vm/` first boot/state and independently replayed inspection copy; AArch64 e2fsck diagnostic on the extracted staged filesystem; whole original/result image SHA-256 comparison. [VM runner](../../recovery-uke-ofox/tests/check-partition-job-vm.sh) and [staging adapter](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/filesystems.cpp).
- **Practical consequence:** Keep unsupported filesystem features as a refusal before original writes. Record checker diagnostics in the private stage journal. Use an explicitly compatible ext4 fixture for the forced-reboot positive case; do not silently relabel the unsupported-feature trial as successful or disable the safety check.
- **Remaining uncertainty:** A later corrected native run passed on 2026-10-02 (REC-L007), while this failed trial remains preserved. Native tool success does not establish Uke stock-kernel or UFS controller reset durability.
- **Next validation:** Keep unsupported-feature refusal and unchanged-source checks in the successful runner; obtain exact-device forced-reboot acceptance only after the separate live gates.
- **Supersedes / superseded by:** Corrects the first VM fixture assumption; preserves the successful host filesystem/retention tests and the failed native trial as separate evidence.

## REC-L006: stock image length and partition capacity are different identities

- **Lesson ID:** REC-L006
- **Date:** 2026-10-02
- **Environment scope:** Global OS3.0.303.0 stock source / OrangeFox storage preflight
- **Evidence class:** OEM extraction / source inspection
- **Status:** documented finding; live preflight remains unaccepted
- **Question or previous assumption:** Can one size field describe both a firmware file and its destination partition while using the file SHA-256 for whole-partition verification?
- **Finding:** The verified Global `dtbo.img` has 20,971,520 bytes and SHA-256 `044aae9d9a144e9a05b91d2785a2ff4504c78caa11f8c22781839ba2f6c76490`; the pinned rawprogram allocates 25,165,824 bytes for each DTBO partition. The current `global_stock` record combines the larger capacity with the smaller file's hash, and storage preflight hashes the entire selected block object. Consequently, that source-only record cannot establish a positive whole-partition match as written. This is a conservative refusal issue, not evidence of successful stock-device validation.
- **Evidence:** Original Global extraction record, rechecked file length/SHA-256 on 2026-10-02; [stock layout](../../recovery-uke-ofox/manifests/stock-layout-global.json), [boot profile](../../recovery-uke-ofox/manifests/boot-profile-global.json), [shared stock policy](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/install_policy.h) and [storage preflight](../../recovery-uke-ofox/src/device/xiaomi/uke/recoveryctl/libuke/preflight.cpp).
- **Practical consequence:** The stock coordinator must distinguish pinned source length/hash, measured destination capacity and the reviewed write extent. Preserve and identify any unprogrammed tail independently; do not assume it is zero or weaken firmware trust to make a preflight pass. Correct the common live boot-stack policy only with an explicit source/range rule and negative fixtures.
- **Remaining uncertainty:** Exact installed-unit tail contents, AVB interpretation and firmware/model/SKU acceptance have no physical record. Early firmware and unit-bound ranges remain protected and live writes remain closed.
- **Next validation:** Implement selected payload range verification with original-byte rollback, wrong-capacity/source/tail tests and separate Pad 7 / POCO model declarations; then validate the actual installed boot stack on the exact device before opening live writes.
- **Supersedes / superseded by:** Clarifies the earlier source pin and corrects any inference that the unaccepted whole-partition preflight already proves the DTBO file/capacity pair. Historical host/build passes retain their original scope.

## REC-L007: persistent image recovery passed a native guest reset, not tablet acceptance

- **Lesson ID:** REC-L007
- **Date:** 2026-10-02
- **Environment scope:** OrangeFox Android 16 source/AArch64 build; host C++/GUI fixtures; generic Linux 7.2.8 ARM64 virt guest; local package
- **Evidence class:** source / host / sanitizer / AArch64 build / extracted package / emulation
- **Status:** validated within the listed software stages; own-device tests not run
- **Question or previous assumption:** Can one complete image journal recover both filesystem payloads and GPT after reopening on a different guest boot?
- **Finding:** Implementation `7d7c46946bfcb96174d4fe179cb4b63206761ee2` and report `36d01d0` passed 19 project policy checks, all 18 native and sanitizer executables, full host CLI gates and actual GUI callback fixtures. The published-candidate ARM64 CLI and native filesystem tools passed ten VM checks: unsupported-feature refusal without changing the source, emergency guest reboot during application, persistent ext4 journal reopening, actual-byte partial-write inspection, resume and complete original-image SHA-256 rollback. Two package runs were byte identical. The actual compressed ramdisk passed privacy/no-Python, 206-ELF dependency closure, two nested ZIP scans and extracted AArch64 fixtures.
- **Evidence:** [Build report](../../recovery-uke-ofox/reports/URE-PARTITION-JOB-BUILD.md), candidate receipts and `SHA256SUMS` under `artifacts/ure-partition-job-alpha/`; native input manifest SHA-256 `d5d981a6624fd447c0b44970ba6084529d0e2be37aa4a8490b0864b72d3898e3`; native CLI SHA-256 `c4afb2221bb7712fa450d3dafe5f47ba617ede379ffd3c4599f98f504c359226`; QEMU 11.1.2; generic kernel SHA-256 `5691fe5c19ea69328a3cf2990f2ccb05f7eac1ccb600a4c291e927c95183d8a4`.
- **Practical consequence:** Use one filesystem/GPT image recovery boundary rather than treating healthy GPT as proof of usable filesystems. Preserve the exact immutable candidate/receipts for regression comparisons. The GUI offers only inspected, target-bound recovery actions. ASan/UBSan/leak results exclude vptr instrumentation because of the pinned host runtime limitation. The upstream OrangeFox packaging `local` warning remains recorded separately from successful final payload audits.
- **Remaining uncertainty:** The generic kernel/media are not Uke stock kernel/UFS. Neither Pad 7 nor POCO Pad X1 boot, GUI rendering/touch, encrypted userdata policy, Android recreate compatibility, physical writes or forced reboot has acceptance. AVB is `NONE`, the ZIP is unsigned, and only the Global OS3.0.303.0 firmware build scope applies. Btrfs shipping support remains unavailable. GitHub publication is deferred by the owner.
- **Next validation:** Continue the ordered six-LUN stock coordinator with selected pinned payloads and separate image-length/capacity/model declarations; keep live writes closed until original-unit and installed firmware/FBE/ownership evidence plus exact-device forced reboot are accepted.
- **Supersedes / superseded by:** Adds a later successful software run after REC-L005; preserves the failed trial and all earlier metadata-only, filesystem and Btrfs checkpoint scopes. It does not supersede any physical result.
