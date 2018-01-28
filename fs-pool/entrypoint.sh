#!/bin/sh

/usr/bin/mergerfs -d -o defaults,allow_other,use_ino "${DISK_MOUNTS_DIR}/*" "$POOL_MOUNTPOINT"
