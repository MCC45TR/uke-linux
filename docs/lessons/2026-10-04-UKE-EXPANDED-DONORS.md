# 2026-10-04: Additional Uke donors and their reuse limits

## DON-E001: Parent archive verification is not dependency closure

- **Lesson ID:** DON-E001
- **Date:** 2026-10-04
- **Environment scope:** Shared source research and host archive tooling
- **Evidence class:** Source and host archive verification
- **Status:** Documented finding
- **Question or previous assumption:** Are all 13 requested repositories ready as complete build inputs?
- **Finding:** Seven new clones and six reused clones passed parent Git integrity and offline bundle restoration. Twelve archives meet their recorded dependency checks. The direct Linux donor still has 19 gitlinks; 14 exact pins occur in other catalog entries, but that does not verify the parent's build closure.
- **Evidence:** `UKE-EXPANDED-DONOR-INVENTORY.json`, `UKE-LINUX-DEPENDENCY-MAP.json`, `manifests/sources.lock.json`; parent pin `32cad9ccd383ff4b37d8a5e7f88a8bfdcc07307e`.
- **Practical consequence:** Retain `archive_complete=false` for the direct donor and explicitly close its pinned graph before reproduction. Same-disk bundles are not off-site backups.
- **Remaining uncertainty:** Build dependency closure, reproduced donor outputs and hardware acceptance remain separate gates.
- **Next validation:** Verify exact gitlinks and licenses in development-owned directories, then reproduce v6.12 without changing the delivery baseline.
- **Supersedes / superseded by:** None; extends the earlier Git/LFS distinction in DON-U001.

## DON-E002: Separate URLs can preserve identical evidence

- **Lesson ID:** DON-E002
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox and kernel donor selection
- **Evidence class:** Exact Git commit/tree comparison
- **Status:** Documented finding
- **Question or previous assumption:** Do the additional recovery and Resources kernel URLs provide independent implementations?
- **Finding:** Delano/Xiaomi recovery share commit `d037467a1643d64979337ad79267c8b8f2e4ca17` and tree `3102ff0207e5c93f64078c22167eb50e8a83c723`. Resources/Xiaomi kernel prebuilts share commit `446629e5d30c76848bfde9e3a67bcf6386ac24fa` and tree `b14cabda429a72abca902b2a0b236ae519cf12ff`.
- **Evidence:** Read-only `git rev-parse HEAD^{tree}` comparisons and pinned inventory records.
- **Practical consequence:** Preserve canonical clones for provenance; do not double-count mirrors as independent touch, boot or kernel acceptance.
- **Remaining uncertainty:** Future branch divergence requires a fresh review.
- **Next validation:** Compare exact trees when new refs are proposed, retaining existing recovery security/input findings.
- **Supersedes / superseded by:** None.

## DON-E003: Product performance and charging flags do not establish native controls

- **Lesson ID:** DON-E003
- **Date:** 2026-10-04
- **Environment scope:** Fedora performance, display and power research
- **Evidence class:** Static Android product and policy inspection
- **Status:** Documented finding
- **Question or previous assumption:** Can Delano/Perry tuning be applied directly to mainline Fedora?
- **Finding:** Delano's kernel-manager configuration names CPU policy/KGSL interfaces. Its bypass flag points to `smart_charge/smart_night`. Perry's 589-line power hints and 357-line boost selection tables use Android Power HAL conventions. Their flags and values contain no project battery, thermal or latency measurements.
- **Evidence:** Delano `78812b13d6a04596ed6157668c5d160ee4ca29db`: `configs/ax_kernel_manager.xml`, `lineage_uke.mk`; Perry `5c9266c11812c7f64484c2cb76350338c2d3355b`: `power/`, `device.mk`.
- **Practical consequence:** Establish native interface semantics and conservative defaults before controlled benchmarks. Do not equate the night-charging path with measured bypass operation.
- **Remaining uncertainty:** Actual supported panel modes, HBM behavior, charge control and energy benefit need separate installed-profile and physical evidence.
- **Next validation:** Map policy requirements to native driver controls, then measure idle/workload energy, input/frame latency and temperatures.
- **Supersedes / superseded by:** None.

