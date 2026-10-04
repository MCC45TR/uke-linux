# 2026-10-04: Common recovery ownership and verified lifetime

- **Lesson ID:** REC-O001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox native management, host regular-image backend
- **Evidence class:** Source, independent review and native process fixtures
- **Status:** AUD-005 source boundary implemented; target and combined guest pending
- **Question or previous assumption:** Do a GUI mutex and independent journal
  locks exclude a separately invoked cooperating writer?
- **Finding:** They do not. The common coordinator now takes process-independent
  admission before target/journal locks and binds the exact operation, plan,
  every target identity and journal parent/path. A frozen private persistent
  domain is shared by cooperating GUI, CLI and nested native calls. Preparation
  holds exclusion without durable target intent; the first effect checkpoints
  that intent. Process death and elapsed time cannot authorize a different job.
- **Evidence:** `operation_lease.cpp`, `operation_guard.cpp`, common ownership
  fixtures and explicit parent-token integration throughout file, GPT, raw,
  stream, filesystem, partition, six-LUN stock, installer and boot operations.
- **Practical consequence:** Preserve unresolved intent until exact recovery
  verifies bytes/metadata and child/mount cleanup. Do not borrow authority by
  PID, thread-local state or inherited file description.
- **Remaining uncertainty:** This is cooperative host exclusion. An unrestricted
  root program can ignore it. Android management admission remains unavailable;
  host environment/configuration cannot enable a device backend.
- **Next validation:** Fresh target compilation and combined guest acceptance
  after the ordered P1 source work; separate physical durability admission.
- **Supersedes / superseded by:** Implements the common-ownership work left open
  by REC-I001 and REC-I004 without changing their physical acceptance limits.

---

- **Lesson ID:** REC-O002
- **Date:** 2026-10-04
- **Environment scope:** Ownership terminal publication and forced interruption
- **Evidence class:** Independent review, native SIGKILL and fsync fault injection
- **Status:** Retirement publication ordering corrected
- **Question or previous assumption:** Can a visible completion marker hide an
  owner when its directory synchronization failed?
- **Finding:** The first candidate removed the owner before durably publishing
  completion. A failed publication followed by failed restoration could expose
  apparent idle state to a fresh process. Completion now publishes the exact
  verified terminal receipt and synced completion marker while the original
  owner still exists, then removes it. Failed completion publication preserves
  that original owner even when every restoration synchronization fails. Death
  after the durable completion point is distinguishable from unfinished intent.
- **Evidence:** Fresh `exec` probes avoid inherited local coordinator state.
  Controls kill before/after completion durability and inject one or repeated
  fsync failures. Concurrent checkpoint/retirement calls are serialized within
  the token as well as across independent admission processes.
- **Practical consequence:** A destructor or absent PID is never an ownership
  retirement oracle. Release requires a complete independent terminal receipt.
- **Remaining uncertainty:** Host filesystem synchronization does not establish
  tablet controller persistence after a forced restart. Wholesale privileged
  deletion of a host domain is outside this cooperative model.
- **Next validation:** Repeat retirement/interruption cases in the combined
  generic guest, retaining an unaccepted device backend.
- **Supersedes / superseded by:** Corrects the initial AUD-005 retirement design.

---

- **Lesson ID:** REC-O003
- **Date:** 2026-10-04
- **Environment scope:** Compound filesystem and streamed restore delegation
- **Evidence class:** Source review and adverse regular-image fixtures
- **Status:** Derived-plan and initial stream reservation gaps corrected
- **Question or previous assumption:** Does a valid raw journal for the same
  inode necessarily belong to the outer filesystem operation?
- **Finding:** It does not. Filesystem delegation now checks the persisted
  application digest, original/prepared data commitments, exact target/profile
  and both copies of the derived raw plan. An independently valid foreign plan
  is rejected before effects. Journal bindings require the immediate parent
  directory to exist, avoiding identity changes caused by later preparation.
  Stream preparation publishes a durable VALIDATED journal before checkpointing
  its between-call reservation; forced death before READY remains inspectable
  and exactly cancellable after complete original-byte verification.
