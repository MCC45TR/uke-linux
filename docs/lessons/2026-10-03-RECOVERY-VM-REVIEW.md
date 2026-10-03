# 2026-10-03: isolated recovery VM review and renderer corrections

## REC-VM001: forced guest restart is a distinct persistence test

- **Lesson ID:** REC-VM001
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox native partition/Btrfs tools; generic Linux 7.2.8 ARM64 guests
- **Evidence class:** emulation / separate shipping-ELF identity comparison
- **Status:** documented finding
- **Question or previous assumption:** Can current recovery tools be checked after an actual forced restart without connecting a tablet or host block device?
- **Finding:** The partition job guest performed an emergency sysrq reboot while APPLYING, reopened its persistent ext4 journal on a second boot, recognized partial expected writes, resumed to COMMITTED and restored the complete original image hash. Ten checks passed. A separate guest passed fourteen Btrfs ioctl checks, including subvolume/snapshot/send, CRC and lineage checks, refusal of corrupt streams and unsafe rollback, retained-original exchange, scrub, filtered balance and resize.
- **Evidence:** Generic kernel SHA-256 `5691fe5c19ea69328a3cf2990f2ccb05f7eac1ccb600a4c291e927c95183d8a4`; partition CLI `2da5a9c7e9762833ade964de10d201e99d739e6c738e3900fdf97bf844146060`, runner `5cadea2f18f28edb3d3cd5471a00beba31b2b5c361645e8b20b7d987d7853c97`; optional non-shipping Btrfs fixture `a33b0fc9c48a53873142cf23d116589a503d91bce7115265003ddff3dace8053`, runner `2a1be15996315735a5624b19d3e542177208d17aa63165750dc6720666226b6d`. Sanitized VM records are bound to exact executable hashes in the new candidate. The runners attach only their newly created regular-file images and no NIC.
- **Practical consequence:** Retain emergency-restart and host SIGKILL results separately. Attach a prior VM record to a new package only after exact ELF and runner comparison; never transfer it by feature name alone.
- **Remaining uncertainty:** No UFS persistence, real tablet forced restart, six-LUN reset, encrypted userdata, shipping-kernel Btrfs support or Btrfs receive/boot restore was accepted.
- **Next validation:** Develop isolated receive/restore and coordinated stock-reset trials, then independently gate exact-device storage acceptance.
- **Supersedes / superseded by:** Extends REC-L007 with fresh CLI-specific generic-guest evidence; no physical status changes.

## REC-VM002: allocation failure must be a usable renderer fallback

- **Lesson ID:** REC-VM002
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox minuitwrp renderer / native oracle / generic graphical VM
- **Evidence class:** source / failed and corrected reference-host and emulation trials
- **Status:** corrected
- **Question or previous assumption:** Does failure to create a DRM framebuffer safely return to another rendering backend?
- **Finding:** Three unused entries in framebuffer handle/pitch/offset arrays were uninitialized. A host oracle compiling the actual function with poisoned automatic storage reproduced rejection before correction. Separately, three allocation-failure paths freed a resource list that had already been freed, producing a Scudo invalid-chunk abort in the first graphical guest. The correction initializes all plane arrays, removes the duplicate frees and uses one standard mixer unless the connector reports vendor topology. Corrected trials reach fbdev fallback without that abort.
- **Evidence:** [Project patch](../../recovery-uke-ofox/patches/0010-drm-framebuffer-initialization.patch), SHA-256 `0afbeee9715d88a0f563feecd27d657ad3cc40eac7bab9772ac985a822133c30`; [actual-function oracle](../../recovery-uke-ofox/tests/check-drm-surface.sh), SHA-256 `382cdd2fe3dfe07e96ab2a5634aa2852b2487eb11694ee6270d3478e915157f4`. Positive mapping and AddFB/create-dumb failure cleanup passed normally and with pinned address/undefined/leak instrumentation. Full 23-test host and instrumented gates were repeated after the renderer correction.
- **Practical consequence:** Check both successful allocation and every failure cleanup boundary. A generic DRM connector must not implicitly treat a cursor plane as a second mixer.
- **Remaining uncertainty:** The guest's AddFB rejection also reflects a separate XBGR/XRGB format difference. Array initialization alone cannot establish virtio-format or real Uke DRM support. Vendor topology and physical scanout remain untested.
- **Next validation:** Exercise exact shipping Android kernel/display integration and later separate panel/external-output routes on accepted hardware.
- **Supersedes / superseded by:** Corrects the initial graphical failure; earlier renderer fixture scope stays unchanged.

## REC-VM003: generic mainline needs explicit Android-runtime adaptations

- **Lesson ID:** REC-VM003
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox GUI / QEMU 11.1.2 / generic ARM64 Linux 7.2.8
- **Evidence class:** source / failed harness and corrected adapted-emulation trials
- **Status:** documented finding
- **Question or previous assumption:** Can a shipping Android recovery executable be rendered directly on a generic mainline kernel?
- **Finding:** Missing EXTERNAL_STORAGE caused a pre-main crash; legacy virtio MMIO prevented GPU/input probing; missing proc prevented normal dynamic-loader path discovery. Once those were addressed, this recovery's CodeCache still required Android ashmem compatibility unavailable on unmodified mainline. A synthetic property trie alone did not provide it. LD_PRELOAD and a link-time wrap did not redirect the executable-defined symbol as called from shared code. A VM-only relink aliases that symbol to a bounded memfd adapter, alongside a synthetic property area, test fstab, fbdev link and copied-theme page redirect.
- **Evidence:** Graphical kernel `0dafe914751929b011f6a3d8d84e47c51452de4b604d123714b64dd2546e8a80`, configuration `480a9180fcb395fe1d43d2e3dbb4343be79f28f6e286dded9c15656c26467fe8`; QEMU display module RPM `qemu-device-display-virtio-gpu-11.1.2-1.fc46`, SHA-256 `1409ac29f96fa5bb61711bc192f1c6f31f737fadd509e247a1050257e183f987`. [Host preparation](../../recovery-uke-ofox/tests/prepare-gui-vm.sh), [VM runner](../../recovery-uke-ofox/tests/check-gui-vm.sh) and C++ helpers record this adaptation and keep physical/shipping-GUI acceptance false. A stale logged link invocation lacked liblzma; the helper now uses the current generated build recipe. The first property-helper build used stub libc exports and failed; the corrected helper links the actual platform libc. The host property-trie build also required standard headers, the pinned parser and a POSIX strerror ABI adapter.
- **Practical consequence:** Keep these test-only helpers outside shipping build targets and payloads. Report the adapted GUI separately from exact shipping-executable boot. No project Python or tablet Python was introduced.
- **Remaining uncertainty:** No Android init/property service, accepted KeyMint/TEE path, UFS, hardware brightness/thermal, USB gadget, second physical monitor, 75 Hz or MST test was supplied by this environment.
- **Next validation:** Repeat the adapted graphical runner against the final build, then address shipping-kernel/init and exact-hardware integration as separate gates.
- **Supersedes / superseded by:** Supersedes the assumption that a generic graphical guest can serve as exact Android recovery boot acceptance.

## REC-VM004: URE string defaults must not enter theme arithmetic

