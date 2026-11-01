# Ubuntu package migration

Recorded: 1 November 2026. Target: Ubuntu 27.04 Tenacious ARM64, unstable only.
No Ubuntu image or published package is available from this work.

The hardware-support submodule tracks the `ubuntu` packaging branch. Common
component sources and RPM recipes remain shared and unchanged; Debian overlays
hold distribution dependencies and lifecycle integration. See the
[migration report](uke-linux-hardware-support/packaging/ubuntu/README.md),
[implemented recipes](uke-linux-hardware-support/packaging/ubuntu/components.tsv)
and [43-entry COPR coverage](uke-linux-hardware-support/packaging/ubuntu/coverage.json).

Sixteen source routes are prepared, including shared SSC, SensorProxy, UPower,
VA-API and touchscreen patch sets. Four configuration-only ARM64 DEBs passed
payload checks on the x86_64 host. No native ARM64 compilation, installation,
VM or tablet validation was performed. None is publication-ready. Current COPR
release reconciliation, Control APT/dpkg transactions, real kernel/DT/module and
initramfs checks, firmware and remaining runtime ports are implementation work.

Launchpad identity: `mcs45tr`. Parent confirmed accepted PPA terms and public
ARM64-only unstable and stable PPAs, both empty. OpenPGP signer enrollment and
signed-source upload remain pending. No key, credential, upload or image was
created here. Stable remains gated by independent qualification.

Workspace CI preserves pinned component checkouts and validates each configured
branch. Shallow submodule fetches do not necessarily create a tracking ref for
non-default branches; validation now fetches only that configured ref before
checking it, without checking out its tip or weakening the remaining tests.
