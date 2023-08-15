SUMMARY = "Basler camera sensor driver"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://../COPYING;md5=288618fe39e7689c3712691843e7c40c"

inherit module

SRC_URI = "https://artifacts.baslerweb.com/artifactory/embedded-vision-public/packages/basler-camera-driver/basler-camera-driver_${PV}.tgz"
S = "${WORKDIR}/basler-camera-driver_${PV}/basler-camera-driver"


FILES:${PN}-dev = "${includedir}/linux/basler-camera-driver.h"
do_install:append() {
    install -d ${D}${includedir}/linux
    install -m 644 ${S}/basler-camera-driver.h ${D}${includedir}/linux/basler-camera-driver.h
    rm -R ${D}${includedir}/${PN}/
}
