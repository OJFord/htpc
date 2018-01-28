FROM debian:jessie-slim

ENV VERSION='2.23.1'

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E007F6BD
RUN echo "deb http://ppa.launchpad.net/chazomaticus/minit/ubuntu quantal main" >/etc/apt/sources.list.d/minit.list
RUN apt update
RUN apt install -y fuse
RUN apt install -y minit
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

ADD entrypoint.sh /etc/minit/startup
ADD exitpoint.sh /etc/minit/shutdown
ENTRYPOINT ["/sbin/minit"]
STOPSIGNAL SIGINT
