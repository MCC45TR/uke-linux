# 2026-10-04: Bound tree enumeration before materializing names

## REC-TREE001: Per-directory limits do not bound a retained traversal frontier

- **Lesson ID:** REC-TREE001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox native Linux/home file-tree backups
- **Evidence class:** Source and reference-host native/sanitizer fixtures
- **Status:** Source/host remediation of AUD-015
- **Question or previous assumption:** A 100,000-child limit and 64-level recursion bound could bound directory listing memory.
- **Finding:** Recursive ancestor name vectors have been replaced by an iterative frontier and sorted 1,024-name runs in anonymous files inside the retained private backup store. A shared budget admits children before copying names and limits accounted listing/frontier storage to 2 MiB, live scratch to 512 MiB and total entries to one million. The original per-directory/depth limits remain. Opaque filenames, bytewise sibling order and namespace hashes remain compatible; older sealed plans without informational enumeration fields remain readable.
- **Evidence:** `tree_listing.hpp/.cpp`, tree planning/capture/restored-tree verification and the resource contract in `docs/TREE-BACKUP.md`. Full native and pinned sanitizer builds completed with two compile jobs and ccache. Four focused native tests passed in 57.20 seconds; matching leak-enabled ASan/UBSan tests passed in 148.26 seconds. Frozen native-input manifest SHA-256: `30e2670dee369bf077754600df74492c25336eb944f5c55a10003fad787dc4f3`.
- **Practical consequence:** Deep trees do not retain complete ancestor vectors or JSON records. Entry/resource refusal precedes uncontrolled allocation and preserves source data.
- **Remaining uncertainty:** The 2 MiB figure excludes separately bounded metadata pages, hardlink indexes, allocator/runtime overhead and page cache. It is not a complete-process RSS guarantee. A new failed planning store can retain unsealed metadata pages.
- **Next validation:** Fresh ARM64/package closure and combined disposable guest acceptance; physical backups require separately accepted device/filesystem identity and durable storage.

## REC-TREE002: Measure actual maximum-width and maximum-depth fixtures

- **Lesson ID:** REC-TREE002
- **Date:** 2026-10-04
- **Environment scope:** Host filesystem and instrumented native executables
- **Evidence class:** Real synthetic directories, retained source identity and independent restore oracles
- **Status:** Focused fixtures passed
- **Question or previous assumption:** A generated small namespace could establish the behavior of maximum-length wide directories.
- **Finding:** An independently executed scanner enumerates 100,000 actual children with 255-byte names. Accounted working peak is 425,056 bytes and scratch peak 51,400,000 bytes. Native maximum RSS grows from 5,484 to 6,144 KiB; sanitizer maximum RSS grows from 14,640 to 19,308 KiB. Sorting/scanning takes 598 ms and 1,522 ms respectively. A separate 64-directory / 1,088-entry fixture completes actual plan, capture, verification and restore, including deepest content; its accounted peak is 972,356 bytes and scratch peak 268,131 bytes.
- **Evidence:** Final wide/deep CTest receipts; deterministic independent name oracle and fresh-process `getrusage`. Actual tree CLI metadata, ACLs where supported, hardlinks, sparse/opaque names, new-directory restore and observed SIGKILL/file-boundary resume also passed. Private logs retain the exact test environment and outputs.
- **Practical consequence:** Peak accounting and RSS are reported with their measurement scope. Wide/deep acceptance includes actual files and preserved source inode/names, not just a mocked count.
- **Remaining uncertainty:** These are reference-host fixtures and not recovery RAM measurements or a physical Linux home backup. Cached filesystem performance is not a tablet throughput guarantee.
- **Next validation:** Repeat the frozen implementation in the combined target guest, then an accepted physical offline Linux/home source.

## REC-TREE003: Success-path error construction can dominate sanitizer allocation

- **Lesson ID:** REC-TREE003
- **Date:** 2026-10-04
- **Environment scope:** Failed/corrected host compilation and test trials
- **Evidence class:** Preserved failed native/sanitizer receipts and corrected source/test oracles
- **Status:** Corrected without loosening assertions
- **Question or previous assumption:** Passing guards could freely construct temporary diagnostic strings on every child.
- **Finding:** The first frozen sanitizer run failed the unchanged 32 MiB isolated RSS-growth assertion. Per-name guards constructed error strings even when true; failure-only diagnostic construction removes allocator/quarantine churn and the same assertion now passes. Earlier compilation caught missing budget arguments and a misleading one-line loop. A deep-count assertion compared a JsonCpp unsigned value with a differently typed literal; reading `asUInt()` corrected the oracle. A reused `Root::list` oracle returned no names while a fresh descriptor showed the original namespace; the final oracle independently reopens and compares source inode/names and checks descriptor counts rather than depending on listing cursor reuse.
- **Evidence:** Failed receipts and manifest `37ab5780a223b974a67a7981975a523972e03967b817f3cb3178e54e11c385bc` remain private. The final frozen manifest and native/sanitizer receipts above supersede that failed checkpoint. Final cleanup reports retained source offset zero and the original five opaque-name children.
- **Practical consequence:** Optimize successful checks without hiding errors or relaxing resource assertions. Use independent source oracles when descriptor cursor state can affect enumeration.
- **Remaining uncertainty:** The precise earlier reused-listing behavior was not established as a new production defect. Existing generic `Root::list` implementation was not changed by this patch. The original worst-case whole-backup RSS was not measured.
- **Next validation:** Preserve independent oracles and investigate generic listing cursor semantics separately if that behavior recurs.

## REC-TREE004: Anonymous scratch cleanup differs from durable backup recovery

- **Lesson ID:** REC-TREE004
- **Date:** 2026-10-04
- **Environment scope:** Tree-store scratch admission and owned-child interruption
- **Evidence class:** Host failure injection and actual synthetic-process SIGKILL
- **Status:** Resource cleanup verified with an explicit fallback gap
- **Question or previous assumption:** Scratch unlinking alone could establish forced-restart durability of the entire backup.
- **Finding:** Preferred scratch is zero-link mode-0600 `O_TMPFILE` in an owned mode-0700 store. The fallback creates an exclusive private file and immediately unlinks it. Global memory/scratch exhaustion, entry exhaustion after a populated run, reserve/ENOSPC failure, EINTR/short writes and 100,001-child refusal release descriptors and refund accounting. A child is killed only after acknowledgement of a populated scratch write; no visible scratch record remains. Separately, existing capture CLI tests verify sealed-plan/file-boundary recovery after actual SIGKILL.
- **Evidence:** `ure-bounded-tree-enumeration`, `ure-linux-home-tree-backup`, operation-ownership/actual-management regressions and `tests/check-tree-backup.sh`; all use private synthetic files, not tablet or host block writes.
- **Practical consequence:** Scratch writes preserve 16 MiB of free storage. Enumeration cleanup cannot substitute for durable plan/capture verification; new incomplete planning stores are not backups.
- **Remaining uncertainty:** Forced restart in fallback creation/unlink may leave an unreferenced `enumeration-*.tmp`; that gap was not the SIGKILL fixture. RAM-backed stores charge scratch to RAM and are volatile. No new Android package, combined VM or physical acceptance is claimed.
- **Next validation:** Use mounted disk storage for durable large backups and include scratch-gap/low-space guest controls in later combined acceptance.
