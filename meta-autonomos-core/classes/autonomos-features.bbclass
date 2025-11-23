# Dynamically includes packagegroups based on MYPROJECT_FEATURES

AUTONOMOS_FEATURES ?= ""

python __anonymous() {
    features = d.getVar("AUTONOMOS_FEATURES", True).split()
    install_line = ""
    for f in features:
        pkg = f"packagegroup-autonomos-{f}"
        install_line += f" {pkg}"
    d.appendVar("IMAGE_INSTALL", install_line)
}
