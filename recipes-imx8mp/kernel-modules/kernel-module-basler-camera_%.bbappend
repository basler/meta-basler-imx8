
# In case of imx8mplus we need a special modprobe.d config.
RDEPENDS:${PN}:append:mx8mp-nxp-bsp="imx8mp-modprobe-config"
