# U-boot Makefile seems to have a race when building in parallel (make -j):
# Creating symlink to arch include directory and building target u-boot.lds (which requires this symlink) seems to overlap sometimes, resulting in:
#  /some/path/imx8mm_evk.h:11:10: fatal error: asm/arch/imx-regs.h: No such file or directory
PARALLEL_MAKE = ""
PARALLEL_MAKEINST = ""

FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-imx:"
SRC_URI:append:imx8mq-evk = " file://0001-add-CONFIG_DEFAULT_FDT_FILE-to-imx8mq_evk-in-u-boot.patch"

# We intentionally don't use SRC_URI:append:${MACHINE} = " file://${MACHINE}-basler.cfg " here, 
# because key expansion on the left side happens at a later stage and would destroy the order of 
# a similar override in the next bbappend
SRC_URI:append:imx8mm-ddr4-evk = " file://imx8mm-ddr4-evk-basler.cfg "
SRC_URI:append:imx8mm-lpddr4-evk = " file://imx8mm-lpddr4-evk-basler.cfg "
SRC_URI:append:imx8mp-lpddr4-evk = " file://imx8mp-lpddr4-evk-basler.cfg "
SRC_URI:append:imx8mq-evk = " file://imx8mq-evk-basler.cfg "
