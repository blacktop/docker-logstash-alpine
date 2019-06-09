FROM alpine:3.9

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk8-jre su-exec

ENV VERSION 7.1.1
ENV DOWNLOAD_URL https://artifacts.elastic.co/downloads/logstash
ENV TARBALL "${DOWNLOAD_URL}/logstash-${VERSION}.tar.gz"
ENV TARBALL_ASC "${DOWNLOAD_URL}/logstash-${VERSION}.tar.gz.asc"
ENV TARBALL_SHA "11b0678342b70a8665b5143ba200edde911efb70a72eed64f22e20da91e53548bb1952f8cabdf9bff5ead89a0a83c24ab0a21907b5117973fdd298c660cdbbcb"
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
