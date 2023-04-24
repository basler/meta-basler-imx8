require isp-imx-basler-scripts-mixin.inc

# fixes sporadic build problems due to dependency problems in cmake build
PARALLEL_MAKE = "-j 1"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://0001-VSI-Fix-VIV_VIDEO_EVENT_PASS_JSON-usage-in-V4l2Event.patch \
"
