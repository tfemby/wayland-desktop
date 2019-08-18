# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="[WIP] desktop 'environment'"
HOMEPAGE="https://bitbucket.org/carbonOS/carbonshell"


if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/carbonOS/carbonshell.git"
else
	SRC_URI="https://bitbucket.org/carbonOS/carbonshell/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="UNLICENSE"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="
	=gui-wm/wayfire-9999
	dev-libs/flatbuffers
	dev-libs/libdazzle[vala]
	dev-libs/pugixml
	dev-libs/gtkd
	dev-libs/libhandy
	dev-libs/libfmt
	=dev-libs/gtk-layer-shell-9999
"

DEPEND="${RDEPEND}
	dev-libs/wayland-protocols
"
