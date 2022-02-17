FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append = " file://isp-imx-basler/"

do_install_append() {
    #install our camera files on top
    cp -r ${WORKDIR}/isp-imx-basler/* ${D}/
}