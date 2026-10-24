# Reporting a problem

The Fedora images are an **alpha release, not suitable for daily use**. Check the
[hardware status](README.md#hardware-support) and
[existing issues](https://github.com/MCC45TR/uke-linux/issues) before reporting a
problem. A listed limitation can still have useful new evidence.

Open a [bug report](https://github.com/MCC45TR/uke-linux/issues/new?template=bug_report.yml)
for one problem at a time. Include:

- Device model, RAM/storage variant and stock firmware version, if known.
- Release tag, exact system and boot filenames, and their SHA-256 values. State
  whether files were changed or packages were updated after installation.
- Intended root partition label (`linux` or `userdata`) and selected boot slot.
  Write “unknown” if unsure; no partition changes are needed to report a bug.
- The smallest safe steps that show the problem, expected behavior, actual
  behavior and how often it happens. Do not repeat a crash or unsafe charging test
  just to collect evidence.
- Date/time of the failure, whether the clock was synchronized, and relevant
  hardware conditions: power source, attached accessories, display mode and
  whether touch input or SSH remained available.

The `userdata` boot variant has not been tested on the tablet. A successful build
or checksum check does not establish that it boots. Installation instructions
will be published separately.

## Useful evidence from a running Fedora session

These commands only read system information and write local text files. Run the
ones available in the session; missing commands or a locked-up device need not
prevent a report. On the computer holding the downloaded images, use `sha256sum`
on each file and compare the result with the release checksums.

On Fedora, collect the kernel and distribution versions:

```sh
uname -r
cat /etc/os-release
```

For a recent failure in the current boot, collect a short journal window and
kernel warnings:

```sh
journalctl -b --since '-5 min' --no-pager -o short-monotonic > journal-recent.txt
sudo dmesg --level=emerg,alert,crit,err,warn > kernel-warnings.txt
```

If `sudo` access is unavailable, include the journal output you can read. If the
device has already restarted, `journalctl -b -1` may contain the preceding boot;
share only a relevant, reviewed excerpt. A photo of the last visible error is
also useful when no shell is available. Do not send memory dumps or complete
partition contents.

**Review every attachment before uploading it.** Remove passwords, keys, tokens,
serial numbers, unit identifiers, MAC addresses, SSIDs, IP addresses, usernames,
hostnames, home-directory paths and calibration data. Crop personal information
out of photos. Keep error codes, driver names and relative timestamps intact;
replace private values with `[redacted]`. Public issues are not a place for raw
private logs. Use [private security reporting](SECURITY.md) for vulnerabilities.

# Documentation style

Use this report style across Uke repositories, including README status sections,
hardware tables, release notes, issues, pull requests and commit summaries.

State the report date, tested device and software, observed result and remaining
work. Name the device directly. For example: "The USB port did not supply power
to the ESP32-S3."

Use concise, natural English. Omit personal ownership labels, conversational
narration, promotional wording and internal review jargon. A configured model
name is not a hardware identity; record the tested commercial model separately.

Keep source review, build, package, VM and tablet results separate. Preserve
checksums, source attribution, failures and test limitations. Shortening a report
must not broaden a hardware claim. Keep lengthy trial histories and raw logs in
the private engineering records.

## Commit authorship

24 October 2026. Code contributions retain their human authors and human
`Co-authored-by` credit. Do not list AI tools as authors or co-authors. Tool-use
notes may remain in the pull request description. Preserve human contributor
credit, source attribution and license notices when squashing or editing commit
messages. Maintenance workflows may retain their normal service-account author.
