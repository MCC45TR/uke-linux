# 2026-10-04: Owned recovery jobs and measured host control latency

## REC-J001: Management I/O must not own the GUI state mutex

- **Lesson ID:** REC-J001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox Uke recovery; portable and actual-callback reference-host fixtures
- **Evidence class:** Source and reference-host tests
- **Status:** Corrected within the AUD-013 source/host scope
- **Question or previous assumption:** A synchronous management callback held its session mutex across hashing, copy, filesystem tools and rollback. Btrfs maintenance instead detached a worker that published GUI values directly.
- **Finding:** An explicit management session owns its plans, editor and retained roots. The joinable worker uses frozen variables and returns bounded updates. Actual DataManager publication occurs when the GUI collects completion, outside native backend I/O. A second job is refused while the first session is owned; status, advisory stop and short display actions remain reachable.
- **Evidence:** Component `ure-gui.cpp`, `libuke/gui_job.cpp`, `tests/ure/gui_job_latency.cpp`, actual management/boot/stock callback fixtures and reviewed patch `0026-owned-management-jobs.patch`. Fixtures count foreign-thread DataManager access and observed none.
- **Practical consequence:** Queue admission and completion have different APIs and receipts. The renderer collects completed jobs, while active jobs shorten its existing idle-input timeout to 50 ms.
- **Remaining uncertainty:** A host UI stand-in does not measure rendered frame latency, shipping Android behavior or a physical tablet.
- **Next validation:** Connect AUD-014's global lifecycle registry and backend controllers; perform the combined guest and visual acceptance after ordered P1 work.

## REC-J002: Bounded messages require shape and serialization checks

- **Lesson ID:** REC-J002
- **Date:** 2026-10-04
- **Environment scope:** Native executor and OrangeFox adapter
- **Evidence class:** Source and native/instrumented reference-host tests
- **Status:** Corrected
- **Question or previous assumption:** Counting visible string bytes alone would bound copied requests and JSON result publication.
- **Finding:** The executor checks valid UTF-8 without NUL, complete object keys, escaped byte cost, finite numbers, 16 levels, 131,072 nodes and 64 descriptors before copying. Inputs have a 16 MiB limit; one result has a 256 KiB limit. The adapter additionally bounds captured variable text to 512 KiB and update text to 192 KiB. Invalid results remain inspectable errors, with backend cleanup unverified.
- **Evidence:** Executor fixtures reject nonfinite numbers, truncated/overlong UTF-8, malformed keys, NUL, escape amplification, deep nesting, output overflow and missing object results. They verify exact job identity, captured descriptors, once-only collection and concurrent joined shutdown.
- **Practical consequence:** Publication failure cannot be presented as backend cancellation, rollback or owner retirement. Reviews that were not published are invalidated.
- **Remaining uncertainty:** Native backend memory, captured management-plan sizes and unrelated process pressure are separate budgets; this does not establish a whole-recovery RSS ceiling.
- **Next validation:** Continue AUD-015 and build/runtime resource admission; retain target and stress/frame acceptance separately.

## REC-J003: Six-LUN display projections must preserve the write decision

- **Lesson ID:** REC-J003
- **Date:** 2026-10-04
- **Environment scope:** Stock restore image fixtures and actual OrangeFox callback
- **Evidence class:** Source and reference-host tests
- **Status:** Corrected after a failed publication trial
- **Question or previous assumption:** The entire nested six-LUN plan could be displayed inside the bounded GUI mailbox.
- **Finding:** The first trial exceeded the adapter's per-value limit because it repeated current, desired and reconstructed GPT tables. The corrected projection retains all programming extents, complete layout changes, warnings, source observations, model/SKU limitations and plan hashes; repeated tables are represented by hashes and policy metadata. It is explicitly marked as a non-executable GUI projection. The complete sealed plan remains owned by the session and reaches the native executor unchanged.
- **Evidence:** Private `gui-stock-output-budget-diagnosis.log` preserves the failure. Actual six-LUN GUI controls now check the projection marker, all LUNs, bounded mailbox, slot sets, changed SKU/model/boot-policy refusal, exact image commit and complete rollback. Native and sanitizer controls passed.
- **Practical consequence:** Do not increase a GUI allocation budget just to duplicate a storage plan. A display projection must not be accepted as a sealed execution plan or omit the effects and warnings needed for review.
- **Remaining uncertainty:** These are declared image capacities and source profiles, not measured physical UFS geometry or Android boot compatibility.
- **Next validation:** Exact unit/profile and shipping-target acceptance remain required before live storage support.

## REC-J004: Stop acknowledgement is distinct from native cleanup

