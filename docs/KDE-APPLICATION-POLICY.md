# Original distribution KDE applications

Do not clone, fork, rename or rebuild KDE desktop applications as Uke variants.
Use the distribution's original applications. This owner requirement applies to
source acquisition, source factories, automatic builds and target admission.
It is enforced by the root instructions and the desktop source allowlist.

Plasma workspace and Dolphin variant recipes were created before this policy.
Their COPR source records were removed, active derivative jobs were canceled,
and their source targets now fail before an archive is retrieved. Earlier source,
native helper and package results remain historical evidence. Existing outputs
were archived per exact build before withdrawal from the active COPR repository; withdrawal is
recorded explicitly rather than rewriting previous test results.

Original Fedora Plasma/Dolphin packages currently contain Python components,
including undeclared Dolphin migration scripts. The separate target rule forbids
Python files and runtimes. A complete KDE selection is therefore not admitted
under the current requirements. Do not bypass the interpreter conflicts, delete
RPM-owned files after installation or create derivative KDE packages to resolve
that conflict.

`uke-desktop-metas` release 3 carries readiness/policy metadata and requires the
core console selection. It withdraws the former `kde-plasma-uke-meta` dependency
selection and installs no graphical session. A future graphical selection needs
compatible original distribution packages and its own complete payload,
dependency, lifecycle, session and physical validation.

Independent Uke metadata, original Plymouth theme data, the explicitly requested
upstream Material Decoration plugin, non-KDE native dependency sources and
original device-management tools remain separate work. They do not duplicate
KDE applications or establish Uke graphics support.

See the [package hub](PACKAGE-HUB.md), [source policy](../AGENTS.md) and
[engineering records](lessons/2026-10-04-UKE-COPR-UPDATE-HUB.md).
