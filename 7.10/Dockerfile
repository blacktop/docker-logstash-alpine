FROM alpine:3.12

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk11-jre

ENV VERSION 7.10.2
ENV DOWNLOAD_URL https://artifacts.elastic.co/downloads/logstash
ENV TARBALL "${DOWNLOAD_URL}/logstash-oss-${VERSION}-linux-x86_64.tar.gz"
ENV TARBALL_ASC "${DOWNLOAD_URL}/logstash-oss-${VERSION}-linux-x86_64.tar.gz.asc"
ENV TARBALL_SHA "5425483a7d3ec5ba186574940031a529efa683f452f5e3e38ffd9bd07771beabdd5c54a8147ed42fe761b700ea5c294018f1efb22fa6fdcf23189f2aea314b5b"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

# Provide a non-root user to run the process.
RUN addgroup --gid 1000 logstash && \
  adduser -u 1000 -G logstash \
  -h /usr/share/logstash -H -D \
  logstash

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
  && chown --recursive logstash:logstash /usr/share/logstash/ \
  && chown -R logstash:root /usr/share/logstash \
  && chmod -R g=u /usr/share/logstash \
  && find /usr/share/logstash -type d -exec chmod g+s {} \; \
  && ln -s /usr/share/logstash /opt/logstash \
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

WORKDIR /usr/share/logstash

COPY config/logstash /usr/share/logstash/config/
COPY config/pipeline/default.conf /usr/share/logstash/pipeline/logstash.conf
COPY logstash-entrypoint.sh /
RUN chmod +x /logstash-entrypoint.sh
RUN chown --recursive logstash:root config/ pipeline/

USER 1000

EXPOSE 9600 5044

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk

ENTRYPOINT ["/logstash-entrypoint.sh"]
CMD ["-e", ""]
