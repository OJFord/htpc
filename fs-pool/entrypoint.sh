#!/bin/sh

/usr/bin/mergerfs -d -o defaults,allow_other,use_ino /mnt/\* "$POOL_MOUNTPOINT"
