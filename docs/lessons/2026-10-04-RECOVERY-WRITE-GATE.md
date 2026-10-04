# 2026-10-04: Closing legacy recovery mutation bypasses

- **Lesson ID:** REC-G001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox Uke native sources and isolated host fixtures
- **Evidence class:** Source and host; target build/emulation are recorded separately
- **Status:** Native refusal verified in source, host, ARM64 and focused generic guest
- **Question or previous assumption:** Did a readonly fstab and disabled FBE
  prevent stock OrangeFox Format Data from reaching a formatter?
- **Finding:** Neither is a mutation authorization boundary. A shared native
  policy now refuses Format Data before userdata/metadata lookup, unmount,
  snapshot handling or formatting. The same policy reaches legacy format,
  restore, flash, repair/resize, install/sideload, slot, boot patch, script,
  writable-mount and fastbootd paths. The unavailable live URE backend does not
  become accepted through an advanced-mode preference or a property.
- **Evidence:** Component implementation commit
  `e152b3b`; patch `0020-shared-recovery-write-gate.patch`,
  patch `0021-fastbootd-write-gate.patch`, `recovery_write_policy.hpp`,
  `tests/check-write-gate.sh` and the fixed 111-entry census. Three new host tests
  compile complete production entry functions or the production installer.
  They verify untouched regular-file bytes, no pre-refusal format/mount/slot
  callbacks and installer refusal before open/fork/ioctl. A removed format
  guard is rejected by both static census and compiled behavior.
- **Practical consequence:** Legacy managed device writes remain unavailable.
  Reviewed regular-image URE jobs retain their separate scope. A future live
  writer must carry a target-bound plan, backup, journal and fresh evidence;
  a global allow switch in the legacy policy is not an implementation shortcut.
- **Remaining uncertainty:** This is not a root-shell sandbox, an OEM HAL or
  bootloader security claim, nor a device-write or forced-reboot acceptance
  result. Previously sealed candidates remain unchanged. The new message uses
  an English fallback; this change does not complete the localization draft.
- **Next validation:** Resolve the ordered P1 findings, complete the broader
  shipping-CLI/GUI guest acceptance and retain separate exact-device gates.
- **Supersedes / superseded by:** Corrects the shared-preflight coverage claim
  identified by REC-A001 and AUD-001 without removing the historical finding.

---

- **Lesson ID:** REC-G002
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox filesystem mount implementation
- **Evidence class:** Primary kernel contract, source and mocked native syscalls
- **Status:** Readonly retry behavior corrected in source and host fixtures
- **Question or previous assumption:** Does `MS_RDONLY` alone prevent every
  filesystem write, including a fallback mount?
- **Finding:** ext4 may replay its journal under `ro`. Legacy retries discarded
  mount options; the exFAT FUSE command lacked `ro`, and the kernel-to-FAT
  fallback used flags zero. The corrected mount body retains ext3/ext4 `noload`
  and F2FS `norecovery` on retries, passes readonly options to helpers and keeps
  `MS_RDONLY` on the FAT fallback. Unknown/auto and unreviewed proprietary
  filesystem types are refused before new mounting. Existing writable or uninspectable mounts
  are rejected without an automatic remount. Slot initialization remains an
  observation and does not call the boot-control HAL.
