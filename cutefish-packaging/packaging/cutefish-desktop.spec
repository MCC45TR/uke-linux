Name:           cutefish-desktop
Version:        1.0^20261027
Release:        4%{?dist}
Summary:        Upstream Cutefish Wayland desktop
License:        BSD-3-Clause AND GPL-3.0-only AND GPL-3.0-or-later AND LGPL-2.0-or-later AND MIT
URL:            https://cutefish.org/
ExclusiveArch:  aarch64

Source0: https://github.com/cutefishos/cutefish-toolkit/archive/f04f85bbdf31e57f32133dfcb3267d78af402af6.tar.gz#/cutefish-toolkit-f04f85bbdf31e57f32133dfcb3267d78af402af6.tar.gz
Source1: https://github.com/cutefishos/cutefish-framework/archive/f7408d227b8839541afa7e0749d7a389449c6f2b.tar.gz#/cutefish-framework-f7408d227b8839541afa7e0749d7a389449c6f2b.tar.gz
Source2: https://github.com/cutefishos/cutefish-core/archive/94f6ff6a917dc31bd9cd4bbad9e312fd62d5fdc6.tar.gz#/cutefish-core-94f6ff6a917dc31bd9cd4bbad9e312fd62d5fdc6.tar.gz
Source3: https://github.com/cutefishos/cutefish-compositor/archive/36822133297756a1a51e5bf210b99b6e7b410ae2.tar.gz#/cutefish-compositor-36822133297756a1a51e5bf210b99b6e7b410ae2.tar.gz
Source4: https://github.com/cutefishos/filemanager/archive/a24259b1afe206abe5b57edd80f228abe413720c.tar.gz#/filemanager-a24259b1afe206abe5b57edd80f228abe413720c.tar.gz
Source5: https://github.com/cutefishos/icons/archive/a38be51fe7f6a87a9b2bb4928f8d96134a066848.tar.gz#/icons-a38be51fe7f6a87a9b2bb4928f8d96134a066848.tar.gz
Source6: https://github.com/cutefishos/settings/archive/724827e0fd2a56dac5d506075b5a891e516b4015.tar.gz#/settings-724827e0fd2a56dac5d506075b5a891e516b4015.tar.gz
Source7: https://github.com/cutefishos/terminal/archive/bd1d32202d66899d5ba0af55f00d871cc8d9b32c.tar.gz#/terminal-bd1d32202d66899d5ba0af55f00d871cc8d9b32c.tar.gz
Source8: https://github.com/cutefishos/xdg-desktop-portal-cutefish/archive/03d019c0bf5cb875881f852b6a74e2b1670a5949.tar.gz#/xdg-desktop-portal-cutefish-03d019c0bf5cb875881f852b6a74e2b1670a5949.tar.gz
Source9: https://skia.googlesource.com/skia/+archive/95ee33d7ec7791ab9c071675710a14fe6408ae4f.tar.gz#/skia-95ee33d7ec7791ab9c071675710a14fe6408ae4f.tar.gz
Source10: sources.sha256
Source11: upstream.tsv
Source12: cutefish-auth

BuildRequires: gcc-c++ clang cmake ninja-build gn python3 gettext binutils
BuildRequires: pkgconfig desktop-file-utils
BuildRequires: wayland-devel >= 1.23
BuildRequires: wayland-protocols-devel >= 1.39
BuildRequires: mesa-libEGL-devel mesa-libGLES-devel mesa-libgbm-devel
BuildRequires: libdrm-devel libxkbcommon-devel libinput-devel libseat-devel
BuildRequires: systemd-devel pam-devel fontconfig-devel freetype-devel
BuildRequires: harfbuzz-devel libicu-devel expat-devel libpng-devel
BuildRequires: libjpeg-turbo-devel zlib-ng-compat-devel libwebp-devel
BuildRequires: libtiff-devel libheif-devel libjxl-devel
BuildRequires: pipewire-devel ffmpeg-free-devel libva-devel libxcb-devel
BuildRequires: libarchive-devel fuse3-devel libmtp-devel libsmbclient-devel
BuildRequires: libssh-devel libzip-devel libxcrypt-devel libXcursor-devel
BuildRequires: pcre2-devel gtk-update-icon-cache
BuildRequires: bzip2-devel xz-devel lzfse-devel

