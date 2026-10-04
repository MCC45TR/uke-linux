# 2026-10-03: Production recovery CLI function tests in an isolated guest

These records describe OrangeFox functions in a disposable generic ARM64 VM.
The production CLI and packaged tools are copied without relinking. Synthetic
roots and file disks do not establish Xiaomi Pad 7 or POCO Pad X1 acceptance.
Raw console logs and test media remain private.

## REC-F001: Shell bootstrap must match the packaged Android shell

- **Lesson ID:** REC-F001
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox recovery function-test guest
- **Evidence class:** Emulation and host test infrastructure
- **Status:** Corrected
- **Question or previous assumption:** Could generic shell helper names and a
  default here-document temporary directory be reused without checking mksh?
- **Finding:** Packaged mksh already defines `hash` as an alias. A helper of that
  name did not return the plan digest, causing `editor-confirmation` to fail.
  The first rescue guest also lacked the shell's default temporary directory;
  a here-document failed and PID 1 exited. The guest now uses `plan_digest`,
  sets `TMPDIR` to its private mounted temporary filesystem, and traps unexpected
  shell exits to report failure and power down.
- **Evidence:** Failed core console SHA-256
  `6033a2fcaab76e0ffdd64de32fb6b28724536590f94433814dbdf52baa33fa6e`;
  failed rescue console SHA-256
  `751e523b1ad308ce0f154c150c302294d30e23b8b281c6eb2f0a83ae5ca0602a`.
  A separate initial payload scan rejected a literal home-directory path in
  the fixture script; a relative synthetic home name corrected the fixture
  without weakening the scanner. Its host log SHA-256 is
  `f4e9b5d4bb7e2e1008ebaf9f7c4dbdd05b04b8b3d7358b9496be8c4e6352f158`.
- **Practical consequence:** Keep guest setup compatible with the shipped shell
  and enforce the payload gate before boot. Bootstrap failures cannot create a
  passing receipt.
- **Remaining uncertainty:** This tests the synthetic init environment, not
  stock Android init, vendor services or physical recovery startup.
- **Next validation:** Preserve the bootstrap checks whenever the packaged shell
  or generic kernel changes.
- **Supersedes / superseded by:** The failed trials are retained as failure
  evidence; they are excluded from accepted function-test records.

## REC-F002: A missing backup tail differs from an internal gap

- **Lesson ID:** REC-F002
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox raw image backup in a generic guest
- **Evidence class:** Emulation
- **Status:** Corrected fixture assumption; production refusal retained
- **Question or previous assumption:** Would deleting chunk 1 from a complete
  backup necessarily represent an interrupted partial capture?
- **Finding:** Later chunks were still present. The production CLI correctly
  classified this as an internal gap and returned `invalid-backup`. The test now
  checks that refusal separately, then removes the entire tail after chunk 0
  to model resumable interruption. Both 512-byte and 4096-byte sector cases
  complete and verify after resume.
- **Evidence:** Failed trial console SHA-256
  `f448e04c75f3296bc57bbfb245f35a254b9e5e237ccf7dbe099cc11d87318a8b`;
  accepted core console SHA-256
  `1313cf3b11c90046d6f81c697d64ea5d9845ac12a71c4b6dbe24ba0bf10cdd34`.
- **Practical consequence:** Keep internal corruption refusal strict. A resumed
  capture must establish a contiguous verified prefix before writing its tail.
- **Remaining uncertainty:** File images do not test UFS controller behavior,
  physical sector geometry or encrypted userdata.
- **Next validation:** Repeat the same corruption and resume cases against any
  future live-write backend before accepting device storage operations.
- **Supersedes / superseded by:** The failed fixture's partial-state expectation
  is superseded by distinct gap-refusal and contiguous-prefix checks.

## REC-F003: Test source metadata before judging restored metadata

