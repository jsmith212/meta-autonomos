FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"


do_install:append() {
    # Replace the empty SSID and password with those provided in WIFI_SSID & WIFI_PSK_HASH
    sed -i -e s/ssid=\"\"/ssid=\"${WIFI_SSID}\"/ -e s/psk=\"\"/psk=${WIFI_PSK_HASH}/ ${D}/etc/wpa_supplicant.conf
}
