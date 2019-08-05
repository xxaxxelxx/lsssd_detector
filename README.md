# ***LSSSD | MAINTENANCER***
# Maintenance Module
# Part of Dockerized LIQUIDSOAP STREAM SILENCE DETECTOR

[xxaxxelxx/lsssd_maintenancer](https://index.docker.io/u/xxxaxxelxx/lsssd_maintenancer)

## Synopsis
This repo is the base for an [automated docker build](https://hub.docker.com/r/xxaxxelxx/lsssd_maintenancer/) and is part of a dockerized distributed stream silence detector system consisting of following elements:
* [xxaxxelxx/lsssd_maintenancer](https://github.com/xxaxxelxx/lsssd_maintenancer)

The running docker container provides a service for very special stream silence detecting purposes usable for a distributed architecture.
It presumably will not fit for you, but it is possible to tune it. If you need some additional information, please do not hesitate to ask.

This [xxaxxelxx/lsssd_maintenancer](https://hub.docker.com/r/xxaxxelxx/lsssd_maintenancer/) repo is an essential part of a complex compound used for stream silence detection.
It maintenances the core database.

### Example
```bash
$ docker run -d --name liquidsoap_MOUNTPOINT-ID --link icecast_player:icplayer --restart=always xxaxxelxx/xx_liquidsoap MOUNTPOINT-ID
```
***

## License

[MIT](https://github.com/xxaxxelxx/lsssd_maintenancer/blob/master/LICENSE.md)
