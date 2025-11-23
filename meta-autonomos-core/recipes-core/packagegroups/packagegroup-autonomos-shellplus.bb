SUMMARY = "Better shell experience"
DESCRIPTION = "Packagegroup for a better shell experience."
LICENSE = "MIT"

inherit packagegroup

PACKAGEGROUP_PACKAGES = "zsh tmux vim"

RDEPENDS:${PN} = "${PACKAGEGROUP_PACKAGES}"
