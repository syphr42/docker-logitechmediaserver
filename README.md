[![Build state](https://travis-ci.org/syphr42/docker-logitechmediaserver.svg?branch=master)](https://travis-ci.org/syphr42/docker-logitechmediaserver)

# Supported tags and respective `Dockerfile` links

-	[`7.9.0` (*Dockerfile*)](https://github.com/syphr42/docker-logitechmediaserver/blob/master/Dockerfile)

# What is Logitech Media Server?
Logitech Media Server is a software system for controlling physical and virtual music players (e.g. Squeezebox). For more information, click here: https://en.wikipedia.org/wiki/Logitech_Media_Server

# How to Use
When creating a container from this image, you should mount '/var/lib/squeezeboxserver' to a volume on the host to preserve configuration.

```
docker run \
        --name logitechmediaserver \
	-p 9000:9000 \
	-p 9090:9090 \
        -v /opt/lms:/var/lib/squeezeboxserver \
        -d \
        --restart=always \
        syphr/logitechmediaserver
```

After starting the container based on this image, access the web app: http://host:9000

The command line interface is available on port 9090.

The Docker image can be found here: https://hub.docker.com/r/syphr/logitechmediaserver
