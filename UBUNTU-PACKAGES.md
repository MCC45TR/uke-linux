# Ubuntu package migration

Recorded: 1 November 2026. Target: Ubuntu 27.04 Tenacious ARM64, unstable only.
No Ubuntu image is available from this work. The first speaker preset is now
Published for Tenacious ARM64. The user has resumed work on a minimal Ubuntu
test image for later download; no tablet writes are authorized here.
Experimental kernel1006 was found in the separate test/power channel and its
exact emitted source is staged. See the
[test-image gates](uke-linux-hardware-support/packaging/ubuntu/TEST-IMAGE-GATES.md).

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
Native kernel retry 41309327976 terminated because the old Debian release name
exceeded the shared ALSA `sizeof("uke" UTS_RELEASE) <= 16` assertion. The new
coordinated experimental identity 7.3.1-1006u1 fits exactly; the assertion is
unchanged. Source assembly, emitted inventories, signer and chunk reconstruction
pass. Native execution of the new source set has not run. The userspace test
uses only signed official Ubuntu packages plus the published PPA preset and
exports evidence, not a root/boot image. The bounded dracut/dpkg overlay now
stages with unchanged kernel configuration and root-handoff code. Metadata
refusal fixtures and actual stock ARM64 package provenance pass. Native1006
execution still awaits source-specific approval; full embedded initramfs,
DT/module trust and actual root handoff remain unqualified. The final security
profile is not selected and no security setting was changed.
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