Provides: bundled(skia) = 156
Requires: accountsservice polkit gsettings-desktop-schemas xdg-user-dirs
Requires: NetworkManager bluez upower power-profiles-daemon udisks2 fuse3
Requires: pipewire pipewire-pulseaudio wireplumber gnome-keyring gnome-keyring-pam
Requires: xdg-desktop-portal xorg-x11-server-Xwayland adwaita-icon-theme
Requires: glibc-locale-source glibc-langpack-en

%description
The upstream Cutefish desktop, built for Fedora Rawhide AArch64. Includes its
toolkit, service framework, session, compositor, file manager, icons, Settings,
Terminal and desktop portal. Cutefish source and branding belong to upstream.
This package supplies Fedora packaging only. It does not replace or enable a
display manager, select a default session, or install Uke hardware support.
Upstream Unsplash wallpapers and optional agent-control software are excluded.

%package devel
Summary: Development files for the upstream Cutefish toolkit and framework
Requires: %{name}%{?_isa} = %{version}-%{release}
Requires: pkgconfig(libpipewire-0.3) >= 0.3.65

%description devel
Headers, linker names and CMake packages for the upstream Cutefish libraries.

%prep
%setup -q -c -T
(cd %{_sourcedir} && sha256sum -c %{SOURCE10})
mkdir cutefish-toolkit cutefish-framework cutefish-core cutefish-compositor filemanager icons settings terminal xdg-desktop-portal-cutefish
tar -xf %{SOURCE0} --strip-components=1 -C cutefish-toolkit
tar -xf %{SOURCE1} --strip-components=1 -C cutefish-framework
tar -xf %{SOURCE2} --strip-components=1 -C cutefish-core
tar -xf %{SOURCE3} --strip-components=1 -C cutefish-compositor
tar -xf %{SOURCE4} --strip-components=1 -C filemanager
tar -xf %{SOURCE5} --strip-components=1 -C icons
tar -xf %{SOURCE6} --strip-components=1 -C settings
tar -xf %{SOURCE7} --strip-components=1 -C terminal
tar -xf %{SOURCE8} --strip-components=1 -C xdg-desktop-portal-cutefish
mkdir -p cutefish-toolkit/third_party/skia
tar -xf %{SOURCE9} -C cutefish-toolkit/third_party/skia
# Use Fedora's native GN; no downloaded build executable or network fetch.
ln -s %{_bindir}/gn cutefish-toolkit/third_party/skia/bin/gn

%build
%set_build_flags
stage=$PWD/stage
export CMAKE_PREFIX_PATH="$stage%{_prefix}"
export LD_LIBRARY_PATH="$stage%{_libdir}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
for component in cutefish-toolkit cutefish-framework icons cutefish-core filemanager terminal xdg-desktop-portal-cutefish settings cutefish-compositor; do
    cmake -S "$component" -B "build/$component" -G Ninja \
        -DCMAKE_INSTALL_PREFIX=%{_prefix} \
        -DCMAKE_INSTALL_LIBDIR=%{_lib} \
        -DCMAKE_INSTALL_LIBEXECDIR=%{_libexecdir} \
        -DCMAKE_INSTALL_SYSCONFDIR=%{_sysconfdir} \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TESTING=OFF
    cmake --build "build/$component" --parallel %{_smp_build_ncpus}
    DESTDIR="$stage" cmake --install "build/$component"
done

%install
cp -a stage/. %{buildroot}/
# Debian common-auth/common-account have no Fedora provider.
install -m644 %{SOURCE12} %{buildroot}%{_sysconfdir}/pam.d/cutefish-auth
mkdir -p %{buildroot}%{_licensedir}/%{name} %{buildroot}%{_docdir}/%{name}
for component in cutefish-toolkit cutefish-framework cutefish-core cutefish-compositor filemanager icons settings terminal xdg-desktop-portal-cutefish; do
    install -Dm644 "$component/LICENSE" "%{buildroot}%{_licensedir}/%{name}/$component/LICENSE"
done
install -Dm644 cutefish-toolkit/third_party/skia/LICENSE %{buildroot}%{_licensedir}/%{name}/skia/LICENSE
install -Dm644 cutefish-toolkit/third_party/skia/modules/skcms/LICENSE %{buildroot}%{_licensedir}/%{name}/skcms/LICENSE
install -Dm644 terminal/qmltermwidget/LICENSE %{buildroot}%{_licensedir}/%{name}/qmltermwidget/LICENSE
install -m644 terminal/qmltermwidget/LICENSE.BSD-3-clause terminal/qmltermwidget/LICENSE.LGPL2+ %{buildroot}%{_licensedir}/%{name}/qmltermwidget/
install -m644 %{SOURCE10} %{SOURCE11} %{buildroot}%{_docdir}/%{name}/
%find_lang %{name} --all-name

