SUMMARY = "Basler dart BCON for MIPI GenTL producer"
PR = "r0"

PACKAGE_FILE_NAME="${BPN}_${PV}_arm64.selfsh"

SRC_URI = "https://artifacts.baslerweb.com/artifactory/embedded-vision-public/packages/${BPN}/${PACKAGE_FILE_NAME};name=tarball \
           file://set-gentl-path.sh \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

INSANE_SKIP_${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

RDEPENDS_${PN} = "\
    kernel-module-basler-camera \
"

RRECOMMENDS_${PN} = "\
    pylon \
    python3-pypylon \
"

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
    cp -a --no-preserve=ownership ${S}/* ${D}
    # fix permissions for group and others
    find ${D} -perm 700 -exec chmod 755 {} \;
    find ${D} -perm 600 -exec chmod 644 {} \;
    
    install -D "${WORKDIR}/set-gentl-path.sh" "${D}/etc/profile.d/${BPN}.sh"
}

FILES_${PN} += "/opt/*"
FILES_${PN} += "/etc/"