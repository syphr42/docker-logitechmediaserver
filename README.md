![Build](https://github.com/syphr42/docker-logitechmediaserver/workflows/build-images/badge.svg)

# Supported tags and respective `Dockerfile` links

- [`8.3.0-beta` (*Dockerfile*)](https://github.com/syphr42/docker-logitechmediaserver/blob/master/Dockerfile)
- [`8.3.0`, `latest` (*Dockerfile*)](https://github.com/syphr42/docker-logitechmediaserver/blob/master/Dockerfile)
- [`7.9.3` (*Dockerfile*)](https://github.com/syphr42/docker-logitechmediaserver/blob/master/Dockerfile)

# What is Logitech Media Server?
Logitech Media Server is a software system for controlling physical and virtual music players (e.g. Squeezebox). For more information, click here: https://en.wikipedia.org/wiki/Logitech_Media_Server

# How to Use
When creating a container from this image, you should mount '/var/lib/squeezeboxserver' to a volume on the host (or elsewhere) to preserve configuration. You should also mount your media to the container (e.g. /data/media) so that you can select it during LMS setup.

```
docker run \
        --name logitechmediaserver \
        --publish 9000:9000/tcp \
        --publish 9090:9090/tcp \
        --publish 3483:3483/tcp \
        --publish 3483:3483/udp \
        --volume /data/lms:/var/lib/squeezeboxserver \
        --volume /data/media:/data/media \
        --detach \
        --restart always \
        syphr/logitechmediaserver
```

After starting the container based on this image, access the web app: http://localhost:9000

The command line interface is available on port 9090. TCP and UDP ports 3483 are used for streaming and discovery.

The Docker image can be found here: https://hub.docker.com/r/syphr/logitechmediaserver

# NFS

If you are using NFS to mount a directory where you will be mapping ```/var/lib/squeezeboxserver``` and the NFS export is using ```all_squash``` or ```root_squash```, you will need to override either the command or the entrypoint defined for this image. The reason is that the entrypoint script, when using the default command, will attempt to perform ```chown``` on ```/var/lib/squeezeboxserver``` with the default non-root user (squeezeboxserver) and then drop to that user. Changing ownership of a directory is not permitted via NFS with the squash options enabled and so the container will fail to start with the default configuration.

With this NFS setup, you will also need to specify the mount point as "nocopy". Without this, Docker attempts to copy the contents of the folder in the container to the mount point and then copy the permissions. This fails for the same reason as above.

```
docker run \
        --name logitechmediaserver \
        --publish 9000:9000/tcp \
        --publish 9090:9090/tcp \
        --publish 3483:3483/tcp \
        --publish 3483:3483/udp \
        --volume /data/lms:/var/lib/squeezeboxserver:nocopy \
        --volume /data/media:/data/media \
        --detach \
        --restart always \
        --entrypoint squeezeboxserver \
        syphr/logitechmediaserver
```

# Kubernetes

For the easy path to run LMS on Kubernetes, see the [Logitech Media Server Helm Chart](https://github.com/syphr42/helm/tree/main/charts/logitech-media-server). The latest version can be installed with this command:

```
helm install --repo https://syphr42.github.io/helm lms logitech-media-server
```
