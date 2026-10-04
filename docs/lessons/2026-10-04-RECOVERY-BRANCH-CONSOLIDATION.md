# 2026-10-04: Preserve reviewed history while consolidating public branches

## REC-BR001: A release branch must use the actual source series

- **Lesson ID:** REC-BR001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox recovery repository and its parent workspace
- **Evidence class:** Git source identity and GitHub publication metadata
- **Status:** Verified for the recovery repository
- **Question or previous assumption:** The public development branches should be replaced by one default branch named after the OrangeFox release series.
- **Finding:** The recovery source lock identifies official `fox_16.0`, core revision `3d733672081bca3af42475a286145f4a8cdce4e7`, and release series R12.0. The recovery repository now has exactly one public branch, `R12.0`, and GitHub and the remote symbolic HEAD both identify it as the default. Its verified tip is `5ed1d799d5d4a47f8a73b3aa52e63543f919c5d3`.
- **Evidence:** Component `manifests/recovery.lock.json`; fresh GitHub repository/branch API and `git ls-remote --symref` checks on 2026-10-04. The existing alpha release remains attached to `96e49e0e602de7b3b734bc07e305efca7bcab0e5`.
- **Practical consequence:** Use R12.0 in current recovery source links. The Linux workspace retains its own `main` naming because it is not an OrangeFox release branch.
- **Remaining uncertainty:** A default branch change does not validate an Android image, advance an existing release artifact or establish tablet compatibility.
- **Next validation:** Continue the ordered P1 implementation and require fresh target/package and combined guest receipts before making a new release claim.

## REC-BR002: Branch consolidation did not require a history rewrite

- **Lesson ID:** REC-BR002
- **Date:** 2026-10-04
- **Environment scope:** Both project repositories; local Git and authenticated GitHub API
- **Evidence class:** Ancestry, commit metadata and public branch checks
- **Status:** Recovery consolidation verified; workspace consolidation prepared
- **Question or previous assumption:** Removing temporary branch names might require deleting commits or recreating a repository.
- **Finding:** Both public main branches and both temporary development tips were already ancestors of the reviewed local work. The complete commit-message, author and committer metadata scan found no assistant-tool labels. The recovery main branch was advanced by a normal fast-forward, renamed using the GitHub branch API, and its obsolete development branch was deleted with an exact remote-tip lease. Original commit identities and the release tag were preserved; no force update of a surviving branch or repository deletion was needed.
- **Evidence:** Ancestry checks against recovery tips `96e49e0e602de7b3b734bc07e305efca7bcab0e5` and `56ef32c6ef55d9e552588e6243bc6346951054bc`, and workspace tips `f21540df5144fedd8c737f21c784cae037564824` and `9cff4e6faa2806aa907d2820c557e2c26d3ebb29`. Fresh branch checks showed no open pull requests or protected branches that needed migration. Private reference snapshots preserve the pre-change ref map.
- **Practical consequence:** Retire obsolete refs rather than discard reviewed code. Current cross-repository links must follow the consolidated defaults. Historical file snapshots still retain their original contents; this is not a claim that every old URL was purged from Git objects.
- **Remaining uncertainty:** Third-party clones and cached historical pages are outside this publication transaction. The parent workspace publication is a separate verification step.
- **Next validation:** Fast-forward workspace `main`, remove its obsolete development ref, and verify both repositories again after publication.

## REC-BR003: Resolve the Git directory for submodules

- **Lesson ID:** REC-BR003
- **Date:** 2026-10-04
- **Environment scope:** Recovery component managed as a Git submodule
- **Evidence class:** Failed host metadata command and corrected Git operation
- **Status:** Corrected before source or remote mutation
- **Question or previous assumption:** A private reference snapshot could be written below the component's `.git` path as though it were a directory.
- **Finding:** The component uses a `.git` indirection file. The first snapshot command refused with `Not a directory` before changing source, branches or remotes. The corrected command resolves `git rev-parse --absolute-git-dir` and writes the private snapshot there.
- **Evidence:** Local branch-consolidation command results on 2026-10-04; corrected snapshot followed by successful fast-forward, default rename and exact-lease deletion.
- **Practical consequence:** Git metadata paths must be resolved through Git, including in managed worktrees and submodules. Preserve unrelated working and index changes when publishing focused fixes.
- **Remaining uncertainty:** A reference snapshot is not a complete backup of untracked files or build payloads. Those existing files were kept in place.
- **Next validation:** Check the final index and working-tree separation before resuming recovery implementation.
