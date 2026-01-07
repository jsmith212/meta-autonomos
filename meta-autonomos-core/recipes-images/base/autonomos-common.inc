SUMMARY = "Core image with basic packages for Autonomos"

LICENSE = "CLOSED"

inherit core-image
inherit autonomos-features

IMAGE_INSTALL:append = " iw wpa-supplicant wpa-supplicant-service"
IMAGE_FEATURES:append = " splash"
