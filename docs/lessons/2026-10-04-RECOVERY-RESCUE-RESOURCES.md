# 2026-10-04: Aggregate rescue enforcement and supervisor lifetime

## REC-RSRC001 — Namespace isolation did not bound total resource use

- **Lesson ID:** REC-RSRC001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox recovery source and native host fixtures.
- **Evidence class:** Source, native build, host kernel; no tablet evidence.
- **Status:** Implemented; target and combined guest acceptance remain open.
- **Question or previous assumption:** Could namespace isolation, timeout and per-process limits keep an installed command within the recovery memory/process budget?
- **Finding:** The original chroot had no aggregate memory/PID/CPU envelope. The new compiled cgroup-v2 backend configures and reads back memory.max/high, swap.max, oom.group, pids.max and cpu.max before admitting a blocked worker. Missing real controllers/delegation or GUI/ancestor headroom refuses execution before session ownership/journal effects. Per-process limits are supplemental; UID-zero RLIMIT_NPROC is explicitly not an accepted substitute.
- **Evidence:** `libuke/rescue_resources.cpp`, `rescue.cpp`, sealed resource policy and strict read-only `linux rescue-capabilities`; primary [kernel cgroup-v2 documentation](https://docs.kernel.org/admin-guide/cgroup-v2.html). Default 1 GiB/two jobs/128 tasks, bounded choices 128–2048 MiB/1–4 jobs/16–256 tasks, tmpfs quarter-budget and 512 MiB additional admission reserve.
- **Practical consequence:** Installed descendants and tmpfs allocations share the same group. Callers cannot select a fake controller path/backend or permit an unbounded fallback. Current proc membership uses its numeric PID, preserving the root resolver's no-magic-symlink policy. A delegated namespace's mount-root memory limit also participates in admission.
- **Remaining uncertainty:** Admission cannot reserve memory against unrelated workloads. Shipping Android controller layout/delegation and target-kernel enforcement are not accepted. No host result enables a tablet write.
- **Next validation:** Exact target build/package closure and later combined guest/physical resource acceptance, including protected negative OOM inheritance.

## REC-RSRC002 — Supplemental OOM eligibility needed a host-compatible policy

- **Lesson ID:** REC-RSRC002
- **Date:** 2026-10-04
- **Environment scope:** Native unprivileged host and private user namespaces.
- **Evidence class:** Source and failed/corrected host control.
- **Status:** Corrected; original failed fixture retained privately.
- **Question or previous assumption:** Should every installed worker set oom_score_adj to exactly zero?
- **Finding:** The first fixture's expected namespace refusal instead returned `rescue-resource-unavailable` before unshare. The desktop worker inherited a positive OOM adjustment; lowering it to zero was unnecessary and could be denied by the inherited unprivileged minimum. The corrected worker preserves an existing nonnegative value and resets only negative protection to zero, with readback.
- **Evidence:** Private `rescue-before-process-limit-correction-test.log` and its retained native state; `rescue_process_limits`. An earlier fixture also used direct JsonCpp unsigned/signed equality for default pids/jobs; explicit validated numeric conversion corrected that oracle before execution.
- **Practical consequence:** Eligible host workers are not rejected merely to lower their OOM score. The installed session must not inherit the recovery GUI's negative OOM protection. Core/files/scheduler failures remain explicit refusal.
- **Remaining uncertainty:** A protected negative score under the shipping recovery's privileges has not been physically exercised.
- **Next validation:** Target negative-score control plus exact user-namespace and instrumented receipts.

## REC-RSRC003 — A local memory throttle is not an observed OOM kill

- **Lesson ID:** REC-RSRC003
- **Date:** 2026-10-04
- **Environment scope:** Fresh delegated host user scope with a 1 GiB outer memory limit; workload group 128 MiB/one CPU/16 tasks.
- **Evidence class:** Real host kernel enforcement, distinct from VM and tablet evidence.
- **Status:** Corrected stress oracle; initial failed trials preserved.
- **Question or previous assumption:** Would touching 256 MiB inside the group necessarily produce memory.events.oom_kill before a five-second deadline?
- **Finding:** Both page-by-page allocation and writable population were throttled at memory.high before reaching the hard limit. The deadline correctly killed the group; oom_kill remained zero. Treating that as an OOM failure was an incorrect test oracle. The corrected test requires incomplete bounded allocation, a measured bounded memory peak and either a real local OOM kill or recorded high-pressure throttling plus responsive outside supervision/deadline termination.
- **Evidence:** Private `rescue-before-memory-population-stress.log`, `rescue-before-throttle-oracle-stress.log`, native `rescue_stress.cpp` and the final separate native/instrumented host stress receipts. The first successful native trial recorded 498 outside ticks and 11 ms maximum gap during memory pressure; CPU stress recorded 200 ticks/11 ms gap, pids.events.max increased, and every group was empty and removed.
- **Practical consequence:** Keep the production memory-high protection. Do not weaken limits or fabricate an OOM claim to make a test pass. The wrapper changes only its fresh uniquely named user scope, never existing desktop/service cgroups.
- **Remaining uncertainty:** Outside-supervisor heartbeat is not GUI frame/input latency. The successful trial used host kernel controls, not a shipping Android kernel or tablet.
- **Next validation:** AUD-013 GUI status/cancel latency and later combined guest/target controller acceptance.

## REC-RSRC004 — Descriptor visibility was part of resource isolation

- **Lesson ID:** REC-RSRC004
- **Date:** 2026-10-04
- **Environment scope:** Source and real disposable namespace/ESP host sessions.
- **Evidence class:** Source and host kernel fixture.
- **Status:** Corrected.
- **Question or previous assumption:** Was a read-only sys mount sufficient to prevent an installed payload from reaching its supervisor's writable controller descriptors?
- **Finding:** Descriptor inheritance and private proc visibility also needed review. The worker closes inherited controller descriptors before namespace creation. Namespace init becomes nondumpable, and the executed payload lacks ptrace/mount/resource capabilities. The real read-only session rejected access to `/proc/1/root` and the supervisor descriptor while retaining its intended private proc/sys/dev/runtime environment.
- **Evidence:** `RescueResources::close_in_child`, `rescue_process_limits`, init setup, capability allowlist and `tests/check-rescue.sh` descriptor checks.
- **Practical consequence:** Installed commands cannot borrow recovery controller/journal/root descriptors through the namespace supervisor's proc aliases. The payload also receives read-only proc, preventing it from restoring an inherited minimum OOM exemption or changing process/kernel proc controls. The real fixture rejects a normally permitted positive self OOM adjustment. Aggregate enforcement remains fixed by the recovery parent.
- **Remaining uncertainty:** This is a bounded interface control, not a complete security proof for every installed program or kernel vulnerability.
- **Next validation:** Shipping kernel/proc privilege behavior and combined target fixture.

## REC-RSRC005 — Cancellation acknowledgement and verified closure differ

- **Lesson ID:** REC-RSRC005
- **Date:** 2026-10-04
- **Environment scope:** Native/instrumented host fault controls and real disposable chroot sessions.
- **Evidence class:** Source and host fixtures.
- **Status:** Implemented; external restart recovery and GUI acceptance separate.
- **Question or previous assumption:** Could a separate controller cancel a running chroot without borrowing its writer token or trusting a persisted PID?
- **Finding:** `linux rescue-cancel` validates the private sealed journal/hash and exact retained owner, then durably publishes a bounded request. It acknowledges only the request. The existing supervisor performs pidfd/whole-group termination, verifies group emptiness/removal, mount lifetime and required filesystem sync, and alone retires ownership. A verified empty/removed group also closes the lifetime when termination preceded the init-pidfd handoff. Failure of the first resource cleanup retains ownership and blocks reboot admission.
- **Evidence:** Production cancellation dispatch; link-only factory wrappers exercise missing controllers, attachment refusal before unshare, fork/unshare failures, deadline, exact cancellation hash, unsafe plan permissions/hardlinks, conservative failed cleanup and explicit independent fixture recovery. Private control records are bounded, metadata-validated and read through one retained descriptor. Actual namespace sessions separately exercise timeout/cancel without backend substitution.
- **Practical consequence:** No saved-PID kill, caller-selected backend, early cleanup claim or destructor-based owner retirement. Short completed control/admission exclusion is retried for at most one second only before retirement effects; durability and owner mismatch errors are never retried. A deterministic held-control fixture checks terminal serialization.
- **Remaining uncertainty:** External forced-restart recovery of unresolved resource/mount journals is not an accepted automatic owner-release path. Writable package/shell operations remain non-atomic. GUI request handling follows in AUD-013.
- **Next validation:** GUI executor/lifecycle ownership followed by combined restart/resource acceptance; keep unresolved ownership intact until independent recovery proof exists.

## REC-RSRC006 — Verification receipts

- **Lesson ID:** REC-RSRC006
- **Date:** 2026-10-04
- **Environment scope:** Native compiler, pinned Clang ASan/UBSan/leak instrumentation, real delegated host cgroups and copied native ELF fixtures.
- **Evidence class:** Build and host tests only.
- **Status:** Matching source/build/host receipts complete; broader target acceptance open.
- **Question or previous assumption:** Did the actual production backend and fault controls pass against the same source inputs?
- **Finding:** Eight native controls passed in 25.89 seconds and the same eight pinned Clang ASan/UBSan/leak controls in 54.16 seconds. Both builds separately passed actual host cgroup stress and namespace CLI sessions. Allocation was locally throttled and deadline-terminated in both, not recorded as an OOM kill. The native memory supervisor measured 499 ticks/11 ms maximum gap; CPU supervision 200 ticks/11 ms gap. Instrumented memory measured 499 ticks/11 ms and CPU 199 ticks/11 ms. All four workload groups were independently empty/removed, pids and CPU events confirmed the relevant limits, and the 2 GiB request was refused against the outer 1 GiB scope before workload creation. A link-only backend mock never claims aggregate kernel enforcement; actual stress/session checks use the unchanged compiled backend.
- **Evidence:** Both final input comparisons matched private `build/p1/rescue-resource-frozen-inputs.sha256`, SHA-256 `32821b0dc20dfa01578ecf92b747ab5aa1efd3fe61f0fecb7107d8de40605525`. Distinct native/instrumented build, eight-test, stress and CLI logs are preserved, together with pre-read-only-proc and pre-retained-record input/receipt snapshots. Independent host capability and unrelated-option refusal also passed. No fresh independent agent review was obtained in this continuation.
- **Practical consequence:** No GitHub publication, ARM64 package, VM result or physical support record is inferred from these receipts.
- **Remaining uncertainty:** Fresh target build, combined VM, real Arch/Fedora repair, GUI rendering and physical device acceptance remain open.
- **Next validation:** Finish matching checks, focused local commit, then AUD-013 in original order.
