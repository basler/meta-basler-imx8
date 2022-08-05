LICENSE = "Basler-SLA-02 & BSD-3-Clause & OpenSSL"
LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"
# checksum of the selfsh for this camera module
SRC_URI[tarball.sha256sum] = "495131b3f17dd1a6d427eca9b132d7438356aff195e94d77648ca4c7dfbdc67d"

require basler-dart-bcon-mipi.inc

RDEPENDS_${PN} = "basler-daa2500-60mc-imx-isp-driver imx-gpu-g2d"