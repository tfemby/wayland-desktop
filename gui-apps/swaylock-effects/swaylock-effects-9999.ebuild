
EAPI=7

inherit fcaps meson

DESCRIPTION="Screen locker for Wayland"
HOMEPAGE="https://github.com/mortie/swaylock-effects"

MY_PV=$(ver_rs 2 '-')
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mortie/swaylock-effects.git"
else
	SRC_URI="https://github.com/mortie/swaylock-effects/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_PV}
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
CPU_FLAGS_X86=( "sse" )
IUSE="+gdk-pixbuf +man +pam ${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}"

DEPEND="
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2 )
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}
	!gui-apps/swaylock
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.14
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

src_prepare() {
	default
	sed -e "/werror=true/d" \
	    -e "/mtune=native/d" \
	    -e "/-O3/d" \
	    -i meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature pam)
		$(meson_feature gdk-pixbuf)
		$(meson_use cpu_flags_x86_sse sse)
		"-Dfish-completions=false"
		"-Dzsh-completions=false"
		"-Dbash-completions=false"
	)
	if [[ ${PV} != 9999 ]]; then
		emesonargs+=( "-Dswaylock-version=${PV}" )
	fi
	meson_src_configure
}

pkg_postinst() {
	if ! use pam; then
		fcaps cap_sys_admin usr/bin/swaylock
	fi
}