- **Lesson ID:** REC-VM004
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox actual XML variable loader / boot and management GUI
- **Evidence class:** emulation discovery / source / failed and corrected native regression tests
- **Status:** corrected
- **Question or previous assumption:** Do host callback tests ensure that XML defaults reach callbacks with their original strings?
- **Finding:** The actual boot page showed model and firmware as 0 even though its XML specified poco-pad-x1 and global-os3.0.303.0. The upstream loader interprets any hyphen in a default as subtraction, corrupting these names and hyphenated paths/JSON. The project correction preserves URE-prefixed defaults as literal strings while retaining original geometry arithmetic and existing reviewed selections on reload.
- **Evidence:** [Literal-default patch](../../recovery-uke-ofox/patches/0011-literal-ure-theme-defaults.patch). The regression generator now compiles the actual PageSet::LoadVariables function and upstream RapidXML, rather than checking only stand-in variable assignment. The freshly built baseline failed with `Native URE defaults became theme arithmetic`; failed-trial log SHA-256 `bc40caf4221e23cb503569f026b3ea2f7bbab6df51f58c98c1e9b9aa9c273797`. The corrected test passed; corrected targeted log `b2d798d5f9102354c9137a92a5e352f24c32c572979e4aa3542cd7d1afb11aae`. Cases cover model/firmware, path, JSON, signed number, empty value, preserved selection and unchanged addition/subtraction.
- **Practical consequence:** Test the actual boundary that loads user-facing defaults, as well as callbacks. Treat identifiers, paths and structured records as literal native inputs; parse their types in the native manager.
- **Remaining uncertainty:** Declared model/profile still do not prove installed firmware identity. Correct labels do not authorize an unaccepted backend or device write.
- **Next validation:** Complete final host, pinned sanitizer, build and adapted-GUI gates, and compare corrected visible labels against their exact XML values.
- **Supersedes / superseded by:** Corrects the earlier fixture coverage gap; callback and security-policy results retain their original narrower scope.

## REC-VM005: graphical review needs startup, reload and failure evidence

- **Lesson ID:** REC-VM005
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox graphical smoke / host regression harness / packaging
- **Evidence class:** failed and corrected reference-host build/test trials / adapted emulation
- **Status:** documented finding
- **Question or previous assumption:** Does a rendered splash prove all management pages, input and scaling work?
- **Finding:** Adapted guests rendered the splash, stock settings, URE menu and boot page, accepted mouse and keyboard navigation and visibly changed from 75% to 50% density. A premature screenshot still showed the old scale while TCG rebuilt resources; later logs and a screenshot showed uniform 50% text/icons/targets. Separate default-loading inspection exposed REC-VM004. Runtime/property/vendor/MTP warnings in the generic guest are classified separately from product defects; none becomes a physical-support claim.
- **Evidence:** Private 50% screenshot SHA-256 `39d92566c7526dc7edaff6e9451a110a9e7c086dce97aff24203a7be1c25463d`; private mouse URE-menu screenshot `8478ecf02273fc16718c017070171dbe26c6b2c3ec9f26e90ed7ab412f293ebf`. The XML regression harness initially lacked std::string and RapidXML's error handler; one accidental stale-executable run after compilation failed is explicitly excluded from pass evidence. Pinned Clang then rejected upstream RapidXML signedness warnings; only that upstream include is marked SYSTEM, retaining fatal project warnings. Shellcheck was unavailable; Bash syntax, real build, native/sanitizer execution and actual VM checks were used.
- **Practical consequence:** Bind screenshots and complete private logs to exact adapted/shipping executable identities. Retain failed trials and repeat relevant gates after a correction. New package repeats verify six asset hashes; they do not establish clean binary reproducibility or release signing.
- **Remaining uncertainty:** The full roadmap, every GUI workflow, real distro repair, LUKS/Windows recovery, expanded ADB sessions and signed distribution remain unfinished. BitLocker and SSH/network work remain owner-deferred.
- **Next validation:** Use the reviewed coverage matrix to choose the next ordered implementation and VM tests; measure GUI reload, backup throughput, bounded scans and CI caches without removing durable checks.
- **Supersedes / superseded by:** No device record is superseded; [review report](../../recovery-uke-ofox/reports/URE-VM-REVIEW.md) is the bounded checkpoint.

## REC-VM006: compact density requires viewport anchors and actual placement tests

- **Lesson ID:** REC-VM006
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox built-in theme; native renderer oracle; adapted ARM64 graphical VM
- **Evidence class:** source / failed and corrected host tests / adapted visual emulation
- **Status:** corrected implementation; final visual matrix recorded in the component review
- **Question or previous assumption:** Does an enlarged logical canvas alone keep the stock interface attached to the display edges?
- **Finding:** The owner correctly identified clustered stock controls. Numerous status/battery, toolbar, console and navigation variables still referenced the original 1080-wide phone canvas. File-search background/fields, credits tabs and the right gesture strip also used literal coordinates. Explicit viewport anchors and stock XML replacements retain compact control density while distributing the navigation panel and preserving trailing/center/bottom alignment. The first corrected screenshots exposed a second boundary: LoadAttrInt resolves DataManager variables directly rather than using gui_parse_text. New names therefore need stock variable declarations, not just a text hook. Undeclared toolbar names fell to zero and appeared clipped at the left edge. The correction adds those declarations and tests the actual attribute-loading functions.
- **Evidence:** [Responsive patch](../../recovery-uke-ofox/patches/0012-responsive-stock-theme.patch), [actual density/variable/placement oracle](../../recovery-uke-ofox/tests/ure/display.cpp). Five framebuffer shapes and seven scale percentages are covered. A freshly compiled previous adapter failed with `Status bar retained the phone right edge`, log SHA-256 `cb79b8cbcf1e9c82edb6095bbb58630b813c1345fedb3fcba28af6f78ec18a45`. The placement regression separately failed with `Actual placement loader cannot resolve new stock anchors`, log `11d49221d6f4b9ccaf2215a6b6e901e8db858edcd9286cd7b97a40e752ac8690`, and passed after declarations, log `5de7289e9eac558e283126371768d74768d53a1bd15af6b2b00958764be128f4`. Initial baseline-helper attempts failed because of an assumed system jsoncpp include and a duplicated function opening; neither was executed as acceptance evidence. Loading real stock vars reset the host lock fixture; the fixture now establishes its lock state immediately before the actual reload and simulates the stock reset during package loading.
- **Practical consequence:** Inspect portrait and landscape screenshots after scaling and test actual attribute resolution, not only text expansion or calculated coordinates. Navigation image/touch widths must use the same distributed slots as their centers.
- **Remaining uncertainty:** These are initial fixed-orientation generic VM layouts, not sensor rotation, real touch, external HDMI/75 Hz or unmodified shipping Android GUI acceptance. Every installed recovery workflow still requires its own acceptance.
- **Next validation:** Preserve exact screenshot, interaction, shipping/adapted executable and console hashes; follow the component coverage matrix for remaining device and workflow tests.
- **Supersedes / superseded by:** Extends REC-VM005 and corrects its assumption that visibly smaller controls alone establish responsive stock layout.

## REC-VM007: verification records must reject source changes during a run

