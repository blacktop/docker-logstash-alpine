FROM alpine:3.6

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre tini su-exec

ENV LS_VERSION 5.5.2
ENV LOGSTASH_URL "https://artifacts.elastic.co/downloads/logstash"
ENV LOGSTASH_TARBALL "$LOGSTASH_URL/logstash-${LS_VERSION}.tar.gz"
ENV LOGSTASH_TARBALL_ASC "$LOGSTASH_URL/logstash-${LS_VERSION}.tar.gz.asc"
ENV LOGSTASH_TARBALL_SHA1 "2961489ccf8bef2bf9ae6c4eaaeeeb65b2ccd109"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk add --no-cache libzmq bash
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
  && cd /tmp \
  && wget --progress=bar:force -O logstash.tar.gz "$LOGSTASH_TARBALL"; \
  if [ "$LOGSTASH_TARBALL_SHA1" ]; then \
		echo "$LOGSTASH_TARBALL_SHA1 *logstash.tar.gz" | sha1sum -c -; \
	fi; \
	\
	if [ "$LOGSTASH_TARBALL_ASC" ]; then \
		wget --progress=bar:force -O logstash.tar.gz.asc "$LOGSTASH_TARBALL_ASC"; \
		export GNUPGHOME="$(mktemp -d)"; \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY"; \
		gpg --batch --verify logstash.tar.gz.asc logstash.tar.gz; \
		rm -r "$GNUPGHOME" logstash.tar.gz.asc; \
	fi; \
  tar -xzf logstash.tar.gz \
  && mv logstash-$LS_VERSION /usr/share/logstash \
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

VOLUME ["/etc/logstash/conf.d"]

COPY logstash-entrypoint.sh /

ENTRYPOINT ["/logstash-entrypoint.sh"]
CMD ["-e", ""]
