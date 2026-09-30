# Releases and downloads

GitHub Releases is the authoritative download location for [experimental recovery candidates](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/releases). The privacy-clean alpha provides three distinct recovery/temporary-boot/installer assets, source snapshots and offline validation evidence. No physical boot has been tested. No UEFI, Uke-bootable mainline kernel, RPM or Fedora system image is released. Fedora test packages will be published in `uke-linux-test` after local package checks.

Each release description will name the exact POCO Pad X1 or Xiaomi Pad 7 model, SKU and firmware profile, together with the source/patch revision, toolchain, kernel release and device-tree profile. It will list SHA-256 hashes, artifact sizes, signatures, prerequisites, installation steps, rollback steps, physical tests and known limitations. Artifacts from different firmware profiles will not be presented as interchangeable.

A GitHub source archive is not a recovery image. A local image build, passing CI or successful COPR build does not establish device boot. Physical acceptance is published per feature in `DEVICE-STATUS.md` with build, firmware, variant and raw evidence references. Only supported functions are described as working.

Development versions will use a clearly marked pre-release with a build identifier. No artifact is uploaded while packaged files expose private build paths or host identity. No production release is created until stock-return, recovery/boot, package, stability, privacy and license gates pass. Earlier known-good versions remain available for rollback. No Fedora package installation script changes Android partitions or the default boot selection.

An **experimental, untested** prerelease is a different evidence class from a
supported hardware-validation release. It may publish bounded, source-identified
assets after host/package/privacy checks with explicit unsigned status, exact
firmware constraints, guarded installation instructions and an unrehearsed
stock-return procedure. It must not advertise hardware success, reliable OTA or
decryption. The recovery installation ZIP changes only the verified active
recovery partition under its native policy; it does not change boot selection,
userdata, GPT or trusted firmware. Fedora package scripts retain the no-Android-
partition-write rule above.
