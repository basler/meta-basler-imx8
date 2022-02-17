#!/bin/bash
#
# Start the isp_media_server with detection info
# (c) NXP 2020
# (c) Basler AG 2021
#

set -e

RUN_SCRIPT=`realpath -s $0`
RUN_SCRIPT_PATH=`dirname $RUN_SCRIPT`
echo "RUN_SCRIPT=$RUN_SCRIPT"
echo "RUN_SCRIPT_PATH=$RUN_SCRIPT_PATH"

LOAD_MODULES="0" # do not load modules, they are automatically loaded if present in /lib/modules
LOCAL_RUN="0" # search modules in /lib/modules and libraries in /opt/imx8-isp/lib

# an array with the modules to load, insertion order
declare -a MODULES=("imx8-media-dev" "vvcam-video" "vvcam-dwe" "vvcam-isp")

USAGE="Usage:\n"
USAGE+="run.sh [-isp0 <isp_config0>] [-isp1 <isp_config1>] &\n"

ISP_CONFIG_0=""
ISP_CONFIG_1=""

# setup the library path
set_libs_path () {
    local ONE_LIB="$1"
    LIB_PATH=`find $RUN_SCRIPT_PATH -name $ONE_LIB | head -1`
    if [ ! -f "$LIB_PATH" ]; then
        LIB_PATH=`find $RUN_SCRIPT_PATH/../../../usr -name $ONE_LIB | head -1`
        if [ ! -f "$LIB_PATH" ]; then
            echo "$ONE_LIB not found in $RUN_SCRIPT_PATH"
            echo "$ONE_LIB not found in $RUN_SCRIPT_PATH/../../../usr"
            exit 1
        fi
    fi
    LIB_PATH=`realpath $LIB_PATH`
    export LD_LIBRARY_PATH=`dirname $LIB_PATH`:/usr/lib:$LD_LIBRARY_PATH
    echo "LD_LIBRARY_PATH set to $LD_LIBRARY_PATH"
}

# load kernel modules
load_module () {
    local MODULE="$1.ko"
    local MODULE_PARAMS="$2"
    
    # return directly if already loaded.
    MODULENAME=`echo $1 | sed 's/-/_/g'`
    echo $MODULENAME
    if lsmod | grep "$MODULENAME" ; then
        echo "$1 already loaded."
        return 0
    fi
    
    if [ "$LOCAL_RUN" == "1" ]; then
        MODULE_SEARCH=$RUN_SCRIPT_PATH
        MODULE_PATH=`find $MODULE_SEARCH -name $MODULE | head -1`
        if [ "$MODULE_PATH" == "" ]; then
            MODULE_SEARCH=$RUN_SCRIPT_PATH/../../../modules
            MODULE_PATH=`find $MODULE_SEARCH -name $MODULE | head -1`
            if [ "$MODULE_PATH" == "" ]; then
                echo "Module $MODULE not found in $RUN_SCRIPT_PATH"
                echo "Module $MODULE not found in $MODULE_SEARCH"
                exit 1
            fi
        fi
        MODULE_PATH=`realpath $MODULE_PATH`
    else
        MODULE_SEARCH=/lib/modules/`uname -r`
        MODULE_PATH=`find $MODULE_SEARCH -name $MODULE | head -1`
        if [ "$MODULE_PATH" == "" ]; then
            echo "Module $MODULE not found in $MODULE_SEARCH"
            exit 1
        fi
        MODULE_PATH=`realpath $MODULE_PATH`
    fi
    insmod $MODULE_PATH $MODULE_PARAMS  || exit 1
    echo "Loaded $MODULE_PATH $MODULE_PARAMS"
}

load_modules () {
    # remove any previous instances of the modules
    n=${#MODULES_TO_REMOVE[*]}
    for (( i = n-1; i >= 0; i-- ))
    do
        echo "Removing ${MODULES_TO_REMOVE[i]}..."
        rmmod ${MODULES_TO_REMOVE[i]} &>/dev/null
        if lsmod | grep "${MODULES_TO_REMOVE[i]}" ; then
            echo "Removing ${MODULES_TO_REMOVE[i]} failed!"
            exit 1
        fi
    done

    # force unload of imx8-media-dev to 
    # workaround load order issue in 5.10 kernel
    rmmod imx8-media-dev
    
    # and now clean load the modules
    for i in "${MODULES[@]}"
    do
        echo "Loading module $i ..."
        load_module $i
    done
    
}

# parse command line arguments
while [ "$1" != "" ]; do
    case $1 in
        -isp0 )
            shift
            ISP_CONFIG_0=$1
        ;;
        -isp1 )
            shift
            ISP_CONFIG_1=$1
        ;;        
        -l | --local )
            LOCAL_RUN="1"
            # search modules and libraries near this script
            # this should work with the flat structure from VSI/Basler
            # but also with the output from make_isp_build_*.sh
        ;;
        -lm | --load-modules )
            LOAD_MODULES="1"
        ;;
        * )
            echo -e "$USAGE" >&2
            exit 1
    esac
    shift
done

# identify start configuration
if [ "$ISP_CONFIG_0" != "" ] && [ "$ISP_CONFIG_1" == "" ]; then 
    STARTMODE="CAMERA0"
    ${RUN_SCRIPT_PATH}/Sensor_${ISP_CONFIG_0}_setup.sh 0
elif [ "$ISP_CONFIG_0" == "" ] && [ "$ISP_CONFIG_1" != "" ]; then 
    STARTMODE="CAMERA1"
    ${RUN_SCRIPT_PATH}/Sensor_${ISP_CONFIG_1}_setup.sh 1
elif [ "$ISP_CONFIG_0" != "" ] && [ "$ISP_CONFIG_1" != "" ]; then
    STARTMODE="DUAL_CAMERA"
    ${RUN_SCRIPT_PATH}/Sensor_${ISP_CONFIG_0}_setup.sh 0
    ${RUN_SCRIPT_PATH}/Sensor_${ISP_CONFIG_1}_setup.sh 1
else
    echo "invalid isp config"
    exit 1
fi

echo "Apply configuration $ISP_CONFIG_0 $ISP_CONFIG_1..."

MODULES=("basler-camera-driver-vvcam" "${MODULES[@]}")

if pgrep -f isp_media_server
then
	PIDS_TO_KILL=`pgrep -f isp_media_server`
    echo "Killing preexisting instances of isp_media_server:"
    echo `ps $PIDS_TO_KILL`
    while pkill -f isp_media_server
    do
        sleep 1
    done
fi

if [ "$LOAD_MODULES" == "1" ]; then
    load_modules
fi

if [ "$LOCAL_RUN" == "1" ]; then
    set_libs_path "libmedia_server.so"
fi

echo "Starting isp_media_server with configuration $STARTMODE "
cd ${RUN_SCRIPT_PATH}
./isp_media_server $STARTMODE
