# Copyright 2022 Enéas Ulir de Queiroz
# SPDX-License-Identifier: GPL-2.0-or-later

EAPI=7

inherit linux-info systemd tmpfiles

DESCRIPTION="The sqm-scripts traffic shaper"
HOMEPAGE="https://github.com/tohojo/sqm-scripts"

SRC_URI="https://github.com/tohojo/sqm-scripts/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
SLOT=0

RDEPEND="sys-apps/iproute2"

CONFIG_CHECK="~IFB ~NET_SCHED"
ERROR_IFB="QoS and/or fair queueing support (CONFIG_NET_SCHED) is not set in kernel config"
ERROR_NET_SCHED="IFB support (CONFIG_IFB) is needed to run sqm, but is not set in kernel config"

PATCHES=( "${FILESDIR}"/${P}-systemd.patch )

src_install() {
	emake install DESTDIR="${ED}" UNIT_DIR="${ED}$(systemd_get_systemunitdir)"
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	tmpfiles_process sqm.conf
}
