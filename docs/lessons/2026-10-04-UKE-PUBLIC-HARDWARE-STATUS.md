# 2026-10-04: Publish named hardware observations without promoting acceptance

## UKE-DOC001: A platform landing page needs current component and artifact scope

- **Lesson ID:** UKE-DOC001
- **Date:** 2026-10-04
- **Environment scope:** Uke Linux workspace and GitHub documentation
- **Evidence class:** Reviewed source documentation, repository/release metadata and Markdown rendering
- **Status:** Corrected public documentation
- **Question or previous assumption:** Chronological recovery checkpoints and obsolete plans could serve as a concise platform introduction.
- **Finding:** The README now groups four components, current recovery features, hardware/sensor status, downloads, validation and licensing. It removes obsolete SSH/BitLocker planning and an incorrect unpublished-source statement. Recovery links use R12.0. Generic ARM64 builds, current recovery source, the older Global OS3 alpha and installed stock OS2 remain separate. Kernel development is described without presenting a generic build or an unfinished adaptation as a bootable tablet release.
- **Evidence:** Fresh GitHub API responses show the single experimental recovery prerelease and no releases in the UEFI, kernel or Fedora builder repositories. README SHA-256 `3be0055f6e0d79a4a41dc65f7adc7cdda7fc88b3b79092112e52afc7c46a8f23`; GitHub Markdown rendered three tables and five sections. Publication links and privacy are checked against the proposed Git index. The first replacement attempt used duplicate delete/add operations for one path and refused without editing source; the corrected write preserved the original draft in ignored private storage.
- **Practical consequence:** Readers can distinguish source capabilities from sealed downloads and locate actual validation boundaries without interpreting development requests.
- **Remaining uncertainty:** Documentation/rendering checks do not compile or validate tablet firmware. COPR and GitHub release availability may change after this dated check.
- **Next validation:** Refresh artifact information when a newly reviewed release is published; continue ordered P1 and later combined target/guest acceptance.

## UKE-DOC002: Descriptor inventory and partial observations are not sensor acceptance

- **Lesson ID:** UKE-DOC002
- **Date:** 2026-10-04
- **Environment scope:** Own-device stock Android observations; Recovery/UEFI/Fedora/PenguinOS status remains separate
- **Evidence class:** Reviewed stock inventory transcription and generated capability ledger
- **Status:** Public evidence summary; functional acceptance unchanged
- **Question or previous assumption:** A working-sensors list could infer function from HAL names and cached records.
- **Finding:** Named LSM6DSO, QMC630x, STK3BCx, SIP1328, SX937x and Hall/fusion interfaces now have explicit observation and functional-status columns. Only the front non-wakeup ALS last-event timestamp advanced in the two passive snapshots. That partial observation does not establish reference lux, motion streams or automatic brightness. Sixty-one sensor descriptors include software and reporting variants, not 61 chips. QMI8658 remains an alternate configuration and QMC6308 an unconfirmed suffix. The complete ledger retains 143 not-tested capabilities per project environment with zero promoted successes, partial acceptance or measured failures.
- **Evidence:** STOCK-ADB-20261003-01/02/03 receipts on Global OS2.0.205.0.VOZMIXM and the condensed public summary SHA-256 `e265f7247300e32b787a345da083a17fa797bfcadabc46c4fe131b1e6a4e26f7`. Reviewed local source-summary hashes are `1a32b434ab651680dd868844ee8e3df532e7c0f4e4fe829b73f09145dedefa6f`, `aa5607ff519a56b51d5485812969ee413c7732a31ddc32f47f60f960b8b8cd7c` and `6ed8c89261ed7f2b5b5ca6ea5d9393fb86dd3b5b043f4a64e822de0f76193cbd` respectively. Physical device availability is now true, while all project functional results remain not-tested. The former first-build/privacy wording is superseded with dated alpha/current-source scope.
- **Practical consequence:** Fully working, partial, failed and untested results require their own workload/evidence. A candidate suffix or incomplete inventory cannot become a success or hardware-failure record.
- **Remaining uncertainty:** Physical sensor IDs, transport, calibration, units, accuracy, wake/resume and both models' project support are still open. Public receipts summarize earlier read-only collection; no fresh physical collection ran for this documentation change.
- **Next validation:** Run approved controlled workloads per build/firmware/SKU and update the generated ledger only after acceptance evidence exists.

## UKE-DOC003: Public evidence needs a closed and reviewed link set

- **Lesson ID:** UKE-DOC003
- **Date:** 2026-10-04
- **Environment scope:** Host documentation validation and selective publication
- **Evidence class:** Existing host checks, staged privacy checks and repository links
- **Status:** Reviewed publication closure
- **Question or previous assumption:** Linking every local research draft could yield a complete public README.
- **Finding:** The page links a self-contained reviewed summary, the generated 143-capability matrix and a platform lessons index. Stock receipt/source links point to that tracked summary instead of untracked research payloads. Original research, localization, kernel/builder and unrelated workspace drafts remain outside this focused publication. The ledger renderer incorporates the separate stock inventory without changing Recovery/UEFI/Linux results.
- **Evidence:** Nineteen existing host checks passed, including unsupported-result rejection and generated-ledger consistency; shell syntax and current ledger checks passed. Public relative links resolve in the proposed index. The planned GitHub content/readback checks compare the published README and summary byte-for-byte rather than relying on cached search-page content.
- **Practical consequence:** Navigation is usable from GitHub and publication includes neither private raw captures nor an accidental collection of unrelated work.
- **Remaining uncertainty:** Link, privacy and Markdown checks are documentation/host evidence only; semantic hardware acceptance is not automated by them.
- **Next validation:** Complete GitHub publication/readback and inspect the actual rendered table; preserve separate physical and runtime gates.
