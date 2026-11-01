# Ubuntu package migration

Recorded: 1 November 2026. Target: Ubuntu 27.04 Tenacious ARM64, unstable only.
No Ubuntu image or published package is available from this work.

The hardware-support submodule tracks the `ubuntu` packaging branch. Common
component sources and RPM recipes remain shared and unchanged; Debian overlays
hold distribution dependencies and lifecycle integration. See the
[migration report](uke-linux-hardware-support/packaging/ubuntu/README.md),
[implemented recipes](uke-linux-hardware-support/packaging/ubuntu/components.tsv)
and [43-entry COPR coverage](uke-linux-hardware-support/packaging/ubuntu/coverage.json).

Twenty source routes define 30 binary packages, including shared SSC, SensorProxy, UPower,
VA-API and touchscreen patch sets. Battery 1.4.1 and SSC release 26 now reuse
their exact released safety-related source changes. Four configuration-only
ARM64 DEBs, existing Android recovery delivery and the separately attributed
speaker preset passed payload
checks on the x86_64 host. Recovery artifacts retain their published checksums
and have no installation or boot hooks; recovery was not recompiled.
Kernel release-115 source composition is retained exactly. Its three candidate
packages are staged outside live boot/module paths; the first-pass Image is
not bootable and boot-bundle production fails explicitly. Synthetic payload
refusal tests pass; no real kernel/module payload has yet been admitted.
The six shared image tools have a separate native Debian recipe. No system
image composition is performed. Offline metadata simulation resolves build
dependencies for 19 recipes; SensorProxy awaits the patched libssc package.
Read-only native APT policy tests pass, but the active package backend remains
Fedora until solver, authentication, journal and boot integration are complete.
No native ARM64 compilation, installation,
VM or tablet validation was performed. None is publication-ready. Current COPR
release reconciliation, Control APT/dpkg transactions, real kernel/DT/module and
initramfs checks, firmware and remaining runtime ports are implementation work.

Launchpad identity: `mcs45tr`. Parent confirmed accepted PPA terms and public
ARM64-only unstable and stable PPAs, both empty. OpenPGP enrollment is confirmed;
the private key remains on the user's tablet. Native build approval is pending,
and local signing/upload must wait for package qualification. No key, credential, upload or image was
created here. Stable remains gated by independent qualification.

Workspace CI preserves pinned component checkouts and validates each configured
branch. Shallow submodule fetches do not necessarily create a tracking ref for
non-default branches; validation now fetches only that configured ref before
checking it, without checking out its tip or weakening the remaining tests.
