FROM igorgajsin/openjdk:latest
MAINTAINER igor@gajsin.name

WORKDIR /gerrit
RUN apk update; apk add git nss openssh util-linux

RUN addgroup -S gerrit \
	&& adduser -S gerrit -G gerrit -s /sbin/nologin -h /gerrit
USER gerrit

ADD gerrit-2.16.7.war /gerrit/gerrit-2.16.7.war
RUN ln -s /gerrit/gerrit-2.16.7.war /gerrit/gerrit.war

RUN java -jar /gerrit/gerrit.war init --batch --install-all-plugins -d /gerrit \
	&& java -jar /gerrit/gerrit.war reindex -d /gerrit \
	&& git config --add -f /gerrit/etc/gerrit.config container.javaOptions "-Djava.security.egd=file:/dev/./urandom" \
	&& git config --file /gerrit/etc/gerrit.config auth.type HTTP \
	&& git config --file /gerrit/etc/gerrit.config auth.emailFormat '{0}@example.com'

EXPOSE 29418 8080

VOLUME ["/gerrit/git", "/gerrit/index", "/gerrit/cache", "/gerrit/db", "/gerrit/etc"]

# Start Gerrit
CMD /usr/bin/java -Xmx1024m -jar /gerrit/bin/gerrit.war daemon -d /gerrit  && tail -f /gerrit/logs/error_log
