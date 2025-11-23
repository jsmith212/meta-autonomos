FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://10-wired.network \
    file://20-wifi.network \
"

FILES:${PN} += " \
    ${sysconfdir}/systemd/network/10-wired.network \
    ${sysconfdir}/systemd/network/20-wifi.network \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -D -m 0644 ${WORKDIR}/10-wired.network ${D}${sysconfdir}/systemd/network
    install -D -m 0644 ${WORKDIR}/20-wifi.network ${D}${sysconfdir}/systemd/network
}