- **Lesson ID:** REC-VM007
- **Date:** 2026-10-03
- **Environment scope:** Native host and pinned sanitizer runners
- **Evidence class:** source / intentionally invalidated test-run evidence
- **Status:** corrected
- **Question or previous assumption:** Can an input manifest captured only after tests accurately identify the code that was executed?
- **Finding:** Visual fixes changed theme and test sources while an earlier suite was still running. The sanitizer runner correctly rejected its final source comparison. The native runner previously hashed only at completion, which could bind an old compiled test to newer sources. It now snapshots inputs before configuration and compares again before emitting verification. Results from an in-flight changed-source run are excluded from final candidate acceptance; final runs are made after staging is frozen.
- **Evidence:** [Native runner](../../recovery-uke-ofox/tests/run-native.sh), [sanitizer runner](../../recovery-uke-ofox/tests/check-sanitizers.sh). The invalidated sanitizer log ends with an input comparison failure; its individual passing tests are not a current-source acceptance record.
- **Practical consequence:** Test success and source identity are one gate. A source mismatch requires a fresh build/run, rather than rewriting a receipt around old results.
- **Remaining uncertainty:** This closes a host evidence-binding gap; it is not proof of clean binary reproducibility, signing or physical device behavior.
- **Next validation:** Publish only final unchanged-input records and retain earlier failed or invalidated logs privately.
- **Supersedes / superseded by:** Corrects the native runner's former end-only input capture. Earlier sealed artifacts retain their original evidence scope.

## REC-VM008: isolate host memory and keep large fixtures off tmpfs

- **Lesson ID:** REC-VM008
- **Date:** 2026-10-03
- **Environment scope:** Host Linux build/test environment, pinned Go 1.23.4, cgroup v2 and user systemd
- **Evidence class:** observed host OOM / corrected host resource policy
- **Status:** resource isolation implemented; final command results remain separately gated
- **Question or previous assumption:** Can concurrent build, sanitizer and VM jobs use the host's ordinary temporary directory without disrupting the desktop?
- **Finding:** The owner reported repeated application termination. Read-only kernel logs recorded two global OOM kills of Soong at approximately 18–19 GiB anonymous RSS. A discontinued filesystem fixture occupied about 12 GiB on RAM-backed /tmp; smaller interrupted partition/restore fixtures also remained. Only those identified, owner-matching project-generated directories were removed after preserving small diagnostics. Available host memory rose from about 18 to 24 GiB and swap use fell from approximately 7.8 to 1.4 GiB. The new host wrapper serializes heavy commands, moves /tmp into disk-backed private scratch, and places each command outside the desktop app's cgroup with 9 GiB MemoryHigh, 10 GiB MemoryMax, 512 MiB MemorySwapMax, CPUQuota 200% and TasksMax 256. The host Go runtime gets a 5 GiB soft heap limit, GOGC 40 and GOMAXPROCS 2; native test builds default to two jobs.
- **Evidence:** [Host budget wrapper](../../recovery-uke-ofox/scripts/with-host-budget.sh). A separate probe confirmed memory.max `8589934592`, the new user-service cgroup and a non-tmpfs /tmp. The first real wrapper trial failed because the user-service environment omitted the host ripgrep path and the nested namespace could not write /dev/null. The wrapper now explicitly preserves PATH and binds /dev; a nested probe verified both before retrying the build. Kernel events and interrupted build/test logs remain private. The abandoned directory identities were inspected and no active project writer remained. An attempted rm-style cleanup was rejected by automatic command review; the reviewed exact-directory, same-owner cleanup used filesystem traversal with a same-filesystem boundary instead.
- **Practical consequence:** Memory-heavy tests need both concurrency limits and a disk-backed fixture area. Source receipts from interrupted work do not become passing results. Keep these controls host-only; do not kill unrelated applications or change host-wide overcommit, swap or OOM policy to make a build fit.
- **Remaining uncertainty:** A cgroup limit protects the rest of the host but may terminate an oversized build. Successful final build/test receipts must be obtained separately; the resource probe does not establish recovery functionality.
- **Next validation:** Complete the unchanged-source build, individual graphical guests and host/sanitizer gates sequentially, inspect their logs and publish exact receipts only after success.
- **Supersedes / superseded by:** Corrects the earlier use of overlapping unrestricted heavy jobs; all earlier interrupted runs remain excluded from final acceptance.

## REC-VM009: verify runtime limits at the actual clean-environment builder

- **Lesson ID:** REC-VM009
- **Date:** 2026-10-03
- **Environment scope:** Pinned upstream Soong `6dc77879464584ef3f178cae622134ed0bf19e1e`, Blueprint and host-only resource wrapper
- **Evidence class:** source / observed child-process environment / corrected build policy
- **Status:** host runtime propagation corrected
- **Question or previous assumption:** Does setting Go variables on the outer build shell limit the real Soong process?
- **Finding:** No. The generated primary-builder command uses env -i and only the explicitly constructed invocationEnv. Direct inspection of the running child found none of the outer GOMEMLIMIT, GOGC or GOMAXPROCS variables. Separately, Blueprint resets GOMAXPROCS to runtime.NumCPU. The initial limited run was safe inside its cgroup but unnecessarily slow. It was deliberately stopped, preserving its memory events with no OOM kill. The reviewed host-only patch forwards only GOMEMLIMIT and GOGC into the primary-builder environment. The wrapper additionally applies affinity to at most two already allowed CPUs, so runtime.NumCPU observes that bound; CPUQuota and the memory limits remain in force.
- **Evidence:** [Host Soong patch](../../recovery-uke-ofox/patches/0013-soong-host-memory-policy.patch), primaryBuilderInvocation in ui/build/soong.go, bootstrap command construction in build/blueprint/bootstrap/bootstrap.go and RunBlueprint in bootstrap/command.go. The wrapper probe reported `5GiB`, `40` and `nproc=2`. The patch is checked during staging and included in the owning recovery component's source archive; reference archives remain unchanged. It changes the upstream host build tool's existing Go source and adds no device Go or Python application.
- **Practical consequence:** Inspect the environment and CPU count of the process that actually consumes memory. Shell settings alone are insufficient across a clean-environment launcher or a runtime override. Preserve both failed and corrected trials instead of inferring a successful limit from the outer shell.
- **Remaining uncertainty:** The soft Go heap limit is not a hard process cap; the independent cgroup maximum remains mandatory. Actual completed build and test receipts are separate acceptance gates.
- **Next validation:** Verify forwarded variables in the running builder, retain the completed build's memory peak and complete final sequential checks.
- **Supersedes / superseded by:** Corrects REC-VM008's initial assumption that outer Go variables already reached Soong. Its verified cgroup, disk scratch and serialization results remain valid.

## REC-VM010: an explicit resource budget must reach each job and cache launcher

