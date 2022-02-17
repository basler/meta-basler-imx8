DESCRIPTION = "Basler camera binary drivers"
LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://COPYING;md5=2383fee3f7f91dfa72b970b1bf0d8de4"

SRC_URI[sha256sum] = "39a535c54d186c9c578c7cfd712feafe079c7a62cf7a38387e6270e39345feab"

require basler-dart-bcon-mipi-imx-isp.inc

do_install_append() {
    # in the 4.0.6 release, the wrong drv is referenced in Sensor cfg
    sed -i 's/^drv\s*=.*/drv="daA3840_30mc.drv"/g' ${D}/opt/imx8-isp/bin/Sensor_DAA3840_30MC.cfg
}