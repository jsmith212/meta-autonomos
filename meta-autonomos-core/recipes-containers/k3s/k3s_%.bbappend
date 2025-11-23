do_install:append () {
    install -d ${D}/data/k3s/rancher
    install -d ${D}/data/k3s/kubelet
    install -d ${D}/var/lib
    ln -snf "/data/k3s/rancher" ${D}/var/lib/rancher
    ln -snf "/data/k3s/kubelet" ${D}/var/lib/kubelet
}

FILES:${PN} += "/data /data/k3s /data/k3s/rancher /data/k3s/kubelet"