- **Lesson ID:** REC-F003
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox Linux home tree backup in a generic guest
- **Evidence class:** Emulation
- **Status:** Corrected fixture assumption
- **Question or previous assumption:** Did `mkfifo -m 640` under a private
  `umask 077` create the mode assumed by the comparison?
- **Finding:** The synthetic FIFO had mode 0600, and restore preserved it
  correctly. An explicit `chmod 640` now establishes the intended source mode
  before capture. Content, hardlinks, symlinks, FIFO type, permissions, xattr,
  sparse allocation and an opaque newline-containing filename all compare
  against independently constructed source expectations.
- **Evidence:** Failed metadata trial console SHA-256
  `a2e8154df3b732e3769de33cf6c77c505339003eea41a9a9ff3e60cb7b440d7c`;
  accepted core receipt includes
  `home-content-hardlinks-symlinks-fifo-mode-xattr-sparse-and-opaque-names`.
- **Practical consequence:** Verify fixture creation semantics; do not change
  restoration policy to compensate for an incorrect test expectation.
- **Remaining uncertainty:** This does not establish every installed Linux
  filesystem's ACL, SELinux policy or distribution-specific restore behavior.
- **Next validation:** Extend metadata fixtures only for documented additional
  metadata contracts, with independent source/readback checks.
- **Supersedes / superseded by:** The failed source-mode assumption is superseded
  by explicit source metadata setup.

## REC-F004: Host assertions must check the actual safe refusal stage

- **Lesson ID:** REC-F004
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox home restore controller
- **Evidence class:** Emulation and host assertions
- **Status:** Corrected; failed host trial excluded from acceptance
- **Question or previous assumption:** Should a restore attempted before any
  capture return `incomplete-tree`?
- **Finding:** The capture state record does not yet exist, so the CLI returns
  `path-unavailable` and creates no output target. All guest operations passed
  in that trial, but the host expected the wrong refusal code and correctly
  withheld its receipt. The assertion now requires `path-unavailable` and the
  guest still independently checks that no target was created. Failed JSON
  assertions now print the record name and predicate for diagnosis.
- **Evidence:** Guest-complete but host-rejected console SHA-256
  `01d3cb99a98451af2139c0c22d1f4c0deb8850c414603bbf8c2f7e850318a8e2`;
  the subsequent accepted core record checked all 73 JSON outputs.
- **Practical consequence:** A guest success marker alone is insufficient. Both
  the independent byte checks and exact host refusal predicates must pass.
- **Remaining uncertainty:** Error codes may intentionally change with an
  explicitly reviewed CLI contract change; a harness mismatch is not itself
  evidence of a runtime storage defect.
- **Next validation:** Keep refusal codes and no-side-effect checks paired when
  adding incomplete or corrupted backup fixtures.
- **Supersedes / superseded by:** The previous pre-capture error-code expectation
  is superseded; production code was unchanged.

## REC-F005: Generic devtmpfs differs from Android loop aliases

- **Lesson ID:** REC-F005
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox filesystem function-test guest
- **Evidence class:** Emulation and guest fixture infrastructure
- **Status:** Fixture corrected
- **Question or previous assumption:** Would Android Toybox loop auto-discovery
  return a usable node in the generic Linux guest?
- **Finding:** The kernel has built-in loop support and exposes `/dev/loop0`
  through devtmpfs. Toybox auto-discovery returned `/dev/block/loop0`, an Android
  alias absent in this synthetic guest. The test now selects its known unused
  guest loop node explicitly and checks that it is a block node before binding
  the newly created test image.
- **Evidence:** First filesystem console SHA-256
  `030afd42f6b92f7a8cdf87d3cf77d0a7aaa6d2b964364da51b1336b30547edcf`;
  generic kernel configuration has `CONFIG_BLK_DEV_LOOP=y` and minimum count 8.
  The guest reported `URE_FUNCTION_FAILURE unexpected-shell-status-1` and
  powered down rather than recording a pass.
