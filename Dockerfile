# This image creates a Logitech Media Server (formerly SlimServer or Squeezebox Server)

# When running a container created from this image, you should mount 
# /var/lib/squeezeboxserver to a volume to preserve configuration between
# executions.

# The default ports are as follows:
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
	--no-install-recommends && rm -r /var/lib/apt/lists/*

# copy install script into the container
COPY ./install-lms.sh .

# download and install lms package
RUN ./install-lms.sh

# fix permissions
RUN chown -R squeezeboxserver:nogroup /usr/share/squeezeboxserver/

# switch to pre-configured user
USER squeezeboxserver

CMD ["/usr/sbin/squeezeboxserver"]
