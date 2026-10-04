# 2026-10-04: Keep Android build scratch on the admitted disk

## REC-TMP001: An inner mount must preserve the outer scratch policy

- **Lesson ID:** REC-TMP001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox host resource service and nested Android builder
- **Evidence class:** Source and actual host mount-namespace fixture
- **Status:** AUD-023 source/host remediation; full-image acceptance open
- **Question or previous assumption:** Binding a disk directory in the outer runner was enough to keep Android temporary files off tmpfs.
- **Finding:** The old inner bubblewrap replaced that binding with tmpfs. One production namespace helper now preserves the same disk directory and sets TMPDIR/TMP/TEMP. Before admission, after the service lock and inside the builder, a host helper checks kernel filesystem magic/ID, directory device/inode, owner/mode and exact receipt identity. A create/write/filesystem-sync/unlink probe checks actual writeability. Android requires 8 GiB available filesystem space; native/sanitizer work requires 2 GiB. Fixed-count filesystems require 131,072 free inodes. Known Btrfs zero counts are recorded as dynamic accounting. Unknown/RAM/network/overlay filesystems and unavailable or low capacity refuse.
- **Evidence:** Frozen source-input manifest SHA-256 `55bc8d47c4c96c9a80388530f46f4ff7c5728198a0bf2ceaff8b31abb612abcf`; actual production namespace test and byte/inode/identity fixtures. Reintroduced tmpfs, a different disk directory and readonly scratch all refuse before sentinel commands. Existing host budget/cache and pinned Blueprint controls pass again against the same inputs. [Bubblewrap's bind interface](https://github.com/containers/bubblewrap/blob/main/bwrap.xml) describes the host-path binding; actual kernel/path identity is checked rather than inferred from that source alone.
- **Practical consequence:** Nested isolation no longer silently reinstates RAM scratch. Host helper changes do not add a tablet runtime or touch block devices.
- **Remaining uncertainty:** Space/inode snapshots are not quotas or future allocation guarantees, especially for Btrfs metadata. Output-directory capacity and immutable output evidence remain separate. A service restart can leave unreferenced private probe/diagnostic files, which are retained rather than assumed to be durable target transactions.
- **Next validation:** Complete AUD-024, then measure clean/warm complete Android builds, desktop response and separately matched package/VM acceptance.
- **Supersedes:** The open inner-tempfs limitation at REC-HOST003's earlier checkpoint; its original evidence remains historical.

## REC-TMP002: A mount-list match can describe a shadowed filesystem

- **Lesson ID:** REC-TMP002
- **Date:** 2026-10-04
- **Environment scope:** Actual nested bubblewrap mounts on the Btrfs host
- **Evidence class:** Failed host trial, mountinfo and resolved-path statfs/stat comparison
- **Status:** Corrected conservative false refusal
- **Question or previous assumption:** The first `findmnt` target match identified the filesystem reached by `/tmp`.
- **Finding:** The first trial reported old tmpfs and refused before heavy work even though statfs on the resolved path reported Btrfs and the bound directory's device/inode matched the disk source. Multiple mountinfo entries shared the target. Production admission now uses the path's kernel filesystem magic; diagnostic mount entries are explicitly allowed to include shadowed mounts.
- **Evidence:** Failed first-control/service logs retained privately; actual comparison showed both tmpfs and Btrfs target entries and Btrfs magic `9123683e`. Corrected production-recipe controls passed, including deliberate tmpfs substitution. Linux's filesystem magic definitions were checked against the host kernel UAPI header.
- **Practical consequence:** Listing order does not authorize scratch placement or reject a valid disk bind. Kernel-resolved path identity and actual writeability provide separate checks.
- **Remaining uncertainty:** These checks assume cooperating host automation; they are not an adversarial security boundary against another process controlled by the same host account.
- **Next validation:** Preserve the substitution controls and compare their exact helper/source hashes in future complete-build receipts.

## REC-TMP003: Disk storage still has a memory cost

- **Lesson ID:** REC-TMP003
- **Date:** 2026-10-04
- **Environment scope:** Bounded 64 MiB host write in the actual inner Android recipe
- **Evidence class:** Allocated file blocks, filesystem space and cgroup/process accounting
- **Status:** Measured reference-host fixture
- **Question or previous assumption:** Disk scratch should have zero charged memory consumption.
- **Finding:** A 67,108,864-byte incompressible file allocated the same number of bytes on disk. Charged file cache increased by 67,117,056 bytes; the aggregate filesystem availability drop after synchronization was also 67,117,056 bytes. Anonymous memory changed by -4,096 bytes and shmem by zero. The owned service peaked at 73,277,440 charged bytes; command maximum RSS was 4,664 KiB and wall time 0.52 seconds. OOM counters and final PSI averages were zero. An earlier unsynchronized aggregate free-space snapshot showed no drop; it was not treated as proof of no allocation.
- **Evidence:** Frozen scratch, host budget and builder logs; private initial/admitted/inner policy, mount, before/after memory.stat, memory.peak/events, filesystem space and command accounting records. The random-file size/allocated-block oracle and unchanged directory identity are independent of aggregate free-space changes.
- **Practical consequence:** Keep disk placement, cache charging, process RSS and aggregate filesystem space as distinct measurements. Disk scratch reduces anonymous/shmem pressure but does not bypass the job's total cgroup budget.
- **Remaining uncertainty:** Filesystem-wide available bytes can include unrelated activity; snapshots and this small job do not measure full-image behavior or establish desktop responsiveness, device durability or hardware support.
- **Next validation:** Clean/warm complete recovery image receipts after input/output closure; combined guest testing only after the ordered P1 changes.