- **Practical consequence:** Model namespace differences in the disposable
  fixture. Keep the production target-ownership policy unchanged and check its
  live-loop alias refusal before any journal or byte mutation.
- **Remaining uncertainty:** This does not accept Android device-node creation
  or a physical loop mount in recovery.
- **Next validation:** Complete the corrected filesystem group and bind its
  accepted receipt to the exact updated guest script.
- **Supersedes / superseded by:** The failed automatic-discovery fixture is
  superseded by explicit selection of the fixture-owned guest node.

## REC-F006: Production CLI operations can be tested without modifying their ELF

- **Lesson ID:** REC-F006
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox production CLI on generic Linux 7.2.8
- **Evidence class:** Emulation
- **Status:** Documented passing core group
- **Question or previous assumption:** Which functions can be validated beyond
  the adapted GUI smoke and visual tests?
- **Finding:** The unchanged shipping CLI completed transactional file editing
  and exact rollback, eleven private scale setting round trips, two raw image
  backup/restore workflows, metadata-preserving home restore and observed
  SIGKILL/resume. Six independent data/metadata checks and 73 JSON assertions
  passed. Every run creates only new regular-file test disks with no host block
  attachment, USB passthrough or NIC.
- **Evidence:** Production CLI SHA-256
  `9199d27343d258480f97898ae9bf7593370206ba4eee17dcc64d07383891ac5b`;
  complete shipping-userspace manifest SHA-256
  `004fb6ab9ed77ec623869ce7f2dc7c4f3310fc392a3c72083bb187dcf64854c0`;
  accepted core console SHA-256
  `1313cf3b11c90046d6f81c697d64ea5d9845ac12a71c4b6dbe24ba0bf10cdd34`.
  The final frozen-source rerun again passed all 73 JSON assertions and six
  data/metadata checks: receipt SHA-256
  `c1a604aecbec113d7856f12c9eb2f1aac1c3334b504968d6f196ce9b93b05b51`,
  console SHA-256
  `0a8aca8e633ee9bca7ca030ed62c3ad2c76036ffa08cff037add45c6a8e0a025`.
- **Practical consequence:** Preserve runner/script/kernel/ELF/userspace and
  console bindings. A fixture-script change requires renewed acceptance for
  the new source identity; earlier passing logs remain historical evidence.
- **Remaining uncertainty:** The generic kernel, synthetic distribution roots
  and image targets do not prove physical boot, live UFS writes, FBE/KeyMint,
  HDMI, sensor streams or installed distribution repair.
- **Next validation:** Finish filesystem, managed rescue and production Btrfs
  CLI groups; package their exact receipts separately from hardware acceptance.
- **Supersedes / superseded by:** Complements REC-VM026's reviewed checkpoint;
  neither evidence class substitutes for the other.

## REC-F007: Retained transaction journals determine fixture disk capacity

- **Lesson ID:** REC-F007
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox filesystem function-test guest
- **Evidence class:** Source review and deliberately interrupted emulation
- **Status:** Fixture budget corrected; final group accepted in REC-F013
- **Question or previous assumption:** Was a 6 GiB scratch disk and a 30-minute
  generic emulator deadline sufficient for all five filesystem workflows?
- **Finding:** The fixture retains independent format, repair and resize jobs
  until full rollback checks finish. Each operation reserves five image sizes
  plus a 64 MiB margin. The 512 MiB F2FS case exceeds the original cumulative
  fixture allowance when all three stores are retained. The partial run had
  completed ext4/exFAT/NTFS checks but was deliberately terminated before the
  large case. It has no accepted group receipt. The filesystem fixture now has
  a 12 GiB sparse regular-file disk and a bounded 60-minute TCG deadline; guest
  memory stays at 2 GiB and the host remains under its j16/16 GiB wrapper.
