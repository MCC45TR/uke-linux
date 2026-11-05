#!/usr/bin/env bash
# Host-only: export the exact signed COPR boot payload. No device operations.
set -Eeuo pipefail
export LC_ALL=C
work=${RUNNER_TEMP:?}/unstable-boot-${GITHUB_RUN_ID:?}
[[ ! -e $work ]]
mkdir -p "$work"/{inputs,receipts,delivery}
inputs=$work/inputs
receipts=$work/receipts
base=senemos-uke-linux-kernel-mainline-unstable
evr=7.3.1-12101.fc46
krel=7.3.1-12101-unstable
source=bba194e74ab97dcb848887fa62430c20f9d755d9
copr=https://copr.fedorainfracloud.org/api_3
packages=https://download.copr.fedorainfracloud.org/results/mcc45tr/uke-linux-unstable/fedora-rawhide-aarch64/Packages/s
curl -q -fLsS --retry 2 --max-time 60 "$copr/build/11260781" -o "$receipts/copr-build.json"
jq -e '.id==11260781 and .state=="succeeded" and .project_dirname=="uke-linux-unstable" and .source_package.name=="senemos-uke-linux-kernel-mainline-unstable" and .source_package.version=="7.3.1-12101" and .chroots==["fedora-rawhide-aarch64"]' "$receipts/copr-build.json"
curl -q -fLsS --retry 2 --max-time 60 "$copr/build/source-build-config/11260781" -o "$receipts/source-build-config.json"
jq -e --arg commit "$source" '.source_dict.script|contains("commit="+$commit+"\n") and contains("copr-camera-ssc-cohort731.sh") and contains("12101")' "$receipts/source-build-config.json"
curl -q -fLsS --retry 2 --max-time 60 'https://download.copr.fedorainfracloud.org/results/mcc45tr/uke-linux-unstable/pubkey.gpg' -o "$inputs/copr-key.asc"
for component in core boot; do
    curl -q -fLsS --retry 3 --max-time 600 --proto '=https' --proto-redir '=https' "$packages/$base-$component-$evr.aarch64.rpm" -o "$inputs/$base-$component-$evr.aarch64.rpm"
