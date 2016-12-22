FROM gliderlabs/alpine:3.4

MAINTAINER blacktop, https://github.com/blacktop

RUN apk-install openjdk8-jre tini su-exec

ENV LOGSTASH 5.0.2

RUN apk-install libzmq bash
RUN mkdir -p /usr/local/lib \
  && ln -s /usr/lib/*/libzmq.so.3 /usr/local/lib/libzmq.so
RUN apk-install -t .build-deps wget ca-certificates \
  && cd /tmp \
  && wget -O logstash-$LOGSTASH.tar.gz https://artifacts.elastic.co/downloads/logstash/logstash-$LOGSTASH.tar.gz \
  && tar -xzf logstash-$LOGSTASH.tar.gz \
  && mv logstash-$LOGSTASH /usr/share/logstash \
  && adduser -DH -s /sbin/nologin logstash \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

ENV PATH /usr/share/logstash/bin:/sbin:$PATH

# necessary for 5.0+ (overriden via "--path.settings", ignored by < 5.0)
ENV LS_SETTINGS_DIR /etc/logstash
# comment out some troublesome configuration parameters
#   path.log: logs should go to stdout
#   path.config: No config files found: /etc/logstash/conf.d/*
RUN set -ex \
  && if [ -f "$LS_SETTINGS_DIR/logstash.yml" ]; then \
  	sed -ri 's!^(path.log|path.config):!#&!g' "$LS_SETTINGS_DIR/logstash.yml"; \
  fi

VOLUME ["/etc/logstash/conf.d"]

COPY config/logstash/logstash.yml /etc/logstash/
COPY logstash-entrypoint.sh /

ENTRYPOINT ["/logstash-entrypoint.sh"]
CMD ["-e", ""]