## DON-E004: Android setup scripts can import unpinned dependencies and foreign trust

- **Lesson ID:** DON-E004
- **Date:** 2026-10-04
- **Environment scope:** Host source acquisition and release signing
- **Evidence class:** Static dependency-script review
- **Status:** Documented finding
- **Question or previous assumption:** Is running the donor setup a safe way to complete its tree?
- **Finding:** Perry `vendorsetup.sh` shallow-clones eight repositories from moving branches, including an external signing-key template. Product/common/vendor build includes are not closed by the requested product clone alone.
- **Evidence:** `vendorsetup.sh` at `5c9266c11812c7f64484c2cb76350338c2d3355b`; exact dependency groups listed in the expanded audit.
- **Practical consequence:** Never execute the donor setup or adopt foreign signing authority. Acquire necessary source dependencies independently with exact pins and full archive checks.
- **Remaining uncertainty:** Unrequested dependency contents and build compatibility were not accepted by this review.
- **Next validation:** Review only dependencies needed by an explicit build plan; keep key generation/trust under project release policy.
- **Supersedes / superseded by:** None.

## DON-E005: A header symlink and DT blob name can hide missing build inputs

- **Lesson ID:** DON-E005
- **Date:** 2026-10-04
- **Environment scope:** Kernel/recovery binary comparison and donor reproduction
- **Evidence class:** Git tree, Image hashes and FDT header inspection
- **Status:** Documented finding
- **Question or previous assumption:** Does Vember supply the header/DT layout expected by the Android product?
- **Finding:** Default pin `9bb7c4331be7205fabf5427b5654555763304d20` has an unresolved `kernel-headers` symlink and a concatenated four-record `dtb.img`, while product files expect `dtbs/`. Its default Image matches Resources' 6.1.118 Image, but `lunaris-16.2` supplies a different 6.1.138 Image and no headers entry. Neither is rebuildable Linux implementation source.
- **Evidence:** Git mode 120000 and symlink target, Image hashes/banners, four FDT offsets/sizes and per-ref pins in the expanded audit.
- **Practical consequence:** Resolve external headers and DT transformations explicitly before Android reproduction. Never import Android binary modules into mainline as drivers.
- **Remaining uncertainty:** Header framing does not validate overlay/board/binding relationships, and release names alone do not decide Android KMI compatibility.
- **Next validation:** Compare exact stock-profile artifacts, source/KMI metadata and decoded DT relationships.
- **Supersedes / superseded by:** None; extends DON-U002 and DON-U004.

## DON-E006: ukefi does not implement Uke platform firmware

- **Lesson ID:** DON-E006
- **Date:** 2026-10-04
- **Environment scope:** Project Aloha and Fedora boot packaging research
- **Evidence class:** Static source and license inspection
- **Status:** Corrected source classification
- **Question or previous assumption:** Does a repository named ukefi provide Xiaomi Uke UEFI support?
- **Finding:** Pin `6a7daff10b4d48aba4d213cc11e1bd434effec77` hardcodes `linuxx64.efi.stub` and implements Debian/Bash Unified Kernel EFI packaging. It has no ARM64/SM7675 board port. Hooks can write the ESP/EFI variables; optional signing has unsigned fallback and unbounded retry/wait behavior.
- **Evidence:** `src/update-ukefi.in`, `src/ukefi-configure-boot.in`, Debian hooks and MIT license in the pinned 21-file tree.
- **Practical consequence:** Use current/fallback packaging ideas only after ARM64/native Fedora redesign. Do not run its hooks or treat it as an Aloha Uke target.
- **Remaining uncertainty:** No boot artifact or signing flow from this donor was built or executed.
- **Next validation:** Define ARM64 image and bounded signing/fallback contracts independently from platform firmware bring-up.
- **Supersedes / superseded by:** Corrects possible name-based classification; no prior hardware result changes.

