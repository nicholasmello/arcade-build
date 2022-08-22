#!/bin/bash

TARGET=/mnt
BUILD=/home/dkr/arcade/build

mkdir -p $BUILD/conf
source /home/dkr/poky-dunfell/oe-init-build-env $BUILD

if [ -f $TARGET/local.conf ]; then
  cp -f $TARGET/local.conf $BUILD/conf/local.conf
else
  cp -f /home/dkr/rpi/meta-rpi/conf/local.conf.sample $BUILD/conf/local.conf
fi

if [ -f $TARGET/bblayers.conf ]; then
  cp -f $TARGET/bblayers.conf $BUILD/conf/bblayers.conf
else
  cp -f /home/dkr/rpi/meta-rpi/conf/bblayers.conf.sample $BUILD/conf/bblayers.conf
fi

touch $BUILD/conf/sanity.conf
cd $BUILD
bitbake console-image
cp -r $BUILD/tmp/deploy/images/* $TARGET/
/bin/bash