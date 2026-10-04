# 2026-10-04: Report regular-image repartitioning without live-device inference

- **Lesson ID:** REC-RP001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox partition capability contract and user interface
- **Evidence class:** Source, host fixtures and actual GUI callbacks
- **Status:** Image/live scope and admission reasons made explicit
- **Question or previous assumption:** Can an implemented image job or a
  successful forced-process-stop fixture stand for an accepted tablet partition
  manager or six-LUN restore?
- **Finding:** No. The dedicated read-only capability API separates implemented
  regular-image preview, GPT transactions, filesystem/GPT jobs and six-LUN stock
  restoration from unaccepted device operations. Runtime tool observations have
  an explicit selected-target validation requirement. Encrypted preservation,
  before-userdata migration, outside-userdata content jobs and ESP migration are
  unavailable. Source/model tags are declarations only. The general report and
  layout page use the same contract, with stable live blockers and explanations.
- **Evidence:** `partition_capabilities`, `partition_live_blockers`, CLI strict
  option controls and actual management callbacks. The former manager overview
  ambiguously listed multi-LUN orchestration as unfinished even though the
  regular-image coordinator exists; the overview now separates that source scope
  from its unimplemented/unaccepted device backend.
- **Practical consequence:** Keep device writer, unit/firmware, complete GPT
  geometry, Android KeyMint/TEE, snapshots, exclusive ownership, fallback and
  physical forced-restart durability gates visible. Advanced mode and imported
  declarations cannot enable them. A compiled assertion requires review of this
  contract before the common live writer could be enabled.
- **Remaining uncertainty:** This change makes AUD-009's gap explicit and
  strengthens refusal; it does not implement or accept a native physical writer.
- **Next validation:** Fresh target/combined guest after ordered P1 source work;
  separately develop and validate native collection/writing only for accepted
  unit, firmware, trust and rollback profiles.
- **Supersedes / superseded by:** Refines REC-S005's declared-model/image scope while
  preserving their original physical acceptance boundary.

---

- **Lesson ID:** REC-RP002
- **Date:** 2026-10-04
- **Environment scope:** Compound partition CLI and direct native planner
- **Evidence class:** Source and host negative controls with no device effects
- **Status:** Live refusal moved before request/target and sensitive helper work
- **Question or previous assumption:** Can an unaccepted live compound route
  perform unnecessary selection or filesystem work before its final refusal?
- **Finding:** `partition job-* --object` now refuses before target selection,
  request/journal reads or even opening the supplied system root. A direct native
  job planner checks regular-image scope before GPT/ filesystem work. There is
  no credential use, mapper creation or mount admission in either path. These
  changes leave separate read-only inventory and GPT observation APIs intact.
- **Evidence:** Native policy fixtures call all six compound routes with a
  nonexistent root/request and test direct planning without a descriptor. CLI
  controls use an unopened FIFO with a five-second bound; every valid unaccepted
  route returns `live-repartition-unavailable`. Unrelated options, dual image/live
  targets, live sector overrides and read-only confirmations are rejected.
- **Practical consequence:** Refuse unavailable actions before parsing
  unneeded supplied data or selecting live storage, while preserving strict
  option errors and private regular-image recovery.
- **Remaining uncertainty:** This is a closed admission path, not verified
  KeyMint/TEE integration or accepted device storage ownership.
- **Next validation:** Include these stable reason/option contracts in the
  fresh target and combined guest receipts.
- **Supersedes / superseded by:** Narrows AUD-009's early refusal behavior without
  granting Android encryption authority to any fixture or declaration.

---

- **Lesson ID:** REC-RP003
- **Date:** 2026-10-04
- **Environment scope:** Disposable userdata/ESP/Linux/Windows image placement
- **Evidence class:** Native host and pinned Clang ASan/UBSan/leak fixtures
- **Status:** Explicit front recreation and original-byte rollback verified
- **Question or previous assumption:** Does before-userdata placement preserve
  the original files or provide an encryption migration mechanism?
- **Finding:** The front-placement image job requires advanced mode and the
  recreate policy. Its reviewed record identifies data loss, reports no data
  preservation or migration, and keeps Android boot compatibility false. The
  native control independently checks all new filesystem signatures, absence of
  the original file and the exact complete-image digest after rollback. Existing
  controls also verify shared ESP bytes, 512/4096 GPT geometry, fscrypt refusal,
  process interruption and full original-image recovery.
- **Evidence:** Five focused native controls passed in 147.69 seconds, and five
  pinned Clang ASan/UBSan/leak controls passed in 334.41 seconds. Native and
  instrumented capability/strict-option and layout CLI scripts passed. Matching
  source inputs were frozen before the builds and stayed byte-identical;
  manifest SHA-256 is
  `c7e8e2739a1e8822372128e77f9ff16a0f4b680ef9a07d2fb7a6d7f3e897f950`.
  No full release or tablet result is inferred.
- **Practical consequence:** Present front placement as destructive recreation,
  and require its original bytes in the retained recovery record. Do not label it
  as an encrypted-data preservation path.
- **Remaining uncertainty:** Large populated/fragmented/damaged filesystem and
  minimum-size cases are the following AUD-010 work. Physical FBE/boot acceptance
  remains unavailable even after a regular-image formatter succeeds.
- **Next validation:** Proceed to AUD-010 before the combined guest and later
  P2 findings; keep the device-backend gap visible in acceptance records.
- **Supersedes / superseded by:** Adds explicit front-placement execution and
  rollback evidence; preserves the user's prohibition on inferring device safety
  from emulation or source execution.
