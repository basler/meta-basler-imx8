#!/bin/sh
# This script extends the GENICAM_GENTL64_PATH if required.
# It must be compatible to most shells out there.
D=/opt/dart-bcon-mipi/lib

case :$GENICAM_GENTL64_PATH: # notice colons around the value
    in *:$D:*) ;; # do nothing, it's there
    *)
        # prevent colons in the variable if only one part is needed
        if [ -z "$GENICAM_GENTL64_PATH" ]; then
            export GENICAM_GENTL64_PATH=$D
        else
            export GENICAM_GENTL64_PATH="$GENICAM_GENTL64_PATH:$D"
        fi
    ;;
esac