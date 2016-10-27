#!/bin/sh
set -e

if [ "$1" = 'squeezeboxserver' ]; then
    chown -R $LMS_USER .

    exec gosu $LMS_USER "$@"
fi

exec "$@"
