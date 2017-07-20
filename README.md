# SKS OpenPGP keyserver docker on Alpine Linux [![Build Status](https://travis-ci.org/ogarcia/docker-sks.svg?branch=master)](https://travis-ci.org/ogarcia/docker-sks)

(c) 2017 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

[SKS][1] is an OpenPGP keyserver whose goal is to provide easy to deploy,
decentralized, and highly reliable synchronization. That means that a key
submitted to one SKS server will quickly be distributed to all key servers,
and even wildly out-of-date servers, or servers that experience spotty
connectivity, can fully synchronize with rest of the system.

This docker packages **SKS**, under [Alpine Linux][2], a lightweight Linux
distribution.

Visit [Docker Hub][3] to see all available tags.

[1]: https://bitbucket.org/skskeyserver/sks-keyserver/wiki/Home
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/connectical/sks/

## Run

To run this container exposing SKS and mounting a permanent volume for sks
data in `/docker/sks`, run.

```
/usr/bin/docker run --rm \
  --network host \
  --name sks \
  -e "SKS_SERVER_CONTACT=YOUR_OPENPGP_KEYID" \
  -v /docker/sks:/var/lib/sks \
  connectical/sks
```

Take note that if you dont have a valid SKS database, the server will not
run. Please, take a look to [dump documentation][4] and [SKS Readme][5] for
more info.

[4]: https://bitbucket.org/skskeyserver/sks-keyserver/wiki/KeydumpSources
[5]: https://bitbucket.org/skskeyserver/sks-keyserver/src/tip/README.md

## Executing commands

If you need execute a SKS command, for example `sks_build.sh` for buld
database, simply call docker with desired command.

```
/usr/bin/docker run -t -i --rm \
  -v /docker/sks:/var/lib/sks \
  connectical/sks sks_build.sh
```

Take note that if you pass paths to command, these paths will refer to
inside of docker.

## Configuration via docker variables

The `run.sh` script that lauchs SKS use the following environment variables
to modify the config file (you can refer to [SKS man page][6] to know more
about this settings).

| Variable | Default value |
| --- | --- |
| SKS_HOSTNAME | localhost |
| SKS_RECON_ADDR | 0.0.0.0 |
| SKS_RECON_PORT | 11370 |
| SKS_HKP_ADRESS | 0.0.0.0 |
| SKS_HKP_PORT | 11371 |
| SKS_SERVER_CONTACT |  |
| SKS_NODENAME | keys |

The config file have more options, you can edit them directly, the `run.sh`
script only touch those mentioned above.

[6]: https://manpages.debian.org/stretch/sks/sks.8.en.html

## Run with systemd

If you want run this image with systemd you can use the following unit.

```
[Unit]
Description=SKS OpenPGP keyserver container
Requires=docker.service
After=docker.service

[Service]
ExecStartPre=-/usr/bin/docker kill sks
ExecStartPre=-/usr/bin/docker rm sks
ExecStartPre=/usr/bin/docker pull connectical/sks:VERSION_TAG
ExecStart=/usr/bin/docker run \
  --network host \
  --name sks \
  -v /docker/sks:/var/lib/sks \
  -e "SKS_HOSTNAME=your.host.example.com" \
  -e "SKS_RECON_ADDR=0.0.0.0" \
  -e "SKS_RECON_PORT=11370" \
  -e "SKS_HKP_ADRESS=0.0.0.0" \
  -e "SKS_HKP_PORT=11371" \
  -e "SKS_SERVER_CONTACT=YOUR_OPENPGP_KEYID" \
  -e "SKS_NODENAME=keys" \
  connectical/sks:VERSION_TAG
ExecStop=/usr/bin/docker stop -t 2 sks
Restart=always

[Install]
WantedBy=multi-user.target
```