- **Evidence:** `filesystem_operation_plan` records
  `estimated_max_journal_bytes = image_bytes * 5 + 64 MiB` for these operations.
  Interrupted console SHA-256
  `988ec54624fa2ac1c6e755553a6067cb9c5c24598f2cc9b35208ef0283cab112`;
  ten completed data/metadata markers, no `URE_FUNCTION_EXIT filesystems 0`.
- **Practical consequence:** Size disposable storage for retained journal
  lifetimes. Do not disable free-space checks, shrink safety margins, discard
  rollback copies or equate sparse disk capacity with resident RAM.
- **Remaining uncertainty:** Generic TCG timing is not tablet throughput. This
  correction does not accept physical-storage free-space or persistence policy.
- **Next validation:** Run all groups against the final frozen runner/script
  identity, then capture filesystem timing and resource peaks separately.
- **Supersedes / superseded by:** Supersedes the original fixture capacity and
  deadline assumptions; partial positive checks remain historical evidence.

## REC-F008: Generic module debug paths must pass the same payload gate

- **Lesson ID:** REC-F008
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox Btrfs function guest; generic kernel modules
- **Evidence class:** Host packaging/privacy gate before emulation
- **Status:** Corrected fixture packaging; runtime accepted in REC-F010
- **Question or previous assumption:** Could newly built generic modules be
  copied into the guest without reviewing their debug information?
- **Finding:** Five modules included local absolute DWARF paths, so the existing
  payload gate refused boot. The runner now strips debug only from its private
  disposable module copies using the pinned Android LLVM 20 tool. Original
  modules, loadable symbols and the production CLI/payload remain unchanged.
  The corrected guest tree passed the same privacy/no-Python gate without
  scanner exceptions. Module inputs and the strip tool are hashed before and
  after each Btrfs run.
- **Evidence:** Failed host log SHA-256
  `8887ae58f68f649962369088449c1e1b5960298b36ac8db382aa8e766710fef8`;
  strip executable SHA-256
  `d2a3191ad2228bb60c35e18466615cb53ed7263c2e73134624349f0367cb1f88`.
- **Practical consequence:** Test-only payloads must meet the privacy contract
  before boot. Preserve external input provenance when preparing private
  runtime copies; do not mutate a reference/build input to hide the finding.
- **Remaining uncertainty:** Removing debug metadata is not shipping-kernel
  Btrfs support or physical module-loading acceptance.
- **Next validation:** Load the prepared modules and complete production CLI
  Btrfs operations in the generic guest, with exact module/input receipts.
- **Supersedes / superseded by:** The pre-boot rejected trial is excluded from
  runtime acceptance; the payload scanner is unchanged.

## REC-F009: Select fixture disks by identity before mounting

- **Lesson ID:** REC-F009
- **Date:** 2026-10-03
- **Environment scope:** Generic ARM64 guest with ext4 media and Btrfs test disks
- **Evidence class:** Failed emulation bootstrap and fixture correction
- **Status:** Corrected disk binding; all four final groups passed
- **Question or previous assumption:** Would QEMU's command-line disk order
  always assign ext4 to `vda` and the second Btrfs disk to `vdb`?
- **Finding:** The second virtio disk was enumerated first: `vda` had 512 MiB
  and contained Btrfs, while `vdb` had 6 GiB and contained ext4. The name-based
  ext4 mount failed before any CLI operation. The runner now assigns unique
  synthetic virtio serial tags and the guest resolves each through sysfs,
  requiring a unique matching block node. The shell failure trap now covers
  all bootstrap mounts rather than only post-mount function execution.
- **Evidence:** Failed console SHA-256
  `fc9e18649e31f580c0a28ac8313341fdff755acdd83c460a6b651188d8c5cdd6`;
  two guest virtio capacity records, failed ext4 mount and PID 1 panic, with no
  function JSON records or accepted receipt.