%check
test -x %{buildroot}%{_bindir}/cutefish-compositor
test -x %{buildroot}%{_bindir}/cutefish-wayland-session
test -x %{buildroot}%{_bindir}/cutefish-settings
test -x %{buildroot}%{_bindir}/cutefish-terminal
test -x %{buildroot}%{_bindir}/cutefish-filemanager
# DesktopNames is a display-manager session key, outside the application spec.
grep -Fx 'DesktopNames=Cutefish;' %{buildroot}%{_datadir}/wayland-sessions/cutefish-wayland.desktop
sed '/^DesktopNames=/d' %{buildroot}%{_datadir}/wayland-sessions/cutefish-wayland.desktop > session-check.desktop
desktop-file-validate session-check.desktop
! grep -E 'common-auth|common-account' %{buildroot}%{_sysconfdir}/pam.d/cutefish-auth || exit 1
find %{buildroot} -type f \( -name '*.py' -o -name '*.pyc' -o -name '*.pyo' \) > python-files.txt
test ! -s python-files.txt
! grep -rlE '^#!.*python' %{buildroot} || exit 1
find %{buildroot} -type f -exec file --brief {} + > payload-types.txt
! grep -i 'python' payload-types.txt || exit 1
find %{buildroot}%{_libdir} -name '*.a' > static-libraries.txt
test ! -s static-libraries.txt
test ! -d %{buildroot}%{_datadir}/backgrounds/cutefishos
# Imported build dependencies must not escape into installed CMake metadata.
! grep -rF "$PWD/stage" %{buildroot}%{_libdir}/cmake || exit 1

%files -f %{name}.lang
%license %{_licensedir}/%{name}/
%license %{_licensedir}/cutefish-compositor/
%doc %{_docdir}/%{name}/
%{_bindir}/cutefish-*
%{_libexecdir}/cutefish-*
%{_libexecdir}/xdg-desktop-portal-cutefish
%{_libdir}/libcutefish-*.so.*
%{_datadir}/applications/*cutefish*.desktop
%{_datadir}/cutefish*/
%{_datadir}/icons/Cutefish/
%{_datadir}/wayland-sessions/cutefish-wayland.desktop
%{_datadir}/dbus-1/services/*cutefish*
%{_datadir}/dbus-1/system-services/*cutefish*
%{_datadir}/dbus-1/system.d/*cutefish*
%{_datadir}/polkit-1/actions/*cutefish*
%{_datadir}/polkit-1/rules.d/*cutefish*
%{_datadir}/xdg-desktop-portal/*cutefish*
%{_datadir}/xdg-desktop-portal/portals/cutefish.portal
%{_prefix}/lib/systemd/system/cutefish-*.service
%{_prefix}/lib/systemd/user/*cutefish*
%{_prefix}/lib/systemd/user/xdg-document-portal.service.d/
%{_prefix}/lib/udev/rules.d/*cutefish*
%{_prefix}/lib/modules-load.d/cutefish-ddc.conf
%config(noreplace) %{_sysconfdir}/pam.d/cutefish-auth

%files devel
%{_includedir}/cutefish*/
%{_libdir}/cmake/Cutefish*/
%{_libdir}/libcutefish-*.so

%changelog
* Tue Oct 27 2026 MCC45TR <MCC45TR@users.noreply.github.com> - 1.0^20261027-4
- Require PipeWire development files for the public audio client headers.
- Match actual upstream installation paths and make payload checks enforce failures.

* Tue Oct 27 2026 MCC45TR <MCC45TR@users.noreply.github.com> - 1.0^20261027-3
- Validate the session extension separately while preserving its upstream bytes.

* Tue Oct 27 2026 MCC45TR <MCC45TR@users.noreply.github.com> - 1.0^20261027-2
- Declare the file manager archive dependencies and preserve terminal notices.

* Tue Oct 27 2026 MCC45TR <MCC45TR@users.noreply.github.com> - 1.0^20261027-1
- Package the pinned upstream Wayland desktop for Rawhide AArch64.
- Use Fedora GN and PAM; exclude Unsplash wallpapers and optional agent tools.
