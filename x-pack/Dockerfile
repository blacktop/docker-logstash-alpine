FROM alpine:3.12

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk11-jre

ENV VERSION 7.10.2
ENV DOWNLOAD_URL https://artifacts.elastic.co/downloads/logstash
ENV TARBALL "${DOWNLOAD_URL}/logstash-${VERSION}-linux-x86_64.tar.gz"
ENV TARBALL_ASC "${DOWNLOAD_URL}/logstash-${VERSION}-linux-x86_64.tar.gz.asc"
ENV TARBALL_SHA "34099b34a05c6b85b1b355310bd190b606aa0bcce1cad07bf5fd98959e54f61860bdd697cca8f3cdab2d2b815bbc2a788d2e14dcac4b3d85a0d5bafd72d2b170"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk add --no-cache libzmq bash
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg1 openssl \
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
  && rm -rf /usr/share/logstash/jdk \
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

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk

ENTRYPOINT ["/logstash-entrypoint.sh"]
CMD ["-e", ""]
