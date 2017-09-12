#!/bin/sh

set -e

# Add logstash as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" = 'logstash' ]; then
	chown -R logstash: /usr/share/logstash
	chown -R logstash: /etc/logstash/conf.d/
	# chown -R logstash: /opt/logstash/patterns

	set -- su-exec logstash tini -- "$@"
fi

exec "$@"
