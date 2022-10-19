LICENSE = "Basler-SLA-02 & BSD-3-Clause & OpenSSL"
LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"
# checksum of the selfsh for this camera module
SRC_URI[tarball.sha256sum] = "5f1f59883fe3639805043716e0bfadbe0b75d8d5a90b3116c37931ea2ac195d6"

require basler-dart-bcon-mipi.inc

RDEPENDS:${PN} = "basler-daa3840-30mc-imx-isp-driver imx-gpu-g2d"
