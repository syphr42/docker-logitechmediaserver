[![Build state](https://travis-ci.org/syphr42/docker-logitechmediaserver.svg?branch=master)](https://travis-ci.org/syphr42/docker-logitechmediaserver)

# Supported tags and respective `Dockerfile` links

-	[`7.9.0`, `latest` (*Dockerfile*)](https://github.com/syphr42/docker-logitechmediaserver/blob/master/Dockerfile)
-       [`7.9.0-armhf`, `latest-armhf` (*Dockerfile*)](https://github.com/syphr42/docker-logitechmediaserver/blob/master/Dockerfile.armhf)

# What is Logitech Media Server?
Logitech Media Server is a software system for controlling physical and virtual music players (e.g. Squeezebox). For more information, click here: https://en.wikipedia.org/wiki/Logitech_Media_Server

# How to Use
When creating a container from this image, you should mount '/var/lib/squeezeboxserver' to a volume on the host to preserve configuration. You should also mount your media to the container (e.g. /data/media) so that you can select it during LMS setup.

```
docker run \
        --name logitechmediaserver \
        -p 9000:9000/tcp \
        -p 9090:9090/tcp \
        -p 3483:3483/tcp \
        -p 3483:3483/udp \
        -v /data/lms:/var/lib/squeezeboxserver \
        -v /data/media:/data/media \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        -d \
        --restart=always \ 
        syphr/logitechmediaserver
```

After starting the container based on this image, access the web app: http://localhost:9000

The command line interface is available on port 9090. TCP and UDP ports 3483 are used for streaming and discovery.

The Docker image can be found here: https://hub.docker.com/r/syphr/logitechmediaserver
