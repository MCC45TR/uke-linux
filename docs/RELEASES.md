# Releases and downloads

There are no public device artifacts yet. A first local OrangeFox recovery build exists, but its payload privacy audit fails and no physical boot has been tested. GitHub Releases will be the authoritative download location for recovery, UEFI, kernel and system-image candidates once their gates pass. Fedora test packages will be published in `uke-linux-test` after local package checks.

Each release description will name the exact POCO Pad X1 or Xiaomi Pad 7 model, SKU and firmware profile, together with the source/patch revision, toolchain, kernel release and device-tree profile. It will list SHA-256 hashes, artifact sizes, signatures, prerequisites, installation steps, rollback steps, physical tests and known limitations. Artifacts from different firmware profiles will not be presented as interchangeable.

A GitHub source archive is not a recovery image. A local image build, passing CI or successful COPR build does not establish device boot. Physical acceptance is published per feature in `DEVICE-STATUS.md` with build, firmware, variant and raw evidence references. Only supported functions are described as working.

Development versions will use a clearly marked pre-release with a build identifier. No artifact is uploaded while packaged files expose private build paths or host identity. No production release is created until stock-return, recovery/boot, package, stability, privacy and license gates pass. Earlier known-good versions remain available for rollback. No package installation script changes Android partitions or the default boot selection.
