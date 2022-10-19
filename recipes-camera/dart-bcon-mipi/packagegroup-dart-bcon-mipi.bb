DESCRIPTION = "Everything needed to operate the dart BCON for MIPI cameras"

inherit packagegroup

PACKAGES = "\
    packagegroup-dart-bcon-mipi \
    "

RDEPENDS:packagegroup-dart-bcon-mipi = "\
    basler-daa2500-60mci \
    basler-daa4200-30mci \
"

RDEPENDS:packagegroup-dart-bcon-mipi:append:mx8mp = "\
    basler-daa2500-60mc-vvcam \
    basler-daa3840-30mc-vvcam \
    basler-daa3840-30mc-notrigger-vvcam \
"