- **Evidence:** Foreign-plan inspect/resume/rollback/cancel controls and an
  actual stream SIGKILL between the reservation and READY publication. Other
  restore and lifecycle requests remain blocked by the retained owner.
- **Practical consequence:** Pass explicit parent tokens and independently
  validate the helper's commitment; a valid unrelated journal is insufficient.
- **Remaining uncertainty:** These are image workflows, not encrypted userdata
  shrink or physical six-LUN restore acceptance.
- **Next validation:** Combined guest source-independent interruption cases.
- **Supersedes / superseded by:** Extends REC-I004's wrapper binding to other
  compound operations and corrects the initial stream reservation ordering.

---

- **Lesson ID:** REC-O004
- **Date:** 2026-10-04
- **Environment scope:** Directory-tree restore staging, publication and recovery
- **Evidence class:** Independent review, adverse fixtures and actual SIGKILL
- **Status:** Persistent exact restore recovery implemented
- **Question or previous assumption:** Is matching archived content enough to
  identify a directory that this operation published?
- **Finding:** A foreign inode can contain identical content. Restore persists
  an exact plan/state, captures the staging inode and verifies the complete
  namespace, bytes, metadata and hardlink relationships after no-replace
  publication. Recovery refuses foreign inodes, added files and replaced store
  or destination parent paths. Unpublished cancellation preserves staging as an
  explicit artifact rather than recursively deleting unknown entries.
- **Evidence:** Production `backup_tree_recover`; kill points before stage
  identity, during staging, before/after publication and at terminal records.
  Controls cover identical foreign directories, extra nested/root entries,
  hash/metadata divergence, socket omission policy, pathname replacement and
  injected I/O failure.
- **Practical consequence:** Use the retained inode and sealed plan/state as
  ownership evidence, then perform independent full-tree verification.
- **Remaining uncertainty:** This does not implement Btrfs receive or establish
  installed Linux boot consistency. Unknown staging remains visible to review.
- **Next validation:** Integrated native/sanitizer and subsequent guest cases.
- **Supersedes / superseded by:** Corrects the first tree candidate's namespace
  and pathname-verification gaps without changing the backup format's socket
  omission policy.

---

- **Lesson ID:** REC-O005
- **Date:** 2026-10-04
- **Environment scope:** Rescue worker, namespace init and failure cleanup
- **Evidence class:** Source and host tests with no device effects
- **Status:** Explicit lifetime and pre-init failure proof implemented
- **Question or previous assumption:** Does a failed namespace setup imply that
  a payload or mount lifetime never began?
- **Finding:** Only a specific private pre-init message plus a reaped worker
  proves that no init was created. Fork failure has its own no-worker cleanup
  path. Ordinary sessions retain a pidfd-backed supervisor, kill/reap descendants
  and verify mount/worker cleanup before releasing the parent token. Writable
  sessions require synchronization proof for each written filesystem. Missing
  supervision or synchronization evidence leaves ownership unresolved.
- **Evidence:** `linux_rescue_execute`, private SOCK_SEQPACKET handoff and
  `rescue_lease.cpp` with fork/unshare failure injection. All mount calls in the
  latter fixture terminate the test, and its incomplete ELF is never executed.
- **Practical consequence:** Distinguish lifetime closure from content rollback
  or package repair. Do not clear an unknown lifetime using PID absence alone.
- **Remaining uncertainty:** Aggregate cgroup admission is AUD-012. Recovery
  after lost rescue supervision is not accepted by this change.
- **Next validation:** Namespace shell fixture, aggregate resource envelope and
  combined guest cleanup controls.
- **Supersedes / superseded by:** Corrects the initial pre-init/fork ownership
  leak; retains the existing unresolved-supervision gate.

