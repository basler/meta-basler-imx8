LIC_FILES_CHKSUM = "file://opt/dart-bcon-mipi/share/doc/${PN}/copyright;md5=ff8962a0d69b960bd5b0a2bd0c97c184"

def get_model_name(pn):
    import re
    pattern = r"basler-(daa\d+)-(\d+mc).*?(-vvcam)?"
    m = re.match(pattern, pn)
    model_name = f"{m.group(1)}-{m.group(2)}"
    return model_name

RDEPENDS:${PN} += "basler-${@get_model_name(d.getVar('PN'))}-imx-isp-driver imx-gpu-g2d"