- **Practical consequence:** Bind each disposable disk by declared identity;
  never treat enumeration order as ownership proof. Setup failures must stop
  cleanly and cannot be hidden by a later function-level success marker.
- **Remaining uncertainty:** Synthetic tags are fixture identities, not real
  UFS LUN numbers, model identifiers or physical device serial evidence.
- **Next validation:** Complete the tagged two-disk Btrfs guest, then repeat
  single-disk function groups with the same frozen runner/script identity.
- **Supersedes / superseded by:** Supersedes the fixture's name-based mount
  assumption; no production storage policy or physical-device status changed.

## REC-F010: Production Btrfs CLI operations pass against real generic ioctls

- **Lesson ID:** REC-F010
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox shipping CLI; generic Linux 7.2.8 Btrfs guest
- **Evidence class:** Emulation
- **Status:** Passed within the declared generic-kernel scope
- **Question or previous assumption:** Did the production CLI itself perform
  the operations already exercised by a non-shipping native ioctl fixture?
- **Finding:** Thirty CLI JSON assertions and three independent content/ioctl
  checks passed. Full and incremental snapshot sends verified; a modified stream
  was rejected. Snapshot rollback retained both versions with independent byte
  comparison. Inventory, scrub, bounded balance and 384/512 MiB resize passed.
  Scrub reported zero uncorrectable errors. All operations ran through the
  unchanged production CLI rather than a relinked guest fixture.
- **Evidence:** CLI SHA-256
  `9199d27343d258480f97898ae9bf7593370206ba4eee17dcc64d07383891ac5b`;
  accepted receipt SHA-256
  `a76f9eb1096397c00b4c94e33377377e0a7ee9f6bfd15d76e8f0474659303261`;
  console SHA-256
  `3beb8769406486146b061924039ec0d2c833fade8dfdc8680927b76214bdf1c0`;
  five original module inputs SHA-256
  `2facc755ce97d6692a494011b945dee7006e11b873f265ec035a8e9e2cf4491f`.
- **Practical consequence:** Keep the production-CLI receipt separate from the
  earlier fourteen-check optional native fixture. Bind the kernel, runner,
  guest script, userspace and module preparation identities before reuse.
- **Remaining uncertainty:** The generic kernel supplies Btrfs. Shipping-kernel
  support, receive/restore, root boot integration and physical data acceptance
  remain open.
- **Next validation:** Implement isolated receive/restore with verified lineage
  and rollback before requesting shipping-kernel/device acceptance.
- **Supersedes / superseded by:** Complements REC-VM001 and REC-VM026's optional
  fixture evidence; it does not replace their different execution scope.

## REC-F011: Managed chroot cleanup is distinct from distribution repair

- **Lesson ID:** REC-F011
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox managed rescue in synthetic Arch/Fedora roots
- **Evidence class:** Emulation with actual namespace/chroot/process syscalls
- **Status:** Passed session mechanics; distribution repair unaccepted
- **Question or previous assumption:** Are read-only policy, selected ESP,
  writable session, descendant reaping and timeout cleanup real operations?
- **Finding:** Eleven JSON assertions and four independent namespace/cleanup
  checks passed. Shell commands accessed the selected ESP and isolated runtime
  mounts; source/ESP writes were denied in read-only mode. An explicit writable
  session persisted its selected change. Child processes were reaped, timeout
  returned unsuccessful `TIMED_OUT` without pending cleanup, and the outer mount
  table matched its baseline. A changed root identity invalidated a saved plan;
  missing Fedora package tools were refused without fake replacements.
- **Evidence:** Accepted receipt SHA-256
  `50eb83bd26a42468b2ecae0626b88d9dd00ad1e745b420b85e06fbb3706ac8aa`;
  console SHA-256
  `5f745812f2bc33db26c0143488ec1fa98bf18a17f347343358df69fcf9a31495`.
  All four nested session consoles were read from the powered-off test disk.
  Expected read-only write errors and synthetic-root linker-config warnings
  were distinguished from unexpected errors.
