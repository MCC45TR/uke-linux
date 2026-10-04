# 2026-10-04: Xiaomi Uke donor archives and implementation boundaries

## DON-U001: A complete Git clone can still omit firmware objects

- **Lesson ID:** DON-U001
- **Date:** 2026-10-04
- **Environment scope:** Shared source research; OrangeFox, kernel and Fedora
- **Evidence class:** Source and host archive verification
- **Status:** Corrected acquisition state
- **Question or previous assumption:** Are six restored Git bundles a complete donor archive?
- **Finding:** Four sources needed only Git objects. Both vendor trees declare LFS; Git-only restore passed while `archive_complete` correctly remained false. Four modem objects and one common library object were subsequently fetched, hashed, archived and restored offline. Both vendor Git/LFS restore checks then passed.
- **Evidence:** The six `xiaomi-uke-*` records in `manifests/sources.lock.json`, the two vendor records in `manifests/lfs.lock.json` and `docs/research/XIAOMI-UKE-INVENTORY.json` preserve exact pins and checksums. LFS object counts are 4 and 1; no submodules were found.
- **Practical consequence:** Keep LFS payload verification separate from Git bundle success and retain historical objects. Pointer files may remain in the reference worktree without changing verified archive status.
- **Remaining uncertainty:** This is one-disk local retention and does not establish off-site backup or redistribution clearance.
- **Next validation:** Recheck bundle/LFS digests before a new restore or proposed build input.
- **Supersedes / superseded by:** Corrects the temporary Git-only acquisition state; no prior physical result is superseded.

## DON-U002: Exported headers are not a rebuildable kernel tree

- **Lesson ID:** DON-U002
- **Date:** 2026-10-04
- **Environment scope:** Senemos Uke kernel and recovery
- **Evidence class:** Source inventory and static binary metadata
- **Status:** Documented finding
- **Question or previous assumption:** Does the kernel-named organization repository supply Linux implementation source?
- **Finding:** Pin `446629e5d30c76848bfde9e3a67bcf6386ac24fa` contains one Image, four DTBs, DTBO, 1,032 exported header-tree files and 788 module file instances. It has no native implementation or DTS/DTSI source; its header Makefile has a no-op default target.
- **Evidence:** `kernel-headers/Makefile`, complete pinned Git-tree inventory, Image banner and `modinfo` samples. The Image is 6.1.118; sampled vendor modules are labeled 6.1.68. The recovery Image has the same SHA-256 as this kernel.
- **Practical consequence:** Use binary identities and dependency lists for comparison, not as source for mainline or a module ABI shortcut. The 788 instances represent 507 basenames and 509 distinct blobs.
- **Remaining uncertainty:** Different Android release labels alone do not settle KMI compatibility or device functionality.
- **Next validation:** Compare symbol CRCs, configurations, source commits and exact stock-profile artifacts before any Android module selection.
- **Supersedes / superseded by:** None.

## DON-U003: Common platform names do not erase Muyu provenance

- **Lesson ID:** DON-U003
- **Date:** 2026-10-04
- **Environment scope:** Fedora firmware research and shared hardware mapping
- **Evidence class:** Source history, file headers and GitHub repository metadata
- **Status:** Documented finding
- **Question or previous assumption:** Is every file under an Uke organization or SM8635 common tree derived from Pad 7?
- **Finding:** Uke device/vendor imports identify OS3.0.301.0.WOZMIXM. The latest shared device/vendor import explicitly identifies Pad 7 Pro/Muyu OS3.0.301.0.WOYMIXM. Both vendor repositories are related forks, and their older archived pins are ancestors of the new revisions.
- **Evidence:** Uke `proprietary-files.txt`, common `proprietary-files.txt`, vendor commit subjects and successful ancestor checks recorded in the donor audit.
- **Practical consequence:** Preserve device/profile provenance per file; mirrors or ancestor revisions are not independent hardware corroboration.
- **Remaining uncertainty:** Shared HAL compatibility and board-specific firmware applicability require source and installed-profile comparison.
- **Next validation:** Map candidate files to OEM Uke sources and exact stock package digests before reuse.
- **Supersedes / superseded by:** None.

## DON-U004: An extracted community DTBO can contain deliberate edits

- **Lesson ID:** DON-U004
- **Date:** 2026-10-04
- **Environment scope:** Kernel DT and recovery boot profiles
- **Evidence class:** Static source inspection
- **Status:** Documented finding
- **Question or previous assumption:** Can a ROM-derived DTBO filename be treated as untouched stock?
- **Finding:** The kernel extraction script changes two Uke panel symbols' `qcom,dsi-supported-dfps-list` to 120/144/90/60 before regenerating DTBO. The supplied artifact therefore requires exact OEM comparison rather than automatic stock classification.
- **Evidence:** Pinned kernel repository `extract-files.sh`, line 152; artifact SHA-256 `7afe1c987f7220c8f4fbbe0399234d27933946fb9252d5218f5e9690776eecc3`.
- **Practical consequence:** Record transformation provenance and compare all relevant base/overlay combinations before creating a transition profile.
- **Remaining uncertainty:** The script describes a transformation; this audit did not independently decode and compare the committed DTBO to its stock origin.
- **Next validation:** Perform a native, read-only DTB/DTBO comparison against OS3.0.8.0.WOZMIXM source artifacts.
- **Supersedes / superseded by:** None.

