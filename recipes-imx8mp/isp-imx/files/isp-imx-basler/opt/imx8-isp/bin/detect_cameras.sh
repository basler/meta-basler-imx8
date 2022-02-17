#! /bin/bash

# copyright Basler AG (2021)
# this script will detect Basler dart MIPI cameras on i.MX8M Plus
# precondition:
# to be called after boot without loaded kernel mode drivers

set -e

# search for all configured basler ISP cameras on the system
DEVICE_TREE_BASLER=$(grep basler-camera-vvcam /sys/firmware/devicetree/base/soc@0/*/i2c@*/*/compatible -l 2> /dev/null)

for entry in ${DEVICE_TREE_BASLER}; 
do
    DT_CAMERA_DEVICE=$(echo ${entry} | rev | cut -d "/" -f2- | rev)
    ISP=$(od ${DT_CAMERA_DEVICE}/csi_id -i --endian=big -A none | tr -d " " 2> /dev/null)
    I2C_ADDR=$(od ${DT_CAMERA_DEVICE}/reg -i --endian=big -A none | tr -d " " 2> /dev/null)
    I2C_BUS_NAME=$(echo ${DT_CAMERA_DEVICE} | sed -r "s/.*i2c@([a-fA-F0-9]+).*/\1.i2c/")
    MAX_PIXEL_FREQUENCY=$(od ${DT_CAMERA_DEVICE}/port/endpoint/max-pixel-frequency -i --endian=big -A none \
            | tr -s " " | cut -d " " -f3 | sed "s/000000//" 2> /dev/null)

    # read model name
    ## is device reachable
    if $(i2ctransfer -f -y $I2C_BUS_NAME w2@$I2C_ADDR 0x00 0x44 r8 &> /dev/null)
    then 
        BYTES_0=$(i2ctransfer -f -y $I2C_BUS_NAME w2@$I2C_ADDR 0x00 0x44 r8 )
        BYTES_1=$(i2ctransfer -f -y $I2C_BUS_NAME w2@$I2C_ADDR 0x00 0x4C r8 )
        BYTES_2=$(i2ctransfer -f -y $I2C_BUS_NAME w2@$I2C_ADDR 0x00 0x54 r8 )
        BYTES_3=$(i2ctransfer -f -y $I2C_BUS_NAME w2@$I2C_ADDR 0x00 0x5C r8 )
        DEV_MODEL_NAME=""
        for b in $BYTES_0 $BYTES_1 $BYTES_2 $BYTES_3
        do 
            if [[ $b -eq "0x00" ]]; then break ; fi
            NAME_CHARACTER=$(printf %x $b)
            DEV_MODEL_NAME+=$(printf "\x$NAME_CHARACTER")
        done
        # convert to uppercase standard notation
        DEV_MODEL_NAME=$(echo $DEV_MODEL_NAME | tr a-z A-Z | tr "-" "_")
        # isp_channel_model_name_max_pixel_frequency
        echo ${ISP}:${DEV_MODEL_NAME}_${MAX_PIXEL_FREQUENCY}
    fi

done
