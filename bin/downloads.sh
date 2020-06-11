#!/bin/bash

DEST="./downloads"

# Desktop image
curl http://de.eu.odroid.in/ubuntu_18.04lts/C2/ubuntu-18.04.3-3.16-mate-odroid-c2-20190820.img.xz --output $DEST/desktop.img.xz &
# Minimal image
curl http://de.eu.odroid.in/ubuntu_18.04lts/C2/ubuntu-18.04.3-3.16-minimal-odroid-c2-20190814.img.xz --output $DEST/minimal.img.xz &

wait
