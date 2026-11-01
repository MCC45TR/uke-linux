# Ubuntu package migration

Recorded: 1 November 2026. Target: Ubuntu 27.04 Tenacious ARM64, unstable only.
No Ubuntu image is available from this work. Launchpad ARM64 build 33897552
for the first speaker preset succeeded; archive publication is still pending.
New Ubuntu implementation and build dispatches are paused while Fedora Rawhide
DE release work takes priority. Existing build results are monitored read-only.

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
Native kernel retry 41309327976 terminated because the Debian release name
exceeds the shared ALSA `sizeof("uke" UTS_RELEASE) <= 16` assertion. Its
coordinated shorter release identity is the next kernel action on resumption;
the assertion has not been weakened and no new build was dispatched.
The six shared image tools have a separate native Debian recipe. No system
image composition is performed. Native Tenacious ARM64 server builds now pass
for shared libssc and SensorProxy; the latter builds against the exact patched
libssc DEBs in its own clean root. See the recorded
[native build results](uke-linux-hardware-support/packaging/ubuntu/NATIVE-BUILDS.md)
and live CI for the remaining routes.
Read-only native APT policy tests pass, but the active package backend remains
Fedora until solver, authentication, journal and boot integration are complete.
The attributed speaker preset passed native ARM64 build, payload inspection,
server install/reinstall/conffile/remove/purge and recipe source construction.
Its [first Launchpad recipe handoff](uke-linux-hardware-support/packaging/ubuntu/LAUNCHPAD-RECIPES.md)
includes the published package branch and upstream tag. Nineteen non-kernel
recipe source branches and exact-original metadata are now published. Of the
27 actual binary packages, runtime metadata resolves 16 closures and refuses
11 missing real ABI providers; two development closures include host Python
and are server-only. Daily enrollment of gated source groups remains held.
Launchpad publication is still pending. No tablet validation was performed. Current COPR
release reconciliation, Control APT/dpkg transactions, real kernel/DT/module and
initramfs checks, firmware and remaining runtime ports are implementation work.

Launchpad identity: `mcs45tr`. Parent confirmed accepted PPA terms and public
ARM64-only unstable and stable PPAs, both empty. OpenPGP enrollment is confirmed;
the private key remains on the user's tablet. Native server builds and public
Git import/daily changed-source recipes to unstable are authorized. Source
branches are enrolled after validation; the parent session handles the first
Launchpad import and recipe UI. No new upload credential or Ubuntu image was
created here. Stable remains gated by independent qualification.

Workspace CI preserves pinned component checkouts and validates each configured
branch. Shallow submodule fetches do not necessarily create a tracking ref for
non-default branches; validation now fetches only that configured ref before
checking it, without checking out its tip or weakening the remaining tests.
