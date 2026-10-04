# 2026-10-04: Recovery startup lessons from pinned Uke donors

- **Lesson ID:** REC-D001
- **Date:** 2026-10-04
- **Environment scope:** OrangeFox source and staged ramdisk; Uke recovery donors
- **Evidence class:** Read-only source comparison, not a new build or device result
- **Status:** Startup dependency gap documented for AUD-024 and AUD-034
- **Question or previous assumption:** Could a currently used donor solve startup
  failures before our own recovery reaches a tablet?
- **Finding:** Native BoardConfig excludes the default recovery USB init, but
  project recovery/root supplies no Uke USB override. The staged generic init
  has FunctionFS/configfs recipes and sets `sys.usb.configfs=0`; its inspected
  files do not assign `sys.usb.controller` or enable configfs. Recovery donor
  `d037467a1643d64979337ad79267c8b8f2e4ca17` supplies controller selection,
  peripheral mode and UDC/FunctionFS ordering. This is a source/staging gap;
  external vendor_boot imports can still affect runtime composition.
- **Evidence:** Native `recovery-uke-ofox/src/device/xiaomi/uke/BoardConfig.mk`,
  staged `system/etc/init/hw/init.rc`, and the pinned donor's
  `recovery/root/init.recovery.usb.rc`. An independent read-only agent compared
  the files; the parent inspected the controller/readiness actions directly.
- **Practical consequence:** Bind init imports and service/module dependencies
  into build receipts. Adapt required Uke readiness behavior in owned code with
  explicit deadlines and stage-specific reasons, in the existing P1 order.
- **Remaining uncertainty:** No observed tablet USB failure or new enumeration
  success is established. Recovery and fastboot-boot compositions need separate
  vendor_boot closure and physical validation.
- **Next validation:** Resolve AUD-024 startup closure, then AUD-034 readiness.
- **Supersedes / superseded by:** Supplements DON-U005 and DON-E002 without
  upgrading any third-party or own-device support claim.

---

- **Lesson ID:** REC-D002
- **Date:** 2026-10-04
- **Environment scope:** Novatek/THP/HAL/uinput donor startup and native recovery
- **Evidence class:** Pinned source and static binary metadata
- **Status:** Readiness and ABI requirements documented
- **Question or previous assumption:** Is a module-loader completion property
  enough to start the touch HAL?
- **Finding:** The donor delays HAL start until module processing and a touch
  node exist, and documents an earlier panel-registration race. Its fallback
  module sequence is not a complete dependency closure: `nt36532_touch` also
  needs DRM, battery and scheduler providers. The pinned OrangeFox loader can
  publish `twrp.modules.loaded=true` after loading zero modules. Native
  BoardConfig does not enable that loader call, although first-stage init may
  still load vendor_boot modules. A loader property alone proves no readiness.
- **Evidence:** Donor `vendor.xiaomi.hw.touchfeature-service.rc`,
  `touch_perms.sh`, `runatboot.sh` and static `.modinfo`; pinned native
  `partitionmanager.cpp` and `kernel_module_loader.cpp`. Both recovery mirrors
  have the same commit and tree, so they are one implementation.
- **Practical consequence:** Observe module presence, panel/node availability,
  accessible ABI, HAL state and actual input delivery separately. Require
  matching source/config/symbol/signature provenance. Do not copy opaque uinput
  binaries, unbounded restart loops, mode 0666 or disabled SELinux policy.
- **Remaining uncertainty:** Release strings 6.1.68, 6.1.118 and 6.1.138 alone
  cannot establish or reject Android KMI compatibility. No touch event was
  collected in this comparison.
- **Next validation:** Establish exact installed vendor_boot/vendor_dlkm closure
  and implement bounded owned readiness during AUD-034.
- **Supersedes / superseded by:** Refines the DON-U005 startup comparison.

---

- **Lesson ID:** REC-D003
- **Date:** 2026-10-04
- **Environment scope:** Mainline donor init at an exact archived source revision
- **Evidence class:** Source contradiction verified with local pinned Git files
- **Status:** Documentary claim corrected; reference tree preserved
- **Question or previous assumption:** Does the pinned mainline donor's static
  init actually load its packaged USB modules and report UDC status?
- **Finding:** At `32cad9ccd383ff4b37d8a5e7f88a8bfdcc07307e`,
  `docs/UKE_USB_SOURCE_FIXES.md` describes that loader, but
  `images/init_boot/init.c` only prints a greeting. The shell init mounts
  devtmpfs/proc/sysfs and opens BusyBox. Its Makefile builds the greeting helper
  and packages `modules.load`; the inspected startup code does not consume it.
  The module order is intended reference data, not an implemented loader.
- **Evidence:** Exact HEAD and the four files above in the immutable
  `senemos-uke-kernel/referances/community/uke-linux` archive. Both independent
  comparison and parent file inspection confirmed the mismatch without running
  donor scripts or modifying the archive.
- **Practical consequence:** Correct reuse assumptions in recovery intake;
  require executable source and dependency closure for claimed startup behavior.
- **Remaining uncertainty:** Third-party simplefb/torch reports remain separate;
  their missing slot/log/artifact bindings do not become our physical evidence.
- **Next validation:** Close the donor's nineteen parent gitlinks separately
  before any reproducibility or implemented-loader claim.
- **Supersedes / superseded by:** Supersedes any inference from the donor USB
  documentation that this exact pin implements the described loader; preserves
  the intake's platform/USB source classification and existing open gates.

---

- **Lesson ID:** REC-D004
- **Date:** 2026-10-04
- **Environment scope:** Recovery/common/OEM geometry and DTBO provenance
- **Evidence class:** Pinned declarations and transformation source
- **Status:** Existing profile separation reaffirmed
- **Question or previous assumption:** Can donor geometry or regenerated DTBO
  be used as stock authority for both commercial models?
- **Finding:** Recovery donor super size 9,126,805,504, common-device size
  8,321,499,136 and the Global OS3 candidate size 11,274,289,152 are distinct
  inputs. The Resources kernel extraction source also modifies panel refresh
  properties before regenerating DTBO. These are not the owner's installed OS2
  six-LUN geometry or untouched whole-partition stock bytes.
- **Evidence:** Recovery donor `d037467a1643d64979337ad79267c8b8f2e4ca17`,
  common-device donor `d3e10662e157f273a43755a296db98063ace01f0`, native
  `manifests/boot-profile-global.json`, and Resources extraction source
  `446629e5d30c76848bfde9e3a67bcf6386ac24fa`.
- **Practical consequence:** Preserve no fixed native super size; require
  exact model/SKU/capacity/firmware admission in AUD-006 and independent complete
  boot-layout evaluation in AUD-007. Keep transformed display data distinct.
- **Remaining uncertainty:** Physical geometry and fallback rehearsal remain
  unavailable, and neither recovery mirror supplies independent validation.
- **Next validation:** Run profile mismatch and complete-layout fixture controls
  in report order before the combined VM acceptance.
- **Supersedes / superseded by:** Supplements DON-U004 and DON-U006; no physical
  support result is changed.