---

- **Lesson ID:** REC-O006
- **Date:** 2026-10-04
- **Environment scope:** Stock lifecycle, fastbootd and Btrfs controls
- **Evidence class:** Reviewed patch stack and actual callbacks with mocked effects
- **Status:** Shared lifecycle/control source hooks implemented
- **Question or previous assumption:** Can a mount or reboot callback bypass a
  management lease, or can cancellation operate on newly selected GUI input?
- **Finding:** Complete mount/bind/unmount, related-partition unmount, direct and
  queued GUI reboot, fs_mgr unmount and fastbootd shutdown/reboot callbacks now
  acquire explicit lifecycle ownership before effects. Btrfs controls bind the
  captured root/FSID and exact running plan/journal; they cannot retire its token.
  Maintenance captures a duplicated root descriptor before setting its running
  flag, so failed capture cannot strand that flag.
- **Evidence:** Patches 0024/0025, production lifecycle/mount fixtures and
  compile-time Android policy controls. Android tests are host compilations
  using Android policy, not target-build or device results.
- **Practical consequence:** Keep stock lifecycle available while the Android
  managed backend is unaccepted. Enabling management without wiring its shared
  lifecycle domain must fail compilation.
- **Remaining uncertainty:** Owned GUI execution and joinable maintenance remain
  AUD-013/AUD-014. Device coordinator wiring is intentionally not accepted.
- **Next validation:** Ordered GUI fixes followed by fresh target and guest
  acceptance of complete callback lifetimes.
- **Supersedes / superseded by:** Extends REC-G records with lifetime exclusion
  while preserving the existing legacy mutation refusal.

---

- **Lesson ID:** REC-O007
- **Date:** 2026-10-04
- **Environment scope:** Exact reviewed source stacks and host fixture isolation
- **Evidence class:** Source staging, compiler failures and corrected native tests
- **Status:** Reproducible compatibility corrections recorded
- **Question or previous assumption:** Can overlapping patches be checked by
  reversing only the final patch, and do all host fixtures share a valid domain?
- **Finding:** Known exact-prefix staging now checks the entire reviewed stack
  against pinned recovery/fastboot revisions and rejects unknown local changes.
  Independent CTest fixtures receive private persistent domains shared by their
  child processes. The namespace rescue fixture needs a separate domain under
  its own UID mapping. Optional platform fixture helpers compile the owner's
  separate localization draft when present without stripping actual GUI code.
- **Evidence:** Complete stack/unknown-change controls and 111 legacy entry-point
  checks passed. Initial builds exposed missing localization fixture declarations
  and a Clang Android-policy unused private member; both were corrected. A first
  patch attempt named the wrong scale fixture header and applied no changes.
- **Practical consequence:** Preserve owner work and failed trials; compile the
  actual functions with compatible platform boundaries. Optional draft inputs
  belong in local source receipts, not translation acceptance claims.
- **Remaining uncertainty:** Localization review remains AUD-026/AUD-029–031.
- **Next validation:** Final integrated source receipts and complete regression
  results, then move to AUD-006 in report order.
- **Supersedes / superseded by:** Corrects intermediate build assumptions only.

---

- **Lesson ID:** REC-O008
- **Date:** 2026-10-04
- **Environment scope:** Adverse ownership fixtures and integration verification
- **Evidence class:** Private native and pinned Clang sanitizer logs
- **Status:** Native/sanitizer regressions and subsequent affected checks passed
- **Question or previous assumption:** Did the first focused fixture failures
  identify a production defect, and do focused passes cover all integrations?
- **Finding:** One transaction fixture supplied a random confirmation instead
  of the locked plan hash and correctly failed earlier than its busy-state
  assertion. A tree wrapper matched a nested binding rather than the top-level
  state; another trial resealed only the plan and correctly failed its unchanged
  state digest. Corrected fixtures exercise the intended production boundary.
  Six ownership/restore controls and five lifecycle/mount controls then passed;
  focused stream and pre-init rescue controls also passed. Those intermediate
  passes are not a complete source, target, release or VM receipt.
