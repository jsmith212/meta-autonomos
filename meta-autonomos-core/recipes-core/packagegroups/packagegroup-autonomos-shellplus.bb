SUMMARY = "Better shell experience"
DESCRIPTION = "Packagegroup for a better shell experience with oh-my-zsh."
LICENSE = "MIT"

inherit packagegroup

PACKAGEGROUP_PACKAGES = "\
    zsh \
    tmux \
    oh-my-zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
"

RDEPENDS:${PN} = "${PACKAGEGROUP_PACKAGES}"