- **Lesson ID:** REC-VM010
- **Date:** 2026-10-03
- **Environment scope:** Owner-authorized j16 / 16 GiB host build policy, ccache 4.14.1, pinned Android/host C++ builds
- **Evidence class:** host configuration / process probes; completed-build results remain separate
- **Status:** implemented; final cache and build counters are recorded separately
- **Question or previous assumption:** Can the owner-requested 16-job budget improve throughput without returning to unrestricted overlapping builds?
- **Finding:** The host reports 16 logical CPUs and about 30 GiB RAM. The revised wrapper uses a 16 GiB hard cgroup cap, 14 GiB high threshold, 512 MiB swap cap, CPUQuota 1600%, at most 16 allowed CPUs and 2048 tasks. It serializes heavy jobs and retains disk-backed scratch. Go receives a 12 GiB soft limit and GOGC 40. The previous lower-limit graph generation was deliberately stopped; its cgroup had no OOM kill. Lower thresholds were adjusted during that trial and are not final throughput evidence. The new probe reports 16 CPUs, 12GiB, 40, 16 jobs and memory.max 17179869184. The command wrapper now requires a status receipt, preventing a manually stopped service from becoming successful completion merely because systemd classifies SIGTERM as a clean stop.
- **Evidence:** [Resource policy](../../recovery-uke-ofox/docs/HOST-BUILD-BUDGET.md), with-host-budget.sh, build-public.sh, host-ccache.sh, actual pinned build/make/core/ccache.mk and Soong CcWrapper construction. Android and native caches are separate and capped at 10 GB each; content-based compiler checking and empty sloppiness override the upstream permissive make defaults. The existing host ccache was enabled without installing a tablet dependency.
- **Practical consequence:** Cache C/C++ compilation with checked compiler identity, keep heavy jobs sequential and enforce a process-tree memory cap independently of job count. A cold cache, Go graph generation, linking and VM tests do not benefit automatically; measure counters rather than promising a speedup.
- **Remaining uncertainty:** These limits describe the current 30 GiB host and leave desktop headroom. They do not establish that the full Android build fits on a machine with only 16 GiB total RAM, nor complete binary reproducibility or tablet functionality.
- **Next validation:** Retain final build peak/events, inspect actual compiler-wrapper invocations and cache counters, then complete unchanged-source native, sanitizer and visual VM gates.
- **Supersedes / superseded by:** Updates REC-VM008 and REC-VM009's initial conservative two-job policy following the owner's explicit j16 / 16 GiB request. Their failure evidence, serialization, disk scratch and child-environment findings remain valid.

## REC-VM011: CPU concurrency does not bound the builder's OS thread count

- **Lesson ID:** REC-VM011
- **Date:** 2026-10-03
- **Environment scope:** Actual j16 Soong graph generation inside the host resource cgroup
- **Evidence class:** failed host build / corrected process-tree policy
- **Status:** task cap corrected; successful final build is a separate gate
- **Question or previous assumption:** Is TasksMax 512 sufficient for a 16-CPU Android build?
- **Finding:** No. The first j16 run aborted in Go newosproc with errno 11 after creating 476 OS threads, while the cgroup also contained launcher and other build processes. This was a task-count failure, not an observed global OOM. CPU job count and GOMAXPROCS do not cap all blocked OS threads. TasksMax is now 2048; the 16 GiB memory cap, 14 GiB high threshold, swap cap, CPU affinity/quota and heavy-job lock remain mandatory.
- **Evidence:** The actual child command forwarded GOMEMLIMIT 12GiB and GOGC 40. The private build log contains `runtime: failed to create new OS thread (have 476 already; errno=11)` and `fatal error: newosproc`. User-service diagnostics and that failed command's status are retained privately. No failed run is used as compilation acceptance.
- **Practical consequence:** Measure the entire process tree, including OS threads, instead of equating -j16 with 16 tasks. Keep independent memory and CPU limits while permitting the build system's required blocked threads.
- **Remaining uncertainty:** A higher task cap does not prove a successful build or a performance gain. Cache statistics, final memory events and completed-command receipts still require inspection.
- **Next validation:** Retry once with the corrected cap, then retain the actual completed build's peak/events and run the separate test gates.
- **Supersedes / superseded by:** Corrects REC-VM010's initial 512-task assumption without removing its memory or serialization safeguards.

## REC-VM012: host tool parsing must set a deterministic locale

- **Lesson ID:** REC-VM012
- **Date:** 2026-10-03
- **Environment scope:** Resource-isolated Android build, GNU readelf 2.47.50.20260921 and the host ramdisk callback
- **Evidence class:** failed package callback / direct output reproduction / corrected host locale
- **Status:** locale corrected; final image packaging is gated separately
- **Question or previous assumption:** Does the user service preserve the calling tool's C locale automatically?
- **Finding:** No. The source build completed its compiled targets, but the final callback rejected the AArch64 Zstd codec. Inside the new service, readelf printed the translated field `Makine:` while the callback expected `Machine:`. A private probe recorded producer status 0 and grep status 1, the actual translated header and unchanged source-built ELF. This was not a SIGPIPE or an observed OOM. The wrapper and the host-only callback now explicitly set LC_ALL=C and LANG=C before parsing tool output.
- **Evidence:** Actual callback trace, independent header-file and pipeline probes, exact ELF identity and service diagnostics remain private. The interrupted image build consumed 26:47 wall time with approximately 14 GiB cgroup peak, 45.4 MiB swap peak and no recorded OOM kill. Its compiled ELF identities are retained, but it is not a successful image-build receipt. A first diagnostic call omitted the required callback phase and was excluded from acceptance.
- **Practical consequence:** Pin the locale at the layer that parses human-readable output. Keep valid architecture checks and fail closed; do not remove them to make a translated header pass. Resource isolation must preserve or explicitly define tooling semantics as well as memory limits.
- **Remaining uncertainty:** The correction requires a successful callback/image retry, payload audit and separate GUI acceptance. The recorded peak belongs to a failed image build, not a passing package.
- **Next validation:** Retry with the warm compiler cache and C locale, then retain completed image and test receipts separately.
- **Supersedes / superseded by:** Extends REC-VM010/011 and corrects the initial assumption that the failed callback was an ELF or early-pipe-exit defect.

## REC-VM013: complete HID reports reveal a click-canceling touch translation defect

- **Lesson ID:** REC-VM013
- **Date:** 2026-10-03
- **Environment scope:** Actual OrangeFox evdev function oracle and generic adapted graphical VM
- **Evidence class:** native baseline failure / corrected input classification / pending final graphical confirmation
- **Status:** regression reproduced and corrected; final VM acceptance remains separately gated
- **Question or previous assumption:** Do isolated mouse/key edges cover the complete USB HID event stream?
- **Finding:** No. A HID report includes SYN_REPORT after motion and button/key edges. The upstream translator fed these packets into shared touchscreen state and could synthesize an ABS finger-up event, interrupting an actual mouse press before release. Patch 0014 classifies devices from paired absolute-position capabilities; non-touch sync/ABS packets are consumed while real key/relative edges and dropped-queue cancellation are preserved. A native oracle now sends repeated complete button reports and verifies a real touchscreen down/up sequence with an interleaved mouse sync.
- **Evidence:** The freshly built baseline aborts on `result!=0 || event.type!=EV_ABS`. The combined footer/HID baseline log SHA-256 is `50527d311a0fb17ca366bec7597e1b37ea7279d2d5deeb5c19627b33c5e7fbcf`. The first isolated corrected oracle passed. Exact-source final native/sanitizer and live adapted GUI tests are required for acceptance.
- **Practical consequence:** Test complete device reports, including synchronization, instead of only semantic key/motion edges. Preserve cancellation after hotplug/dropped queues and ensure mouse synchronization cannot alter a held touchscreen action.
- **Remaining uncertainty:** This does not prove the owner's USB hub, tablet HID driver or physical touch operation. Capability-probe refusal and actual guest clicks remain separate checks.
- **Next validation:** Repeat the complete input suite and test menu navigation plus scale reload by mouse in both adapted VM orientations.
- **Supersedes / superseded by:** Extends the earlier keyboard/hotplug oracle; its edge-only coverage did not establish complete HID click behavior.

## REC-VM014: a full-width navigation panel does not guarantee a balanced footer or splash

