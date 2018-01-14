FROM debian:jessie-slim

ENV VERSION='2.23.1'
RUN apt update && apt install -y fuse python3 rsync wget \
    && wget "https://github.com/trapexit/mergerfs/releases/download/${VERSION}/mergerfs_${VERSION}.debian-jessie_amd64.deb" \
    && dpkg -i mergerfs*.deb && rm mergerfs*.deb \
    && wget -O /usr/local/bin/mergerfs.balance "https://raw.githubusercontent.com/trapexit/mergerfs-tools/master/src/mergerfs.balance" \
    && chmod +x /usr/local/bin/mergerfs.balance


ARG UID=1000
RUN useradd -M -Groot -U -u"$UID" mfsuser \
    && echo 'user_allow_other' >> /etc/fuse.conf \
    && mkdir -p /mnt/pool \
    && chown -R "$UID" /mnt \
    && chmod -R u+rw /mnt

USER "$UID"
ENTRYPOINT /usr/bin/mergerfs -d -o defaults,allow_other,use_ino /mnt/data\* /mnt/pool
# may break the mountpoint on exit - run `fusermount -uz {mountpoint}` to fix:
#  "Transport endpoint is not connected"
