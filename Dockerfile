FROM ubuntu:trusty
MAINTAINER Kitpages <ops@kitpages.fr>

RUN apt-get update && \
    apt-get install -y --no-install-recommends mysql-client \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN mkdir /backup
VOLUME ["/backup"]

ADD backup-scripts/ /backup-scripts
VOLUME ["/backup-scripts"]

ENV CRON_TIME="0 0 * * *"
ENV MYSQL_DB="--all-databases"

ADD run.sh /run.sh

CMD ["/run.sh"]
