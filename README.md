OpenEmbedded/Yocto layer for Basler dart BCON for Mipi cameras on the i.MX8 platform
====================================================================================

This layer contains drivers and support files to use Basler mipi cameras on an imx8

Introduction:
-------------
The following instructions help you to build yocto images. This will allow you to
stream images from a Basler dart BCON for MIPI camera ("Basler MIPI camera" for short) used with an NXP i.MX8 board.
You can save the images to an SD card and process them using the Basler pylon SDK and the pylonViewer app.

Prerequisites
-------------
Make sure you have a yocto working environment on your PC before you continue with the instructions.
The instructions here are based on NXP's user guide [i.MX_Yocto_Project_User's_Guide.pdf](https://www.nxp.com/docs/en/user-guide/IMX_YOCTO_PROJECT_USERS_GUIDE.pdf). It is continously updated by
NXP as new software versions are released, and may therefore apply to a version later than 5.15.5-1.0.0.
NXP provides further documentation for the specific release [5.15.5-1.0.0](https://www.nxp.com/webapp/Download?colCode=L5.15.5_1.0.0_LINUX_DOCS) targeted by this readme.

The user's guide includes information about how to establish the yocto working environment and details about NXP yocto builds.

The instructions assume that the hardware installation for the camera is complete and that the system is up and running.
The NXP i.MX8 board, however, is assumed to be switched off. It is also assumed that a monitor program, e.g. Tera Term, is running.

For details about hardware installation, see the Quick Install Guide Basler Add-on Camera Kit dart BCON for MIPI document (AW001568).
You can download the document free of charge from the Basler website: baslerweb.com.

Supported boards:
-----------------
This Basler Camera Enablement Package supports the following NXP i.MX8 boards:

- imx8mmevk (NXP: 8MMINILPD4-EVK)
- imx8mmddr4evk (NXP: 8MMINID4-EVK)
- imx8mpevk (NXP: 8MPLUSLPD4-EVK)
- imx8mqevk (NXP: MCIMX8M-EVKB (B Silicon))


To build a yocto image for a NXP i.MX8 board
---------------------------------------------
1.  Create a new working folder for the yocto sources and images from the Basler MIPI camera and the NXP i.MX8 board.
    ```
        $ mkdir imx-yocto-bsp
    ```

2.  Check out the NXP imx yocto Board Support Package (BSP) to the working folder and grab all sources:
    ```
        $ cd imx-yocto-bsp
        $ repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-honister -m imx-5.15.5-1.0.0.xml
        $ repo sync
    ```

3.  Add the basler meta layers
    ```
        $ cd imx-yocto-bsp/sources
        $ git clone --branch honister https://github.com/basler/meta-basler-tools.git
        $ git clone --branch honister-5.15.5-1.0.0 https://github.com/basler/meta-basler-imx8.git
    ```

4.  Set the DISTRO and MACHINE variables and do the fsl setup.
    `<machine>` can be one of imx8mmevk, imx8mmddr4evk, imx8mpevk, imx8mqevk
    ```
        $ cd imx-yocto-bsp
        $ DISTRO=fsl-imx-xwayland MACHINE=<machine> source imx-setup-release.sh -b build-xwayland-<machine>
    ```

5.  In the `imx-yocto-bsp/build-xwayland-<MACHINE>/` directory:
    Append the following lines to the `conf/bblayers.conf` file to add the required meta layers for the Basler MIPI camera:
    ```
        BBLAYERS += "${BSPDIR}/sources/meta-basler-imx8"
        BBLAYERS += "${BSPDIR}/sources/meta-basler-tools"
    ```

6.  Please read the license files in `imx-yocto-bsp/sources/meta-basler-*/licenses/`. To accept the licenses and to 
    install the required packages, append the following lines to  `imx-yocto-bsp/build-xwayland-<MACHINE>/conf/local.conf`:
    ```
        ACCEPT_BASLER_EULA = "1"
        IMAGE_INSTALL:append = "packagegroup-dart-bcon-mipi"
    ```

7.  Call bitbake to create the required image.
    Building the image can take several hours.
    For minimal testing
    ```
        $ cd imx-yocto-bsp/build-xwayland-<MACHINE>/
        $ bitbake imx-image-multimedia
    ```
    Including all machine learning support
    ```
        $ cd imx-yocto-bsp/build-xwayland-<MACHINE>/
        $ bitbake imx-image-full
    ```

8.  Enable the NXP i.MX8M Plus EVK board for SD card use.
    -   Set the SW4 switch to 0011 in order to boot from SD card.

    -   Flash SD card.
        Insert an SD card of at least 4 GB size into an SD card writer and flash according to the operating system.

        **Warning:** The commands below will execute dd as root and are able to destroy your system. You need to replace
        `/dev/sdX` with the correct device name. `lsblk` helps in finding the correct device.

        If the SD card already contains a file system, or partitions containing file systems, these may be automatically
        mounted upon insertion by your desktop environment. If this happens to be the case, you need to unmount those file systems
        prior to executing the `dd` command.

        ```
            $ cd imx-yocto-bsp/build-xwayland-<MACHINE>/
            $ bzip2 -cd tmp/deploy/images/<MACHINE>/imx-image-multimedia-<MACHINE>.tar.bz2 | sudo dd of=/dev/sdX bs=1M status=progress
            $ sync
        ```
        or if image is imx-image-full:
        ```
            $ cd imx-yocto-bsp/build-xwayland-<MACHINE>/
            $ bzip2 -cd tmp/deploy/images/<MACHINE>/imx-image-full-<MACHINE>.tar.bz2 | sudo dd of=/dev/sdX bs=1M status=progress
            $ sync
        ```

        After flashing the image to the SD card, there will be two partitions /dev/sdX1 and /dev/sdX2, the latter containing the root file system.
        Depending on the size of your SD card, there may be some unallocated space after the rootfs partition, which can be reclaimed by
        growing it using a disk partitioning tool like gparted or cfdisk. After growing the partition, make sure that the file system contained in it is also
        resized. Resizing the rootfs partition is all optional. If you are uncomfortable using those low-level tools, just leave the partition as it is.

    -   Make sure the NXP i.MX8 board is switched off.

    -   Insert the SD card into the SD card slot of the NXP i.MX8 board.

9.  -   Connect the Basler MIPI camera to the first CSI-2 port (imx8mp port #1 and/or port #2) on the NXP i.MX8 board.
        Note: The following boot sequence will proceed very quickly. You will have the opportunity to break into the startup sequence only in a three-second-window while "Hit any key to stop autoboot" appears.
        Assuming a monitor app is installed and running on the host system:
    -   Switch on the NXP i.MX8 board and stop the boot process in u-boot mode looking at the UART monitor.
    -   Set the corresponding device tree file in u-boot console before Linux is started.

        ## Available device treefile

        The correct device tree file depends on the SoC and the number and type of connected cameras.

        There are two types of Basler MIPI cameras:
        - Cameras **with integrated ISP** (usually named daA*-mci).
        - Cameras **without integrated ISP** (usually named daA*-mc).

        The following table lists all possible combinations of SoC and cameras.

        **imx8mp**

        | Device tree file name                 | Camera on CSI1                          | Camera on CSI2                        |
        | ------------------------------------- | --------------------------------------- | ------------------------------------- |
        | `imx8mp-evk-basler.dtb`               | without ISP, max 500MPix/s              | --                                    |
        | `imx8mp-evk-dual-basler.dtb`          | without ISP, max 266MPix/s, max 1080P   | without ISP, max 266MPix/s, max 1080P |
        | `imx8mp-evk-basler-mixed-isp-isi.dtb` | without ISP, max 500MPix/s              | with ISP, max width 2048 pix          |
        | `imx8mp-evk-basler-isi0.dtb`          | with ISP, max width 4096 pix            | --                                    |
        | `imx8mp-evk-basler-isi0-isi1.dtb`     | with ISP, max width 2048 pix            | with ISP, max width 2048 pix           |

        **imx8mm**

        | Device tree file name                 | Camera on CSI1               | Camera on CSI2               |
        | ------------------------------------- | ---------------------------- | ---------------------------- |
        | `imx8mm-evk-basler-camera.dtb`        | with ISP                     | -- (no second csi port)      |

        **imx8mmddr4**

        | Device tree file name                 | Camera on CSI1               | Camera on CSI2               |
        | ------------------------------------- | ---------------------------- | ---------------------------- |
        | `imx8mm-ddr4-evk-basler-camera.dtb`   | with ISP                     | -- (no second csi port)      |

        **imx8mq**

        | Device tree file name                 | Camera on CSI1               | Camera on CSI2               |
        | ------------------------------------- | ---------------------------- | ---------------------------- |
        | `imx8mq-evk-basler-camera.dtb`        | with ISP                     | with ISP                     |


        Examples:
        - daA2500-60mci connected on CSI1, no camera on CSI2: imx8mp-evk-basler-isi0.dtb
        - daA3840-30mc connected on CSI1, daA3840-30mc on CSI2: imx8mp-evk-dual-basler.dtb
          Cameras will be limited to 266MPIX/s bandwidth and 1080P resolution.

        Chose the correct device tree file from the above list:
        imx8mpevk:
        ```
            u-boot=> setenv fdtfile imx8mp-evk-basler.dtb
            u-boot=> saveenv
            u-boot=> reset
        ```

    The system is ready for use.

10. To start the Basler pylon Viewer, enter the following line in the Wayland terminal window:
    ```
        $ GENICAM_GENTL64_PATH=/opt/dart-bcon-mipi/lib /opt/pylon/bin/pylonviewer
    ```
    or use the shorthand:
    ```
        $ pylon
    ```

    Now you can operate the camera
    - Select the Basler MIPI camera.
    - Open the camera.
    - Start streaming.

----------------------------------------------------------------------

Supplementary Information
-------------------------
-   re 7. Optionally, it is possible to use the bitbake populate_sdk command to create a yocto SDK which enables 
    local cross compilation for the `<MACHINE>` target device. This can be used to develop own applications without using the yocto image build.
    ```
        $ bitbake -c populate_sdk fsl-image-validation-imx
    ```

-   remote X support: In order to establish a remote ssh -X session call on host
    ```
        $ ssh -X root@<ip-address>
        # Once the remote connection is established call
        $ GENICAM_GENTL64_PATH=/opt/dart-bcon-mipi/lib /opt/pylon6/bin/pylonviewer
    ```

-   re 10. gstreamer usage for daA2500-60mc and daA3840-30mc
    it is possible to display live video via gstreamer using:
    ```
        $ gst-launch-1.0 -v v4l2src device=/dev/video2 ! waylandsink
    ```

-   To speedup the flash process we recommend to use the bmaptool.
    The correcsponding flash commandline is:
    ```
        $ sudo bmaptool copy tmp/deploy/images/<MACHINE>/imx-image-multimedia-<MACHINE>.tar.bz2 /dev/sdX
    ```
