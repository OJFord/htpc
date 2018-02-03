#!/bin/sh
set -e
rm -f /config/snapraid.conf

# Set parity disks
ls /mnt/parity | xargs -I@ echo "parity /mnt/parity/@/snapraid.parity" >> /config/snapraid.conf

# Set content list disks - must have at least (1 + {no. parity disks}) many
echo content /var/snapraid/snapraid.content >> /config/snapraid.conf
ls /mnt/parity | xargs -I@ echo "content /mnt/parity/@/snapraid.content" >> /config/snapraid.conf

# Set data disks
ls /mnt/data | xargs -I@ echo "data ${@/disk/data} /mnt/data/@" >> /config/snapraid.conf

# Set other options
echo nohidden >> /config/snapraid.conf

# Now run the snapraid command
/sbin/my_init