- **Lesson ID:** REC-J004
- **Date:** 2026-10-04
- **Environment scope:** Owned worker and real regular-image I/O
- **Evidence class:** Source and reference-host latency/data verification
- **Status:** Corrected reporting; backend GUI controls remain a separate item
- **Question or previous assumption:** A responsive stop button could be treated as proof that a running native operation had stopped.
- **Finding:** The exact job receives an `ADVISORY_FLAG_ONLY` acknowledgement. It may stop before entering its backend at a reviewed checkpoint. A started hash, copy, filesystem tool or rollback may complete. Worker return and requested cancellation never imply kernel, namespace, mount, byte or durable-owner cleanup.
- **Evidence:** Real 512 MiB hash and backup plus 320 MiB ext4 resize/rollback continued status sampling and advisory requests. Native maximum status latency was 1 ms and acknowledgements were 0 ms at millisecond resolution. Instrumented maximum status latency was 28 ms and acknowledgements were at most 1 ms. Queue admission was at most 4 ms native and 21 ms instrumented. Independent backup verification, an ext4 superblock size oracle and original-image digests passed.
- **Practical consequence:** Show the final backend result and journal. Avoid interrupting a storage write merely to make a stop button appear immediate.
- **Remaining uncertainty:** The GUI flag is not the existing native exact-owner rescue/Btrfs controller. AUD-014 must connect those separate controllers, global lifecycle exclusion and application teardown. No physical latency is inferred.
- **Next validation:** Exact-owner control during a running worker, unmount/reboot admission and forced-restart recovery in the appropriate later acceptance environment.

## REC-J005: Changed selections cannot consume an old review

- **Lesson ID:** REC-J005
- **Date:** 2026-10-04
- **Environment scope:** Frozen management session, editor and display callbacks
- **Evidence class:** Source and actual-callback reference-host tests
- **Status:** Corrected
- **Question or previous assumption:** A result computed before a selection or page change could safely replace current values.
- **Finding:** Selection mismatch or an explicit changed view epoch preserves the completed result for inspection but rejects its GUI updates and review state. Confirmation hashes and apply affordances are invalidated. Editor previews now stop at complete UTF-8 scalar boundaries; binary console bytes remain private records.
- **Evidence:** The timed hash fixture changes its source during work and verifies that the worker neither opens the new source nor resets its selection. Actual editor callbacks test a non-ASCII 64 KiB preview boundary and a changed epoch. The applied display scale is captured for preference storage, and normal scale/mirror/widget regressions pass.
- **Practical consequence:** Capture inputs explicitly; do not let a worker read mutable DataManager values or publish cached reviews into a changed view.
- **Remaining uncertainty:** Independent DataManager reads are not an atomic multi-variable application snapshot. Matching checks are conservative and include captured display preferences; a scale change can require another management review.
- **Next validation:** Combined rendered portrait/landscape navigation and input tests after ordered P1 fixes.

## REC-J006: Broader source hooks exposed integration mistakes

- **Lesson ID:** REC-J006
- **Date:** 2026-10-04
- **Environment scope:** Host compilation and reviewed OrangeFox source stack
- **Evidence class:** Failed build trials, corrected source and host regressions
- **Status:** Corrected
- **Question or previous assumption:** The extracted management callback alone would establish that the adapter and renderer still compiled together.
- **Finding:** Initial integration had an unmatched anonymous namespace and a fixture compiled before its asynchronous collector helper was available. A subsequent automated edit matched the renderer's scale-directory assignment instead of the frozen-input table, introducing an invalid call and missing the intended captured scale values. The broader display hook compilation exposed it before packaging. The edit was corrected using exact contexts, and the applied-scale persistence fixture was added.
- **Evidence:** Private `gui-owned-integration-before-namespace-fix.log`, `gui-owned-integration-before-fixture-helper.log` and `gui-before-density-edit-correction.log`; final actual management, density, preview, external display and graph controls. The reviewed patch-stack fixture accepts the exact source stack and preserves an unknown-change sentinel on refusal.
- **Practical consequence:** Compile adjacent production hooks after a session refactor. Narrow extracted callback success is insufficient for an adapter-wide source claim. Preserve failed receipts instead of reclassifying them as device defects.
- **Remaining uncertainty:** Actual target linking, package closure and combined rendered acceptance remain open. Existing localization edits belong to separate owner work and were not silently included in this implementation commit.
- **Next validation:** Publish only matching source/build/package receipts after the remaining ordered changes.

## REC-J007: Focused acceptance does not seal a new recovery release

- **Lesson ID:** REC-J007
- **Date:** 2026-10-04
- **Environment scope:** Native C++/ccache build with two workers; pinned Clang ASan/UBSan/leak checks and disposable reference-host media
- **Evidence class:** Source, host build and focused reference-host tests
- **Status:** Accepted within the reported source/host scope
- **Question or previous assumption:** New executor tests would establish all P1, complete VM or physical readiness.
- **Finding:** Nine focused controls passed native in 72.26 seconds and instrumented in 125.45 seconds. Both source comparisons match frozen manifest `5229d440ae19d7df0a5207f6beaa7ac4a60910fd7bb1a671c364bfe6b60ffd93`. The exact reviewed patch-stack and component publication/privacy checks also passed. These are distinct focused receipts, not a fresh complete recovery release.
- **Evidence:** Private `gui-owned-frozen-{native,sanitizer}-{build,test}.log`, `gui-owned-frozen-inputs.sha256`, `gui-owned-reviewed-stack-test.log` and `gui-owned-component-privacy.log`. A separate English-only staged adapter is compiled and exercised without absorbing the owner's localization draft.
- **Practical consequence:** Continue AUD-014 next, then remaining P1 in report order. Combined VM follows P1 source work; P2 stays last. Keep local focused commits separate from GitHub publication.
- **Remaining uncertainty:** No fresh independent subagent review, target package, physical device or combined VM acceptance occurred. Global lifetime/controller work remains unfinished. No real block device or connected tablet was written.
- **Next validation:** AUD-014 lifecycle/control tests, later complete build/package receipts and combined guest acceptance.
