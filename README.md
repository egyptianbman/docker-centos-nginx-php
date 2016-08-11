# docker-centos-nginx-php:7.0

This repo is hosted on Github at https://github.com/egyptianbman/docker-centos-nginx-php/

### Available tags
- php 5.5: egyptianbman/docker-centos-nginx-php:ubuntu12-5.5
- php 5.6: egyptianbman/docker-centos-nginx-php:latest
- php 7.0: egyptianbman/docker-centos-nginx-php:7.0

This repo is hosted on Github at
https://www.github.com/egyptianbman/docker-centos-nginx-php/

This container aims to be a fully-functional, highly configurable yet minimalistic.

The container is built using ansible on centos 7(:latest) running nginx and php-fpm 7.0.

A conscious effort has been made to modify as little as possible to allow the consumer full freedom to modify at will.

An example usage of this container can be found in the [example](https://github.com/egyptianbman/docker-centos-nginx-php/tree/7.0/example) directory utilizing [docker-compose](https://docs.docker.com/compose/).

#### Notes:
- Add/mount a `/docker` directory with a `start.sh` script to have it automatically picked up and executed on startup, before `supervisord` (see [example](https://github.com/egyptianbman/docker-centos-nginx-php/tree/7.0/example)).
