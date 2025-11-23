SUMMARY = "Kubernetes Deployment"
DESCRIPTION = "Runs a kubernetes cluster on the device using k3s."
LICENSE = "MIT"

inherit packagegroup

PACKAGEGROUP_PACKAGES = " \
    packagegroup-k3s-host \
    packagegroup-k3s-node \
    ca-certificates \
    kernel-modules \
"

RDEPENDS:${PN} = "${PACKAGEGROUP_PACKAGES}"