- **Evidence:** [ext4 mount contract](https://docs.kernel.org/admin-guide/ext4.html),
  [F2FS mount contract](https://docs.kernel.org/filesystems/f2fs.html), complete
  production `TWPartition::Mount` extraction and its default/FUSE-disabled
  test variants; complete `Set_Active_Slot` extraction with counted HAL calls.
- **Practical consequence:** Preserve no-replay options independently of the
  user-supplied options. Readonly inspection after an unclean shutdown may
  expose an inconsistent view; it is not an accepted repair operation.
- **Remaining uncertainty:** Generic mocks do not establish the behavior of
  the stock kernel, an OEM filesystem driver or a live encrypted filesystem.
- **Next validation:** Preserve these options in the extracted image and
  independently verify unchanged media hashes in the generic guest; keep
  exact-device filesystem acceptance separate.

---

- **Lesson ID:** REC-G003
- **Date:** 2026-10-04
- **Environment scope:** Clean tracked-source checkpoint and Android build staging
- **Evidence class:** Host and ARM64 build failures; no tablet operation
- **Status:** Failed trials recorded; corrected ARM64 build and extracted payload verified
- **Question or previous assumption:** Would a source archive reuse all fixture
  inputs, and would recovery defaults export the policy to every build variant?
- **Finding:** The archive retains a tracked reference directory, so creating
  a link with that directory name nests the link instead of replacing it.
  The first staging trial could not locate the pinned wimlib snapshot; selected
  reference links fixed staging but missed the pinned Lucide license at a
  later host gate. All 27 CTest fixtures had passed before that infrastructure
  failure. Reusing explicit reference child links fixes the input layout.
  The first ARM64 build then failed because `libaosprecovery` uses its own
  defaults and lacked the header-library dependency added to other recovery
  targets. Its explicit dependency is now included in the reviewed patch.
- **Evidence:** Private `write-gate-native.log` and
  `recoveryimage-neutral-build.log`, isolated source checkpoint, original
  compiler errors for `install/install.cpp` and `install/adb_install.cpp`, and
  reviewed dependency correction in patch 0020. The failed ARM64 job recorded
  `oom=0` and `oom_kill=0` with a 16 GiB limit and a 6 GiB Go soft memory target.
- **Practical consequence:** Keep unrelated localization work out of this
  checkpoint, reconstruct exact patch bytes and verify each distinct target's
  header dependencies. Invalidate receipts after build-input changes instead
  of relabeling an earlier partial run as the final source validation.
- **Remaining uncertainty:** A passed host compilation cannot substitute for
  the Android target build or package inspection. The failed trial is not a
  claim that a clean build fits a physical 16 GiB host with arbitrary workloads.
- **Next validation:** Retain the final receipt hashes in REC-G007 and repair
  the host headroom/build-attestation findings before wider acceptance.

---

- **Lesson ID:** REC-G004
- **Date:** 2026-10-04
- **Environment scope:** VM preparation and actual ARM64 OrangeFox startup
- **Evidence class:** Failed host launch, generic guest log and source call chain
- **Status:** Base-theme startup correction verified by 21 completed native guest requests
- **Question or previous assumption:** Would an English fallback embedded in a
  queued GUI error remain safe when resources load later?
- **Finding:** An early guard can queue its error before the theme exists. Once
  theme resources exist, `GUIConsole::Translate_Now()` holds `console_lock`
  while converting that message. A missing `ure_device_write_blocked` key enters
  `ResourceManager::FindString()` fallback logging; its `LOGERR` calls console
  translation again and tries to reacquire the same lock. The graphics-enabled
  guest remained alive but never reached command-channel initialization. Adding
  the key to the always-loaded base English language prevents that fallback.
  Both source and extracted-image gates now require the resource.
- **Evidence:** The failed guest log stops at the first post-theme startup
  refusal, followed by the runner's FIFO deadline. The source chain is
  `gui_err` → `gui_msg` → `Message::operator std::string` → `FindString`, and
  `Translate_Now` → `FindString` → `LOGERR` → `Translate_Now`. Earlier launches
  also exposed missing explicit emulator/module-directory variables and the
  wrong generic kernel: the platform 7.2.8 build lacks virtio GPU/input closure,
  whereas the graphics VM kernel has SHA-256
  `0dafe914751929b011f6a3d8d84e47c51452de4b604d123714b64dd2546e8a80`.
  The runner now collects module dependencies before its copy loop so a failed
  `modprobe` cannot disappear inside a process substitution.
- **Practical consequence:** A returned refusal must preserve recovery's
  liveness as well as target bytes. Exercise real GUI startup in a guest;
  mocks of `gui_err` cannot prove its resource/locking behavior. Invalidate the
  earlier receipt after the base-theme/input change and repeat target/native
  checks. Launch failures and deliberately interrupted obsolete jobs are not
  successful validation runs.
- **Remaining uncertainty:** The focused resource correction does not repair
  every upstream missing-resource locking scenario or complete all translations.
  A runner that exits PID 1 on failure produces a generic kernel panic; that
  panic is a failed fixture, not evidence of a tablet kernel crash.
- **Next validation:** Preserve the base resource in future language/build
  closures and test the broader console-resource locking behavior separately.

---

- **Lesson ID:** REC-G005
- **Date:** 2026-10-04
- **Environment scope:** Native managed writers, ORS errors and generic guest runner
- **Evidence class:** Independent source review, extracted-function host fixtures
- **Status:** Sibling paths reconciled; exact-input host/sanitizer and focused guest checks passed
- **Question or previous assumption:** Did refusing the central image flasher
  also prevent every managed recovery copy, and did a refused ORS operation
  necessarily return a failure?
- **Finding:** The recovery repacker has a direct active-to-inactive `dd` path.
  Managed GUI `dd`, `cmd` and `ftls` helpers also execute writers directly;
  external ADB restore can launch `bu` outside the ordinary restore manager.
  ORS copies can remove their source and ORS handlers discard some failed
  operation results. The no-auto-reboot branch can replace failure with code 3.
  Shared early refusals now precede those paths; ORS dispatch permits only
  reviewed inspection/UI/cleanup controls, and its success override requires
  a successful operation. Startup block unlocking also refuses before BLKROSET.
- **Evidence:** Independent read-only investigation; complete production
  GUI, recovery-copy, ADB-restore and ORS-file functions compiled with counted
  command, slot, lookup, unlink and write callbacks. The updated source census
  checks 111 entries. All three focused CTest executables and the removed-guard
  regression passed against the updated sources.
- **Practical consequence:** Trace direct writers as well as named manager
  functions. A refusal must retain caller-owned files and report failure; it
  must not overwrite the fallback recovery or change block readonly state.
- **Failed trials and corrections:** The first expanded mock build lacked a
  string overload and used a copied loop variable under warnings-as-errors;
  fixture signatures and references were corrected before rerunning. The first
  guest runner unconditionally unmounted paths already cleaned by recovery,
  exited PID 1 and panicked its generic kernel. Cleanup now checks mount state.
  A combined native run failed the raw-restore interruption fixture while other
  heavy work was concurrent; the cause remains unproven until isolated reruns.
- **Remaining uncertainty:** Entry enumeration is a regression aid, not a
  universal proof for future APIs. Explicit root-terminal/ADB operations remain
  outside the boundary. No device write or physical forced restart was tested.
- **Next validation:** Keep heavy jobs serialized. The isolated interruption
  test passed in 47.65 seconds, the final native run passed and the sanitizer
  interruption test passed in 116.28 seconds. The earlier concurrency-related
  failure remains a recorded, unproven timing diagnosis; no timeout was relaxed.

---

- **Lesson ID:** REC-G006
- **Date:** 2026-10-04
- **Environment scope:** Fastbootd read-only inspection and candidate review
- **Evidence class:** Independent source review and extracted production reader
- **Status:** Confirmed compatibility regression corrected; target and payload checks passed
- **Question or previous assumption:** Did permitting `getvar` dispatch preserve
  the complete read-side path after writable partition opens were refused?
- **Finding:** `GetPartitionSize()` relied on `OpenPartition()`'s upstream
  default `O_WRONLY`. The new early writable-open refusal correctly denied that
  mode, but the ordinary size query therefore failed. The reader now supplies
  `O_RDONLY` explicitly. Its complete production function is compiled with the
  actual guarded opener and the unchanged write-default declaration in mocks.
- **Evidence:** Fresh read-only candidate review; the newly added reader fixture
  first reproduced `Read-only fastboot partition-size query failed`. After the
  explicit readonly correction, physical, nonzero logical, zero-length logical
  and missing-argument cases passed together with all write-refusal cases.
  Updated three-executable CTest and 111-entry census both passed.
- **Practical consequence:** Check legitimate readers through their actual
  callers, not only direct test invocations supplying already-safe flags. Keep
  readonly intent explicit without changing every writer's default silently.
- **Remaining uncertainty:** This fixture does not establish physical USB
  transport, device-mapper behavior or an OEM HAL's side effects. The candidate
  review found no further confirmed bypass within its stated managed boundary;
  that conclusion is scoped, not a whole-repository security certificate.
- **Next validation:** Keep physical transport and device-mapper acceptance
  separate; require this actual-reader control whenever the opener changes.

---

- **Lesson ID:** REC-G007
- **Date:** 2026-10-04
- **Environment scope:** Neutral tracked-source checkpoint, current ARM64 payload,
  host fixtures and a disposable graphics-enabled generic ARM64 guest
- **Evidence class:** Source, build, package, host and focused emulation; no hardware
- **Status:** AUD-001 source remediation verified; broader release acceptance remains open
- **Question or previous assumption:** Can one passing fixture or an unchanged
  staged directory substitute for the complete mutation-refusal verification?
- **Finding:** The final frozen inputs passed 111 entry checks, the compiled
  removed-Format-Data-guard regression, 27/27 native CTest executables (215.43 s),
  all native CLI/tool checks and 27/27 pinned Clang address/undefined/leak CTest
  executables (423.80 s). The known pinned-runtime exclusion for vptr remains
  explicit. The input manifest SHA-256 for both native and sanitizer checks is
  `6961f3cc5f34bb793b76c9d524069e2a71ea1127ce1a16012b35dee8d2050e62`.
- **Evidence:** The corrected ARM64 build completed in 4 min 52 s. The actual
  header-v4 recovery image has 104,857,600 bytes and SHA-256
  `7049453d8d9fc54284acb9aded260e2464dcf822fbf99478ddf1e2a172d3ec78`.
  Its compressed ramdisk has 38,016,604 bytes. Extraction checked 206 AArch64
  ELFs, dependency/interpreter closure, both embedded archives, privacy, no
  Python payload, current policy markers and the base refusal resource.
  Two package productions matched byte-for-byte; source snapshots retained
  upstream licenses and the exact reviewed patch stack.
- **Emulation evidence:** 21 actual recovery FIFO requests completed, including
  confirmation refusal, format/repair/resize/wipe/install/sideload writers, managed
  ORS mutations/source retention, recovery reflash, MTP refusal and inspection
  after failure. Both entire newly created 128 MiB media hashes were unchanged.
  The media were writable QEMU attachments but `ro,noload` guest mounts. The
  guest used the pinned generic 7.2.8 kernel, matching modules, synthetic
  properties, a disposable fstab and a memfd code-cache adapter. The shipping
  recovery ELF hash is
  `99f7fa7f8ae01aba1c1c3f33e885dcc4a2cd1331f0cf41a3e02c0bef39a1fff2`.
- **Resource evidence:** Recorded cgroup peaks were 14,262,444,032 bytes for
  ARM64 build, 14,083,526,656 for native checks, 3,712,266,240 for sanitizers and
  1,330,552,832 for the focused guest. Each recorded zero `high`, `oom` and
  `oom_kill` events. These are jobs under a 16 GiB ceiling on this host, not
  proof of adequate desktop reserve on a complete 16 GiB computer.
- **Practical consequence:** Keep the new source closure and focused test
  evidence together. The neutral checkpoint excludes the unrelated localization
  and capacity drafts; it does not validate those drafts. Existing sealed
  candidates were not changed and do not acquire the new policy retroactively.
- **Failed final sealing trial:** The general candidate sealer refused the
  current record because broad QEMU-user shipping-CLI acceptance is false in
  the extracted-image receipt. The focused recovery guest is a different
  evidence class. The gate was retained; this candidate remains unsealed and
  no binary release was published. Broader VM acceptance belongs to the ordered
  P1 follow-up and final combined validation.
- **Remaining uncertainty:** No tablet, host block device, live storage write,
  physical forced restart, shipping-kernel boot, physical USB fastboot, complete
  visual review or whole-roadmap acceptance occurred. Generic shutdown notices
  remain in the private console log; they are not tablet kernel failures.
- **Next validation:** Complete P1 remediation in report order, then run the
  broader shipping-CLI, GUI and filesystem guest matrix and seal only current
  matching receipts. Keep exact model/SKU, firmware, geometry and physical
  fallback acceptance unavailable until separately evidenced.
- **Supersedes / superseded by:** Supersedes AUD-001's vulnerable-source state
  for this new source/payload closure; other AUD findings remain separate.
