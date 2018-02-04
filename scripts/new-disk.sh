#!/bin/sh
set -e
script_dir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

new_disk="$1"
type="$2"

case "$type" in
    media)
        ;;
    parity)
        ;;
    *)
        echo "Disk type (arg 2) must be one of: media, parity"
        exit 1
        ;;
esac

disk_dir="$(readlink -e "${script_dir}/../disks/${type}")"
disk_count="$(ls "$disk_dir" | wc -l)"

echo "Identifying first free disk number for type $type"
for candidate_num in $(seq 0 "$disk_count"); do
    # We have $disk_count disks, numbered from 0.
    # If they're sequentially numbered with no gaps, we can definitely use
    #   number $disk_count for our new disk.
    # If, however, one's been removed in the middle, then disk number
    #  $disk_count will be taken, and we need to find the number available.
    if [ -d "${disk_dir}/disk${candidate_num}" ]; then
        continue
    fi

    new_number="$candidate_num"
done

echo "Identified disk $new_number available for type $type"
new_label="${type}-disk$new_number"

echo "Creating partition on $new_label"
parted "$new_disk" mklabel gpt mkpart primary ext4 0% 100%

echo "Formatting $new_label"
case "$type" in
    parity)
        # Recommended SnapRAID options
        mkfs.ext4 -m 0 -T largefile4 "$new_disk"
        ;;
    *)
        # -m0: No reservation for superuser
        # -i67108864: One inode for every ~67MB (the max - idk why) of disk
        mkfs.ext4 \
            -m 0 \
            -i 67108864 \
            "$new_disk"
        ;;
esac

echo "Labelling $new_label"
e2label "$new_disk" "$new_label"

fstab_backup="./fstab.${new_label}.bak"
cp /etc/fstab "$fstab_backup"
echo "/etc/fstab backed up to $fstab_backup"

new_mount="${disk_dir}/disk$new_number"
echo "Adding $new_disk at $new_mount"
tee -a /etc/fstab <<-EOF
	# $(date)
	$new_disk	$new_mount	ext4	defaults	0 0
EOF

echo "Mounting $new_mount"
mkdir "$new_mount"
mount "$new_disk"

echo "Restoring user htpc permissions to $new_mount"
chown -R htpc:users "$new_mount"

echo "Success!"
exit 0
