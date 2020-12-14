#!/bin/sh

set -e

export LS_JAVA_OPTS="-Dls.cgroup.cpuacct.path.override=/ -Dls.cgroup.cpu.path.override=/ $LS_JAVA_OPTS"

if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
  exec logstash "$@"
else
  exec "$@"
fi