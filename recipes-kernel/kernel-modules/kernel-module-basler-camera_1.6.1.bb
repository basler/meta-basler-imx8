SUMMARY = "Basler camera sensor driver"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://../COPYING;md5=801f80980d171dd6425610833a22dbe6"

inherit module

SRC_URI = "https://artifacts.baslerweb.com/artifactory/embedded-vision-public/packages/basler-camera-driver/basler-camera-driver_${PV}.tgz"
SRC_URI[sha256sum] = "c2e62fc7774da42cbbf1043a8d06c262b68b05632ab666ce60118c9133cc8090"
S = "${WORKDIR}/basler-camera-driver_${PV}/basler-camera-driver"


FILES_${PN}-dev = "${includedir}/linux/basler-camera-driver.h"
do_install_append() {
    install -d ${D}${includedir}/linux
    install -m 644 ${S}/basler-camera-driver.h ${D}${includedir}/linux/basler-camera-driver.h
    rm -R ${D}${includedir}/${PN}/
}

