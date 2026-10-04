# 2026-10-04: Separate source capabilities from downloadable recovery artifacts

## REC-DOC001: The repository landing page must describe the current product scope

- **Lesson ID:** REC-DOC001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox recovery repository and GitHub documentation
- **Evidence class:** Reviewed source documentation, publication metadata and GitHub Markdown rendering
- **Status:** Corrected documentation; no runtime or hardware claim
- **Question or previous assumption:** The recovery README mixed dated implementation checkpoints, obsolete planned transports and development-request terminology with the downloadable alpha.
- **Finding:** The landing page now groups current capabilities into eight areas, distinguishes image-only execution from live tablet admission, and separates the R12.0 source branch from the older published alpha. Excluded SSH/network rescue and BitLocker plans are absent from the feature summary. Downloads identify each artifact's purpose, and development links replace the chronological checkpoint narrative. Licenses are described per component rather than assigning the repository license to imported code.
- **Evidence:** Reviewed replacement README SHA-256 `c69add4b13306fd233e0ebee97543765c2ec04ebc54d328a213fa69c1b1976d3`, published in recovery commit `26c94aae6eb8ec33f98f280dbdc4898327a57ce5` and compared byte-for-byte with the GitHub contents API. GitHub Markdown rendered two tables and five sections; a separate browser screenshot showed the published feature table with intact columns and links. Every relative link resolves to a tracked file. A privacy/stale-scope check found no personal paths, email addresses or removed planning phrases. Fresh GitHub metadata identified default branch R12.0 and prerelease `r12.0-uke.20260930-alpha1`, still attached to `96e49e0e602de7b3b734bc07e305efca7bcab0e5`. The repository description now includes both commercial models.
- **Practical consequence:** Users can locate capabilities, installation guidance and limitations without interpreting implementation history. New source work must not be presented as a feature of an older sealed download.
- **Remaining uncertainty:** Markdown rendering and link checks establish documentation behavior only. They do not compile a recovery image, validate a physical display or accept either tablet's storage backend.
- **Next validation:** Continue ordered P1 fixes and later target/package and combined VM acceptance; refresh the landing page when a newly validated artifact is published.
