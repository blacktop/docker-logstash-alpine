FROM alpine:3.6

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre su-exec

ENV VERSION 5.6.3
ENV URL "https://artifacts.elastic.co/downloads/logstash"
ENV TARBALL "$URL/logstash-${VERSION}.tar.gz"
ENV TARBALL_ASC "$URL/logstash-${VERSION}.tar.gz.asc"
ENV TARBALL_SHA "18e9ecf879f0583759977838ee94a3f03ea9655179fe0edea1fc05ef80aa7dd99ac7f63db2a2e01724b4db69a59070d5b1f52a8a316dcfc2fcce810a352daadb"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk add --no-cache libzmq bash
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
  && cd /tmp \
  && wget --progress=bar:force -O logstash.tar.gz "$TARBALL"; \
  if [ "$TARBALL_SHA" ]; then \
		echo "$TARBALL_SHA *logstash.tar.gz" | sha512sum -c -; \
	fi; \
	\
	if [ "$TARBALL_ASC" ]; then \
		wget --progress=bar:force -O logstash.tar.gz.asc "$TARBALL_ASC"; \
		export GNUPGHOME="$(mktemp -d)"; \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
		gpg --batch --verify logstash.tar.gz.asc logstash.tar.gz; \
		rm -r "$GNUPGHOME" logstash.tar.gz.asc; \
	fi; \
  tar -xzf logstash.tar.gz \
  && mv logstash-$VERSION /usr/share/logstash \
  && adduser -DH -s /sbin/nologin logstash \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

ENV PATH /usr/share/logstash/bin:/sbin:$PATH
ENV LS_SETTINGS_DIR /usr/share/logstash/config

RUN set -ex; \
  if [ -f "$LS_SETTINGS_DIR/log4j2.properties" ]; then \
    cp "$LS_SETTINGS_DIR/log4j2.properties" "$LS_SETTINGS_DIR/log4j2.properties.dist"; \
    truncate -s 0 "$LS_SETTINGS_DIR/log4j2.properties"; \
  fi

# Install X-Pack plugin
RUN logstash-plugin install x-pack

VOLUME ["/etc/logstash/conf.d"]

COPY logstash-entrypoint.sh /

ENTRYPOINT ["/logstash-entrypoint.sh"]
CMD ["-e", ""]
