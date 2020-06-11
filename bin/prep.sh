#!/bin/bash

DOWNLOADS="./downloads"
WORKING="./working"
BOOT="./boot"

# Minimal image
echo 'Uncompressing minimal image'
gzip -dk $DOWNLOADS/minimal.img.xz

echo 'prep directory (ignore errors)'
rm -rf $WORKING
mkdir $WORKING

echo 'move to working directory'
mv $DOWNLOADS/minimal.img $WORKING/minimal.img

echo 'break down minimal image into 1G chunks'
cd $WORKING
split -a 1 -b 1024m minimal.img min-

echo 'set up your mac tftp server and copy the files to c2/'
# echo 'mounting minimal image'
# open minimal.img
# cd ..

# echo 'grabbing boot files'
# rm -rf $BOOT
# mkdir $BOOT

# cp /Volumes/boot/* $BOOT/

# echo 'unmount minimal image'
# umount /Volumes/boot


