# Uke workspace continuation — 14 November 2026

The front camera has not produced a RAW frame. The observed tablet runs
`7.3.3-26-unstable`; CAMCC reports `fault -95`, `firmware-enabled-refused`,
`crm-admission`, last gate0x13308/readback1. No fitted sensor/media node exists.
No kernel, boot selection, EEPROM, actuator or calibration was changed.

The current camera source branch is `feat/hardware-kernel-migration` in
[senemos-uke-kernel-mainline](https://github.com/MCC45TR/senemos-uke-kernel-mainline/tree/feat/hardware-kernel-migration).
Commit `f03d7eb191a98feaf03d6806c14550ff97ef3c07` is qualified by
[COPR11327411](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-unstable/build/11327411/)
(native112,438s). Metadata-only `8fad7a9b` records that result. Four compiler/
sanitizer modes, all30 passive OEM clocks,40 read-fault cases per mode,
last-owner PM pin, four semantic mutants and actual complete-provider/all38
AArch64 adapter objects passed. Trusted2204 signed text receipt SHA256:
`37cbf36febf32ce2dc8d83b912ef3359f2e044ae3d77f7cc984a8b7992c70e10`.
It is not a runtime package and was not installed. The previous111 qualifier
failed a source-constructor fixture dependency; the complete55-line full26
source prefix is restored in112. All full26 source assets/configuration and
the original firmware guard are retained.

Next implement actual ROM parent resolution, permanent CRM transport/IRQ
binding and inherited AP SWDRV0 startup/sync withdrawal. Then qualify the
complete provider, native front GENI/sensor/CSIPHY4/CAMSS graph and completed
RAW buffer. Both full cameras, private read-only fitted EEPROM calibration
consumption and rear AF/parking remain open. Do not clear firmware CRM or
skip its guard. LIVEPATCH is disabled and module signatures are forced.

Exact source references remain in the donor manifests: MiCode kernel
5712080a4b0c0b1a879e6d145c601c649ddaddfd; camera-kernel699fa15a; kernel DT94c84aeb;
camera DT57d2135e; OnePlus SM7675fc892483; original Linux7.3.3. The Oct14
SM8650 clk-DVFS DNM RFC and earlier SM8750 display CESTA proposal do not
establish a ready enabled-Cliffs CRM implementation. Preserve attribution
and reference checkouts; follow `uke-linux-docs/docs/DONOR-POLICY.md`.

## Migration source snapshots

Branches named `handoff/workspace-20261114` in the root, kernel, hardware-support
and private documentation repositories contain `migration-handoff/20261114/`.
Their manifests record exact base commits, separate staged/unstaged patches,
untracked source hashes and privacy exclusions. These snapshots preserve WIP;
they do not merge it into default branches or qualify runtime behavior.
The original working branches and indexes were retained. Keyboard source is
already on its existing master branch at c2a9da2f.

For one snapshot, checkout its exact manifest base in an isolated worktree,
apply `staged.patch` with `git apply --index`, apply `unstaged.patch` with
`git apply`, and copy its `untracked/` files. Private-only deltas, local Git
objects and full restoration instructions are in the requested Desktop ZIP.
The ZIP also contains Codex history with consistent SQLite snapshots, small
reference inputs and build/coordination metadata. Never publish that archive.
Authentication files and machine-specific downloaded Codex binaries are
excluded; reauthenticate and reinstall the matching Codex build on the new PC.

On a different PC first verify its architecture and establish access to the
actual tablet. Do not treat the old local sysfs observations as observations
of the new host. Inspect current device/build/queue state before resuming.
Use one cumulative unstable COPR queue and shared delivery lock. Kernel/runtime
installation remains DNF on the tablet; do not compile on the tablet, install
copied binaries, restart an unobserved live job, promote stable or reboot from
this document. Preserve recovery, automatic staging and the existing local
rollback preference. No full27 release is reserved here.
