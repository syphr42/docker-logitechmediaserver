#!/bin/bash
set -eo pipefail
shopt -s failglob

set -x

usage() {
    echo "usage: $(basename "${0}") <version> <stable|beta>"
    exit 1
}

# Verify version was provided
lms_version=${1}
if [ -z "${lms_version}" ]; then
    echo "error: no LMS version passed to installer script"
    usage
fi

# Verify channel was provided
lms_channel=${2}
if [ -z "${lms_channel}" ]; then
    echo "error: no LMS channel passed to installer script"
    usage
fi

# Get download link
case ${lms_channel} in
    stable)
        lms_url_deb="http://downloads.slimdevices.com/LogitechMediaServer_v${lms_version}/logitechmediaserver_${lms_version}_all.deb"
        ;;
    beta)
        lms_url_link_provider="http://www.mysqueezebox.com/update/?version=${lms_version}&revision=1&geturl=1&os=deb"
        lms_url_deb=$(wget -O - "${lms_url_link_provider}")
        ;;
    *)
        echo "error: unknown channel '${lms_channel}'"
        usage
        ;;
esac

# Download and install deb
wget -O /tmp/lms.deb "${lms_url_deb}"
dpkg -i /tmp/lms.deb

# Cleanup
rm -rf /tmp/lms.deb
