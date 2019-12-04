FROM alpine:3.10

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre su-exec

ENV VERSION 7.5.0
ENV DOWNLOAD_URL https://artifacts.elastic.co/downloads/logstash
ENV TARBALL "${DOWNLOAD_URL}/logstash-oss-${VERSION}.tar.gz"
ENV TARBALL_ASC "${DOWNLOAD_URL}/logstash-oss-${VERSION}.tar.gz.asc"
ENV TARBALL_SHA "b7cf702efa112bf5b550a0c8927f87ebf3a8947b4325b0aeec44bdfef4c307cbdcfa3bf55a884a2fc492b4e494d4a266f96dc032d549ab39dde8dde7700c4f35"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk add --no-cache libzmq bash
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

RUN apk add --no-cache libc6-compat

ENV PATH /usr/share/logstash/bin:/sbin:$PATH
ENV LS_SETTINGS_DIR /usr/share/logstash/config
ENV LANG='en_US.UTF-8' LC_ALL='en_US.UTF-8'

RUN set -ex; \
  if [ -f "$LS_SETTINGS_DIR/log4j2.properties" ]; then \
  cp "$LS_SETTINGS_DIR/log4j2.properties" "$LS_SETTINGS_DIR/log4j2.properties.dist"; \
  truncate -s 0 "$LS_SETTINGS_DIR/log4j2.properties"; \
  fi

VOLUME ["/etc/logstash/conf.d"]

COPY config/logstash /usr/share/logstash/config/
COPY config/pipeline/default.conf /usr/share/logstash/pipeline/logstash.conf
COPY logstash-entrypoint.sh /
RUN chmod +x /logstash-entrypoint.sh

EXPOSE 9600 5044

ENTRYPOINT ["/logstash-entrypoint.sh"]
CMD ["-e", ""]
