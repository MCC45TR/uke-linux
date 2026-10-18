# Development changes

## 18 October 2026

Environment: POCO Pad X1, 8 GB / 512 GB, Fedora Rawhide AArch64, original KDE
Plasma and stock Android bootloader. These results concern the development
installation. The public Alpha 1 images retain their older kernel and have not
been accepted as complete exported images on this tablet.

### Installed and observed

- **Kernel 7.2.11-2:** signed COPR 11168745 installs through DNF. Boot B is
  written and read back, Android A is unchanged and earlier tested image/modules
  are retained. A normal reboot reaches KDE; physical display and touch pass.
- **VRR preference and observation:** KDE Always persists through that reboot.
  An eight-second DRM/DPU capture measures about 30 Hz idle while the configured
  upper mode remains 144 Hz. The user accepts the development VRR/touch profile;
  optical cadence and complete receiver/endurance qualification remain separate.
- **Native management:** signed COPR 11168593 installs uke-control 11 and its
  separate development diagnostics. Signed COPR 11169204 upgrades runtime and
  charging helper to 7. Exact source/signature/native payload and DNF verification
  pass; charge workers stay disabled. The 3690 MiB half-RAM
  swap survives reboot. Existing swap-partition preference remains untested.
- **Charging configuration:** an explicit input-off operation enables the
  existing firmware 70/80 band. Readback survives normal reboots through
  7.2.11-2, without service replay. A later powered observation reaches reported
  80% with positive battery current; physical charge stop remains unqualified.
  A separate fixed target-application request is prepared for 7.2.11-3.
- **Minimal charging interface:** signed runtime cohort 7 retains the separate
  native offline screen. Its normal-boot guard refuses drawing over KDE; the
  desktop and touch service remain uninterrupted. The interface includes a large
  battery, percentage, firmware time-to-full, signed battery-side power and
  temperature. Missing time data remains unknown. Actual charger boot is untested.
- **USB dock:** the powered Juo dock on kernel 27 enumerates its hubs, receiver
  and RTL8153; mouse movement passes evdev and physical confirmation. Kernel 28
  enables compressed firmware loading; ethtool reports rtl8153b-2 v2 04/27/23.
  SuperSpeed enumeration is distinct from throughput or Ethernet traffic.
  Kernel 7.2.11-2 corrects the WCD AUX status address/mask. Its powered HDMI
  validation remains behind the charging gate.
- **Manual CDC:** CDC defaults off. Explicit one-shot management uses
  `uke-control set cdc on/off`; it has no persistent gadget service. Development
  SSH uses infrastructure Wi-Fi.
- **External brightness preparation:** original Fedora ddcutil is installed.
  Adaptive-display 9 initializes original PowerDevil/libddcutil after reboot
  while excluding internal GENI buses. Physical DDC/CI brightness remains open.
- **Bluetooth audio:** soundcore Space Q45 stereo playback is reported clear;
  PipeWire confirms an active A2DP/LDAC transport. HFP, latency and lifecycle
  qualification remain separate.
- **Power and sensors:** three desktop CPU/GPU profiles switch successfully;
  the current profile is balanced. Native sensor readiness and original KDE
  interfaces are retained. These observations do not close jank, energy,
  thermal, color-temperature or complete sensor-accuracy work.
- **Fastfetch:** signed COPR 11169224 installs 2.68.1-2. A non-x86 guard removes
  the legacy PC BIOS memory scan that caused root SIGBUS. The all-module root
  capture completes at exit 0 without a device-permission workaround. Missing
  cache geometry and unavailable hardware remain explicit.
- **Scrolling measurements:** a physical original Settings-list trial records
  approximately 143.9 Hz DPU timing and application CPU use approaching one full
  core. GPU frequency responds to load. Content frame rate and the reported
  stutter remain unresolved; no KDE application is forked or replaced.
- **Suspend policy:** signed COPR 11169255 installs adaptive-display 10. Standard
  systemd selects s2idle at startup and each suspend request; logind reports
  suspend available after deliberate removal of earlier laboratory masks. A
  device-test PM phase and one real approximately 26-second s2idle cycle return
  with zero failure counters. The recorded wake IRQ maps to the RTC alarm;
  Wi-Fi reconnects about nine seconds after resume. Physical display/input,
  power-key wake, repeated cycles and sleep power remain separate gates.

### Remaining work

The next kernel, 7.2.11-4/sourceac1ed7e, adds the fixed input-off application
probe for the already enabled 70/80 band and reviewed AudioReach response and
readiness changes. Fresh ordered 79-patch/native preparation, actual battery
and audio fixtures and complete AArch64 translation units pass. Full
[COPR 11169288](https://copr.fedorainfracloud.org/coprs/build/11169288/) is in
progress; it is not installed. The prior -3 full kernel compiles, but its package
check fails because compiler-rt is missing; -4 declares that build dependency.
Audio stays disabled, with no admitted speaker,
microphone, DAI or amplifier path. Opaque charging receipt/readback cannot prove
actuator effect or battery bypass. Actual offline charging remains untested.

Qualify charge-stop behavior, reboot-persistent protection and any actual
bypass/system-power path before resuming powered HDMI tests. HDMI output,
Ethernet traffic, storage throughput and external brightness still need physical
tests. The internal display uses the OEM 10-bpc RGB/DSC path; selectable 8/12/16-bpc
modes are not implemented. White-flash behavior, stability and energy efficiency
remain open. S2idle is now enabled at the user's request; actual sleep/resume
and energy validation remain open. Display-only blanking is a separate action.

Source, host tests, signed packages and physical observations are reported
separately in the [hardware support table](README.md#hardware-support).
