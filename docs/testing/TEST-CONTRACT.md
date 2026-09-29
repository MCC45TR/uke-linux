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