- **Practical consequence:** Keep session mechanics and actual installed
  distribution repair as separate requirements. A synthetic `os-release` does
  not establish package, initramfs or SELinux repair compatibility.
- **Remaining uncertainty:** No installed Arch/Fedora root, package database,
  real ESP contents, network, Android host init or physical storage was tested.
- **Next validation:** Build isolated real distribution fixtures without Python
  payloads and validate their installed package/initramfs/boot dependencies.
- **Supersedes / superseded by:** Supersedes the earlier rescue pass only for the
  final runner/script source identity; historical logs remain valid bounded
  evidence of their earlier fixtures.

## REC-F012: Classify generic shutdown notices from their actual source

- **Lesson ID:** REC-F012
- **Date:** 2026-10-03
- **Environment scope:** Generic Linux 7.2.8 QEMU guest and synthetic rescue roots
- **Evidence class:** Emulation logs and primary source comparison
- **Status:** Documented bounded explanation
- **Question or previous assumption:** Did every warning in an accepted console
  indicate a failed recovery operation or physical flash activity?
- **Finding:** Accepted core/rescue/Btrfs consoles have no panic, fatal signal
  or Scudo abort. Linker realpath warnings precede the first proc mount; nested
  linker-config warnings reflect Android libraries in synthetic distro roots.
  The generic pflash shutdown notice reports state 20. The inspected CFI enum
  defines that as `FL_SHUTDOWN`; its reset handler assigns that state before
  shutdown. This explains the source of the generic-device notice and does not
  establish UFS or tablet firmware activity. Success still requires the guest
  marker, final synchronization/unmount/powerdown, host JSON/data assertions
  and unchanged source/payload identities.
- **Evidence:** Linux 7.2.8 `cfi_cmdset_0001.c` SHA-256
  `9557715a35f236a0da14274cab092b2d3ab6814484bc1e8a564f3c0849655c05`;
  `flashchip.h` SHA-256
  `515f124d685c2a22b5ad0732f9cf7abaaf28c919891ea7b764070b172b28b7f4`;
  accepted console identities in REC-F006, REC-F010 and REC-F011.
- **Practical consequence:** Match warnings to the executing environment and
  source. Keep expected negative stimuli distinct from crashes, unexplained
  errors and physically untested behavior; never disable error gates merely
  because a preceding success marker exists.
- **Remaining uncertainty:** This classification applies to the generic guest.
  Similar-looking physical-device warnings need their own source and evidence.
- **Next validation:** Apply the same log classification to the final filesystem
  run and preserve any new unexplained failure before publication.
- **Supersedes / superseded by:** No runtime defect or physical acceptance record
  is superseded by a generic shutdown notice.

## REC-F013: Filesystem transactions preserve complete image rollback in the guest

- **Lesson ID:** REC-F013
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox shipping CLI/tools; generic Linux 7.2.8 guest
- **Evidence class:** Emulation
- **Status:** Passed within the clean/empty image-fixture scope
- **Question or previous assumption:** Do packaged filesystem adapters execute
  their staging/check/apply/rollback sequence in a real guest environment?
- **Finding:** Fifty-eight JSON assertions and sixteen independent byte,
  geometry and refusal checks passed. ext4/exFAT/NTFS/FAT32/F2FS format and clean
  repair each passed the independent read-only checker. ext4/NTFS/F2FS resize
  preserved container capacity/inode and their full original-image hashes after
  rollback. exFAT resize, absent FAT resizer and a live loop alias were refused
  before source mutation. Complete original-image format rollback also passed
  for all five types. The final twelve-GiB fixture retained its separate journals
  and powered down cleanly after 2,138 seconds.
