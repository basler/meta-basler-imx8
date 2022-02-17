#!/bin/sh
#
# Start the isp_media_server autodetecting the connected basler module
#
# (c) Basler AG 2021
#

set -e

BINARY_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASLER_DEVICES=$($BINARY_DIR/detect_cameras.sh)

# check if the basler device are enabled in the device tree
if [[ $(echo $BASLER_DEVICES | wc -l) -ge 1 ]]; then

    echo "Starting isp_media_server"

    RUN_ARGS=""
    for dev in $BASLER_DEVICES; do

        IFS=':' read -a dev_info <<< "$dev"
        # check that the driver config is available
        # to filter out external ISP cameras
        if [[ -f  "${BINARY_DIR}/Sensor_${dev_info[1]}_setup.sh" ]]; then
            echo "${dev_info[1]} on ISP ${dev_info[0]}"
            RUN_ARGS+="-isp${dev_info[0]} ${dev_info[1]} "
        fi
    done

    if [[ $RUN_ARGS == "" ]]; then
        # device tree and cameras don't match. exit with code no device or address
        echo "ISP device tree not matching connected cameras, check dtb file!" >&2
        exit 6
    fi

    # create
    exec $BINARY_DIR/run.sh $RUN_ARGS -lm

else
    # no device tree found exit with code no device or address
    echo "No device tree found for Basler cameras, check dtb file!" >&2
    exit 6
fi
