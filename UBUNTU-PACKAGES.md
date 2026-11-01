# Ubuntu package migration

Recorded: 1 November 2026. Target: Ubuntu 27.04 Tenacious ARM64, unstable only.
No Ubuntu image or published package is available from this work.

The hardware-support submodule points to the `ubuntu` packaging branch, which
adds native Debian recipes around unchanged common component sources and RPM
specs. It is a packaging staging branch, not an independent hardware-source
fork. See [migration coverage and instructions](uke-linux-hardware-support/packaging/ubuntu/README.md)
and the [43-entry COPR inventory](uke-linux-hardware-support/packaging/ubuntu/coverage.json).

Two unsigned source packages (battery observer and front-color helper) passed
source assembly/extraction and static packaging checks on Debian 13 x86_64.
No ARM64 binary build, installation, VM or tablet validation was performed.
The front-color helper requires the still-unported SSC service. No package is
ready for publication. Kernel/DTB/modules/initramfs cohort safeguards and the
Control APT/dpkg transaction backend remain substantial implementation work.

Launchpad identity: `mcs45tr`. PPA terms acceptance, signing-key enrollment and
upload authorization remain pending in the parent workflow. No signing key,
credential, PPA upload or image was created here. Stable stays empty until
separately documented qualification; Fedora evidence is not Ubuntu acceptance.
