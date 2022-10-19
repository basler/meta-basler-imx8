LICENSE = "Basler-SLA-02 & BSD-3-Clause & OpenSSL"
LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"
# checksum of the selfsh for this camera module
SRC_URI[tarball.sha256sum] = "0a754149d1a978c66067d5b5a823d325c77feb03db36392d22f161ffcd0b34c9"

require basler-dart-bcon-mipi.inc

RDEPENDS:${PN} = "basler-daa2500-60mc-imx-isp-driver imx-gpu-g2d"
