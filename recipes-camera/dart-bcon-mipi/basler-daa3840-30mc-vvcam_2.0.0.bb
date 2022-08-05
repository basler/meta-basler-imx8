LICENSE = "Basler-SLA-02 & BSD-3-Clause & OpenSSL"
LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"
# checksum of the selfsh for this camera module
SRC_URI[tarball.sha256sum] = "8b2416e218be0c9c0a06990bfaa2de75af01f03472191778db39000ac6d56e5b"

require basler-dart-bcon-mipi.inc

RDEPENDS_${PN} = "basler-daa3840-30mc-imx-isp-driver imx-gpu-g2d"