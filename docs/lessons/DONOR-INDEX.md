# Donor research lessons

These records cover local source acquisition, static analysis and archive
verification. They do not change build, emulation or physical-device results.
Keep older findings and add explicit corrections when new evidence supersedes
an assumption.

| Record | Lesson IDs | Scope and next validation |
|---|---|---|
| [Xiaomi Uke donor audit](2026-10-04-XIAOMI-UKE-DONORS.md) | DON-U001–DON-U008 | Six pinned source archives, LFS restoration, binary/kernel boundaries, Muyu provenance, modified DTBO, recovery security/input behavior and variant evidence; source comparison before implementation |
| [Additional Uke donors](2026-10-04-UKE-EXPANDED-DONORS.md) | DON-E001–DON-E009 | Thirteen requested URLs, mirror identity, unresolved direct-donor gitlinks, Android tuning and trust boundaries, missing header/DT closure, generic x86-64 ukefi, documentation-only desktop claims, mixed import provenance and corrected host diagnostics |

The [research report](../research/XIAOMI-UKE-DONOR-AUDIT.md) links exact pins,
files, limitations and reuse priorities. Recovery implementation/test lessons
remain in the [recovery index](RECOVERY-INDEX.md).

The [expanded audit](../research/UKE-EXPANDED-DONOR-AUDIT.md) records the additional
repository placement, exact pins, branch/profile comparisons and dependency map.