- **Lesson ID:** REC-VM014
- **Date:** 2026-10-03
- **Environment scope:** Actual stock XML loader, five framebuffer shapes / seven scale percentages, and owner-provided visual feedback
- **Evidence class:** native baseline failure / implementation / pending final screenshot review
- **Status:** geometry correction implemented; final visual acceptance remains separately gated
- **Question or previous assumption:** Are the splash and gesture footer automatically responsive once status/menu anchors use the viewport?
- **Finding:** No. The indicator sat 123 theme units above the bottom of a 144-unit reserved footer, leaving asymmetric blank space. It now sits at the footer center (72 units above the bottom); the home gesture region covers the reserved footer. The splash used hardcoded x=540 and undeclared full-viewport centers. Both standard and customized templates now declare centers/dimensions and use viewport-relative placement. The actual XML oracle checks fill coverage and logo centers as well as footer alignment across all 35 geometry/scale combinations.
- **Evidence:** The owner supplied a crop showing the blank-space imbalance. The freshly compiled baseline reports `Gesture indicator is not centered in its reserved footer`; its log identity is shared with REC-VM013. Earlier adapted VM screenshots also expose the left-clustered splash. The full patch stack is verified against an isolated Git index, including prior settings-page changes. Two patch-generation attempts included earlier changes and were rejected by staging; neither became build acceptance. The final patch is generated against the exact preceding stack.
- **Practical consequence:** Review startup, persistent chrome and action hit areas independently. Keep density changes uniform while making position and safe-footer geometry follow the complete viewport.
- **Remaining uncertainty:** A native geometry oracle cannot prove rendered glyph placement, physical gestures, panel orientation or USB display timing.
- **Next validation:** Review portrait and landscape screenshots at 50%, 75% and 100%, then exercise actual input after theme reload.
- **Supersedes / superseded by:** Extends REC-VM007's responsive stock-theme correction and records the owner's subsequent footer feedback.

## REC-VM015: immutable upstream constants must be modeled at placement time

- **Lesson ID:** REC-VM015
- **Date:** 2026-10-03
- **Environment scope:** Adapted graphical VM, actual DataManager source and placement-loader oracle
- **Evidence class:** failed visual review / confirmed source behavior / corrected test boundary
- **Status:** defect confirmed; final corrected placement and VM gates required
- **Question or previous assumption:** Does declaring center_y in splash variables replace OrangeFox's built-in center?
- **Finding:** No. DataManager initializes center_y and screen_original_h in its immutable constant store. A theme SetValue cannot replace them, and LoadAttrInt previously queried that store directly. Text-expression hooks and horizontal anchors were correct, but the logo remained vertically at the scaled 3200-unit theme center. The first host stand-in used only a mutable map, so it falsely allowed this replacement. It now models the actual immutable values and SetValue refusal. The placement loader must consult the explicit viewport-geometry hook before resolving a stored constant; no stored preference is changed.
- **Evidence:** The 1600-by-2560 adapted screenshot shows the logo at physical y=960 rather than y=1280. Actual data.cpp initializes OF_CENTER_Y_S in mConst and variables.h defines its name as center_y. The failed review is retained privately and excluded from final visual acceptance. Actual mouse scale changes to 50% and 100%, menu selection, balanced footer and keyboard folder navigation worked in this intermediate trial. One-second QMP presses allow TCG to render held input; they do not measure tablet latency.
- **Practical consequence:** Platform stand-ins must preserve constant precedence and write refusal. Test both expression expansion and direct placement lookup. Cover the customizable splash and its restore-default template so a reset cannot reintroduce fixed anchors.
- **Remaining uncertainty:** Final rendered startup and both orientations still require fresh review against the final shipping executable identity. The generic guest remains adapted and uses fbdev fallback.
- **Next validation:** Retain the freshly compiled immutable-constant baseline failure, pass the corrected native/sanitizer gates and repeat the visual matrix.
- **Supersedes / superseded by:** Corrects REC-VM014's initial assumption that declaring center_y alone guarantees vertical centering; its footer and horizontal-placement findings remain valid.

## REC-VM016: action menus must not auto-select an empty backing value

- **Lesson ID:** REC-VM016
- **Date:** 2026-10-03
- **Environment scope:** Actual OrangeFox list-item initialization, page-focus/variable-change functions and adapted URE menu review
- **Evidence class:** failed visual review / freshly compiled baseline failure / corrected actual-function oracle
- **Status:** source correction and isolated oracle complete; final GUI/native/sanitizer gates remain separate
- **Question or previous assumption:** Does an action-only listbox reliably start with its first entries visible?
- **Finding:** No. The original constructor marked each empty item value selected when the absent backing variable also had an empty value. Page focus then applied selection scrolling to every matching entry, leaving the URE menu at its last entries. Patch 0015 gates value-based selection on a nonempty backing variable. Action menus retain their position and update conditions; bound selection lists still reveal their stored selected item. The host oracle compiles the actual initializer statements and full NotifyVarChange/SetPageFocus functions, with GUI condition/resource boundaries stubbed explicitly.
- **Evidence:** The intermediate adapted URE screenshot initially showed OS boot/history through partition layout while hiding the earlier scale/diagnostics/rescue entries. A freshly compiled baseline reports `Action-only menu items inherit an empty selected value`. The first harness attempt failed compilation due to its unused baseline-only parameter and is excluded; marking that test-adapter parameter maybe_unused preserved fatal project warnings. The immutable-placement baseline independently failed with `Splash logo is not centered vertically` (log SHA-256 `4afa5480f16589f8e58d658b751efda9a3c06fc79b967b04e9a3c428ffce9100`).
- **Practical consequence:** Verify initial menu position, condition changes, stored selections and actual mouse/keyboard navigation. A menu's existence in XML is not evidence that its first options are visible when opened.
- **Remaining uncertainty:** The fake condition boundary does not validate every upstream condition expression. Final fresh-source native/sanitizer execution and both VM orientations remain required.
- **Next validation:** Repeat the URE opening after scale reload, verify its first entries and test read-only capability/storage output plus menu scrolling in the final adapted guest.
- **Supersedes / superseded by:** Extends REC-VM015's failed visual trial and records a separate list-state defect discovered during comprehensive review.

## REC-VM017: enlarged footer hit regions need evenly spaced centers

- **Lesson ID:** REC-VM017
- **Date:** 2026-10-03
- **Environment scope:** Actual viewport-hook and stock-variable oracle over 35 geometry/scale combinations
- **Evidence class:** freshly compiled baseline failure / corrected geometry
- **Status:** source corrected; final native/sanitizer and adapted GUI gates required
- **Question or previous assumption:** Can three footer targets expand to a third of the viewport while keeping quarter-based legacy icon centers?
- **Finding:** No. The enlarged home/back/console rectangles overlapped because their centers still followed the old quarter-offset positions. Centers now occupy the three equal viewport cells (one sixth, one half and five sixths); target widths retain the existing inset. The native oracle checks ordered, non-overlapping bounds as well as the separate four-item panel and gesture footer.
- **Evidence:** The freshly compiled pre-correction oracle reports `Navigation footer touch targets overlap`. The check is derived from the actual stored stock target widths and resolved centers, not a separate replacement layout. The final source is staged before rebuilding; the previous image is excluded from final release acceptance.
- **Practical consequence:** Expand visual anchors and interactive bounds together, including optional navigation modes. Preserve deliberate gaps so a click cannot ambiguously occupy two neighboring actions.
- **Remaining uncertainty:** Native rectangles do not establish physical touch precision or every custom third-party theme's compatibility. The final adapted guest tests remain distinct from tablet acceptance.
- **Next validation:** Pass the unchanged-source matrix, review the final footer and exercise actual navigation after reload.
- **Supersedes / superseded by:** Extends REC-VM014's gesture-footer finding to the optional three-button mode.

