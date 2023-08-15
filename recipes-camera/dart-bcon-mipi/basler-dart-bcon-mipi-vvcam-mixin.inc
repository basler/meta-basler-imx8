LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"

def get_model_name(pn):
    import re

    # strip leading "basler-" and trailing "[-notrigger]-vvcam"
    pattern = r"basler-(daa\d+-\d+mc[^-]*)"
    m = re.match(pattern, pn)
    return f"{m.group(1)}"

RDEPENDS:${PN} += "basler-${@get_model_name(d.getVar('PN'))}-imx-isp-driver imx-gpu-g2d"
