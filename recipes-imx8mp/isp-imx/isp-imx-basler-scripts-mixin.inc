FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://isp-imx-basler/"

do_install:append() {
    # install our camera scripts on top
    cp -r ${WORKDIR}/isp-imx-basler/* ${D}/
}

# Some of the delivered scripts require bash
RDEPENDS:${PN} += "bash"

# The detect_cameras.sh script uses i2ctransfer
RDEPENDS:${PN} += "i2c-tools"
