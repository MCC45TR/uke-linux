# 2026-10-04: Retain GUI job ownership through control and application teardown

## REC-LIFE001: Lifecycle exclusion needs a retained lease

- **Lesson ID:** REC-LIFE001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox recovery and fastbootd lifecycle integration
- **Evidence class:** Source and reference-host native/sanitizer fixtures
- **Status:** Source/host remediation; target and physical gates open
- **Question or previous assumption:** A maintenance-running flag could establish global unmount/reboot exclusion.
- **Finding:** GUI executors acquire a shared runtime activity lease before publishing queue admission. Stock lifecycle guards retain an exclusive lease through the effect, preventing a new job between a busy check and unmount/reboot. A dependency-free header fixes the Android domain at `/tmp/ure-job-registry`, validates private real directories and single-link regular locks, binds descriptor identity and limits local registrations to 64. Forked processes cannot adopt their parent's local ownership. Host-selected paths cannot override the shipping policy.
- **Evidence:** `job_registry.hpp`, production lifecycle callbacks, independent-process contention/path/identity fixtures and a shipping-policy fixture compiled without exceptions or RTTI. The final eighteen-test native and sanitizer groups both passed.
- **Practical consequence:** Runtime exclusion does not depend on the selected page or on a later durable journal being ready. Registry failure refuses admission.
- **Remaining uncertainty:** This is cooperating volatile ownership, not forced-restart durability or admission of the unfinished live Android storage writer. Host policy compilation is not an ARM64 recovery build.
- **Next validation:** Fresh Android compilation/package closure, combined guest lifecycle tests and separately authorized physical acceptance.

## REC-LIFE002: A stop controller must keep the original backend identity

- **Lesson ID:** REC-LIFE002
- **Date:** 2026-10-04
- **Environment scope:** Native rescue and Btrfs management through the actual GUI adapter
- **Evidence class:** Source and exact-descriptor reference-host fixtures
- **Status:** Host-verified control binding
- **Question or previous assumption:** Changing the selected root or journal after queueing could redirect a maintenance control.
- **Finding:** A separate joinable controller receives the original retained root descriptor, sealed plan, job identity and journal. GUI cancellation can queue an exact rescue or scrub/balance control without taking the main worker's I/O lock. Admission, advisory cancellation and the native control result are distinct records. A balance pause or failed worker retains durable ownership until native inactivity is independently verified; only the captured cleanup route can retire it.
- **Evidence:** Actual GUI rescue cancel/teardown and Btrfs scrub-cancel, balance-pause/cancel, failed-worker cleanup and wrong-hash fixtures. Changed roots, paths and page epochs cannot retarget the controller; original marker bytes and foreign-thread DataManager access are checked independently. The English-only publication base passed both controller fixtures separately.
- **Practical consequence:** The GUI remains able to inspect or stop owned work without claiming that an acknowledgement has completed cleanup.
- **Remaining uncertainty:** Rescue tests pause before real unshare and replace resource creation; Btrfs tests replace ioctl/fstatfs only for the exact fixture descriptor. These are not real namespace, cgroup or Btrfs kernel acceptance.
- **Next validation:** Exercise the same controls in the combined disposable guest and preserve native terminal/journal oracles.

## REC-LIFE003: Teardown must join supervisors before disposing resources

- **Lesson ID:** REC-LIFE003
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox application and owned native executors
- **Evidence class:** Reviewed upstream patch and native/sanitizer lifetime tests
- **Status:** Source/host remediation
- **Question or previous assumption:** Removing a detached worker alone would cover application shutdown and backend exceptions.
- **Finding:** The reviewed `twrp.cpp` hook closes new admission before application resources are disposed, queues an available exact stop controller and joins controllers without dropping that queued control. It then joins the original supervisors outside the GUI state mutex. Captured callbacks and descriptors are released on success and exception paths before completion publication. Concurrent shutdown callers retain joined-worker behavior.
- **Evidence:** Patch `0027-join-management-jobs-before-teardown.patch`, reviewed full patch-stack/unknown-change controls, concurrent executor joins, actual GUI rescue shutdown, Btrfs failed-worker cleanup and leak-enabled sanitizer fixtures.
- **Practical consequence:** A returned application worker cannot outlive the objects it uses. Noninterruptible native I/O can still delay orderly shutdown, and a returned worker does not establish backend cleanup.
- **Remaining uncertainty:** The original audit described a lifetime concern; no original use-after-free was reproduced. External forced reboot is outside orderly teardown.
- **Next validation:** Fresh target build and combined guest cancellation/shutdown, followed by independent physical restart durability work.

