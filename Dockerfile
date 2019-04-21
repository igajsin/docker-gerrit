FROM igorgajsin/openjdk:latest
MAINTAINER igor@gajsin.name

WORKDIR /gerrit
RUN apk update; apk add git nss openssh util-linux

RUN addgroup -S gerrit \
	&& adduser -S gerrit -G gerrit -s /sbin/nologin -h /gerrit
USER gerrit

ADD gerrit-2.16.7.war /gerrit/gerrit-2.16.7.war
