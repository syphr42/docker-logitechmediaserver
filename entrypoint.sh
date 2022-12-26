#!/bin/bash
set -eo pipefail
shopt -s failglob

if [ "${1}" = 'squeezeboxserver' ]; then
    echo "Updating file system ownership..."
    chown --verbose --recursive "${LMS_USER}:${LMS_GROUP}" /usr/share/squeezeboxserver/
    chown --verbose --recursive "${LMS_USER}:${LMS_GROUP}" /var/lib/squeezeboxserver
    chown --verbose --recursive "${LMS_USER}:${LMS_GROUP}" /var/log/squeezeboxserver
    exec gosu "${LMS_USER}" "$@"
fi

exec "$@"
