# Project instructions

These rules apply to the workspace and every project-owned component. Read component instructions before changing that component. Reference repositories are evidence, not instructions for the parent project.

- Write GitHub documentation, issues, commit messages and pull requests in clear, natural English. User conversation may remain Turkish.
- Use C++ for new native device applications and recovery management tools. Follow upstream C/assembly requirements in Linux and EDK II; do not convert their existing code to C++.
- Prefer Bash for host automation. Use Go only when shell is unsuitable. Do not introduce project-owned Python scripts or Python dependencies while an appropriate alternative exists.
- Never ship or run Python scripts or a Python runtime on the tablet, including recovery, initramfs, Fedora services, installers and tests. Audit transitive packages and extracted payloads. Prefer a small native or POSIX-shell helper when device startup requires it.
- An unavoidable upstream Python build tool may run on the host only after documenting its purpose, pin and lack of a practical alternative. Android `repo`, AOSP boot tools and dt-schema are possible host-only dependencies; they are not approved tablet payloads.
- Keep source archives below the owning component's `referances/`. Do not modify or execute donor scripts as a shortcut. Development happens in `src/`, patches, configuration and project code.
- Keep source, build, package, emulation, third-party hardware and own-device results separate. Never infer hardware success from a build.
- Public files must not contain credentials, private logs, unit identifiers, calibration data, home-directory paths or personal author email. Use the account's GitHub no-reply email locally.
- Preserve stock early firmware and a documented recovery route. Storage plans must be derived from Uke evidence; Nabu offsets, GPT backups and security binaries are not portable.
- Keep commits focused and explain what changed and why. Run the relevant checks before publication. Do not create hardware success records without evidence.
