FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-VSI-Remove-unused-completion-struct-per-file-handle-.patch;patchdir=../.. \
    file://0002-VSI-Improve-slow-v4l2-event-handling.patch;patchdir=../.. \
"
