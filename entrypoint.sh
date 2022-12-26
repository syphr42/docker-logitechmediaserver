#!/bin/bash
set -eo pipefail
shopt -s failglob

if [ "${1}" = 'squeezeboxserver' ]; then
    echo "Updating file system ownership..."
    chown --recursive "${LMS_USER}:${LMS_GROUP}" /usr/share/squeezeboxserver/
    chown --recursive "${LMS_USER}:${LMS_GROUP}" /var/lib/squeezeboxserver
    chown --recursive "${LMS_USER}:${LMS_GROUP}" /var/log/squeezeboxserver

    echo "Changing user to '${LMS_USER}' and starting LMS..."
    exec gosu "${LMS_USER}" "$@"
fi

exec "$@"
