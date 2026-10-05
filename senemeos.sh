#!/bin/sh
# shellcheck shell=bash
# One host-only entry point. This preamble also works on minimal Alpine hosts.
if [ "${SENEMOS_ENTRY_LOADED:-0}" != 1 ]; then
    if ! command -v bash >/dev/null 2>&1; then
        for bootstrap_argument in "$@"; do
            if [ "$bootstrap_argument" = --dry-run ] || [ "$bootstrap_argument" = --offline ]; then
                printf '%s\n' 'Bash is missing; dry-run/offline mode will not install it.' >&2
                exit 1
            fi
        done
        bootstrap_root() {
            if [ "$(id -u)" = 0 ]; then "$@";
            elif command -v sudo >/dev/null 2>&1; then sudo -- "$@";
            elif command -v doas >/dev/null 2>&1; then doas -- "$@";
            else printf '%s\n' 'Bash is missing; root, sudo or doas is required.' >&2; exit 1; fi
        }
        # shellcheck disable=SC1091
        . /etc/os-release
        case " $ID ${ID_LIKE:-} " in
            *' alpine '*|*' postmarketos '*) bootstrap_root apk add --no-cache bash;;
            *' debian '*|*' ubuntu '*) bootstrap_root apt-get update; bootstrap_root apt-get -y install bash;;
            *' fedora '*|*' rhel '*) bootstrap_root dnf -y install bash;;
            *' opensuse '*|*' opensuse-tumbleweed '*|*' suse '*) bootstrap_root zypper --non-interactive install bash;;
            *' arch '*) bootstrap_root pacman -S --needed --noconfirm bash;;
            *) printf '%s\n' 'Unsupported Bash bootstrap host.' >&2; exit 1;;
        esac
    fi
    # Bash receives one immutable copy; queued invocations tolerate later edits.
    SENEMOS_ENTRY_LOADED=1 exec bash -c "$(cat "$0")" "$0" "$@"
fi
unset SENEMOS_ENTRY_LOADED
set -Eeuo pipefail
umask 022
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" && pwd)
KERNEL=$ROOT/senemos-uke-kernel
BUILDER=$ROOT/uke-fedora-builder
RULES=$BUILDER/configs/build-rules.json
VERSION=latest DISTRO=fedora RELEASE='' JOBS='' DRY_RUN=0 OFFLINE=0 TEST=0
ENGINE='' CID='' PAUSED=0
TEST_RUNTIME_ID=''