## DON-U005: Recovery touch fixes expose an ordering problem, not accepted support

- **Lesson ID:** DON-U005
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox touch and early userspace
- **Evidence class:** Static configuration/script and ELF inspection
- **Status:** Documented finding
- **Question or previous assumption:** What does the donor's touchscreen-fix commit actually implement?
- **Finding:** It packages a module/HAL/uinput chain, waits for module readiness and a touch node, adjusts permissions, and runs a restart watchdog. A static ARM64 uinput prebuilt has no companion implementation source in this tree; one referenced touch logging script is absent.
- **Evidence:** Recovery pin `d037467a1643d64979337ad79267c8b8f2e4ca17`, `runatboot.sh`, touchfeature init, watchdog, module lists and ELF metadata. Bridge SHA-256 `772da4540ecd08735fafbf15f05b0611bcbd1d37c86430f7124eb64203a8cfbe`.
- **Practical consequence:** Extract dependency and readiness requirements for a bounded, observable native implementation. Resolve file/library closure rather than hiding errors or importing opaque tools.
- **Remaining uncertainty:** Neither the commit subject nor a source comment proves physical touch, keepalive protocol or display/rotation acceptance.
- **Next validation:** Compare the donor chain to our shipping configuration and source driver ABI, then test C++ state/error handling before separate HIL.
- **Supersedes / superseded by:** None.

## DON-U006: Build flags are not security evidence or storage authority

- **Lesson ID:** DON-U006
- **Date:** 2026-10-04
- **Environment scope:** Recovery security and boot/storage planning
- **Evidence class:** Static donor configuration
- **Status:** Documented finding
- **Question or previous assumption:** Which donor defaults require independent review?
- **Finding:** Recovery disables SELinux enforcement, grants a touch device mode 0666 and declares a synthetic future patch date. Common AVB settings use a development test key and flags 3. Recovery/common super sizes disagree: 9,126,805,504 versus 8,321,499,136 bytes.
- **Evidence:** Both pinned BoardConfig files, recovery init and touch-permission script, as linked in the donor audit.
- **Practical consequence:** Do not import these defaults as production trust, decryption authority or live partition geometry. Retain existing installed-profile and write gates.
- **Remaining uncertainty:** This audit changes no deployed policy, storage layout or device acceptance result.
- **Next validation:** Compare independent OEM metadata and separately acquired installed-profile evidence; define minimum permissions for any new native tool.
- **Supersedes / superseded by:** None.

## DON-U007: Accessory source must be separated from destructive donor glue

- **Lesson ID:** DON-U007
- **Date:** 2026-10-04
- **Environment scope:** Native Linux/recovery pen and keyboard research
- **Evidence class:** Static C/C++/shell review
- **Status:** Documented finding
- **Question or previous assumption:** Can the shared pen implementation be reused unchanged?
- **Finding:** Pen/power helpers ignore open/ioctl failures; the uinput filter hard-codes M80p ranges, scans a small hidraw range and waits indefinitely. A companion shell deletes matching input event nodes. These are implementation leads with unresolved failure and identity behavior.
- **Evidence:** Common-device pin `d3e10662e157f273a43755a296db98063ace01f0`, `parts/xiaomi-pen.cpp`, `power/power-mode.cpp`, `parts/xiaomi-focus-pen-filter.c` and `init/init.pen.events.sh`.
- **Practical consequence:** New management stays C++, with explicit errors, report/ABI validation, reversible ownership and bounded hotplug handling. Donor scripts remain unexecuted.
- **Remaining uncertainty:** Coordinates, pressure, HID identity and protocol are not accepted for our accessory variants.
- **Next validation:** Construct synthetic event/report fixtures and compare Uke-specific driver and real accessory identity before deployment.
- **Supersedes / superseded by:** None.

## DON-U008: Variant inventories and public blobs do not establish deployment eligibility

- **Lesson ID:** DON-U008
- **Date:** 2026-10-04
- **Environment scope:** Fedora firmware, sensors and source publication
- **Evidence class:** Source path inventory, selected registry and ELF metadata
- **Status:** Documented finding
- **Question or previous assumption:** Do listed sensors, Android HALs and public firmware constitute ready Linux support?
- **Finding:** Uke inventory includes LSM6DSO/QMI8658, QMC6308, STK3BCx/SX937x/SIP1328 candidates, two panel/THP variants and camera plugins. The common touch HAL depends on Android linker/Binder/HIDL. No repository-wide license file was found; source notices and proprietary file statements differ. Four Python files exist only as ignored donor host tools.
- **Evidence:** `XIAOMI-UKE-INVENTORY.json`, selected Uke sensor JSON, QDCM/firmware/plugin names, touch HAL `readelf` output and pinned file notices.
- **Practical consequence:** Keep alternatives as candidates, establish populated hardware separately, review every redistribution decision and keep Python out of device payloads. Source/host acquisition cannot promote VM or physical support.
- **Remaining uncertainty:** Mainline interfaces, firmware rights, private calibration and physical variant selection remain open.
- **Next validation:** Build a file-level source/driver/firmware/license map and select only independently justified implementation inputs.
- **Supersedes / superseded by:** None.
