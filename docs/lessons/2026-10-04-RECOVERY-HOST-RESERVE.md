# 2026-10-04: Admit host builds within shared memory headroom

## REC-HOST001: A fixed build maximum is not a desktop reserve

- **Lesson ID:** REC-HOST001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox host build and native/sanitizer entry points
- **Evidence class:** Source, synthetic policy snapshots and actual owned systemd service
- **Status:** Source/host remediation of AUD-022; full-build acceptance open
- **Question or previous assumption:** A 16 GiB hard job maximum could be used unchanged on a 16 GiB computer.
- **Finding:** Admission reads physical available memory, permitted CPUs and ancestor high/max/current accounting, preserving at least 4 GiB or 25% of effective capacity. The service recalculates after acquiring its heavy-job lock, retains its earlier leaf ceiling, verifies exact unit membership, tightens/readbacks memory limits and checks OOM grouping. Native/Android scheduling and sanitizer cost differ; requested j16 remains a maximum and is clamped to admission. Nice 5 favors interactive work. Unavailable accounting, insufficient reserve and explicit nested admission refuse before heavy work.
- **Evidence:** Host policy tests cover 16 GiB, larger j16-capable capacity, constrained shared ancestors, high thresholds, owned-leaf ceilings, CPU lists, malformed data and low available memory. Real systemd jobs verified readback and failure propagation. A fully available 16 GiB snapshot produces a 12 GiB envelope, 13 normal or eight sanitizer workers, and six Soong runtime processors with a 6 GiB soft heap.
- **Practical consequence:** The build ceiling accounts for the rest of the host and does not silently wait on a lock it already owns. Only the new service's limits are modified.
- **Remaining uncertainty:** Snapshot state can change, worker allowances are estimates, and a translation unit can still exceed its own job limit. This is not a diagnosis of the owner's earlier task crashes or a full-load desktop responsiveness result.
- **Next validation:** Fix nested disk scratch and immutable build receipts, then measure fresh clean/warm Android jobs and actual interactive response before wider acceptance.

## REC-HOST002: Runtime environment limits must survive upstream launchers

- **Lesson ID:** REC-HOST002
- **Date:** 2026-10-04
- **Environment scope:** Existing pinned Soong/Blueprint and host Go compiler
- **Evidence class:** Reviewed source stack and actual upstream host package compilation/tests
- **Status:** Host policy retention verified
- **Question or previous assumption:** Exporting GOMAXPROCS alongside a separate Ninja count would constrain the graph builder.
- **Finding:** Soong now preserves GOMAXPROCS with GOMEMLIMIT/GOGC across its clean environment. Blueprint no longer resets runtime parallelism to NumCPU, its bootstrap compile setting uses the admitted Go runtime, and microfactory forwards runtime limits into compiler children and chooses compiler concurrency from it. Exact reviewed-prefix staging protects unknown edits. No new Go application or runtime is added to tablet payloads.
- **Evidence:** Soong pin `6dc77879464584ef3f178cae622134ed0bf19e1e`, Blueprint pin `dcb14f2e146f40cf1f212efb220e9aa1f3cfc280`, preserved patch 0013 plus new patches 0028/0029. Pinned Go 1.23.4 binary SHA-256 `c4859c0d97fe48a45d348c8ceba892a5c2ca1d7f3e429cf3ea4f2c0dae5cc406`. Actual RunBlueprint is invoked with an empty module list and verifies that its ordinary validation error does not change a two-processor runtime policy. Bootstrap/microfactory packages compile and tests pass offline; unknown edits remain byte-identical after staging refusal. Existing recovery stack controls pass separately.
- **Practical consequence:** Compiler and graph-builder parallelism are separate admitted values. Environment exports alone cannot substitute for reviewing a launcher's reset/child behavior.
- **Remaining uncertainty:** Soong environment-map changes are source/stack-verified; a full newly compiled Android graph/image is still pending. Go's limit is soft and each child/charged cache participates in the aggregate cgroup envelope.
- **Next validation:** Fresh whole host frontend and recovery compilation after the remaining source/output/temp gates close.

## REC-HOST003: Cache activity, RSS and cgroup charging need separate receipts

- **Lesson ID:** REC-HOST003
- **Date:** 2026-10-04
- **Environment scope:** Small cold/warm C++ and pinned Go reference-host fixtures
- **Evidence class:** Actual compiler object/cache oracle and private per-service accounting
- **Status:** Frozen host controls passed
- **Question or previous assumption:** Enabling ccache could establish that fresh-build memory pressure had disappeared.
- **Finding:** A fresh private cache compiles an actual C++ object, recompiles after removing the object and proves identical bytes plus a real cache hit. The small cache job records 45,113,344 cgroup peak bytes, 61,156 KiB command maximum RSS and 0.37 seconds. The Go package job records 332,845,056 cgroup peak bytes, 188,044 KiB command RSS and 18.04 seconds. Both record zero OOM counters and zero avg10/avg60/avg300 host memory PSI at the final snapshot. Initial/admitted policies, before/after memory/events/statistics, PSI, tasks/CPU and cache counters remain private.
- **Evidence:** Frozen native-source input manifest SHA-256 `5a86c844d48e4aed6e602bac77fbbb9eafed8ad9874f40ce54150fb4b80a9088`; final host-policy, builder and existing-stack logs; inputs remained identical across those runs. Nonzero command status and missing completion cannot become a pass. Command RSS is available only when the host time utility is present; actual OOM termination was not induced in this checkpoint.
- **Practical consequence:** Report cache behavior and measurement scope explicitly; RSS includes shared resident mappings and differs from charged cgroup peak. Ccache does not cache Go graph generation, linking, packaging, tests or VM execution.
- **Remaining uncertainty:** Small jobs, final snapshot PSI and zero OOM events do not establish full-image clean/warm behavior. Other jobs outside this wrapper can affect shared caches and pressure. Android inner tmpfs remains AUD-023 work.
- **Next validation:** Capture full clean/warm image receipts after disk-scratch/output closure; retain separate package/guest and physical acceptance.

## REC-HOST004: Correct test inputs without weakening admission

- **Lesson ID:** REC-HOST004
- **Date:** 2026-10-04
- **Environment scope:** Failed and corrected host fixture trials
- **Evidence class:** Compiler/parser errors, policy input oracles and actual cache statistics
- **Status:** Corrected, with failed trials retained
- **Question or previous assumption:** The initial fixture expectations accurately represented every threshold and cache counter.
- **Finding:** An awk printf ternary lacked grouping and failed before admission; explicit parentheses corrected parsing. A nested fixture expected a 4 GiB budget although its parent high threshold was 7 GiB; applying the 4 GiB reserve correctly yields 3 GiB, and the oracle now asserts that result. A real warm-cache hit initially failed an assertion using nonexistent counter names; actual `direct_cache_hit` / `preprocessed_cache_hit` statistics corrected the oracle without relaxing object identity. An early setup glob assumed preexisting bootstrap test files and exited; the final disposable host test provides its explicit production-entry-point fixture.
- **Evidence:** Initial failed policy/cache traces and successful frozen controls are retained privately. Actual warm counter and identical object hashes preceded the corrected assertion. No failed command was marked successful by the wrapper.
- **Practical consequence:** Threshold or counter mistakes in a test do not justify changing the reserve, accepting an unbounded build or weakening cache validation.
- **Remaining uncertainty:** None of these host fixture failures is evidence of a tablet defect or the cause of the earlier task shutdowns.
- **Next validation:** Preserve these edge inputs and separate input/oracle failures from product failures in later build receipts.
