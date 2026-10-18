# Development changes

## 18 October 2026

Environment: POCO Pad X1, 8 GB / 512 GB, Fedora Rawhide AArch64, original KDE
Plasma and stock Android bootloader. These results concern the development
installation. The public Alpha 1 images retain their older kernel and have not
been accepted as complete exported images on this tablet.

### Installed and observed

- **Kernel 7.2.10-29:** signed COPR 11168479 installs through DNF. Boot B is
  written and read back, Android A is unchanged and the previous 28 image/modules
  are retained. A normal reboot reaches KDE; physical display and touch pass.
- **VRR preference and observation:** KDE Always persists through that reboot.
  An eight-second DRM/DPU capture measures about 30 Hz idle while the configured
  upper mode remains 144 Hz. The user accepts the development VRR/touch profile;
  optical cadence and complete receiver/endurance qualification remain separate.
- **Native management:** signed COPR 11168593 installs uke-control 11 and its
  separate development diagnostics. Signed COPR 11168630 installs runtime and
  charging helper 6. RPM/source checks and native self-checks pass. The 3690 MiB half-RAM
  swap survives reboot. Existing swap-partition preference remains untested.
- **Charging diagnostics:** metadata status remains read-only. With input off,
  the explicit root query reads firmware restart 70%, stop 80%, feature disabled.
  Old-kernel and ordinary-user requests fail explicitly without a fallback.
  No control permission, SET, electrical cutoff or bypass follows from a read.
- **Minimal charging interface:** signed COPR 11168630 installs the separate
  native offline screen. Its normal-boot guard refuses drawing over KDE; the
  desktop and touch service remain uninterrupted. The interface includes a large
  battery, percentage, firmware time-to-full, signed battery-side power and
  temperature. Missing time data remains unknown. Actual charger boot is untested.
- **USB dock:** the powered Juo dock on kernel 27 enumerates its hubs, receiver
  and RTL8153; mouse movement passes evdev and physical confirmation. Kernel 28
  enables compressed firmware loading; ethtool reports rtl8153b-2 v2 04/27/23.
  SuperSpeed enumeration is distinct from throughput or Ethernet traffic.
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

### Remaining work

The next kernel targets signed Linux 7.2.11, the current kernel.org stable source
on 18 October. All 77 base patches, native source preparation, guarded battery
fixtures and full AArch64 battmgr/early-boot translation units pass. Full
[COPR 11168638](https://copr.fedorainfracloud.org/coprs/build/11168638/) is in
progress; it is not installed. Its explicit charger-boot handoff and restricted
existing 70/80 cap enable still require matched-kernel device tests. Source and
package results do not qualify physical offline charging or battery bypass.

Qualify charge-stop behavior, reboot-persistent protection and any actual
bypass/system-power path before resuming powered HDMI tests. HDMI output,
Ethernet traffic, storage throughput and external brightness still need physical
tests. The internal display uses the OEM 10-bpc RGB/DSC path; selectable 8/12/16-bpc
modes are not implemented. White-flash behavior, stability and energy efficiency
remain open. Actual system sleep remains deferred; display-only blanking is
separate from s2idle.

Source, host tests, signed packages and physical observations are reported
separately in the [hardware support table](README.md#hardware-support).
