FROM alpine:3.7

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre su-exec

ENV VERSION 5.6.7
ENV URL "https://artifacts.elastic.co/downloads/logstash"
ENV TARBALL "$URL/logstash-${VERSION}.tar.gz"
ENV TARBALL_ASC "$URL/logstash-${VERSION}.tar.gz.asc"
ENV TARBALL_SHA "01389878e1232cff0edd983b63325a179c4134c05b72db8c195b5c18a31bc38a84e7a5f0d4a5651bf4af2c71570158e48f3ed01eb489ff51ce296a9e9e2cf733"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk add --no-cache libzmq bash libc6-compat
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
  && set -ex \
  && cd /tmp \
  && wget --progress=bar:force -O logstash.tar.gz "$TARBALL"; \
  if [ "$TARBALL_SHA" ]; then \
		echo "$TARBALL_SHA *logstash.tar.gz" | sha512sum -c -; \
	fi; \
	\
	if [ "$TARBALL_ASC" ]; then \
		wget --progress=bar:force -O logstash.tar.gz.asc "$TARBALL_ASC"; \
		export GNUPGHOME="$(mktemp -d)"; \
    ( gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
      || gpg --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" \
      || gpg --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY" ); \
		gpg --batch --verify logstash.tar.gz.asc logstash.tar.gz; \
		rm -rf "$GNUPGHOME" logstash.tar.gz.asc || true; \
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

VOLUME ["/etc/logstash/conf.d"]

COPY logstash-entrypoint.sh /

ENTRYPOINT ["/logstash-entrypoint.sh"]
CMD ["-e", ""]
