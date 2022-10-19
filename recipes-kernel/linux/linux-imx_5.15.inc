FILESEXTRAPATHS:prepend := "${THISDIR}/linux-imx:"

# basler patchset
SRC_URI:append = "\
    file://0001-imx8mm-imx8mq-make-sensor-controls-available-in-mx6s.patch \
    file://0002-imx8mm-imx8mq-added-SRGGB8-format-support.patch \
    file://0003-imx8mq-rxhs-settle-and-send-level-value-is-now-optin.patch \
    file://0004-imx8mm-imx8mq-increase-max-video-memory-from-64-to-1.patch \
    file://0005-imx8mm-imx8mq-imx8mp-implement-cache-invalidation-fo.patch \
    file://0006-imx8mm-imx8mq-handle-subdev-unbind.patch \
    file://0007-imx8mm-imx8mq-media-csi-Add-support-for-RAW10.patch \
    file://0008-imx8mm-imx8mq-media-mxc-mipi_csi-Add-UYVY8_2X8.patch \
    file://0009-imx8mq-media-mxc-capture-Enable-two_8bit_sensor_mode.patch \
    file://0010-imx8mm-media-mxc-Enable-dual-pixel-mode-for-YUV422.patch \
    file://0011-imx8mm-arm64-dts-imx8mm-Add-DTS-for-Basler-camera.patch \
    file://0012-imx8mm-arm64-dts-imx8mm-ddr4-Add-DTS-for-Basler-came.patch \
    file://0013-imx8mq-arm64-dts-imx8mq-Add-DTS-for-Basler-camera.patch \
    file://0014-imx8mm-arm64-dts-imx8mm-Add-DT-variants-using-one-CS.patch \
    file://0015-imx8mm-imx8mq-mxc-capture-Add-debug-event-interrupt-.patch \
    file://0016-imx8mm-imx8mq-mxc-Fix-MASK_OPTION-in-CSICR18-to-avoi.patch \
    file://0017-imx8mq-arm64-dts-imx8mq-Added-highspeed-device-tree-.patch \
    file://0018-imx8mm-imx8mq-media-mxc-change-mx6s_fmt.bpp-to-bits-.patch \
    file://0019-imx8mm-media-mxc-add-support-for-YUV420-NV12.patch \
    file://0020-imx8mp-arm64-dts-imx8mp-Add-DTS-for-Basler-camera.patch \
"
