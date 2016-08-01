![logstash-logo](https://raw.githubusercontent.com/blacktop/docker-logstash-alpine/master/logstash-logo.png)

docker-logstash-alpine
======================

[![CircleCI](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine.png?style=shield)](https://circleci.com/gh/blacktop/docker-elasticsearch-alpine)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/logstash.svg)](https://hub.docker.com/r/blacktop/logstash/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/logstash.svg)](https://hub.docker.com/r/blacktop/logstash/)
[![Docker Image](https://img.shields.io/badge/docker image-141.7 MB-blue.svg)](https://hub.docker.com/r/blacktop/elasticsearch/)

Alpine Linux based Logstash Docker Image

### Why?

Compare Image Sizes:  
 - official logstash = 459 MB  
 - blacktop/logstash = 254 MB

**Alpine version is 205 MB smaller !**

### Dependencies

-	[gliderlabs/alpine:3.4](https://index.docker.io/_/gliderlabs/alpine/)

### Image Tags

```bash
REPOSITORY                    TAG                 VIRTUAL SIZE
blacktop/logstash             latest              254   MB
```

### Usage

Start Logstash with commandline configuration

```
docker run -it --rm blacktop/logstash logstash -e 'input { stdin { } } output { stdout { } }'
```

Start Logstash with configuration file

```
docker run -it --rm -v "$PWD":/config-dir blacktop/logstash logstash -f /config-dir/logstash.conf
```

### Documentation

### Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-logstash-alpine/issues/new)

### Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/logstash

### CHANGELOG

See [`CHANGELOG.md`](https://github.com/blacktop/docker-elasticsearch-alpine/blob/master/CHANGELOG.md)

### Contributing

[See all contributors on GitHub](https://github.com/blacktop/docker-elasticsearch-alpine/graphs/contributors).

Please update the [CHANGELOG.md](https://github.com/blacktop/docker-elasticsearch-alpine/blob/master/CHANGELOG.md) and submit a [Pull Request on GitHub](https://help.github.com/articles/using-pull-requests/).

### License

MIT Copyright (c) 2016 **blacktop**
