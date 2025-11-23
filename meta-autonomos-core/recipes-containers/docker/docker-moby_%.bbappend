do_install:append () {
    install -d ${D}/var/lib
    install -d ${D}/data/docker
    ln -snf "/data/docker" ${D}/var/lib/docker
}

FILES:${PN} += "/data /data/docker"