## REC-LIFE004: Preserve distinct errors and read the reviewed journal destination

- **Lesson ID:** REC-LIFE004
- **Date:** 2026-10-04
- **Environment scope:** Reference-host integration trials
- **Evidence class:** Failed tests, corrected production ordering and corrected test oracles
- **Status:** Corrected, with failed logs retained privately
- **Question or previous assumption:** Every blocked operation should report the new runtime-lifecycle code, and the rescue GUI would populate a mutable journal field before execution.
- **Finding:** A first contention expectation was corrected in the wrong writer context and failed: persistent writer contention remains `operation-busy`, while held lifecycle activity reports `gui-lifecycle-busy`. Inherited leases initially reached runtime validation before process validation; checking process identity first restores `operation-lease-inactive`. Rescue controller trials then used an empty mutable GUI journal field and failed their journal oracle despite successful cancellation. Both scenarios now read `journal_directory` from the reviewed plan result.
- **Evidence:** Private failed receipts `gui-registry-before-expectation-correction.log`, `gui-registry-before-inherited-token-correction.log` and `gui-lifetime-before-journal-oracle-correction.log`; final tests passed without weakening ownership or cleanup assertions.
- **Practical consequence:** New exclusion must preserve existing error contracts. Tests must inspect the immutable reviewed destination rather than guess mutable GUI timing.
- **Remaining uncertainty:** These corrected host failures are not evidence of tablet behavior or a hardware fault.
- **Next validation:** Retain these exact error/journal assertions in later combined guest coverage.

## REC-LIFE005: Bind final results to frozen inputs and the publishable GUI source

- **Lesson ID:** REC-LIFE005
- **Date:** 2026-10-04
- **Environment scope:** Normal native build, pinned Clang ASan/UBSan build and selective publication
- **Evidence class:** Build and reference-host tests
- **Status:** Eighteen native and eighteen sanitizer tests passed
- **Question or previous assumption:** Passing a GUI fixture against a working tree would automatically validate the English-only source selected for publication.
- **Finding:** Both full native libraries/builds completed with two parallel compile jobs and ccache. Eighteen native tests passed in 90.61 seconds; the same eighteen leak-enabled ASan/UBSan tests passed in 160.54 seconds. Source inputs stayed identical to the frozen manifest. Existing localization drafts were preserved outside the staged GUI change, and the independently reconstructed English-only source compiled and passed the actual rescue/Btrfs controller fixtures. The first reconstruction attempt used the working-tree path instead of the intended scratch directory and refused before modifying source; explicit scratch-directory application corrected it.
- **Evidence:** Frozen manifest SHA-256 `4f1ee855ee61042e0b219fc42da1084d0499b4d6ba44a42f02fcd17811d91622`; private native/sanitizer build and test logs; English-only GUI SHA-256 `19e4b0fd9ad4e3ed12da92a7e64e1c2136dcafc917b5e6d648f787c4f437b23b`; separate public-base controller logs. Native-input receipts now include the maintained theme and actual application teardown source.
- **Practical consequence:** Commit only reviewed English GUI changes; a working-tree localization dependency remains explicit and does not become a published translation claim. Preserve focused receipts and unrelated drafts. The publication whitespace guard initially flagged a required final empty context line in the new unified diff. Patch-file attributes now also allow that end context, while ordinary source whitespace checks remain enabled; no tested patch or generated source changed.
- **Remaining uncertainty:** These runs do not include a new Android package, the complete later P1 changes, rendered visual/locale acceptance or either tablet. No fresh independent agent review completed for this checkpoint.
- **Next validation:** Continue AUD-015 and the remaining ordered P1 items, then fresh target/package and combined VM acceptance before P2 work.