- **Evidence:** Ignored `build/p1/ownership-*` and lifecycle logs, exact-source
  input snapshot and the corrected fixture sources. Full CTest sets passed
  36/36 native in 271.98 seconds and 36/36 with pinned Clang ASan/UBSan/leak
  checks in 602.57 seconds. Subsequent rescue synchronization corrections have
  their separate affected-test receipts below; these totals describe the
  preceding complete regression runs, not an unchanged final-source snapshot.
- **Practical consequence:** Classify oracle/scaffolding corrections separately
  from production failures, and repeat affected checks after changes.
- **Remaining uncertainty:** The owner's earlier application/task shutdown cause
  remains unestablished. Current successful compiler runs cannot explain an
  unrelated earlier process exit or establish physical operation safety.
- **Next validation:** Preserve the focused source result in a local commit;
  combined VM and publication remain later task stages.
- **Supersedes / superseded by:** Preserves failed candidate trials rather than
  treating corrected focused controls as historical full acceptance.

---

- **Lesson ID:** REC-O009
- **Date:** 2026-10-04
- **Environment scope:** CLI integration, rescue sync proof and legacy installer fixture
- **Evidence class:** Native CLI, pinned Clang sanitizer CLI and preserved failed trials
- **Status:** Integration defects corrected; separate affected controls passed
- **Question or previous assumption:** Did complete CTest cover the separate
  namespace/CLI scripts, and did all manifest numbers have the same JsonCpp type?
- **Finding:** A rescue sync comparison used direct signed/unsigned JsonCpp
  equality after parsing the plan. The actual mounted root/ESP matched, but the
  supervisor rejected it. Comparisons now use canonical numeric JSON while
  retaining the exact device/inode check; the new bind mount's distinct mount ID
  is not confused with an inode replacement. Native and sanitized namespace
  scripts then passed Arch/Fedora dispatch, selected ESP, readonly/writable
  sessions, stale-plan refusal, descendants, timeout and mount cleanup.
- **Further findings:** The foreign filesystem plan fixture omitted the exact
  sector size. Raw CLI and filesystem management have different defaults. An
  initial 4096-byte correction repeated the mismatch; the corrected fixture
  reads the reviewed target's sector width explicitly. All six filesystem CLI
  workflows then passed, including rejection of both substituted raw-plan
  copies by inspect/resume/rollback/cancel. The old installer fixture still
  called the removed volatile writer. It now prepares only independent regular
  test files using the standard filesystem library and tests production
  read-only validation; the volatile writer was not restored.
- **Evidence:** Private `ownership-rescue-json-identity-failed.log`,
  `ownership-filesystem-sector-assumption-failed.log`,
  `ownership-legacy-installer-fixture-failed.log`, corrected filesystem and
  rescue CLI logs, and the final remaining CLI checks. The affected rescue
  C++ sanitizer control passed in 0.49 seconds; complete CTest results before
  the small synchronization correction remain REC-O008's separate receipts.
- **Practical consequence:** Exercise every actual CLI boundary and preserve
  numeric semantics across record parsing. Derive fixture geometry from its
  reviewed plan and keep fixture preparation distinct from production writers.
- **Remaining uncertainty:** Host namespace sessions are not real package
  database, tablet rescue or controller-persistence acceptance. No fresh full
  native release receipt is inferred from a failed script followed by affected
  checks; final release gating must require matching complete inputs.
- **Next validation:** Source/target/combined guest acceptance after ordered P1
  completion, including the still-open aggregate resource and GUI lifetimes.
- **Supersedes / superseded by:** Corrects the integration gaps missed by the
  initial focused AUD-005 controls and the stale AUD-004 installer fixture.
