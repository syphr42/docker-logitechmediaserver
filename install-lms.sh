#!/bin/bash
set -eo pipefail
shopt -s failglob

set -x

# Verify version was provided
lms_version=${1}
if [ -z "${lms_version}" ]; then
    echo "error: no LMS version passed to installer script"
    exit 1
fi

# Get download link
lms_url_link_provider="http://www.mysqueezebox.com/update/?version=${lms_version}&revision=1&geturl=1&os=deb"
lms_url_deb=$(wget -O - "${lms_url_link_provider}")

# Download and install deb
wget -O /tmp/lms.deb "${lms_url_deb}"
dpkg -i /tmp/lms.deb

# Cleanup
rm -rf /tmp/lms.deb
