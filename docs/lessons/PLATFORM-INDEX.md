# Platform engineering records

These records distinguish source, build, package, host fixture, emulation, third-party and own-device evidence for POCO Pad X1 and Xiaomi Pad 7. Material findings retain stable IDs, dates, limitations and the next validation. Public records omit raw device logs, unit identifiers and private calibration.

| Record | Scope |
|---|---|
| [Platform landing page and hardware status](2026-10-04-UKE-PUBLIC-HARDWARE-STATUS.md) | UKE-DOC001–UKE-DOC003; professional documentation, named sensor observations and separate acceptance states |
| [Kernel landing page and stable release policy](2026-10-05-UKE-KERNEL-PUBLIC-README.md) | UKE-DOC004; package/source workflows, future stable profile admission, COPR links, licensing and separate hardware acceptance |
| [Hardware evidence summary](../research/UKE-HARDWARE-STATUS-2026-10-04.md) | Condensed 3 October stock Android receipts; installed OS2, candidate identity and measurement limits |
| [Recovery engineering index](RECOVERY-INDEX.md) | Ordered recovery implementation, failed/corrected trials and validation records |
| [Kernel and RPM build](2026-10-04-UKE-7.2.9-RPM-BUILD.md) | UKE-K729-L001–UKE-K729-L015; signed 7.2.9 Uke compilation, failed/corrected packaging trials, host-family bootstrap and fresh-install/upgrade lifecycle |
| [COPR, recovery delivery and source tracking](2026-10-04-UKE-COPR-UPDATE-HUB.md) | UKE-PKG-L001–UKE-PKG-L014; actual COPR jobs, DNF image delivery, base-runtime audit corrections, original KDE policy and stable admission |

The [test contract](../testing/TEST-CONTRACT.md) governs physical acceptance. The [generated matrix](../../DEVICE-STATUS.md) remains the complete project capability ledger. A source or VM result does not promote a physical result.
