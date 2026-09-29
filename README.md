# Uke Linux

A recovery-first effort to bring Fedora Rawhide AArch64 to the Xiaomi Pad 7 (`uke`, SM7675). The kernel product is **senemos-uke-kernel-mainline**.

We are preparing sources, architecture and evidence. No project recovery, UEFI or kernel image has been built, and no physical Pad 7 has been tested. [PLAN.md](PLAN.md) contains 100 dependency-ordered steps; [DEVICE-STATUS.md](DEVICE-STATUS.md) tracks 143 hardware capabilities without treating untested work as a failure or a success.

| Component | Local directory | Purpose |
|---|---|---|
| [OrangeFox Uke](https://github.com/MCC45TR/orangefox_device_xiaomi_uke) | recovery-uke-ofox | Recovery and device management |
| [Senemos Uke kernel](https://github.com/MCC45TR/senemos-uke-kernel-mainline) | senemos-uke-kernel | Mainline platform/driver port |
| [Fedora builder](https://github.com/MCC45TR/uke-fedora-builder) | uke-fedora-builder | RPMs, rootfs and boot artifacts |
| [Project Aloha Uke](https://github.com/MCC45TR/uke-project-aloha) | uke-project-aloha | UEFI platform and boot integration |

Each component owns its `referances/`, `src/`, `configs/`, `patches/`, `tests/`, `build/`, `artifacts/` and documentation. Large reference clones and private outputs stay local. Component commits are pinned as submodules. Clone the workspace with:

```sh
git clone --recurse-submodules https://github.com/MCC45TR/uke-linux.git
cd uke-linux
```

Host orchestration uses Bash, Git, jq, ripgrep and standard Linux tools. New native tablet utilities target C++; no Python runtime or scripts may ship to or run on the tablet. Upstream kernel/firmware languages remain unchanged. Read [AGENTS.md](AGENTS.md) for contribution and privacy rules.

```sh
scripts/sources.sh validate
scripts/sources.sh report
scripts/device-status.sh --check
bash tests/run.sh
```

Reference acquisition is explicit and can be large: `scripts/sources.sh archive arkt-nabu` retrieves its pinned full history, verifies objects, creates a bundle and checks offline restoration. `--phase preparation` is the default selection; `--phase implementation` selects later large source trees. Preserve at least 80 GiB free space.

The [uke-linux-test COPR channel](https://copr.fedorainfracloud.org/coprs/mcc45tr/uke-linux-test/) exists for future reviewed Rawhide AArch64 builds. It currently has no project packages. Creating a channel or passing a package build is not hardware acceptance.

See [the preparation report](reports/PREPARATION-REPORT.md), [source archive status](reports/source-archive.md), [test contract](docs/testing/TEST-CONTRACT.md) and [privacy/diagnostics contract](docs/security/SECURITY-AND-OBSERVABILITY.md). The MIT license covers original preparation material only; referenced and future imported upstream code retains its own license and attribution.