## REC-VM018: publish verified chunks with one atomic namespace operation

- **Lesson ID:** REC-VM018
- **Date:** 2026-10-03
- **Environment scope:** Host Linux, pinned Clang address/undefined/leak instrumentation, private disk-backed fixtures
- **Evidence class:** observed interrupted-publication defect / deterministic native regression
- **Status:** reproduced and corrected; final unchanged-source gates are recorded separately
- **Question or previous assumption:** Does link-then-unlink publication preserve the single-link backup policy at every forced-restart boundary?
- **Finding:** The final sanitizer run failed its interruption/streaming test with `Chunk type, permissions or size differs from manifest`. A published chunk could still have its temporary hardlink when SIGKILL arrived between linkat and unlinkat. The bytes were verified, but the strict one-link policy correctly refused that state. Both regular/storage backup publication and raw-restore mirror publication now use renameat2 with RENAME_NOREPLACE followed by directory fsync. The verifier still refuses foreign hardlinks; unsupported atomic publication fails rather than falling back to the vulnerable pair.
- **Evidence:** Original failed sanitizer log SHA-256 `c9098fd2d89efd2ce6d8941b3e7e346c907e390a0703371123f2334d8bafc162`. A freshly compiled old backup implementation with a host-only linkat wrapper freezes the child at the exposed second-link boundary and deterministically reproduces the same refusal, log SHA-256 `77fafe2bc7f52fdd079358c6786bb1d1d418ea720e23f6ea4fa3875dced63e9e`. The corrected instrumented probe passes actual SIGKILL/resume and foreign-hardlink refusal. The wrapper exists only in the native test executable, not in the Android application or payload.
- **Practical consequence:** Atomicity includes namespace/link-count invariants, not just verified bytes. The implementation correction changes the native CLI and shipping recovery identities, so the earlier native receipt, failed sanitizer run and deliberately stopped graphical trial cannot seal the final candidate. Build, native/sanitizer and matching-CLI guest-reset records must be renewed.
- **Remaining uncertainty:** This does not recover an already ambiguous old backup by weakening ownership checks, nor establish UFS persistence or electrical-power-loss behavior.
- **Next validation:** Complete all unchanged-input gates, fresh generic-guest reset and final portrait/landscape review, then bind their exact executables in the candidate manifest.
- **Supersedes / superseded by:** Corrects the backup publication assumption exercised by REC-VM001/007; their other evidence scopes remain unchanged.

## REC-VM019: observed stock names do not establish physical GPT geometry

- **Lesson ID:** REC-VM019
- **Date:** 2026-10-03
- **Environment scope:** Owner's locked stock Android inventory and generic ARM64 QEMU, six read-only sparse regular-file disks
- **Evidence class:** supplied stock observation / reconstructed namespace / guest verification
- **Status:** namespace and logical allocations verified; physical restore unaccepted
- **Question or previous assumption:** Can the newly available owner's inventory define a faithful physical six-LUN restore target?
- **Finding:** It establishes 121 labels and partition indices across sda/sdb/sdc/sdd/sde/sdf, plus eight active super-relative logical extents. It does not establish numeric UFS LU identities, physical disk capacities, GPT starts or GUIDs. Data filesystem capacity is not UFS capacity. The VM generator retains observed names/indices and logical extents while explicitly synthesizing GPT ranges, GUIDs and blank firmware/userdata placeholders. No original stock bytes or encryption keys are present.
- **Evidence:** Source record STOCK-ADB-20261003-01; Markdown SHA-256 `6b7c6e7301283e4443462a8d54885cca9729d3b0e6b3612a35d1896cff3ce350`, JSON SHA-256 `af65d0124e897678807cf67468c139fdd3e7b9b921420d29039ca6b418079d8c`. The six read-only virtio disks expose every index and one parent per observed group to the shipping native graph. Shipping AOSP liblpdump verifies eight active allocations, total super size 11,274,289,152 bytes and used size 7,936,512,000 bytes. Firmware is OS2.0.205.0.VOZMIXM, Android 15; the recovery build remains OS3.0.303.0.WOZMIXM, Android 16.
- **Practical consequence:** Separate observed namespace, regenerated logical metadata and synthetic physical geometry in every fixture and receipt. Do not transfer current recovery firmware acceptance to the installed OS2 stack or Pad 7.
- **Remaining uncertainty:** Physical GPT backups, real device/LU capacities, wrapped keys, recovery boot and restoration have not been observed. Xiaomi Pad 7 needs an independent profile.
- **Next validation:** Acquire read-only physical geometry through an independently authorized recovery route before any actual restoration plan.
- **Supersedes / superseded by:** Supersedes earlier device-absent assumptions for stock inventory only; recovery, Fedora and PenguinOS hardware gates remain open.

## REC-VM020: generic guests need explicit service boundaries

- **Lesson ID:** REC-VM020
- **Date:** 2026-10-03
- **Environment scope:** Shipping Bionic/AOSP tools in a generic ARM64 guest without Android init/Binder services
- **Evidence class:** failed guest setup trials / corrected isolated adapter
- **Status:** direct metadata-library trial passed; Binder client remains untested
- **Question or previous assumption:** Does copying the normal Android lpdump command into a minimal guest exercise metadata directly?
- **Finding:** The Android executable starts a Binder service and waits for its manager. This minimal guest has neither, so it timed out after native graph discovery succeeded. A VM-only entry point now invokes the shipping library's LpdumpMain directly. The initial proc mount also had to use the absolute Toybox path before the shell's executable resolution could safely rely on proc. Protobuf omits zero sizes, and AOSP text layout prints exclusive super-relative ends; validation now follows those actual conventions.
- **Evidence:** Failed setup and bounded timeout logs remain private. Final namespace output contains URE_STOCK_NAMESPACE_EXIT 0, 121 read-only entries and eight exact layout starts/ends. The helper, library, generator and runner identities are recorded separately. The adapter source is excluded from all Android product packages.
- **Practical consequence:** Treat runtime setup failures separately from storage defects. An adapter may test the same metadata code without claiming Binder or snapshot-service acceptance.
- **Remaining uncertainty:** Normal Android init, Binder access controls and snapshot service lifecycle are not covered by this guest.
- **Next validation:** Test the shipping command in the matching recovery runtime after the firmware/hardware route is established.
- **Supersedes / superseded by:** Extends REC-VM019 and preserves its physical-geometry boundary.

## REC-VM021: review selection, glyph resources and footer behavior separately

