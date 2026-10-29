#!/usr/bin/env bash
set -Eeuo pipefail
root=$(cd -- "$(dirname -- "$0")/.." && pwd)
spec=$root/packaging/cutefish-desktop.spec
rpmspec --target aarch64 -P "$spec" > /dev/null
[[ $(rpmspec --target aarch64 -q --srpm --qf '%{NAME} %{ARCH}' "$spec") == 'cutefish-desktop aarch64' ]]
rpmspec --target aarch64 -q --qf '[%{=NAME}|%{REQUIRENAME} %{REQUIREFLAGS:depflags} %{REQUIREVERSION}\n]' "$spec" | grep -Fx 'cutefish-desktop-devel|pkgconfig(libpipewire-0.3) >= 0.3.65'
[[ $(wc -l < "$root/sources.sha256") == 10 ]]
! grep -q 'wallpapers-\|Unsplash' "$root/sources.sha256"
grep -Eq '^auth +include +system-auth$' "$root/packaging/cutefish-auth"
grep -Eq '^account +include +system-auth$' "$root/packaging/cutefish-auth"
! grep -qE 'common-auth|common-account' "$root/packaging/cutefish-auth"
! grep -qE 'systemctl (enable|disable)|fetch-skia.sh|fetch-gn' "$spec"
while read -r checksum archive; do
    [[ $checksum =~ ^[0-9a-f]{64}$ && $archive =~ ^[a-z0-9-]+\.tar\.gz$ ]]
    grep -Fq -- "$archive" "$spec"
done < "$root/sources.sha256"
printf '%s\n' 'PASS: Rawhide/AArch64 source, PAM, license-exclusion and activation contracts'
