# This bbappend removes all files from the package, as everything is installed by basler-daa3840-30mc-imx-isp-driver

do_install_append() {
    # don't do rm -rf ${D}/* for paranoic reasons since $D might be empty
    rm -rf ${D}
    install -d ${D}
}

RDEPENDS_${PN} = "basler-daa3840-30mc-imx-isp-driver \
                  basler-daa2500-60mc-imx-isp-driver "

# Still allow it to be installed
ALLOW_EMPTY_${PN} = "1"
