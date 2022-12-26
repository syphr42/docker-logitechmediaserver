#!/usr/bin/env sh

LMS_VERSION=8.2.0

LMS_CONFIG_DIR=/tmp/lms
LMS_MUSIC_DIR=/tmp/music

podman run --rm -it \
    -p 9000:9000 \
    -p 9090:9090 \
    -p 3483:3483/tcp \
    -p 3483:3483/udp \
    -v "${LMS_CONFIG_DIR}":/var/lib/squeezeboxserver \
    -v "${LMS_MUSIC_DIR}":/mnt/music \
    "syphr/logitechmediaserver:${LMS_VERSION}"
