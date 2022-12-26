#!/usr/bin/env sh

LMS_HOST="${1}"
SL_AUDIO_DEVICE=default:CARD=Generic
SL_NAME=tester

podman run --rm -it --device /dev/snd \
    -e SQUEEZELITE_SERVER_PORT="${LMS_HOST}" \
    -e SQUEEZELITE_AUDIO_DEVICE="${SL_AUDIO_DEVICE}" \
    -e SQUEEZELITE_NAME="${SL_NAME}" \
    giof71/squeezelite
