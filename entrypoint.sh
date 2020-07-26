#!/bin/bash
set -eo pipefail
shopt -s failglob

if [ "${1}" = 'squeezeboxserver' ]; then
    chown -R "${LMS_USER}:${LMS_GROUP}" /usr/share/squeezeboxserver/
    chown -R "${LMS_USER}:${LMS_GROUP}" .
    exec gosu "${LMS_USER}" "$@"
fi

exec "$@"