say() { printf 'senemos: %s\n' "$*"; }
die() { printf 'senemos: ERROR: %s\n' "$*" >&2; exit 1; }
help() {
    cat <<'HELP'
Senemos Uke kernel builder (host only)
Usage: ./senemeos.sh --build VERSION --distro=DISTRO [options]

  --build VERSION     Explicit version, latest, or its alias lastest
  --distro DISTRO     Target distribution, independent of the build host
  --release RELEASE   Target release (Fedora defaults to rawhide)
  --jobs N            Positive parallel job limit; defaults to at most four
  --dry-run           Resolve and show the plan without installing or building
  --offline           Require cached release metadata, source and toolchain
  --test              Validate RPMs, including isolated AArch64 package lifecycle
  --self-test         Run host-only contract and negative tests
  --help, -h          Show this help

Examples:
  ./senemeos.sh --build 7.2.9 --distro=fedora --test
  ./senemeos.sh --build latest --distro=fedora
  ./senemeos.sh --build lastest --distro=fedora

Implemented target: Fedora Rawhide AArch64 RPM and SRPM.
Planned: Fedora 45, openSUSE Tumbleweed, Debian, Ubuntu, Armbian, Kubuntu,
Alpine and postmarketOS. Unsupported profiles fail explicitly.
Host families: Fedora/RHEL, Debian/Ubuntu, openSUSE, Arch, Alpine/postmarketOS.
Missing prerequisites are installed from official host repositories; build
dependencies stay in a pinned container. Builds queue behind other compilers.
Nothing flashes a tablet, unlocks its bootloader or changes boot selection.
HELP
}
package_manager() {
    case " $1 $2 " in
        *' fedora '*|*' rhel '*|*' centos '*|*' rocky '*|*' almalinux '*) echo dnf;;
        *' debian '*|*' ubuntu '*|*' linuxmint '*) echo apt;;
        *' opensuse '*|*' opensuse-tumbleweed '*|*' opensuse-leap '*|*' suse '*) echo zypper;;
        *' arch '*|*' manjaro '*) echo pacman;;
        *' alpine '*|*' postmarketos '*) echo apk;;
        *) return 1;;
    esac
}
privileged() {
    if ((EUID == 0)); then "$@";
    elif command -v sudo >/dev/null 2>&1; then sudo -- "$@";
    elif command -v doas >/dev/null 2>&1; then doas -- "$@";
    else die "Missing installation privilege (root, sudo or doas): $*"; fi
}
install_packages() {
    local manager=$1; shift
    say "Installing missing host prerequisites with $manager"
    case $manager in
        dnf) privileged dnf -y --setopt=install_weak_deps=False install "$@";;
        apt) privileged apt-get update; privileged env DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends "$@";;
        zypper) privileged zypper --non-interactive install --no-recommends "$@";;
        pacman) privileged pacman -Syu --needed --noconfirm "$@";;
        apk) privileged apk add --no-cache "$@";;
    esac
}
check_space() {
    local available=$1 minimum=$2
    ((available >= minimum * 1024 * 1024)) || die "At least $minimum GiB of free space is required"
}
bootstrap() {
    local ID='' ID_LIKE='' VERSION='' manager missing=0 cmd require_engine=${1:-1}
    # /etc/os-release is the host's trusted distribution identity.
    # shellcheck disable=SC1091
    source /etc/os-release
    manager=$(package_manager "$ID" "${ID_LIKE:-}") || die "Unsupported build host: $ID"
    for cmd in curl jq git tar xz gpg flock sha256sum realpath find; do
        command -v "$cmd" >/dev/null 2>&1 || missing=1
    done
    if ((missing)); then
        ((OFFLINE == 0)) || die 'Offline mode cannot install missing prerequisites'
        # jq may be missing, so bootstrap names deliberately do not depend on it.
        case $manager in
            dnf) install_packages dnf bash curl jq git tar xz gnupg2 util-linux coreutils findutils;;
            apt) install_packages apt bash curl jq git tar xz-utils gnupg util-linux coreutils findutils uidmap;;
            zypper) install_packages zypper bash curl jq git tar xz gpg2 util-linux coreutils findutils;;
            pacman) install_packages pacman bash curl jq git tar xz gnupg util-linux coreutils findutils;;
            apk) install_packages apk bash curl jq git tar xz gnupg util-linux coreutils findutils shadow-subids;;
        esac
    fi
    for cmd in curl jq git tar xz gpg flock sha256sum realpath find; do
        command -v "$cmd" >/dev/null 2>&1 || die "Host prerequisite still missing after installation: $cmd"
    done
    ((require_engine)) || return 0
    if command -v podman >/dev/null 2>&1 && podman info >/dev/null 2>&1; then ENGINE=podman;
    elif command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then ENGINE=docker;
    else
        ((OFFLINE == 0)) || die 'Offline mode needs an operational Podman or Docker'
        install_packages "$manager" podman
        if [[ $manager == apt ]]; then install_packages apt uidmap; fi
        if ((EUID != 0)) && ! podman info >/dev/null 2>&1; then
            local account range_start range_end
            account=$(id -un)
            if ! grep -Eq "^($account|$EUID):" /etc/subuid 2>/dev/null || \
               ! grep -Eq "^($account|$EUID):" /etc/subgid 2>/dev/null; then
                range_start=$(awk -F: 'BEGIN {limit=100000} {end=$2+$3; if(end>limit) limit=end} END {print limit}' /etc/subuid /etc/subgid 2>/dev/null) || range_start=100000
                range_end=$((range_start + 65535))
                ((range_end < 4294967295)) || die 'No available rootless UID/GID mapping range'
                say 'Preparing missing rootless UID/GID allocations'
                privileged usermod --add-subuids "$range_start-$range_end" --add-subgids "$range_start-$range_end" "$account"
            fi
        fi
        podman info >/dev/null 2>&1 || die 'Podman is installed but unusable; check user namespaces and subuid/subgid allocation'
        ENGINE=podman
    fi
}
prepare_aarch64() {
    [[ $architecture == x86_64 ]] || return 0
    if "$ENGINE" run --rm --platform linux/arm64 --network=none "$TEST_IMAGE" /bin/true \
        > "$WORK/emulation-preflight.log" 2>&1; then return 0; fi
    ((OFFLINE == 0)) || die 'Offline target tests require operational AArch64 binfmt emulation'
    local ID='' ID_LIKE='' VERSION='' manager binary registration
    # shellcheck disable=SC1091
    source /etc/os-release
    manager=$(package_manager "$ID" "${ID_LIKE:-}")
    case $manager in
        dnf) install_packages dnf qemu-user-static-aarch64;;
        apt) install_packages apt qemu-user-static binfmt-support;;
        pacman) install_packages pacman qemu-user-static qemu-user-static-binfmt;;
        zypper) install_packages zypper qemu-linux-user;;
        apk) install_packages apk qemu-aarch64;;
    esac
    binary=$(command -v qemu-aarch64-static || command -v qemu-aarch64) || die 'Official AArch64 emulator binary is unavailable'
    [[ -e /proc/sys/fs/binfmt_misc/register ]] || privileged mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc
    # Register only our handler; existing host handlers are preserved. F keeps
    # the official static interpreter open across a container's mount namespace.
    registration=':senemos-aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:'"$binary"':F'
    [[ -e /proc/sys/fs/binfmt_misc/senemos-aarch64 ]] || \
        printf '%s\n' "$registration" | privileged tee /proc/sys/fs/binfmt_misc/register >/dev/null
    "$ENGINE" run --rm --platform linux/arm64 --network=none "$TEST_IMAGE" /bin/true \
        > "$WORK/emulation-preflight.log" 2>&1 || die 'AArch64 emulation is installed but unusable; inspect emulation-preflight.log'
}
supported_target() {
    local status
    RELEASE=${RELEASE:-$(jq -r --arg d "$DISTRO" '.targets[$d].default_release // empty' "$RULES")}
    [[ -n $RELEASE ]] || die "Unknown target distribution: $DISTRO"
    status=$(jq -r --arg d "$DISTRO" --arg r "$RELEASE" '.targets[$d].releases[$r] // "unknown"' "$RULES")
    [[ $status == implemented ]] || die "Target $DISTRO/$RELEASE is $status; no fallback package will be built"
}
resolve_version() {
    local cache=$KERNEL/referances/releases/releases.json
    [[ $VERSION != lastest ]] || VERSION=latest
    if [[ $VERSION == latest ]]; then
        if ((OFFLINE)); then [[ -s $cache ]] || die 'Cached release metadata is missing';
        elif ((DRY_RUN)); then
            VERSION=$(curl -fsSL --connect-timeout 20 https://www.kernel.org/releases.json | jq -er '.latest_stable.version')
        else
            curl -fsSL --retry 3 --connect-timeout 20 https://www.kernel.org/releases.json > "$cache.part"
            jq -e '.latest_stable.version | test("^[0-9]+\\.[0-9]+(\\.[0-9]+)?$")' "$cache.part" >/dev/null
            mv "$cache.part" "$cache"
        fi
        if [[ $VERSION == latest ]]; then VERSION=$(jq -er '.latest_stable.version' "$cache"); fi
    fi
    [[ $VERSION =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]] || die "Invalid stable version: $VERSION"
    PROFILE=$KERNEL/manifests/linux-$VERSION.json
    [[ -f $PROFILE ]] || die "No reviewed Uke adaptation profile for Linux $VERSION"
    jq -e --arg v "$VERSION" '.schema_version == 1 and .version == $v and
        (.source_sha256 | test("^[a-f0-9]{64}$")) and
        (.signer | test("^[A-F0-9]{40}$")) and
        (.source_url | startswith("https://cdn.kernel.org/")) and
        (.signature_url | startswith("https://cdn.kernel.org/")) and
        (.patches | length > 0) and (.configs | length == 3) and
        (all(.patches[], .configs[]; (.path | type == "string") and
        (.sha256 | test("^[a-f0-9]{64}$"))))' "$PROFILE" >/dev/null || die 'Invalid or incomplete source profile'
}
verify_source() {
    local archive=$1 signature=$2 profile=$3 key=$4 gpg_home=$5 expected fingerprint
    expected=$(jq -er '.source_sha256' "$profile")
    [[ $(sha256sum "$archive" | cut -d ' ' -f1) == "$expected" ]] || die 'Source SHA-256 mismatch'
    mkdir -p "$gpg_home"; chmod 700 "$gpg_home"
    gpg --homedir "$gpg_home" --batch --import "$key" >/dev/null 2>&1
    fingerprint=$(jq -er '.signer' "$profile")
    xz -cd "$archive" | gpg --homedir "$gpg_home" --batch --status-fd=1 --verify "$signature" - > "$gpg_home/verification.txt" 2> "$gpg_home/verification.log" || die 'Invalid kernel release signature'
    grep -F "[GNUPG:] VALIDSIG $fingerprint " "$gpg_home/verification.txt" >/dev/null || die 'Unexpected kernel release signer'
}
fetch_source() {
    local archive=$KERNEL/referances/releases/linux-$VERSION.tar.xz signature=$KERNEL/referances/releases/linux-$VERSION.tar.sign
    if [[ ! -s $archive || ! -s $signature ]]; then
        ((OFFLINE == 0)) || die 'Offline source archive or signature is missing'
        curl -fL --retry 3 --connect-timeout 20 -o "$archive.part" "$(jq -er '.source_url' "$PROFILE")"
        curl -fL --retry 3 --connect-timeout 20 -o "$signature.part" "$(jq -er '.signature_url' "$PROFILE")"
        mv "$archive.part" "$archive"; mv "$signature.part" "$signature"
    fi
    verify_source "$archive" "$signature" "$PROFILE" "$KERNEL/configs/keys/linux-stable.asc" "$WORK/gnupg"
    local path hash
    while IFS=$'\t' read -r path hash; do
        [[ $path =~ ^[a-zA-Z0-9._/-]+$ && $path != *..* ]] || die 'Unsafe profile path'
        [[ -f $KERNEL/$path && $(sha256sum "$KERNEL/$path" | cut -d ' ' -f1) == "$hash" ]] || die "Reviewed input changed: $path"
    done < <(jq -r '.patches[], .configs[] | [.path,.sha256] | @tsv' "$PROFILE")
}
# Other native/recovery builds take precedence. Only process identity is read;
# their commands and private paths never enter public logs or manifests.
heavy_busy() {
    local process comm group state_record
    for process in /proc/[0-9]*; do
        [[ -r $process/comm ]] || continue
        IFS= read -r comm < "$process/comm" || continue
        case $comm in make|gmake|ninja|ninja-build|soong_ui|ckati|clang|clang++|clang-[0-9]*|clang++-[0-9]*|cc1|cc1plus|ld.lld|ld.lld-[0-9]*|rustc) ;; *) continue;; esac
        IFS= read -r state_record < "$process/stat" 2>/dev/null || continue
        state_record=${state_record##*) }
        case ${state_record%% *} in Z|X) continue;; esac
        group=$(cat "$process/cgroup" 2>/dev/null) || continue
        [[ -n $group ]] || continue
        [[ -n ${CID:-} && $group == *"$CID"* ]] && continue
        return 0
    done
    return 1
}
wait_idle() {
    local announced=0
    while heavy_busy; do
        if ((announced == 0)); then say 'Queued behind another active build; existing work is preserved'; announced=1; fi
        sleep 10
    done
}
cleanup() {
    if [[ -n ${CID:-} && -n ${ENGINE:-} ]]; then
        if ((PAUSED)); then "$ENGINE" unpause "$CID" >/dev/null 2>&1 || true; fi
        "$ENGINE" rm -f "$CID" >/dev/null 2>&1 || true
    fi
}
run_job() {
    local image=$1; shift
    local log=$WORK/build.log lifecycle=0
    local -a opts=(--security-opt label=disable --cpus "$JOBS" -v "$ROOT:/work" -w /work)
    if [[ ${1:-} == --internal-lifecycle ]]; then
        lifecycle=1; log=$WORK/package-lifecycle.log
        opts+=(--platform linux/arm64 --network=none)
    else
        opts+=(--network=none)
        if [[ $ENGINE == podman ]]; then opts+=(--userns=keep-id); else opts+=(--user "$(id -u):$(id -g)"); fi
    fi
    wait_idle
    CID=$("$ENGINE" create "${opts[@]}" "$image" bash /work/senemeos.sh "$@")
    trap cleanup EXIT
    "$ENGINE" start "$CID" >/dev/null
    while [[ $("$ENGINE" inspect --format '{{or .State.Running .State.Paused}}' "$CID") == true ]]; do
        if heavy_busy; then
            if ((PAUSED == 0)); then "$ENGINE" pause "$CID" >/dev/null; PAUSED=1; say 'Paused our build while another build uses the host'; fi
        elif ((PAUSED)); then
            "$ENGINE" unpause "$CID" >/dev/null; PAUSED=0; say 'Resuming our preserved build';
        fi
        sleep 10
    done
    if [[ -s $log ]]; then mv "$log" "$log.previous-$(date +%s)-${CID:0:12}"; fi
    "$ENGINE" logs "$CID" > "$log" 2>&1
    local status
    status=$("$ENGINE" inspect --format '{{.State.ExitCode}}' "$CID")
    cleanup; CID=; PAUSED=0; trap - EXIT
    ((status == 0)) || die "Job failed (exit $status); inspect ${log#"$BUILDER/"}"
    if ((lifecycle == 0)); then
        compgen -G "$WORK/rpmbuild/SRPMS/senemos-uke-linux-kernel-mainline-$VERSION-1.*.src.rpm" >/dev/null || die 'Build exited without an SRPM'
    fi
}
internal_build() {
    VERSION=$1 JOBS=$2
    local toolchain=${3:-unrecorded}
    local work=/work/uke-fedora-builder/build/fedora-rawhide/$VERSION
    local top=$work/rpmbuild adaptation=$work/adaptation/senemos-adaptation
    local source=/work/senemos-uke-kernel
    local manifest=$work/source-profile.json
    local identity previous
    identity=$(build_identity "$manifest" /work/uke-fedora-builder/configs/senemos-uke-linux-kernel-mainline.spec "$toolchain")
    if [[ $(cat "$work/completed-input-identity" 2>/dev/null || true) == "$identity" ]] && \
       (cd "$work"; sha256sum -c completed-artifacts.sha256 >/dev/null 2>&1); then
        if cmp -s "$top/SPECS/kernel.spec" <(sed "s/^Version: .*/Version: $VERSION/" /work/uke-fedora-builder/configs/senemos-uke-linux-kernel-mainline.spec) && \
           [[ $(find "$top/RPMS/aarch64" -maxdepth 1 -name '*.rpm' | wc -l) == 4 ]] && \
           [[ $(find "$top/SRPMS" -maxdepth 1 -name '*.src.rpm' | wc -l) == 1 ]]; then
            say 'Reusing the verified completed build with identical source/config/toolchain and packaging rules'
            internal_audit "$VERSION"
            record_completed "$work" "$identity"
        else
            say 'Reusing the compiled kernel and rebuilding changed packaging rules'
            internal_package "$VERSION" "$toolchain"
        fi
        return
    fi
    if [[ $(cat "$work/compiled-input-identity" 2>/dev/null || true) == "$identity" ]] && \
       cmp -s "$top/SPECS/kernel.spec" <(sed "s/^Version: .*/Version: $VERSION/" /work/uke-fedora-builder/configs/senemos-uke-linux-kernel-mainline.spec) && \
       [[ $(find "$top/RPMS/aarch64" -maxdepth 1 -name '*-1.*.rpm' | wc -l) == 4 ]] && \
       compgen -G "$top/SRPMS/*-1.*.src.rpm" >/dev/null; then
        say 'Resuming validation of the completed kernel and RPM build'
        internal_audit "$VERSION"
        record_completed "$work" "$identity"
        return
    fi
    previous=$(cat "$work/input-identity" 2>/dev/null || true)
    if [[ -d $top/kernel-out && $previous != "$identity" ]]; then
        mv "$top/kernel-out" "$top/kernel-out.saved-$(date +%s)"
    fi
    printf '%s\n' "$identity" > "$work/input-identity"
    mkdir -p "$top"/{BUILD,BUILDROOT,RPMS,SRPMS,SOURCES,SPECS} "$adaptation/patches" "$adaptation/configs"
    cp "$source/referances/releases/linux-$VERSION.tar.xz" "$top/SOURCES/"
    cp "$source/referances/releases/linux-$VERSION.tar.sign" "$source/configs/keys/linux-stable.asc" "$top/SOURCES/"
    cp "$source/patches/$VERSION/"* "$adaptation/patches/"
    cp "$source/configs/arm64-qcom.config" "$source/configs/uke.config" "$source/configs/fedora.config" "$adaptation/configs/"
    cp "$manifest" "$adaptation/source-lock.json"
    cp "$source/patches/$VERSION/README.md" "$adaptation/README.md"
    local path expected staged
    while IFS=$'\t' read -r path expected; do
        staged=$adaptation/${path#*/}
        [[ $path != patches/* ]] || staged=$adaptation/patches/${path##*/}
        [[ $path != configs/* ]] || staged=$adaptation/configs/${path##*/}
        [[ $(sha256sum "$staged" | cut -d ' ' -f1) == "$expected" ]] || die "Input changed while staging: $path"
    done < <(jq -r '.patches[], .configs[] | [.path,.sha256] | @tsv' "$manifest")
    tar --sort=name --mtime=@1791024250 --owner=0 --group=0 --numeric-owner -cJf \
        "$top/SOURCES/senemos-uke-adaptation-$VERSION.tar.xz" -C "$work/adaptation" senemos-adaptation
    sed "s/^Version: .*/Version: $VERSION/" /work/uke-fedora-builder/configs/senemos-uke-linux-kernel-mainline.spec > "$top/SPECS/kernel.spec"
    rpm -qa --qf '%{NAME}-%{EPOCHNUM}:%{VERSION}-%{RELEASE}.%{ARCH}\n' | sort > "$work/toolchain-packages.txt"
    rpmbuild -ba --target aarch64 --define "_topdir $top" --define "_smp_build_ncpus $JOBS" "$top/SPECS/kernel.spec"
    printf '%s\n' "$toolchain" > "$work/completed-toolchain-id"
    printf '%s\n' "$identity" > "$work/compiled-input-identity"
    internal_audit "$VERSION"
    record_completed "$work" "$identity"
}
build_identity() {
    local manifest=$1 spec=$2 toolchain=$3
    { cat "$manifest"; printf '%s\n' "$toolchain"; \
        awk '/^%global krel/ {print} /^%build/ {capture=1} /^%install/ {capture=0} capture' "$spec"; \
    } | sha256sum | cut -d ' ' -f1
}
internal_package() {
    VERSION=$1
    local toolchain=$2
    local work=/work/uke-fedora-builder/build/fedora-rawhide/$VERSION
    local top=$work/rpmbuild identity
    local spec=/work/uke-fedora-builder/configs/senemos-uke-linux-kernel-mainline.spec
    cmp "$work/source-profile.json" "$work/adaptation/senemos-adaptation/source-lock.json" || die 'Compiled source profile changed'
    [[ $(cat "$top/kernel-out/include/config/kernel.release") == "$VERSION-senemos-uke" ]] || die 'Compiled kernel release changed'
    [[ $(cat "$work/completed-toolchain-id") == "$toolchain" ]] || die 'Compiled toolchain changed'
    cmp <(awk '/^%build/ {capture=1} /^%install/ {capture=0} capture' "$spec") \
        <(awk '/^%build/ {capture=1} /^%install/ {capture=0} capture' "$top/SPECS/kernel.spec") || die 'Compilation rules changed'
    [[ $(wc -l < "$top/kernel-out/modules.order") == $(find "$top/kernel-out" -name '*.ko' | wc -l) ]] || die 'Incomplete module link output'
    # A new release must form one coherent set. Preserve older packaging
    # results outside the live RPM directories instead of mixing NEVRAs.
    local kind stamp
    stamp=$(date +%s)-$$
    for kind in RPMS SRPMS; do
        [[ ! -d $top/$kind ]] || mv "$top/$kind" "$top/$kind.saved-$stamp"
    done
    mkdir -p "$top/RPMS/aarch64" "$top/SRPMS"
    sed "s/^Version: .*/Version: $VERSION/" "$spec" > "$top/SPECS/kernel.spec"
    rpmbuild -ba --target aarch64 --define "_topdir $top" --define 'uke_package_only 1' "$top/SPECS/kernel.spec"
    internal_audit "$VERSION"
    identity=$(build_identity "$work/source-profile.json" "$spec" "$toolchain")
    printf '%s\n' "$identity" > "$work/compiled-input-identity"
    record_completed "$work" "$identity"
}
record_completed() {
    local work=$1 identity=$2
    (cd "$work"; find rpmbuild/RPMS rpmbuild/SRPMS output upgrade -type f \
        \( -name '*.rpm' -o -path 'output/*' \) -print0 | sort -z | \
        xargs -0 sha256sum > completed-artifacts.sha256)
    printf '%s\n' "$identity" > "$work/completed-input-identity"
}
internal_audit() {
    VERSION=$1
    local work=/work/uke-fedora-builder/build/fedora-rawhide/$VERSION
    local top=$work/rpmbuild
    local output=$top/kernel-out
    [[ -d $output ]] || die 'Kernel output directory is missing'
    [[ $(find "$top/RPMS/aarch64" -maxdepth 1 -name '*.rpm' | wc -l) == 4 ]] || die 'Expected exactly four matching binary RPMs'
    [[ $(find "$top/SRPMS" -maxdepth 1 -name '*.src.rpm' | wc -l) == 1 ]] || die 'Expected exactly one matching source RPM'
    rm -rf -- "$work/extracted"
    mkdir -p "$work/extracted" "$work/output"
    cp "$output/arch/arm64/boot/Image" "$output/arch/arm64/boot/dts/qcom/sm7675-xiaomi-uke.dtb" "$output/.config" "$output/Module.symvers" "$work/output/"
    llvm-readobj --file-headers "$work/output/Image" | grep -F 'IMAGE_FILE_MACHINE_ARM64' || die 'Image EFI header is not AArch64'
    sha256sum "$work/output/"* > "$work/kernel-checksums.txt"
    local package
    for package in "$top/RPMS/aarch64/"*.rpm; do
        rpm -qp --qf '%{ARCH}\n' "$package" | grep -Fx aarch64
        (cd "$work/extracted"; rpm2cpio "$package" | cpio -idm --quiet)
    done
    local krel=$VERSION-senemos-uke module
    cmp "$work/output/Image" "$work/extracted/usr/lib/modules/$krel/vmlinuz" || die 'Packaged Image differs from the compiled Image'
    cmp "$work/output/.config" "$work/extracted/usr/lib/modules/$krel/config" || die 'Packaged config differs from the compiled config'
    cmp "$output/System.map" "$work/extracted/usr/lib/modules/$krel/System.map" || die 'Packaged System.map differs from the compiled map'
    cmp "$work/output/sm7675-xiaomi-uke.dtb" "$work/extracted/usr/lib/modules/$krel/dtb/qcom/sm7675-xiaomi-uke.dtb" || die 'Packaged Uke DTB differs from the compiled DTB'
    cmp "$work/source-profile.json" "$work/extracted/usr/share/senemos/uke/$krel/source-lock.json" || die 'Packaged source/config identity differs from the compiled profile'
    bash /work/uke-fedora-builder/src/audit/check-target-payload.sh "$work/extracted"
    bash /work/uke-fedora-builder/src/audit/check-target-privacy.sh "$work/extracted"
    local count=0
    : > "$work/module-abi.txt"
    while IFS= read -r -d '' module; do
        [[ $(modinfo -F vermagic "$module") == "$krel "* ]] || die 'Module release does not match Image'
        zstd -dc "$module" > "$work/module-check.ko"
        # Consume the complete header: grep -q can SIGPIPE LLVM under pipefail.
        llvm-readelf -h "$work/module-check.ko" | grep -F AArch64 >/dev/null || die 'Non-AArch64 module found'
        if LC_ALL=C grep -aEq '/home/[^/[:space:]]+/|/Users/[^/[:space:]]+/|C:[\\]Users[\\]' "$work/module-check.ko"; then
            die 'Private build path in decompressed target module'
        fi
        printf '%s\t%s\n' "${module#"$work/extracted/"}" "$(modinfo -F vermagic "$module")" >> "$work/module-abi.txt"
        count=$((count + 1))
    done < <(find "$work/extracted/usr/lib/modules/$krel/kernel" -name '*.ko.zst' -print0)
    ((count > 0)) || die 'No rebuilt modules found'
    [[ $count == "$(wc -l < "$output/modules.order")" ]] || die 'RPM module count differs from the complete compiled module list'
    depmod -e -F "$output/System.map" -b "$work/extracted" -m /usr/lib/modules "$krel" 2> "$work/depmod-validation.txt"
    [[ ! -s $work/depmod-validation.txt ]] || die 'Module symbol/dependency validation failed'
    [[ -f $work/extracted/usr/lib/modules/$krel/modules.dep.bin ]] || die 'Module dependency index missing'
    fdtget -t s "$work/output/sm7675-xiaomi-uke.dtb" / compatible | grep -F xiaomi,uke
    for package in "$top/RPMS/aarch64/"*.rpm; do
        rpm -qp --requires "$package" > "$work/$(basename "$package").requires"
        if grep -Ei 'python|pypy|libpython' "$work/$(basename "$package").requires"; then die 'Python runtime dependency in target RPM'; fi
        rpm -qp --scripts "$package" > "$work/$(basename "$package").scripts"
    done
    # Query package metadata in the RPM toolchain, so APT/APK hosts do not need RPM.
    printf '[]\n' > "$work/package-list.json"
    local nevra checksum kind
    for package in "$top/RPMS/aarch64/"*.rpm "$top/SRPMS/"*.rpm; do
        nevra=$(rpm -qp --qf '%{NAME}-%{EPOCHNUM}:%{VERSION}-%{RELEASE}.%{ARCH}' "$package")
        checksum=$(sha256sum "$package" | cut -d ' ' -f1)
        kind=binary; [[ $package != *.src.rpm ]] || kind=source
        jq --arg file "${package##*/}" --arg nevra "$nevra" --arg sha "$checksum" --arg kind "$kind" \
            '. + [{file:$file,kind:$kind,nevra:$nevra,sha256:$sha}]' "$work/package-list.json" > "$work/package-list.json.part"
        mv "$work/package-list.json.part" "$work/package-list.json"
    done
    local upgrade_identity
    upgrade_identity=$({ cat "$work/source-profile.json" "$top/SPECS/kernel.spec"; \
        sha256sum "$work/output/Image" "$work/output/Module.symvers"; } | sha256sum | cut -d ' ' -f1)
    if [[ $(cat "$work/upgrade-input-identity" 2>/dev/null || true) != "$upgrade_identity" ]] || \
       [[ $(find "$work/upgrade" -maxdepth 1 -name '*.rpm' 2>/dev/null | wc -l) != 4 ]]; then
        mkdir -p "$work/upgrade"
        # Same Image/config/modules, increased RPM release: a real package upgrade.
        rpmbuild -bb --target aarch64 --define "_topdir $top" \
            --define 'senemos_package_release 2' --define 'uke_package_only 1' "$top/SPECS/kernel.spec"
        cp "$top/RPMS/aarch64/"*-2.*.rpm "$work/upgrade/"
        rm "$top/RPMS/aarch64/"*-2.*.rpm
        printf '%s\n' "$upgrade_identity" > "$work/upgrade-input-identity"
    fi
    internal_srpm_check "$VERSION"
    say 'Image, DTB, modules, RPM payload, privacy and ABI checks passed'
}
internal_srpm_check() {
    local version=$1 work=/work/uke-fedora-builder/build/fedora-rawhide/$1
    local srpm identity prepared spec path expected
    local top=$work/srpm-closure
    srpm=$(find "$work/rpmbuild/SRPMS" -maxdepth 1 -name '*.src.rpm' -print -quit)
    [[ -s $srpm ]] || die 'Source RPM is missing'
    identity=$(sha256sum "$srpm" | cut -d ' ' -f1)
    if [[ $(cat "$work/srpm-closure-identity" 2>/dev/null || true) == "$identity" ]] && \
       [[ -s $work/srpm-closure.txt ]]; then return; fi
    rm -rf -- "$top"
    mkdir -p "$top"/{SOURCES,SPECS,BUILD,BUILDROOT,RPMS,SRPMS}
    (cd "$top/SOURCES"; rpm2cpio "$srpm" | cpio -idm --quiet)
    spec=$(find "$top/SOURCES" -maxdepth 1 -name '*.spec' -print -quit)
    [[ -s $spec ]] || die 'Embedded SRPM spec is missing'
    mv "$spec" "$top/SPECS/kernel.spec"
    # Only the embedded spec and sources are supplied to this independent prep.
    rpmbuild -bp --target aarch64 --define "_topdir $top" "$top/SPECS/kernel.spec" \
        > "$work/srpm-preparation.log" 2>&1
    prepared=$(find "$top/BUILD" -type d -name "linux-$version" -print -quit)
    [[ -s $prepared/arch/arm64/boot/dts/qcom/sm7675-xiaomi-uke.dts ]] || die 'SRPM did not prepare the independent Uke DTS'
    cmp "$prepared/senemos-adaptation/source-lock.json" "$work/source-profile.json" || die 'SRPM source identity changed'
    while IFS=$'\t' read -r path expected; do
        [[ $(sha256sum "$prepared/senemos-adaptation/${path%%/*}/${path##*/}" | cut -d ' ' -f1) == "$expected" ]] || die "SRPM input changed: $path"
    done < <(jq -r '.patches[], .configs[] | [.path,.sha256] | @tsv' "$work/source-profile.json")
    printf '%s\n' 'Passed independent SRPM extraction, signed-source verification, seven-patch application and config closure; no second full compilation.' > "$work/srpm-closure.txt"
    printf '%s\n' "$identity" > "$work/srpm-closure-identity"
    rm -rf -- "$top"
}
internal_lifecycle() {
    local location=$1 krel=${1##*/}-senemos-uke
    cd "$location"
    rpm -q kmod
    dnf -y --disablerepo='*' --setopt=install_weak_deps=False install ./rpmbuild/RPMS/aarch64/*.rpm
    # Fresh-install scriptlet ordering also regenerates the core's builtin
    # binary indexes; check this state separately from the later upgrade.
    rpm -V senemos-uke-linux-kernel-mainline-core senemos-uke-linux-kernel-mainline-modules \
        senemos-uke-linux-kernel-mainline-dtbs
    rpm -qa | grep '^senemos-uke-linux-kernel-mainline' | sort
    dnf -y --disablerepo='*' --setopt=install_weak_deps=False upgrade ./upgrade/*.rpm
    rpm -q --qf '%{RELEASE}\n' senemos-uke-linux-kernel-mainline | grep -E '^2\.'
    rpm -qa --qf '%{NAME}\n' | sort > dependency-closure.txt
    rpm -qa --qf '%{NAME}-%{EPOCHNUM}:%{VERSION}-%{RELEASE}.%{ARCH}\n' | sort > dependency-closure-nevra.txt
    if grep -Ei 'python|pypy|libpython' dependency-closure.txt; then die 'Python present in target dependency closure'; fi
    rpm -V senemos-uke-linux-kernel-mainline-core senemos-uke-linux-kernel-mainline-modules \
        senemos-uke-linux-kernel-mainline-dtbs
    dnf -y --disablerepo='*' remove senemos-uke-linux-kernel-mainline senemos-uke-linux-kernel-mainline-core \
        senemos-uke-linux-kernel-mainline-modules senemos-uke-linux-kernel-mainline-dtbs
    if rpm -qa | grep -q '^senemos-uke-linux-kernel-mainline'; then die 'RPM removal left an installed Senemos package'; fi
    if [[ -d /usr/lib/modules/$krel ]] && \
       [[ -n $(find "/usr/lib/modules/$krel" -mindepth 1 \( -type f -o -type l \) -print -quit) ]]; then
        die 'RPM removal left kernel files or generated module indexes'
    fi
    [[ ! -e /usr/share/senemos/uke/$krel/source-lock.json ]] || die 'RPM removal left the source identity file'
    printf '%s\n' 'AArch64 RPM install, upgrade, dependency closure and removal passed; no tablet boot performed.'
}
self_test() {
    local temporary passed=0
    temporary=$(mktemp -d)
    trap 'rm -rf -- "$temporary"' RETURN
    ok() { passed=$((passed + 1)); say "ok $passed - $*"; }
    reject() { if "$@" > "$temporary/rejected.log" 2>&1; then die "Expected rejection: $*"; fi; }
    [[ $(package_manager ubuntu debian) == apt && $(package_manager fedora '') == dnf && \
       $(package_manager opensuse-tumbleweed suse) == zypper && $(package_manager manjaro arch) == pacman && \
       $(package_manager postmarketos alpine) == apk ]]
    ok 'host distribution dispatch'
    local manager
    for manager in dnf apt zypper pacman apk; do
        (
            privileged() { printf '%s\n' "$*"; }
            install_packages "$manager" bash jq > "$temporary/$manager.commands"
        )
        grep -Fq jq "$temporary/$manager.commands"
    done
    ok 'five official package-manager installation command fixtures'
    bash -n "$ROOT/senemeos.sh"
    if command -v shellcheck >/dev/null; then shellcheck -s bash "$ROOT/senemeos.sh"; fi
    ok 'shell syntax and available ShellCheck'
    reject bash "$ROOT/senemeos.sh" --build '../escape' --dry-run
    reject bash "$ROOT/senemeos.sh" --jobs 0 --dry-run
    reject bash "$ROOT/senemeos.sh" --distro=debian --build 7.2.9 --dry-run
    reject bash "$ROOT/senemeos.sh" --build 99.99.99 --dry-run
    reject bash "$ROOT/senemeos.sh" --unknown
    ok 'invalid options, path traversal and unimplemented targets'
    mkdir -p "$temporary/profile-fixture/manifests"
    printf '{"schema_version":1,"version":"7.2.9","patches":[]}\n' > "$temporary/profile-fixture/manifests/linux-7.2.9.json"
    incomplete_profile_fixture() {
        local KERNEL=$temporary/profile-fixture VERSION=7.2.9
        resolve_version
    }
    if (incomplete_profile_fixture) > "$temporary/profile.log" 2>&1; then die 'Incomplete Uke profile accepted'; fi
    ok 'incomplete version profile rejected'
    reject bash "$ROOT/senemeos.sh" --build 99.99.99 --offline --dry-run
    if (check_space 1024 25) > "$temporary/space.log" 2>&1; then die 'Disk preflight accepted insufficient space'; fi
    if ((EUID != 0)); then
        if (PATH=$temporary privileged true) > "$temporary/privilege.log" 2>&1; then die 'Missing privilege accepted'; fi
    fi
    host_identity_fixture() {
        local VERSION=7.2.9
        # shellcheck disable=SC1091
        source /etc/os-release
        [[ -n $VERSION ]]
    }
    host_identity_fixture
    [[ $VERSION == latest ]] || die 'Host os-release leaked into requested kernel version'
    ok 'offline profile, insufficient space, missing privilege and host-version isolation'
    mkdir "$temporary/patch-fixture"
    printf 'original\n' > "$temporary/patch-fixture/file"
    printf 'invalid patch\n' > "$temporary/bad.patch"
    if (cd "$temporary/patch-fixture"; git apply --check "$temporary/bad.patch") > "$temporary/patch.log" 2>&1; then die 'Bad patch accepted'; fi
    ok 'failed patch application is rejected'
    local profile=$KERNEL/manifests/linux-7.2.9.json archive=$KERNEL/referances/releases/linux-7.2.9.tar.xz
    if [[ -s $archive ]]; then
        printf broken > "$temporary/broken.tar.xz"
        reject bash "$ROOT/senemeos.sh" --internal-verify "$temporary/broken.tar.xz" "$KERNEL/referances/releases/linux-7.2.9.tar.sign" "$profile" "$KERNEL/configs/keys/linux-stable.asc" "$temporary/gpg"
        verify_source "$archive" "$KERNEL/referances/releases/linux-7.2.9.tar.sign" "$profile" "$KERNEL/configs/keys/linux-stable.asc" "$temporary/good-gpg"
        printf invalid > "$temporary/invalid.sign"
        reject bash "$ROOT/senemeos.sh" --internal-verify "$archive" "$temporary/invalid.sign" "$profile" "$KERNEL/configs/keys/linux-stable.asc" "$temporary/bad-gpg"
        ok 'real signed source accepted; corrupt archive and signature rejected'
    fi
    say "$passed self-test groups passed; no hardware tests performed"
    rm -rf -- "$temporary"; trap - RETURN
}

if [[ ${1:-} == --internal-build ]]; then shift; internal_build "$@"; exit; fi
if [[ ${1:-} == --internal-audit ]]; then shift; internal_audit "$@"; exit; fi
if [[ ${1:-} == --internal-package ]]; then shift; internal_package "$@"; exit; fi
if [[ ${1:-} == --internal-lifecycle ]]; then shift; internal_lifecycle "$@"; exit; fi
if [[ ${1:-} == --internal-verify ]]; then shift; verify_source "$@"; exit; fi
if [[ ${1:-} == --internal-host-prereqs ]]; then bootstrap 0; say 'Official host prerequisites installed and verified'; exit; fi
if [[ ${1:-} == --self-test ]]; then self_test; exit; fi
while (($#)); do
    case $1 in
        --help|-h) help; exit 0;;
        --build|--distro|--release|--jobs)
            (($# >= 2)) || die "Missing value for $1"
            case $1 in --build) VERSION=$2;; --distro) DISTRO=$2;; --release) RELEASE=$2;; --jobs) JOBS=$2;; esac
            shift 2;;
        --build=*) VERSION=${1#*=}; shift;;
        --distro=*) DISTRO=${1#*=}; shift;;
        --release=*) RELEASE=${1#*=}; shift;;
        --jobs=*) JOBS=${1#*=}; shift;;
        --dry-run) DRY_RUN=1; shift;;
        --offline) OFFLINE=1; shift;;
        --test) TEST=1; shift;;
        *) die "Unknown option: $1 (use --help)";;
    esac
done
[[ -z $JOBS || $JOBS =~ ^[1-9][0-9]*$ ]] || die '--jobs requires a positive integer'
[[ $DISTRO =~ ^[a-z]+$ && ( -z $RELEASE || $RELEASE =~ ^[a-zA-Z0-9._-]+$ ) ]] || die 'Invalid distribution or release'
if ((DRY_RUN)); then
    command -v jq >/dev/null || die 'Dry-run needs jq; no dependencies will be installed'
else
    bootstrap
    mkdir -p "$KERNEL/referances/releases"
    mkdir -p "$BUILDER/build"
    exec 9> "$BUILDER/build/senemos-build.lock"
    if ! flock -n 9; then
        say 'Queued behind another Senemos invocation; its sources and output are preserved'
        flock 9
    fi
fi
supported_target
resolve_version
architecture=$(uname -m)
[[ $architecture == x86_64 || $architecture == aarch64 ]] || die "Unsupported host architecture: $architecture"
BASE_IMAGE=$(jq -er --arg a "$architecture" '.fedora_rawhide_images[$a]' "$RULES")
WORK=$BUILDER/build/fedora-rawhide/$VERSION
ARTIFACTS=$BUILDER/artifacts/fedora-rawhide/$VERSION
cpus=$(getconf _NPROCESSORS_ONLN)
memory_jobs=$(awk '/MemAvailable:/ {n=int($2/2097152); print (n>0?n:1)}' /proc/meminfo)
resource_jobs=$((cpus < memory_jobs ? cpus : memory_jobs))
if [[ -z $JOBS ]]; then
    default_jobs=$(jq -er .default_max_jobs "$RULES")
    JOBS=$((resource_jobs < default_jobs ? resource_jobs : default_jobs))
elif ((JOBS > resource_jobs)); then
    say "Reducing requested concurrency to $resource_jobs workers for available CPU/RAM"
    JOBS=$resource_jobs
fi
say "Target $DISTRO/$RELEASE AArch64; Linux $VERSION; $JOBS jobs; Image + Uke DTB + modules + RPM/SRPM"
if ((DRY_RUN)); then say "Pinned build image: $BASE_IMAGE"; exit; fi
wait_idle
mkdir -p "$WORK" "$ARTIFACTS"
cp "$PROFILE" "$WORK/source-profile.json"
PROFILE=$WORK/source-profile.json
minimum=$(jq -er '.minimum_free_gib' "$RULES")
available=$(df -Pk "$WORK" | awk 'NR==2 {print $4}')
check_space "$available" "$minimum"
fetch_source
RECIPE_SHA=$(cat "$BUILDER/configs/Containerfile.rawhide" "$RULES" | sha256sum | cut -d ' ' -f1)
IMAGE=localhost/senemos-uke-build:rawhide-${architecture/x86_64/amd64}-${RECIPE_SHA:0:16}
if ! "$ENGINE" image inspect "$IMAGE" >/dev/null 2>&1; then
    ((OFFLINE == 0)) || die 'Pinned toolchain image is not cached'
    wait_idle
    "$ENGINE" build --build-arg "BASE_IMAGE=$BASE_IMAGE" --build-arg "RECIPE_SHA=$RECIPE_SHA" \
        -t "$IMAGE" -f "$BUILDER/configs/Containerfile.rawhide" "$BUILDER/configs" > "$WORK/toolchain.log" 2>&1
fi
TOOLCHAIN_ID=$("$ENGINE" image inspect "$IMAGE" --format '{{.Id}}')
run_job "$TOOLCHAIN_ID" --internal-build "$VERSION" "$JOBS" "$TOOLCHAIN_ID"
package_list=$WORK/package-list.json
if ((TEST)); then
    wait_idle
    TEST_IMAGE=$(jq -er '.fedora_rawhide_images.aarch64' "$RULES")
    if ((OFFLINE)); then "$ENGINE" image inspect "$TEST_IMAGE" >/dev/null 2>&1 || die 'Offline AArch64 base image is missing'; fi
    prepare_aarch64
    TEST_RECIPE=$(cat "$BUILDER/configs/Containerfile.lifecycle" "$RULES" | sha256sum | cut -d ' ' -f1)
    TEST_RUNTIME=localhost/senemos-uke-lifecycle:${TEST_RECIPE:0:16}
    if ! "$ENGINE" image inspect "$TEST_RUNTIME" >/dev/null 2>&1; then
        ((OFFLINE == 0)) || die 'Offline AArch64 test runtime is missing'
        "$ENGINE" build --platform linux/arm64 --build-arg "BASE_IMAGE=$TEST_IMAGE" \
            --build-arg "RECIPE_SHA=$TEST_RECIPE" -t "$TEST_RUNTIME" \
            -f "$BUILDER/configs/Containerfile.lifecycle" "$BUILDER/configs" > "$WORK/test-runtime.log" 2>&1
    fi
    TEST_RUNTIME_ID=$("$ENGINE" image inspect "$TEST_RUNTIME" --format '{{.Id}}')
    run_job "$TEST_RUNTIME_ID" --internal-lifecycle "/work/uke-fedora-builder/build/fedora-rawhide/$VERSION"
fi
# Expose one complete candidate only after all requested gates passed. Failed
# trials must not leave new RPMs beside an older successful manifest.
ARTIFACT_DESTINATION=$ARTIFACTS
ARTIFACT_STAGE=$(mktemp -d "$BUILDER/artifacts/fedora-rawhide/.$VERSION-XXXXXX")
ARTIFACTS=$ARTIFACT_STAGE
trap 'rm -rf -- "$ARTIFACT_STAGE"' EXIT
cp "$WORK/rpmbuild/RPMS/aarch64/"*.rpm "$WORK/rpmbuild/SRPMS/"*.rpm "$ARTIFACTS/"
cp -a "$WORK/output" "$ARTIFACTS/"
cp "$WORK/toolchain-packages.txt" "$WORK/module-abi.txt" "$WORK/depmod-validation.txt" "$WORK/srpm-closure.txt" "$ARTIFACTS/"
if ((TEST)); then
    cp "$WORK/dependency-closure.txt" "$WORK/dependency-closure-nevra.txt" "$ARTIFACTS/"
fi
jq -n --slurpfile source "$PROFILE" --slurpfile packages "$package_list" --arg image "$TOOLCHAIN_ID" --arg base "$BASE_IMAGE" \
    --arg recipe "$RECIPE_SHA" --arg config "$(sha256sum "$WORK/output/.config" | cut -d ' ' -f1)" \
    --arg test_image "$TEST_RUNTIME_ID" --arg host "$architecture" \
    --arg abi "$(sha256sum "$WORK/module-abi.txt" | cut -d ' ' -f1)" \
    --argjson modules "$(wc -l < "$WORK/module-abi.txt")" \
    --arg version "$VERSION" --argjson lifecycle "$TEST" \
    '{schema_version:1,product:"senemos-uke-linux-kernel-mainline",source:$source[0],packages:$packages[0],toolchain_image:$image,toolchain_recipe_sha256:$recipe,base_image:$base,config_sha256:$config,kernel_release:($version+"-senemos-uke"),target:"fedora-rawhide-aarch64",compile_validation:"passed",payload_validation:"passed",source_rpm_preparation:"passed",module_count:$modules,module_abi_sha256:$abi,package_lifecycle_tested:($lifecycle==1),package_test_image:$test_image,build_host_architecture:$host,hardware_tested:false,boot_tested:false,signature_state:"unsigned-development-RPM"}' > "$ARTIFACTS/build-manifest.json"
(cd "$ARTIFACTS"; find . -type f ! -name SHA256SUMS ! -name '*.part' -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS.part; mv SHA256SUMS.part SHA256SUMS)
if [[ -d $ARTIFACT_DESTINATION ]]; then
    mv "$ARTIFACT_DESTINATION" "$ARTIFACT_DESTINATION.saved-$(date +%s)-$$"
fi
mv "$ARTIFACT_STAGE" "$ARTIFACT_DESTINATION"
trap - EXIT
say "Verified local candidates: uke-fedora-builder/artifacts/fedora-rawhide/$VERSION/"
