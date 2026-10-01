# Test and evidence contract

The test classes and the full acceptance sequence live in PLAN.md, section 8. Host tests, emulated userspace and physical tests have independent results. This project currently has no physical device or device test records.

Hardware test records require `environment`, `build_id`, `device_variant`, `firmware_profile`, `timestamp_utc` and `evidence`. The ledger references those records by ID. Working, partial and not-working results require actual physical evidence; not-tested makes no failure claim. A source or CI check cannot update a physical result.

A complete implementation test additionally records source/config hashes, command/workload, expected and observed behavior, exit code, duration, firmware/toolchain identity, UTC/monotonic times, raw logs and privacy classification. Preserve failed results and reproduction instructions. Redact public exports while retaining private originals locally.

Run current host checks from the workspace:

```sh
scripts/sources.sh validate
scripts/device-status.sh --check
bash tests/run.sh
scripts/privacy-check.sh
```

Archive verification and restore checks require the locally acquired sources. CI uses small temporary Git fixtures, including wrong-commit, dirty-tree, corrupt-bundle and historical-LFS cases. This proves manager behavior, not completeness of an unacquired upstream repository.

Future U0/U1/U2 jobs cover kernel/config/DT validation, image round trips, RPM solving, target payload inspection, synthetic storage failures and offline reproducibility. U3 is bounded, previously accepted hardware automation. H0/H1/H2/H3 require the appropriate operator and recovery path. No unattended fixture may silently become a real-disk test.

## URE acceptance cases

The recovery [roadmap](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/codex/ure-rescue-framework/docs/COMPREHENSIVE-ROADMAP.md#88-ci-test-classes)
and [capability contracts](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/codex/ure-rescue-framework/docs/FEATURE-PARITY.md#ure-capability-extension)
extend these classes. They are future cases, not new passing test records.

| Scope | Required cases before device acceptance |
|---|---|
| U0/U1 identity and plans | Duplicate/wrong labels and PARTUUIDs, wrong LUN/capacity/sector size, overflow, malformed JSON/XML/GPT, changed target/source hash, stale plan and unknown firmware. |
| U1 transactions | Verified/wrong-device/corrupt backups, full temporary storage, truncated/partial/failed I/O, every journal interruption boundary, safe vs uncertain failure, cancel boundaries and cleanup. |
| U1/U2 Linux/files/crypto | Distribution and kernel/initramfs/modules/DT/BLS fixtures, atomic edit and metadata preservation, symlink/external-change cases, controlled chroot without target Python, wrong LUKS/BITLK keys and mapper cleanup. |
| U1/U2 filesystems and Windows | Damaged ext4/F2FS/FAT/Btrfs/NTFS images, missing driver/features, mounted-device rejection, snapshot/stream failures, bounded WIM metadata/extraction and NTFS/ESP/BCD restore. |
| U1/U2 boot and Android | Missing entry/kernel/initramfs, unknown request version/target, one-shot consumption/replay/fallback, interrupted acknowledgment, active/unknown snapshot merge and logical-partition conflicts. |
| U1/U2 remote access and reports | SSH key/fingerprint/service defaults, separately validated SFTP dependency closure, interrupted/chunked transfer, secret/identifier/path redaction and malicious report/archive inputs. |
| H0/H1/H2/H3 | Exact SKU/profile inventory and stock return, real recovery essentials and read-only access, reviewed writes/restore/boot switching, then repeated boots, reconnects and long-operation/power/thermal stability. |

Parser fuzz targets include rawprogram XML, GPT, profile/plan JSON, os-release,
BLS, boot requests, WIM-wrapper boundaries and report import. Record failures
and bounds as well as successful cases. URE-15 release hardening includes source
reproduction, signatures, SBOM/license closure, target no-Python and privacy
checks; a repeated package build alone does not establish source reproduction.

PLANNED, SOURCE PRESENT, BUILT, HOST TESTED, EMULATION TESTED, DEVICE READ-ONLY
TESTED, DEVICE WRITE TESTED, SUPPORTED and BLOCKED describe separate evidence
dimensions. Record their scope and test IDs independently. Keep the hardware
ledger's existing vocabulary; only actual physical records can change it.
