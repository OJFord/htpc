FROM debian:jessie-slim

ENV VERSION='2.23.1'

RUN apt update
RUN apt install -y fuse
RUN apt install -y python3
RUN apt install -y rsync
RUN apt install -y wget
RUN wget "https://github.com/trapexit/mergerfs/releases/download/${VERSION}/mergerfs_${VERSION}.debian-jessie_amd64.deb"
RUN dpkg -i mergerfs*.deb && rm mergerfs*.deb
RUN wget -O /usr/local/bin/mergerfs.balance "https://raw.githubusercontent.com/trapexit/mergerfs-tools/master/src/mergerfs.balance"
RUN chmod +x /usr/local/bin/mergerfs.balance


ARG POOL_MOUNTPOINT
ENV POOL_MOUNTPOINT ${POOL_MOUNTPOINT:-/pool}
ARG UID=1000
RUN useradd -M -Groot -U -u"$UID" mfsuser
RUN echo 'user_allow_other' >> /etc/fuse.conf
RUN mkdir -p "$POOL_MOUNTPOINT"
RUN chown -R "$UID" /mnt
RUN chmod -R u+rw /mnt
USER "$UID"

ENTRYPOINT /usr/bin/mergerfs -d -o defaults,allow_other,use_ino /mnt/data\* "$POOL_MOUNTPOINT"
# may break the mountpoint on exit - run `fusermount -uz {mountpoint}` to fix:
#  "Transport endpoint is not connected"
