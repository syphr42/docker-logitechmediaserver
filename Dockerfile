# This image creates a Logitech Media Server (formerly SlimServer or Squeezebox Server)

# When running a container created from this image, you should mount 
# /var/lib/squeezeboxserver to a volume to preserve configuration between
# executions.

# The service ports are as follows:
#	HTTP: 9000
#	 CLI: 9090

FROM buildpack-deps:curl

# install runtime dependencies
RUN apt-get update && apt-get install -y \
		libsox-fmt-all \
		libflac-dev \
		libfaad2 \
		libmad0 \
		perl \
		wget \
	--no-install-recommends && rm -r /var/lib/apt/lists/*

# copy install script into the container
COPY ./install-lms.sh .

# download and install lms package
RUN ./install-lms.sh

# set username in the environment
ENV LMS_USER squeezeboxserver

# fix permissions
RUN chown -R ${LMS_USER}:nogroup /usr/share/squeezeboxserver/

# set current directory to data dir
WORKDIR /var/lib/squeezeboxserver

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates

# install entrypoint script
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000 9090
CMD ["squeezeboxserver"]
