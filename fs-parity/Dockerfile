FROM debian:jessie-slim
RUN apt update && apt upgrade -y

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B44C294F
RUN echo 'deb http://ppa.launchpad.net/tikhonov/snapraid/ubuntu trusty main' >/etc/apt/sources.list.d/snapraid.list && apt update
RUN apt install -y smartmontools snapraid

RUN apt install -y cron python wget
RUN wget -O /snapraid-runner 'https://raw.githubusercontent.com/Chronial/snapraid-runner/92b99fbf8f37a0d31eaa744f78a9d51c6d255601/snapraid-runner.py'
RUN chmod +x /snapraid-runner
RUN echo '30 20 * * 1,6 snapraiduser /snapraid-runner -c /config/snapraid-runner.conf' > /etc/cron.d/snapraid-runner

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E007F6BD
RUN echo 'deb http://ppa.launchpad.net/chazomaticus/minit/ubuntu quantal main' >/etc/apt/sources.list.d/minit.list && apt update
RUN apt install -y minit
COPY entrypoint.sh /etc/minit/startup

ARG UID=1000
RUN useradd -M -Groot -U -u"$UID" snapraiduser
RUN mkdir -p /config && chown -R snapraiduser /config
USER "$UID"

ENTRYPOINT ["/sbin/minit"]
