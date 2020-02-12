![logstash-logo](https://raw.githubusercontent.com/blacktop/docker-logstash-alpine/master/logstash-logo.png)

# docker-logstash-alpine

[![CircleCI](https://circleci.com/gh/blacktop/docker-logstash-alpine.png?style=shield)](https://circleci.com/gh/blacktop/docker-logstash-alpine) [![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/logstash.svg)](https://hub.docker.com/r/blacktop/logstash/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/logstash.svg)](https://hub.docker.com/r/blacktop/logstash/) [![Docker Image](https://img.shields.io/badge/docker%20image-387MB-blue.svg)](https://hub.docker.com/r/blacktop/logstash/)

Alpine Linux based [Logstash](https://www.elastic.co/products/logstash) Docker Image

## Dependencies

* [alpine:3.10](https://hub.docker.com/_/alpine/)

## Image Tags

``` bash
REPOSITORY          TAG                 SIZE
blacktop/logstash   latest              387MB
blacktop/logstash   7.6                 387MB
blacktop/logstash   7.5                 388MB
blacktop/logstash   7.4                 394MB
blacktop/logstash   7.3                 392MB
blacktop/logstash   7.2                 390MB
blacktop/logstash   7.1                 390MB
blacktop/logstash   7.0                 384MB
blacktop/logstash   6.8                 393MB
blacktop/logstash   6.7                 393MB
blacktop/logstash   6.6                 389MB
blacktop/logstash   6.5                 378MB
blacktop/logstash   6.4                 349MB
blacktop/logstash   6.3                 335MB
blacktop/logstash   6.2                 337MB
blacktop/logstash   6.1                 300MB
blacktop/logstash   6.0                 285MB
blacktop/logstash   5.6                 278MB
blacktop/logstash   5.5                 263MB
blacktop/logstash   x-pack              384MB
blacktop/logstash   5.4                 263MB
blacktop/logstash   5.3                 289MB
blacktop/logstash   5.2                 289MB
blacktop/logstash   5.1                 289MB
blacktop/logstash   5.0                 312.2MB
blacktop/logstash   2.4                 390MB
blacktop/logstash   2.3                 255.8MB
blacktop/logstash   1.5                 253.5MB
```

## Getting Started

Start Logstash with configuration file

``` bash
$ docker run -d -v "$PWD":/config-dir blacktop/logstash logstash -f /config-dir/logstash.conf
```

Start Logstash with commandline configuration. Download [metricbeat](https://www.elastic.co/downloads/beats/metricbeat)

``` bash
$ docker run -d --name elastic -p 9200:9200 blacktop/elasticsearch
$ docker run -d --name kibana --link elastic:elasticsearch -p 5601:5601 blacktop/kibana
$ docker run -d --name logstash -p 5044:5044 --link elastic:elasticsearch blacktop/logstash \
  logstash -e 'input {
                  beats {
                    port => 5044
                  }
               }

               output {
                 elasticsearch {
                   hosts => "elasticsearch:9200"
                   manage_template => false
                   index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
                   document_type => "%{[@metadata][type]}"
                 }
               }'
$ ./scripts/import_dashboards
$ ./metricbeat -e -c metricbeat.yml
```

> Navigate to http://localhost:5601

Click on `metricbeat-*` and :star: **Set as default index**

![index](https://raw.githubusercontent.com/blacktop/docker-logstash-alpine/master/docs/index.png)

Click on **Dashboard** -> **Open** -> `Metricbeat-cpu`

![kibana](https://raw.githubusercontent.com/blacktop/docker-logstash-alpine/master/docs/kibana.png)

## Documentation

## Issues

Find a bug? Want more features? Find something missing in the documentation? Let me know! Please don't hesitate to [file an issue](https://github.com/blacktop/docker-logstash-alpine/issues/new)

## Credits

Heavily (if not entirely) influenced by https://github.com/docker-library/logstash

## License

MIT Copyright (c) 2016-2020 **blacktop**