- **Lesson ID:** REC-VM021
- **Date:** 2026-10-03
- **Environment scope:** Patched OrangeFox theme/renderer, native platform stand-ins and adapted portrait/landscape guest
- **Evidence class:** source implementation / failed visual and native trials / corrected interaction design
- **Status:** native gates passed; final adapted visual receipt recorded separately
- **Question or previous assumption:** Can a working scale action alone establish a usable tablet interface?
- **Finding:** The added Extra tab now groups display/input, storage, backup, Linux/boot, files and diagnostics. All 360 added list entries have smaller explanatory text. Pin-identified Lucide icons use theme tint and retained ISC/MIT notices. Scale presets/custom input, reset and load change a selection only; Apply validates and queues the existing render-thread reload. A dedicated bottom button stays accessible independently of list scrolling. The first trial used an undefined button font and omitted gesture templates on added pages, leaving a blank button and absent indicator. Those observations were corrected. The fifth navigation target also needed a declared stock variable so the actual variable-loader oracle could inspect it.
- **Evidence:** Actual renderer regression covers 60 layouts and checks icon gaps, bounded labels, arrow margins, smaller fonts and legacy fallback. The exact scale callbacks check reset/load without reload, explicit application and invalid-selection refusal. The first five-target native oracle failed with Navigation touch targets overlap or leave the panel; the corrected real variable declarations pass. Initial screenshots and failed compilation of the new stand-in are excluded from acceptance. SVG, committed PNG and independently rasterized RGBA identities match the pinned Lucide 0.563.0 sources.
- **Practical consequence:** Test actual variable loading and graphical output as well as geometry. Keep controls and hit targets aligned, use existing theme font names, and keep the bottom gesture region independent of scroll content.
- **Remaining uncertainty:** Adapted guest screenshots cannot prove tablet touch/dock timing or arbitrary custom-theme compatibility. Some earlier intermediate capture filenames overstated the visible percentage or page; acceptance must follow observed labels and exact final receipts, not filenames.
- **Next validation:** Complete final 50/75/100 portrait/landscape mouse/keyboard review and bind final screenshots to the shipping/adapted executable hashes.
- **Supersedes / superseded by:** Extends REC-VM015–017. Corrects any intermediate visual claim based only on an unverified screenshot filename while retaining independently proven native results.

## REC-VM022: footer resources must exist when each page is instantiated

- **Lesson ID:** REC-VM022
- **Date:** 2026-10-03
- **Environment scope:** Adapted generic ARM64 OrangeFox guest, stock Files and project Extra pages
- **Evidence class:** observed visual defect / corrected source resource order
- **Status:** corrected; final matching guest review is recorded separately
- **Question or previous assumption:** Does a glyph working on Extra prove that the same footer glyph is available on stock pages?
- **Finding:** The active Extra icon was visible on added pages, but the inactive glyph was missing on Files. Stock pages are constructed before the late maintainer resource include. Both Extra images now belong to the shared stock image resources. Native XML checks require exactly one early definition and no late duplicate.
- **Evidence:** Final-pre-preview landscape job 0S0XTd, adapted recovery SHA-256 `be9fc825ebf8380cc43600dd28e6e8d058ee7a01b1b9e27eb4b622bcc3d8dcac`; reviewed Files screenshot exposes the missing icon. Patch 0017 moves the definitions without changing the glyph bytes. Earlier portrait NqTN7N used a different adapted executable and is excluded from final acceptance.
- **Practical consequence:** Review both selected and unselected footer states on stock and added pages. Correct load order rather than duplicating late resources.
- **Remaining uncertainty:** Arbitrary external ZIP themes are not covered by this resource stack.
- **Next validation:** Inspect Files and Extra at final 50/75/100 portrait and landscape sizes and bind screenshots to final shipping/adapted executable identities.
- **Supersedes / superseded by:** Corrects the overly broad icon-availability assumption in REC-VM021.

## REC-VM023: previews and monitor fit need independent state and ownership

- **Lesson ID:** REC-VM023
- **Date:** 2026-10-03
- **Environment scope:** Native actual GUI widget/callbacks, fake DRM boundary and reviewed upstream patch stack
- **Evidence class:** source implementation / failed mode-policy and preparation trials / corrected regression
- **Status:** native targeted checks passed; final full gates recorded separately
- **Question or previous assumption:** Can a selected scale be previewed without changing the active interface, and can a monitor size share the existing resolution selection safely?
- **Finding:** Five semantic presets use 55/65/75/85/95 percent; Custom scale exposes every five-point value from 50 through 100. The actual widget derives theme fonts relative to the applied percentage, caches unchanged selections and releases its two references on replacement/destruction. Its 605 density/applied/selected combinations retain bounded drawing and show the small-touch warning at 70 or below. Monitor image size is packed atomically with width/height/refresh while scanout resources remain render-thread owned. A size-only change redraws an idle image and reports its actual fit separately. The first monitor test failed because a nonzero scale field accidentally disabled the conservative automatic-mode preference. That preference now checks only width/height/refresh; the existing startup assertion catches the defect. Menu blocks embedded in scroll regions reserve height for their actual row count instead of retaining oversized generic blank regions.
- **Evidence:** Actual preview executable reports 605 reviewed combinations. Corrected native external-display CTest passes the startup preference, all 44 rotation/size conversions, invalid requests, active-size reporting and idle redraw. The preview patch initially had an incorrect hunk count and was refused. A later repeated preparation refused changed context in older density/monitor patches; known newer patches now defer those context decisions to the existing exact isolated-index comparison of the full stack. Unknown final bytes are still refused. The intermediate full native job was explicitly stopped before receipt creation while preparing this correction.
- **Practical consequence:** Treat tablet density, selection preview and output fit as separate state. Retain strong exact-stack verification when newer patches change older context. Renew final hashes and full gates after any such source change.
- **Remaining uncertainty:** Stand-in font/DRM checks do not establish actual tablet rendering, dock negotiation, 75 Hz scanout or touch precision.
- **Next validation:** Complete unchanged-source build, 24 CTests and sanitizer gates, then actual adapted portrait/landscape selection/preview/apply review.
- **Supersedes / superseded by:** Refines REC-VM021's initial three-preset design after the owner's five-preset/custom-page request.

## REC-VM024: static SSC defaults refine readiness without enabling recovery sensors

- **Lesson ID:** REC-VM024
- **Date:** 2026-10-03
- **Environment scope:** Supplied locked POCO Pad X1 Android 15 OS2 inventory; Global OS3 OrangeFox candidate
- **Evidence class:** supplied stock observations / OEM static source finding / conservative interface capability
- **Status:** evidence integrated; recovery stream and hardware acceptance remain open
- **Question or previous assumption:** Can newly acquired board-axis and ALS definitions justify enabling automatic rotation or brightness now?
- **Finding:** The calibration audit adds 67 ODM JSON files, a loader list and 1,100 typed descriptions. Observed LSM6DSO candidates map x to -x, y to -y and z to +z; QMC6308 filenames strengthen a supplier candidate. The stock display dump selects the front STK3BCx non-wakeup ALS for automatic brightness. Raw SSC connection fields cannot be translated directly to AP I2C buses, Linux regulators or TLMM pins. Exposed stock IIO symlinks identify PMIC ADCs, not a recovery IMU/ALS stream. The interface therefore reports automatic rotation/brightness unavailable and exposes manual controls. No calibration data or speculative DT wiring is installed.
- **Evidence:** Read calibration Markdown SHA-256 `6ed8c89261ed7f2b5b5ca6ea5d9393fb86dd3b5b043f4a64e822de0f76193cbd`, record STOCK-ADB-20261003-03; corrected stock Markdown SHA-256 `1a32b434ab651680dd868844ee8e3df532e7c0f4e4fe829b73f09145dedefa6f`. The source audit shows `fsm_re25_show()` initiates forced calibration and save even when read; that attribute is not probed. Recovery diagnostics retain their narrow allowlist.
- **Practical consequence:** Resolve matched firmware/services, effective registry and units/timestamps before enabling a sensor bridge. Validate fixed poses and lux response; apply orientation once. Never recursively collect readable sysfs attributes as presumed side-effect-free diagnostics.
- **Remaining uncertainty:** Private unit calibration, dynamic streams, persisted registry, recovery boot and the separate Pad 7 profile remain unverified.
- **Next validation:** Establish a separately authorized matching recovery observation route and measure the reviewed IMU/front ALS stream without calibration mutation.
- **Supersedes / superseded by:** Supersedes the earlier assumption that board connection/orientation metadata was entirely unavailable; it does not change any recovery hardware acceptance result.