done
(cd "$inputs"; sha256sum *.rpm) > "$receipts/input-RPM-SHA256SUMS"
# Fedora RPM 6 verifies the producer's signatures and extracts payloads in an
# isolated disposable SDK. No RPM installation or scriptlet execution occurs.
cat > "$work/Containerfile" <<'DOCKER'
FROM registry.fedoraproject.org/fedora@sha256:f7d3478d02965da40131211c19fb827b4d6e3de0904e9d582a9354af47949c14
RUN dnf5 -y --setopt=install_weak_deps=False install rpm cpio gnupg2 jq && dnf5 clean all
DOCKER
sdk=unstable-boot-export:$GITHUB_RUN_ID
docker build -t "$sdk" -f "$work/Containerfile" "$work"
docker image inspect "$sdk" --format '{{.Id}}' > "$receipts/sdk-image.txt"
cat > "$inputs/extract.sh" <<'EXTRACT'
#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C
mkdir -m700 /tmp/gpg /tmp/keydb
[[ $(gpg --homedir /tmp/gpg --batch --show-keys --with-colons /inputs/copr-key.asc | awk -F: '$1=="fpr" {print $10;exit}') == 2204A661EA630A5303500085538797E72A3E4ECA ]]
rpmkeys --dbpath /tmp/keydb --import /inputs/copr-key.asc
rpmkeys --import /inputs/copr-key.asc
mkdir /tmp/payload
for archive in /inputs/*.rpm; do
    rpmkeys --dbpath /tmp/keydb --checksig "$archive" | tee -a /receipts/signatures.txt | grep -F 'signatures OK'
    [[ $(rpm -qp --qf '%{VERSION}-%{RELEASE}.%{ARCH}' "$archive") == 7.3.1-12101.fc46.aarch64 ]]
    [[ $(rpm -qp --qf '%{NAME}' "$archive") =~ ^senemos-uke-linux-kernel-mainline-unstable-(core|boot)$ ]]
    rpm -qp --qf '%{NEVRA}\t%{SOURCERPM}\n' "$archive" >> /receipts/input-rpms.tsv
    rpm2cpio "$archive" > /tmp/archive.cpio
    cpio -t --quiet < /tmp/archive.cpio > /tmp/paths
    awk '/^\/|(^|\/)\.\.($|\/)/ {bad=1} END {exit bad}' /tmp/paths
    (cd /tmp/payload; cpio -idm --quiet --no-absolute-filenames < /tmp/archive.cpio)
done
identity=/tmp/payload/usr/share/senemos/uke/7.3.1-12101-unstable
[[ $(cat "$identity/source-commit") == bba194e74ab97dcb848887fa62430c20f9d755d9 ]]
jq -e '.source_commit=="bba194e74ab97dcb848887fa62430c20f9d755d9" and .kernel_release=="7.3.1-12101-unstable" and .source_mode=="complete11003-with-ssc-and-camcc-probe-observations" and .panel_variants==["o82_36_02_0a","o82_42_02_0b"] and .touch_variants==["tianma","csot"] and .physical_acceptance==false' "$identity/source-composition.json"
cp "$identity/source-composition.json" /receipts/kernel-source-composition.json
cp "$identity/source-commit" /receipts/kernel-source-commit.txt
cp /tmp/payload/usr/lib/modules/7.3.1-12101-unstable/vmlinuz /receipts/matching.Image
bundle=/tmp/payload/usr/lib/senemos/kernel-updates/7.3.1-12101-unstable
cp "$bundle/userdata.img" /delivery/boot.img
cp "$bundle/manifest" /receipts/producer-boot-manifest.txt
EXTRACT
docker run --rm --network=none --mount "type=bind,src=$inputs,dst=/inputs,readonly" --mount "type=bind,src=$receipts,dst=/receipts" --mount "type=bind,src=$work/delivery,dst=/delivery" "$sdk" bash /inputs/extract.sh
c++ -std=c++20 -O2 -Wall -Wextra -Werror builder/src/boot/boot-image.cpp -o "$work/boot-image"
"$work/boot-image" inspect "$work/delivery/boot.img" > "$receipts/boot-header.json"
"$work/boot-image" check-root "$work/delivery/boot.img" userdata
"$work/boot-image" extract "$work/delivery/boot.img" "$work/exported.Image"
cmp "$work/exported.Image" "$receipts/matching.Image"
jq -e '.header_version==4 and .image_bytes==100663296 and .ramdisk_bytes==0 and .signature_bytes==0 and .avb_footer_present==false' "$receipts/boot-header.json"
grep -aqF "Linux version $krel " "$work/exported.Image"
# Independently reconstruct using the pinned host codec and compare all bytes.
"$work/boot-image" create "$work/exported.Image" "$work/reconstructed.img" userdata
cmp "$work/reconstructed.img" "$work/delivery/boot.img"
(cd "$work/delivery"; sha256sum boot.img > SHA256SUMS; sha256sum -c SHA256SUMS)
cp "$work/delivery/SHA256SUMS" "$receipts/SHA256SUMS"
hash=$(cut -d' ' -f1 "$work/delivery/SHA256SUMS")
jq -n --arg hash "$hash" --arg source "$source" --arg workflow "$GITHUB_SHA" --arg run "$GITHUB_RUN_ID" \
 '{date:"2026-11-05",device:"uke",filename:"boot.img",sha256:$hash,bytes:100663296,root_selector:"userdata",kernel_release:"7.3.1-12101-unstable",kernel_rpm_evr:"7.3.1-12101.fc46",copr_owner:"mcc45tr",copr_project:"uke-linux-unstable",copr_build:11260781,kernel_source_commit:$source,signer_fingerprint:"2204A661EA630A5303500085538797E72A3E4ECA",method:"Exact export of signed COPR userdata boot, independently reconstructed and byte-compared",embedded_Image_matches_core_RPM:true,physical_boot_tested:false,rootfs_module_compatibility_tested:false,old_R4_R5_modules_compatible:false,device_written:false,release_created:false,workflow_commit:$workflow,workflow_run:$run,artifact_retention_days:90}' > "$work/delivery/PROVENANCE.json"
cat > "$work/delivery/README.txt" <<'NOTES'
2026-11-05: Xiaomi Pad 7 / POCO Pad X1 (uke) experimental boot image.
Kernel: 7.3.1-12101-unstable, COPR mcc45tr/uke-linux-unstable build 11260781.
This is the exact signed COPR userdata boot payload, not a new kernel source build.
Host signature, source identity, Android v4 header, userdata selector, Image
identity and complete reconstruction checks passed. No physical boot was tested.

Extract this ZIP, then run: sha256sum -c SHA256SUMS
Do not flash the ZIP. boot.img is 100663296 bytes (96 MiB).

IMPORTANT: R4 (7.3.1-1010) and R5 (7.3.1-1101) root filesystems contain different
kernel modules. This boot-only artifact does not update the root filesystem.
For a complete working system, its root must contain the matching signed
7.3.1-12101-unstable module/DTB cohort and required userspace dependencies.
Do not claim this is a compatible replacement for the R4/R5 boot image alone.
A boot-only diagnostic trial may fail after early initialization because of
that mismatch. It does not establish or exclude the issue #14 boot-loop cause.

Before any diagnostic flash, verify product=uke, the intended Linux slot,
boot partition capacity >=100663296 bytes, and a known working rollback image
and recovery route. Use a reliable PC/USB fastboot connection. Do not continue
past a failed or hung flash. No userdata, vbmeta, firmware, or recovery changes
are needed or authorized by this artifact. Do not run fastboot -w or format.
No device operation was performed by this workflow.
NOTES
rm "$receipts/matching.Image"
cp "$work/delivery/PROVENANCE.json" "$receipts/PROVENANCE.json"
cat "$work/delivery/SHA256SUMS" >> "$GITHUB_STEP_SUMMARY"
echo 'Signed unstable boot exported and independently reconstructed. Physical testing pending. R4/R5 root modules are incompatible; see README.txt.' >> "$GITHUB_STEP_SUMMARY"
