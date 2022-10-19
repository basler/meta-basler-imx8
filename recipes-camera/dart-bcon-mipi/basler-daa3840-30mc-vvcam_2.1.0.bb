LICENSE = "Basler-SLA-02 & BSD-3-Clause & OpenSSL"
LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"
# checksum of the selfsh for this camera module
SRC_URI[tarball.sha256sum] = "f86a08615bf34cae87ad0828e1345487ceebd9e515f0643a17e9a2c9723c600a"

require basler-dart-bcon-mipi.inc

RDEPENDS:${PN} = "basler-daa3840-30mc-imx-isp-driver imx-gpu-g2d"
