FROM debian:jessie
MAINTAINER Kitpages <system [at] kibatic.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      supervisor \
      wget \
      mysql-client \
      cron \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

ENV DOCKER_GEN_VERSION 0.4.2
RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

RUN mkdir /backup
VOLUME ["/backup"]

ENV CRON_TIME="0 0 * * *"

ADD backup-scripts/ /backup-scripts
VOLUME ["/backup-scripts"]

ENV DOCKER_HOST unix:///tmp/docker.sock
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY config/supervisord/conf.d /etc/supervisor/conf.d
CMD ["/usr/bin/supervisord", "-n"]
