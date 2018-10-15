#!/bin/sh
set -e
rm -f /config/snapraid.conf

# Set parity disks
echo -n parity >> /config/snapraid.conf # begin line
ls /mnt/parity | xargs -I@ echo -n " /mnt/parity/@/snapraid.parity" >> /config/snapraid.conf
echo '' >> /config/snapraid.conf # end line

# Set content list disks - must have at least (1 + {no. parity disks}) many
echo content /var/snapraid/snapraid.content >> /config/snapraid.conf
ls /mnt/parity | xargs -I@ echo "content /mnt/parity/@/snapraid.content" >> /config/snapraid.conf

# Set data disks
ls /mnt/data | xargs -I@ sh -c 'echo data $(echo @ | sed s/disk/data/ -) /mnt/data/@' >> /config/snapraid.conf

# Set other options
echo nohidden >> /config/snapraid.conf
