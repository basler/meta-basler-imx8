
PACKAGE_FILE_NAME="${BPN}_${PV}_arm64.selfsh"

SRC_URI = "https://artifacts.baslerweb.com/artifactory/embedded-vision-public/packages/${BPN}/${PACKAGE_FILE_NAME}"

INSANE_SKIP:${PN} = "ldflags file-rdeps already-stripped"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

python check_basler_eula() {
    eula = d.getVar('ACCEPT_BASLER_EULA')
    pkg = d.getVar('PN')
    if eula is None:
        bb.fatal("To use '%s' you need to accept the Licenses at 'meta-basler-*/licenses'. "
                 "Please read them and in case you accept them, write: "
                 "ACCEPT_BASLER_EULA = \"1\" in your local.conf." % (pkg,))
    elif eula == '0':
        bb.fatal("To use '%s' you need to accept the Basler Licenses." % pkg)
    else:
        bb.note("Basler Licenses have been accepted for '%s'" % pkg)
}


# extract the archive in unpack instead of do_install so that the license files are available for LIC_FILE checking
python do_unpack:append() {
    bb.build.exec_func("check_basler_eula", d)

    archive_file = d.getVar('PACKAGE_FILE_NAME')
    workdir = d.getVar('WORKDIR')
    srcdir = d.getVar('S')

    bb.process.run('sh %s/%s --quiet --accept' % (workdir, archive_file), cwd=srcdir)
}


do_install[dirs] += "${D}/opt"

do_install() {
    dest_dir=${D}/opt/imx8-isp/bin
    install -d $dest_dir
    cp -a --no-preserve=ownership ${S}/opt/* ${D}/opt/
}

FILES:${PN} += "/opt/*"
FILES:${PN} += "/etc/"

COMPATIBLE_MACHINE = "mx8mp"