- **Evidence:** Accepted receipt SHA-256
  `c6b28c3709b5f3c0121a4740532380c032bfede3930aba7018b1bcade0351c8d`;
  console SHA-256
  `eed12b8fc6e5c1490be3bbb57a16563dc0a740f12e4e16ebd4a26f0719b075a2`;
  final runner SHA-256
  `bac830fbec8df548647e37a54fed6edec5cac2fbd08a47b526397d75ce9064d6`;
  guest script SHA-256
  `9c8c45053bdac0b404e6e2342d70a5969803a433714486ab47d2eb7c652b6dba`.
  Host cgroup peak: 2,406,281,216 bytes; high/max/OOM/kill events: zero.
- **Practical consequence:** Preserve exact full-image checks and journal
  lifetime budgets when optimizing staging. The four final function groups
  collectively passed 172 JSON assertions and 29 independent checks against
  one unchanged shipping CLI/userspace identity. TCG timing identifies benchmark
  candidates without establishing physical tablet performance.
- **Remaining uncertainty:** Repair fixtures are clean and resize fixtures are
  empty. Arbitrary corruption recovery, populated filesystem resize/data
  movement, live UFS/GPT/FBE, FAT resizer packaging and exFAT resize implementation
  remain separate requirements. NTFS repair is limited `ntfsfix`, not `chkdsk`.
- **Next validation:** Add populated filesystem/corruption fixtures and bounded
  copy/hash benchmarks before considering any live-storage backend acceptance.
- **Supersedes / superseded by:** Completes the corrected fixture requirements
  from REC-F005 and REC-F007; partial and interrupted trials remain excluded.

## REC-F014: New function receipts must pass both stale refusal and exact seal

- **Lesson ID:** REC-F014
- **Date:** 2026-10-03
- **Environment scope:** OrangeFox host release metadata and source archives
- **Evidence class:** Host/package checks and separately bound emulation records
- **Status:** Exact receipt gate and package-repeat checks passed
- **Question or previous assumption:** Could a passing record from a different
  guest script be attached merely because the shipping CLI hash matched?
- **Finding:** A temporary core receipt with only its guest-script hash changed
  was rejected with status 1 before artifact-manifest creation. The original
  receipt was restored exactly and the positive seal passed. The new candidate
  requires four group records matching runner, guest, generic kernel, complete
  userspace and shipping CLI identities, plus Btrfs module/strip-tool identities.
  Two fresh package generations matched all three asset hashes. A fresh extracted
  ramdisk privacy/no-Python/dependency/ARM64 audit and licensed source archives
  passed. Hardware/full-roadmap/clean-binary flags remain false.
- **Evidence:** Stale-refusal trace SHA-256
  `56a84fbf49bd3242b81755e7fd47ac6e593b154864f4cccc9a1bfddc2f5b0234`;
  restored core receipt SHA-256
  `c1a604aecbec113d7856f12c9eb2f1aac1c3334b504968d6f196ce9b93b05b51`;
  recovery image SHA-256
  `77f7cbf86aaa97a62fb0bfbb3781eb11dffbf9430709ac4fc3e00e92fc0b6c38`.
  The reviewed [function report](https://github.com/MCC45TR/orangefox_device_xiaomi_uke/blob/R12.0/reports/URE-FUNCTION-VM-REVIEW.md)
  records all receipt and repeat-package identities.
- **Practical consequence:** Preserve prior candidates and refuse stale source
  identities. Commit source and evidence changes separately, then seal against
  the clean component commit and verify checksums before authorized publication.
- **Remaining uncertainty:** Package repeatability is distinct from a clean
  reproducible native build. Exact generic-guest receipts still do not prove
  either tablet model, firmware/SKU, shipping GUI/kernel or physical storage.
- **Next validation:** Continue the remaining roadmap work with populated
  filesystem, installed-distribution and profile-specific physical gates kept
  separate. Benchmark copy/hash reuse without removing durable verification.
- **Supersedes / superseded by:** Extends REC-VM027's package receipt binding to
  four production-CLI function groups; no physical acceptance record changes.
