
# In case of imx8mplus we need a special modprobe.d config.
RDEPENDS:${PN}:append:mx8mp="imx8mp-modprobe-config"
