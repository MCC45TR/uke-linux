# Privacy, security and diagnostics contract

This document defines implementation goals; it is not a completed security audit.

## Publication

Use workspace-relative paths and GitHub no-reply author metadata. Keep credentials, signing material, private logs, serials, network identities, calibration, stock user data and raw images outside tracked files. Inspect staged content and commit metadata before pushing. Review releases, CI uploads and COPR inputs separately; `.gitignore` alone does not protect artifacts or old commits.

`scripts/privacy-check.sh` checks staged content, or the current commit when nothing is staged, and rejects common credential patterns, home-directory paths, forbidden file types and project-owned Python files. It prints file names rather than matched secret values. It is a limited guardrail and cannot certify that arbitrary text is free of sensitive data. Historical upstream author identities belong to upstream provenance and are not rewritten; project-owned publication metadata uses the project account's no-reply address.

## Implementation boundaries

Use C++ for new device applications, Bash for host orchestration and the upstream required languages for Linux/EDK II. No Python runs on the tablet. Host-only upstream exceptions must be pinned and recorded; target package closure, ramdisk and shared-library scans enforce the boundary.

Protect model/profile selection, parser bounds, archive extraction, storage arithmetic, plan freshness, mount ownership and signing/rollback metadata. Keep Android firmware trust separate from kernel encryption capability. Maintain SELinux and safe thermal/speaker limits. Debug exceptions must have a scope, owner, reason and removal condition.

## Observability

Correlate operation IDs, build/profile IDs, UTC and monotonic timestamps across recovery, kernel, pstore, systemd, remoteproc, DRM/GPU, USB, storage, sensors and power. Preserve raw channels, units and validity flags alongside interpretations. Reports distinguish facts, hypotheses, counter-evidence and next tests.

Bound log storage and collection overhead with retention limits and incident modes. Keep raw logs private and export redacted summaries. Investigate the cause of errors and warnings; muting messages is not stability work. The release gate permits no unexplained error, warning, crash or regression. Temporary known-message exceptions require ownership, justification, expiry and a regression test.
