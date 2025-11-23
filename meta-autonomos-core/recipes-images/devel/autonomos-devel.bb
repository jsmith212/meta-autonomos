require recipes-images/base/autonomos-minimal.bb
inherit core-image

# Add package management tools
IMAGE_FEATURES:append = " package-management"

# Automatically log in over serial console
IMAGE_FEATURES:append = " serial-autologin-root"

# Enable debug tweaks
IMAGE_FEATURES:append = " debug-tweaks"

# Add SSH server
IMAGE_FEATURES:append = " ssh-server-openssh"

# Enable debug tooling
IMAGE_FEATURES:append = " tools-debug"
IMAGE_INSTALL:append = " htop"