## REC-VM025: isolate launch setup and asynchronous rendering from acceptance

- **Lesson ID:** REC-VM025
- **Date:** 2026-10-03
- **Environment scope:** Host user-service isolation, packaged QEMU 11.1.2 and adapted ARM64 OrangeFox guests
- **Evidence class:** failed host setup / interrupted emulation / corrected visual procedure
- **Status:** corrected; unsuccessful and interrupted jobs excluded
- **Question or previous assumption:** Does an outer environment or a QMP acknowledgement establish a running guest and completed interface update?
- **Finding:** The systemd service did not inherit QEMU variables outside the resource wrapper. The packaged emulator also needed its matching module directory to expose virtio GPU/HID devices. An explicit env command inside the wrapper and the matching QEMU_MODULE_DIR fixed the launch without changing the tested runtime sources. A separately interrupted portrait guest terminated with SIGTERM; it has no clean completion receipt. After queueing Apply 75%, an immediate landscape screenshot still showed Current 100%; the later accepted screenshot showed Current 75%.
- **Evidence:** Final corrected jobs WX3RGO and U8P6aw each contain URE_GUI_EXIT 0 and powerdown. Job 3jIMxN is excluded. Accepted landscape-applied-75-later.png is bound in the final visual receipt SHA-256 `db145b786469942ef9697e7979ba4c88ff42f587636a571a3b572392a017a9cd`. Native/sanitizer input manifest remains `090bb8ff5a03921516dd0d6ad6292200af4a4f64bfc8940473ceded8d3f57eb3`; no pass was transferred from an interrupted guest.
- **Practical consequence:** Verify child environments and packaged emulator modules before launching. Inspect rendered current/selected labels after asynchronous changes; retain original screenshot hashes, not just names. Persist review observations privately so an interrupted conversation does not lose accepted evidence.
- **Remaining uncertainty:** TCG render delays are not tablet touch latency measurements. Mainline guest adapters do not establish shipping Android GUI or physical sensor behavior.
- **Next validation:** Use the separately approved hardware route to measure actual rendering/input and sensor timing on the installed firmware profile.
- **Supersedes / superseded by:** Completes REC-VM021–023's final visual requirement while explicitly excluding earlier partial or stale captures.

## REC-VM026: seal the checkpoint with exact source and executable identities

- **Lesson ID:** REC-VM026
- **Date:** 2026-10-03
- **Environment scope:** Host C++ and pinned sanitizers, j16/16 GiB shipping build, extracted ARM64 payload and generic guest tests
- **Evidence class:** host / build / package / emulation
- **Status:** checkpoint gates passed; commercial device acceptance remains open
- **Question or previous assumption:** Can the final preview build reuse previous storage guest results and seal a visual review without conflating their scopes?
- **Finding:** All 24 native CTests and CLI gates pass against one unchanged input manifest. Matching address/undefined/leak checks pass in 431.41 seconds, plus the separate poisoned-allocation DRM oracle. The shipping j16 build completes in three minutes under a 16 GiB job cap, recording peak 15,033,548,800 bytes and zero memory-max, OOM or kill events. Two images and the installer ZIP repeat byte-for-byte. Fresh extracted payload checks confirm recursive no-Python/privacy, ELF closure and ARM64 CLI behavior. Nine portrait and eleven landscape captures confirm actual applied 50/75/100 sizes, deferred preview/Apply, described rows, active/inactive Extra icons, viewport anchors and mouse/keyboard navigation.
- **Evidence:** Input manifest SHA-256 `090bb8ff5a03921516dd0d6ad6292200af4a4f64bfc8940473ceded8d3f57eb3`; shipping recovery `2493670a7e06170d0bec52acdafa08e6a274ea72086ae233277cf45aafd78727`; adapted recovery `5c82f4df107a6ec764807e33e38a1056d1822e882739f9946d39bbbbbc3b97bf`; native CLI `9199d27343d258480f97898ae9bf7593370206ba4eee17dcc64d07383891ac5b`; visual receipt `db145b786469942ef9697e7979ba4c88ff42f587636a571a3b572392a017a9cd`. The unchanged CLI, Btrfs fixture and stock namespace helper/library hashes retain their separately bound 10-check emergency-reboot, 14-check Btrfs and six-disk/121-label namespace receipts. Parent tests report 19 host checks and no hardware tests.
- **Practical consequence:** Publication gates compare current source inputs, runner hashes and executable identities before attaching each receipt. Package repeatability is distinct from a clean binary-reproducible build. Raw logs, screenshot images and unit calibration remain private.
- **Remaining uncertainty:** Live UFS/GPT writes, both model/SKU stock restores, encrypted userdata, Btrfs receive/boot integration, real Arch/Fedora repair, actual dock/QHD75/HID/sensor behavior and the complete roadmap remain unaccepted. Generic guests do not close these requirements.
- **Next validation:** Continue the remaining source features in the recorded order and perform profile-specific hardware acceptance through a preserved stock recovery route. Benchmark resource reuse, bounded backup pipelining and optimized assertion-preserving host fixtures before changing defaults.
- **Supersedes / superseded by:** Supersedes the earlier pre-preview executable checkpoint for interface acceptance; preserves unchanged storage guest receipts only where their exact binary dependencies still match.

## REC-VM027: keep package-repeat receipts specific to the rebuilt candidate

- **Lesson ID:** REC-VM027
- **Date:** 2026-10-03
- **Environment scope:** Host packaging and offline experimental-candidate sealing
- **Evidence class:** rejected package identity / corrected evidence selection
- **Status:** corrected without relaxing the gate
- **Question or previous assumption:** Can the candidate's earlier repeat receipt remain valid after the preview rebuild?
- **Finding:** The first seal attempt rejected all three checksums because its candidate-named receipt still identified pre-preview assets. The already recorded final pair had independently matched byte-for-byte before this attempt. The earlier record was retained privately and the candidate now references the matching final pair.
- **Evidence:** Final fastboot image SHA-256 `fdb1b7e00ec6f66d30040b82a78e6e45893b8b7fbe8e92bb5911638fc7a80389`; recovery image `77f7cbf86aaa97a62fb0bfbb3781eb11dffbf9430709ac4fc3e00e92fc0b6c38`; installer ZIP `52d67a7065f826c72f4616047bf158edae688352af1b4b2b6831f41b852fcf79`. Separate first/repeated packaging logs and the final comparison are retained privately; the manifest's checksum gate now accepts these exact bytes.
- **Practical consequence:** Renew package-pair provenance after rebuilds. Preserve the rejected evidence, verify the correct recorded pair and keep checksum enforcement intact; do not synthesize a repeat claim from the current package alone.
- **Remaining uncertainty:** Two matching packages do not establish independently reproducible binary compilation or device flashing success.
- **Next validation:** Verify every sealed checksum and preserve a distinct receipt for any later source, compiler or package change.
- **Supersedes / superseded by:** Refines REC-VM026's packaging closure; retains the earlier pre-preview record as historical evidence only.
