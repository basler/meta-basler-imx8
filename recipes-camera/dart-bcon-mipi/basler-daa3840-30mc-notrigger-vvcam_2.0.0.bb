LICENSE = "Basler-SLA-02 & BSD-3-Clause & OpenSSL"
LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"
# checksum of the selfsh for this camera module
SRC_URI[tarball.sha256sum] = "e520c300a65522ba5fc74c94b260cf01f89117d4dba4b15a7b8459cff2826d85"

require basler-dart-bcon-mipi.inc

RDEPENDS_${PN} = "basler-daa3840-30mc-imx-isp-driver imx-gpu-g2d"