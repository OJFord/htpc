FROM debian:jessie-slim

ENV VERSION='2.23.1'
RUN apt update && apt install -y fuse wget \
    && wget "https://github.com/trapexit/mergerfs/releases/download/${VERSION}/mergerfs_${VERSION}.debian-jessie_amd64.deb" \
    && dpkg -i mergerfs*.deb && rm mergerfs*.deb

ENTRYPOINT ["/usr/bin/mergerfs"]
