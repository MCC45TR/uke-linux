# Ubuntu package migration

Recorded: 1 November 2026. Target: Ubuntu 27.04 Tenacious ARM64, unstable only.
No Ubuntu image or published package is available from this work.

The hardware-support submodule tracks the `ubuntu` packaging branch. Common
component sources and RPM recipes remain shared and unchanged; Debian overlays
hold distribution dependencies and lifecycle integration. See the
[migration report](uke-linux-hardware-support/packaging/ubuntu/README.md),
[implemented recipes](uke-linux-hardware-support/packaging/ubuntu/components.tsv)
and [43-entry COPR coverage](uke-linux-hardware-support/packaging/ubuntu/coverage.json).

Seventeen source routes are prepared, including shared SSC, SensorProxy, UPower,
VA-API and touchscreen patch sets. Battery 1.4.1 and SSC release 26 now reuse
their exact released safety-related source changes. Four configuration-only
ARM64 DEBs and the existing Android recovery data-delivery DEB passed payload
checks on the x86_64 host. Recovery artifacts retain their published checksums
and have no installation or boot hooks; recovery was not recompiled.
Read-only native APT policy tests pass, but the active package backend remains
Fedora until solver, authentication, journal and boot integration are complete.
No native ARM64 compilation, installation,
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
