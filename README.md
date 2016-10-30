![logstash-logo](https://raw.githubusercontent.com/blacktop/docker-logstash-alpine/master/logstash-logo.png)

docker-logstash-alpine
======================

[![CircleCI](https://circleci.com/gh/blacktop/docker-logstash-alpine.png?style=shield)](https://circleci.com/gh/blacktop/docker-logstash-alpine)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/logstash.svg)](https://hub.docker.com/r/blacktop/logstash/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/logstash.svg)](https://hub.docker.com/r/blacktop/logstash/)
[![Docker Image](https://img.shields.io/badge/docker image-313.3 MB-blue.svg)](https://hub.docker.com/r/blacktop/logstash/)

Alpine Linux based Logstash Docker Image

### Why?

Compare Image Sizes:  
 - official logstash = 516 MB  
 - blacktop/logstash = 313 MB

**Alpine version is 203 MB smaller !**

### Dependencies

-	[gliderlabs/alpine:3.4](https://index.docker.io/_/gliderlabs/alpine/)

### Image Tags

```bash
REPOSITORY          TAG                 SIZE
blacktop/logstash   latest              313.3 MB
blacktop/logstash   5.0                 313.3 MB
blacktop/logstash   2.4                 259.7 MB
blacktop/logstash   2.3                 258.5 MB
blacktop/logstash   1.5                 256.2 MB
```

### Getting Started

Start Logstash with commandline configuration

```bash
$ docker run -d --name elastic -p 9200:9200 blacktop/elasticsearch
$ docker run -d --link elastic:elasticsearch blacktop/logstash logstash -e 'input { stdin { } } output { elasticsearch { hosts => ["elasticsearch:9200"] } stdout { codec => rubydebug } }'
```

Start Logstash with configuration file

```bash
$ docker run -d -v "$PWD":/config-dir blacktop/logstash logstash -f /config-dir/logstash.conf
```

### Documentation

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-logstash-alpine/issues/new)

### Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/logstash

### CHANGELOG

See [`CHANGELOG.md`](https://github.com/blacktop/docker-logstash-alpine/blob/master/CHANGELOG.md)

### Contributing

[See all contributors on GitHub](https://github.com/blacktop/docker-logstash-alpine/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/blacktop/docker-logstash-alpine/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

### License

MIT Copyright (c) 2016 **blacktop**
