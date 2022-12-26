# This image creates a Logitech Media Server (formerly SlimServer or Squeezebox Server)

# When running a container created from this image, you should mount
# /var/lib/squeezeboxserver to a volume to preserve configuration between
# executions.

# The service ports are as follows:
#	    HTTP: 9000/tcp
#	     CLI: 9090/tcp
#    Control: 3483/tcp
#  Discovery: 3483/udp

ARG ARCH=
ARG BASE_IMAGE=debian
ARG BASE_TAG=buster-slim
FROM ${ARCH}${BASE_IMAGE}:${BASE_TAG}

# install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        faad \
        flac \
        lame \
        libcrypt-openssl-rsa-perl \
        libfaad2 \
        libflac-dev \
        libio-socket-ssl-perl \
        libmad0 \
        libnet-libidn-perl \
        libnet-ssleay-perl \
        libsox-fmt-all \
        musepack-tools \
        perl \
        perl-openssl-defaults \
        sox \
        wavpack \
        wget \
 && rm -r /var/lib/apt/lists/*

# copy install script into the container
COPY ./install-lms.sh .

# lms version in the format x.y.z
ARG LMS_VERSION
# lms channel: stable or beta
ARG LMS_CHANNEL

# download and install lms package
RUN ./install-lms.sh "${LMS_VERSION}" "${LMS_CHANNEL}"

# set user/group in the environment
ENV LMS_USER squeezeboxserver
ENV LMS_GROUP nogroup

# fix permissions
RUN chown -R ${LMS_USER}:${LMS_GROUP} /usr/share/squeezeboxserver/

# set current directory to data dir
WORKDIR /var/lib/squeezeboxserver

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.16
RUN set -eux; \
# save list of currently installed packages for later so we can clean up
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends gnupg2 dirmngr; \
    rm -rf /var/lib/apt/lists/*; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
# clean up fetch dependencies
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu --version; \
    gosu nobody true

# install entrypoint script
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000/tcp 9090/tcp 3483/tcp 3483/udp
CMD ["squeezeboxserver"]
