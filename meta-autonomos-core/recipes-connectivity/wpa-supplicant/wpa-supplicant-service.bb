SUMMARY = "wpa-supplicant service"
DESCRIPTION = "Installs the wpa-supplicant service file to bring up client wifi"

SRC_URI = "file://wpa_supplicant.service"
LICENSE = "CLOSED"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/etc/systemd/system
    install -m 644 wpa_supplicant.service ${D}/etc/systemd/system/

    # Enable the service
    install -d ${D}/etc/systemd/system/network.target.wants
    cd ${D}
    ln -s etc/systemd/system/wpa_supplicant.service etc/systemd/system/network.target.wants/wpa_supplicant.service
}
