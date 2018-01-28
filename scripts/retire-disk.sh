#!/bin/sh
set -e
script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

old_disk="$1"
if ! grep "$old_disk" /etc/fstab; then
    echo "$old_disk not found in /etc/fstab, options are:"
    cut -f1 /etc/fstab
    exit 1
fi

old_mount="$(cat /etc/fstab | grep "$old_disk" | cut -f 2)"

echo "Re-mounting $old_disk so invisible to media server"
temp_mount="${script_dir}/.$(echo "$old_mount" | sed 's|/|_|g')"
umount --move "$old_mount" "$temp_mount"

echo "Removing media server's mountpoint $old_mount"
rm -r "$old_mount"

echo "Moving data off disk $old_disk"
docker-compose restart
mv "${temp_mount}/*" "${script_dir}/../media"

echo "Unmounting $old_disk"
umount "$old_disk"
rm -r "$temp_mount"

fstab_backup="./fstab.$(echo "$old_mount" | sed 's|/|_|').bak"
cp /etc/fstab "$fstab_backup"
echo "/etc/fstab backed up to $fstab_backup"

echo "Removing /etc/fstab entry"
grep -v "$old_mount" > /etc/fstab
