# ***LSSSD | BRIDGEHEAD***
# Bridgehead Module
# Part of Dockerized LIQUIDSOAP STREAM SILENCE DETECTOR

[xxaxxelxx/lsssd_bridgehead](https://index.docker.io/u/xxxaxxelxx/lsssd_bridgehead)

## Synopsis
This repo is part of a dockerized distributed stream silence detector system consisting of following elements:
* [xxaxxelxx/lsssd_bridgehead](https://github.com/xxaxxelxx/lsssd_bridgehead)
* [xxaxxelxx/lsssd_snmpd](https://github.com/xxaxxelxx/lsssd_snmpd)
* [xxaxxelxx/lsssd_maintenancer](https://github.com/xxaxxelxx/lsssd_maintenancer)
* [xxaxxelxx/lsssd_volumecontrol](https://github.com/xxaxxelxx/lsssd_volumecontrol)
* [xxaxxelxx/lsssd_detector](https://github.com/xxaxxelxx/lsssd_detector)

The running docker container provides a service for very special stream silence detecting purposes usable for a distributed architecture.
It presumably will not fit for you, but it is possible to tune it. If you need some additional information, please do not hesitate to ask.

This [xxaxxelxx/lsssd_bridgehead](https://github.com/xxaxxelxx/lsssd_bridgehead) repo is an essential part of a complex compound used for the stream silence detector.

The whole construction consists of two main roles.
You have to run one MASTER role and at least one DETECTOR.
The masters heart is a MariaDB database who stores all the data. The Detector runs one liquidsoap instance per detectable stream and these instances report the streams silence or Sound 
directly to the MASTERs database. The number of parallel liquidsoap instances per machine is limited by the hosts memory amount. In my case i've watched about 70 streams simultaniously on a machine equipped with 4GB RAM.

A key element of the MASTER role is the very important WATCHLIST file, who lists the streams to be guarded. You can access the WATCHLIST file via 
```docker exec -it VolumeControl bash``` or via ssh on port 65522.
You can check any streams status accessing either the MASTER via SNMP on port 65161 or via MYSQL on port 63306.

How to start:
* Log into a host.
* Install git.
* Clone the bridgehead: ```git clone https://github.com/xxaxxelxx/lsssd_bridgehead.git```
* ```cd lsssd_bridgehead```
* ```./prepare_ground.sh```
* ```./run_init_master.sh``` on the MASTER or
* ```./run_init_detector.sh``` on a DETECTOR.
You have to set some passwords, be sure they correspond on both MASTER and DETECTOR.

Attention: ./run_prune.sh cleans all to the bones. But that's not a problem.

Save your active WATCHLIST file to a secure (local) place and then you can easily prune both the master and the detector and run the ./run_init_... scripts afterwards. The whole system will be rebuilt.
Don't forget to upload your local WATCHLIST file to the MASTER afterwards.

Thats all. ;)

If you need some help do not hesitate and ask me anything (project related ;): x@axxel.net

## License

[MIT](https://github.com/xxaxxelxx/lsssd_bridgehead/blob/master/LICENSE.md)
