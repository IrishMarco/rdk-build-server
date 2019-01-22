#!/bin/bash

WS_DIR=/export/workspace/

mkdir -p $WS_DIR
cd $WS_DIR
repo init -u $WS_URL -m $WS_MANIFEST -b $WS_BRANCH
repo sync -q

MACHINE=$WS_MACHINE source $WS_SETENV
bitbake $WS_TARGET
