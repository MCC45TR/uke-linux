# 2026-10-03: Native-resolution interactive recovery window

- **Lesson ID:** REC-W001
- **Date:** 2026-10-03; launch inspection at 20:57 UTC
- **Environment scope:** OrangeFox VM-only adapted GUI, generic ARM64 Linux
  7.2.8, QEMU 11.1.2, desktop GTK window
- **Evidence class:** Host runtime preparation and emulation
- **Status:** Initial window defects corrected; closed at the owner's request
  before the 4 October audit, without complete owner manual acceptance
- **Question or previous assumption:** Would changing the previously reviewed
  headless guest into a GTK window preserve its requested framebuffer dimensions
  and open the added Extra tab?
- **Finding:** The first window selected a 640 by 480 framebuffer despite the
  virtual GPU's requested dimensions. Its startup redirect also used nonexistent
  page `ure_extra`; logs explicitly reported the missing page, and the captured
  frame was unsuitable for review. The actual Extra page is `ure_home`. A fresh
  disposable guest now opens that page, requests `xres=3200,yres=2136` and uses
  `video=Virtual-1:3200x2136@60`. Recovery's fbdev log and a QMP screenshot both
  independently establish 3200 by 2136 pixels. These dimensions match the
  owner-supplied stock inventory's active SurfaceFlinger mode. The generic VM's
  requested 60 Hz is not a measurement of the tablet's refresh rate.

  The shipping device default rotates its physical panel. Only the private
  interactive guest sets `persist.twrp.rotation=0` before starting the existing
  VM-adapted GUI, so the desktop image and input use the same upright landscape
  coordinates. The native preview was inspected: six described Extra categories,
  icons, full-width footer and centered gesture strip are visible. Initial
  interface scale is 75 percent; GTK fits the window to the host screen separately.

  The previously extracted emulator supplied no window backend. Signed Fedora
  GTK/OpenGL modules and the missing VTE/simdutf host libraries were extracted
  into a private project build directory. No host package installation was
  performed. The interactive process uses the existing emulator ELF with the
  host loader/library closure and private window modules. These host additions
  are not recovery payloads or new release acceptance inputs.
- **Evidence:** First window console SHA-256
  `e63d967e9946bef5f452ab70b6d0b23629ffe9afe647ecc26160d56b8d5f043a`;
  rejected 640 by 480 screenshot SHA-256
  `66fa0d8a120889d8b8b90d1a1f8022c0786779869a79081909f112e0052f514a`.
  Corrected 3200 by 2136 Extra screenshot SHA-256
  `9dcde9d0117e568efeec21b473c1b01a1508c5d0370eeea791c418185624ce9a`.
  Private guest init SHA-256
  `2dec698a15f1c7f1fde156b5b1db5f130b6666010a2f4f140e2e8091c3d90d96`;
  private window launcher SHA-256
  `51f12d099ff25dd09ea3ec136dfc6fe7c4f0c94807f3ff5ac11019e37d9efab1`.
  The unchanged adapted GUI ELF remains
  `5c82f4df107a6ec764807e33e38a1056d1822e882739f9946d39bbbbbc3b97bf`.

  All four extracted x86-64 RPMs passed `rpm -K` digest/signature checks:

  | Host package | SHA-256 |
  |---|---|
  | qemu-ui-gtk 2:11.1.2-1.fc46 | `4854462b9c7d6da9aa6a00ef6c0a823a068bff1c7cfed005a5bd61c225877843` |
  | qemu-ui-opengl 2:11.1.2-1.fc46 | `aa4ad2f3e6840edf503a4b643aae2f300a5e83d119713cb66baa5490a639780d` |
  | vte291 0.84.1-1.fc45 | `ea4093428c9c08e6c40163570511e5ac033dc1dc93410cdb54357512c3e5598a` |
  | simdutf 7.2.1-3.fc44 | `d3173e5dc2853113286b06a939ddc4b9ddc9e93915d72d0c2b8fa2c6c62c7af1` |

  QMP reported the process running. The desktop service was active with a
  4 GiB host memory maximum; the guest uses 2 GiB and two emulated CPUs. Raw
  screenshots, serial output, host dependencies and launch files remain private.
- **Practical consequence:** Verify the actual guest framebuffer and a rendered
  frame rather than relying on command-line dimensions or process existence.
  Check startup page names against the loaded theme. Keep desktop-specific
  rotation, display modules and mode selection outside shipping recovery.
  The manual session had no automated smoke-test deadline and was later closed
  at the owner's request. Only newly created regular-file data
  and cache disks are attached, with no NIC or USB/host block passthrough.
- **Remaining uncertainty:** This is a generic interactive GUI session, not
  shipping-kernel boot, physical display/input, HDMI, sensor, storage or full
  feature acceptance. No complete owner interaction acceptance was recorded;
  closing the session does not establish it. Previously sealed release candidates and verification receipts were
  not changed by this session.
- **Next validation:** Preserve the bounded window evidence and collect any
  specific owner findings separately. Repeat relevant native/rendering checks after any product fix;
  record final manual observations separately from existing automated receipts.
- **Supersedes / superseded by:** Corrects the initial interactive window only;
  it does not supersede REC-VM026/REC-VM027 or the production CLI records.
