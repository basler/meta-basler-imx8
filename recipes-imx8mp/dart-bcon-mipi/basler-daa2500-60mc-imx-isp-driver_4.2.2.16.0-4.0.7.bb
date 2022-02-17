DESCRIPTION = "Basler camera binary drivers"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://COPYING;md5=2383fee3f7f91dfa72b970b1bf0d8de4"

SRC_URI[sha256sum] = "934074b31c4bd6804e9ef7789aae14b6d27eab6563e6ef1849ca1b4f0a86e047"

require basler-dart-bcon-mipi-imx-isp.inc

do_install_append() {
    # in the 4.0.6 release, the wrong drv is referenced in Sensor cfg
    sed -i 's/^drv\s*=.*/drv="daA2500_60mc.drv"/g' ${D}/opt/imx8-isp/bin/Sensor_DAA2500_60MC.cfg
}