# Cutefish Fedora packaging

27 October 2026. Target: Fedora Rawhide, AArch64 only.

This directory packages the current [upstream Cutefish desktop](https://cutefish.org/).
The desktop, toolkit, compositor and applications are developed by
[Cutefish](https://github.com/cutefishos). This is downstream RPM packaging,
not a Uke fork or a claim of source ownership. Upstream names, copyright
notices and licenses are preserved. No KDE application is rebuilt.

Fedora Rawhide AArch64 repository queries returned no Cutefish packages.
Existing `rmnscnce/cutefish-desktop` COPR metadata provides 2021-era 0.3
packages, not the current C++/Skia Wayland desktop. The separate build target
is [`mcc45tr/cutefish`](https://copr.fedorainfracloud.org/coprs/mcc45tr/cutefish/).

`packaging/cutefish-desktop.spec` builds nine pinned Cutefish repositories
and pinned Skia in one source RPM, following upstream dependency order.
`upstream.tsv` records revisions; `sources.sha256` records archive bytes.
Sources install into a private build staging directory, never the host root.
The runtime RPM and development subpackage retain upstream component names.

Fedora adaptation is limited to packaging: native Fedora GN instead of the
downloaded GN executable, Fedora library paths, and `system-auth` for the
lock screen. Installation does not enable services, change the default
desktop, replace a display manager, write a tablet partition or alter boot.
The existing display manager can offer the upstream Cutefish Wayland session.

The upstream wallpaper repository uses the Unsplash license, which Fedora
[lists as not allowed](https://docs.fedoraproject.org/en-US/legal/not-allowed-licenses/).
It is excluded from both SRPM and runtime RPM, as required by
[COPR's license policy](https://docs.copr.fedorainfracloud.org/user_documentation.html#what-i-can-build-in-copr).
The compositor retains its upstream solid-color fallback until a wallpaper
is selected. The optional display manager, Qt plugins, extra applications and
agent-control server are outside this initial desktop package.

Skia's upstream GN build executes Python scripts such as `gn/is_clang.py`
and `gn/toolchain/num_cpus.py`. This is an unavoidable, host-only upstream
build dependency at Skia commit `95ee33d7ec7791ab9c071675710a14fe6408ae4f`;
replacing the maintained GN generator has no practical packaging alternative.
Python is a build requirement only. No Python interpreter, source, bytecode,
entrypoint or test is installed in the target package. COPR builds run with
network access disabled. RPM source packages necessarily retain original
upstream build scripts for reproducibility.

Prepare a source RPM on the host:

```bash
bash tests/contract.sh
bash build-srpm.sh ../build/cutefish-rpm
```

On 27 October 2026, native Rawhide AArch64
[COPR build 11214274](https://copr.fedorainfracloud.org/coprs/build/11214274)
produced `cutefish-desktop-1.0^20261027-4.fc46.aarch64` and its development
subpackage. Source checks, RPM checks and independent signature verification
passed. The extracted runtime contains 30 AArch64 ELF files and 25,091 package
paths, with no Python source, bytecode, entrypoint or dynamic dependency.
The upstream session file, source manifest and Fedora PAM policy matched the
expected bytes. No upstream desktop source patch was needed.

A fresh-root DNF installation preview resolved 506 runtime packages and stopped
without installing anything. Python files in that dependency closure belong
to seven signed, unmodified Fedora packages; the complete Fedora closure is
not Python-free. The original Fedora package exception remains narrow and
does not permit project-owned Python or Python in recovery/initramfs.

For an experimental installation on an existing Fedora Rawhide AArch64 desktop:

```bash
sudo dnf copr enable mcc45tr/cutefish
sudo dnf install cutefish-desktop
```

Keep the existing display manager and select **Cutefish (Wayland)** at login.
The installation commands were not executed during this packaging work.
Authentication, locale generation, a graphical session, upstream test suites
and physical Uke operation remain untested. A Uke Linux Cutefish image remains
gated on those integration checks and first-account setup. No image profile or
physical tablet result is claimed here.