## DON-E007: A desktop image description is not a reproducible distribution

- **Lesson ID:** DON-E007
- **Date:** 2026-10-04
- **Environment scope:** Fedora rootfs provenance and publication privacy
- **Evidence class:** Pinned source tree and public release metadata
- **Status:** Documented finding
- **Question or previous assumption:** Does Linux-UKE provide reusable Debian desktop source/build inputs?
- **Finding:** Pin `3eb6ec4437eea0f53b6d23b74bd612e66806a1c8` contains only a 3,193-byte README. Referenced scripts/images/checksums are absent, and the inspected prerelease has no attached assets. The README describes retained personal state and a shared login; those details were not copied or downloaded as payloads.
- **Evidence:** Complete Git-tree inventory and `v0.1-test` release asset list inspected on 2026-10-04.
- **Practical consequence:** Classify as third-party documentation only. Build Fedora images from clean, traceable inputs and review payload privacy independently of donor desktop claims.
- **Remaining uncertainty:** Third-party runtime claims are not reproduced or accepted as project hardware evidence.
- **Next validation:** Use an independently locked package/rootfs build with payload/license/privacy checks.
- **Supersedes / superseded by:** None.

## DON-E008: Common trees retain cross-device and cross-OEM provenance

- **Lesson ID:** DON-E008
- **Date:** 2026-10-04
- **Environment scope:** Shared hardware and firmware research
- **Evidence class:** File headers and commit history
- **Status:** Documented finding
- **Question or previous assumption:** Are the older Resources common/Uke and newer product imports one interchangeable firmware profile?
- **Finding:** Resources product headers identify Uke OS3.0.8 and common Muyu OS3.0.7. New Delano declares Global OS3.0.303. Common history also names graphics imported from OPD2403_16.0.3.501. Native pen/power source is mixed with Android framework/HAL assumptions.
- **Evidence:** Pinned proprietary-file headers, common commit `c6dc428`, native common source and product descriptions; full revisions in the expanded inventory.
- **Practical consequence:** Maintain per-file provenance and exact firmware-profile separation. Compare protocols and board wiring rather than transplanting common definitions.
- **Remaining uncertainty:** An import subject does not prove stock identity or physical suitability of every file.
- **Next validation:** Match candidate components to Uke OEM source, package hashes and separately reviewed installed-profile evidence.
- **Supersedes / superseded by:** None; complements the newer import findings in DON-U003.

## DON-E009: Early-exit filters can invalidate a diagnostic pipeline

- **Lesson ID:** DON-E009
- **Date:** 2026-10-04
- **Environment scope:** Host-only Image metadata inspection
- **Evidence class:** Failed host diagnostic and corrected read-only probe
- **Status:** Corrected
- **Question or previous assumption:** Does a failed banner probe mean the kernel artifact is damaged?
- **Finding:** `strings Image | rg -m1` under `pipefail` returned 141 when the consumer exited early and the producer received SIGPIPE. A complete strings extraction followed by a filter that consumes the whole stream succeeded for both Vember pins.
- **Evidence:** Initial diagnostic exit 141; corrected SHA-256/banner probe returned 0 and identified default 6.1.118 and Lunaris 6.1.138 Images. Probe files were removed explicitly from the task-owned temporary directory.
- **Practical consequence:** Separate diagnostic-command failure from artifact corruption; avoid early-closing consumers in checked pipelines and redact builder identity from public metadata.
- **Remaining uncertainty:** A banner/hash probe does not establish boot, ABI or hardware acceptance.
- **Next validation:** Use independent config/module/DT checks when selecting an explicit build/profile input.
- **Supersedes / superseded by:** Supersedes only the failed banner probe; no kernel result is changed.
