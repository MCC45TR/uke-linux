#!/usr/bin/env bash
# Host-only source packaging; no upstream acquisition or device script runs.
set -Eeuo pipefail
root=$(cd -- "$(dirname -- "$0")" && pwd)
out=${1:?Usage: build-srpm.sh NEW-OUTPUT-DIRECTORY}
[[ ! -e $out ]] || { echo 'Output already exists' >&2; exit 1; }
(cd "$root/referances" && sha256sum -c ../sources.sha256)
mkdir -p -- "$out"/{SOURCES,SPECS,SRPMS,BUILD,RPMS,BUILDROOT}
out=$(realpath -- "$out")
while read -r checksum archive; do
    [[ $checksum =~ ^[0-9a-f]{64}$ && $archive =~ ^[a-z0-9-]+\.tar\.gz$ ]] || exit 1
    cp --reflink=auto -- "$root/referances/$archive" "$out/SOURCES/"
done < "$root/sources.sha256"
cp -- "$root/sources.sha256" "$root/upstream.tsv" "$root/packaging/cutefish-auth" "$out/SOURCES/"
cp -- "$root/packaging/cutefish-desktop.spec" "$out/SPECS/"
rpmbuild -bs --define "_topdir $out" --target aarch64 "$out/SPECS/cutefish-desktop.spec"
