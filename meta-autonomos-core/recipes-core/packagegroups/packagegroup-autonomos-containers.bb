SUMMARY = "Containerization tools"
DESCRIPTION = "Containerization support through Docker, Docker Compose, and containerd."
LICENSE = "MIT"

inherit packagegroup

PACKAGEGROUP_PACKAGES = "docker docker-compose"

RDEPENDS:${PN} = "${PACKAGEGROUP_PACKAGES}"
