# snapdump-docker
Docker container for snapdump (ZFS backup to files)

Details about snapdump can be found at it's github page here: https://github.com/omry/snapdump

# How it works.

This image is based on the jobber docker image from here: https://hub.docker.com/_/jobber.
Jobber is used to run snapdump on a periodic basis (every minute by default).

# Usage

The snapdump container requires three inputs. A snapdump configuration file, a backup directory,
and a ssh private key that can be used to access the server with the ZFS filesystem. See the
snapdump github page above for a sample snapdump config file. The ssh key must not require a
password and must be allowed to login to the ZFS server.

Here's an example docker run usage:

```
docker run -it --rm \
-v ${PWD}/backup:/mnt/backup \
-v ${PWD}/id_rsa:/home/jobberuser/.ssh/id:ro \
-v ${PWD}/snapdump.yml:/home/jobberuser/snapdump.yml:ro \
stuckj/snapdump:latest
```

And, here's an example `docker-compose.yml`:

```
version: '2'

services:
  snapdump:
    image: stuckj/snapdump:latest
    restart: unless-stopped
    volumes:
      - ./backup:/mnt/backup
      - ./id_rsa:/home/jobberuser/.ssh/id:ro
      - ./snapdump.yml:/home/jobberuser/snapdump.yml
```

# Overriding the Jobber Config

If you want a custom jobber configuration to, for example, email when snapdump completes or
fails, you can map in a complete jobber configuration file to the following location using
a volume bind mount: /home/jobberuser/.jobber. This will fully override the jobber configuration
used by this container so you might want to look at the default used and use it as a basis.
You can find it here: https://raw.githubusercontent.com/stuckj/snapdump-docker/main/jobber.yml

Here's an example of overriding the jobber.yml with a docker run command:

```
docker run -it --rm \
-v ${PWD}/backup:/mnt/backup \
-v ${PWD}/id_rsa:/home/jobberuser/.ssh/id:ro \
-v ${PWD}/snapdump.yml:/home/jobberuser/snapdump.yml:ro \
-v ${PWD}/jobber.yml:/home/jobberuser/.jobber:ro \
stuckj/snapdump:latest
```

And, here's an example `docker-compose.yml` overriding the jobber config:

```
version: '2'

services:
  snapdump:
    image: stuckj/snapdump:latest
    restart: unless-stopped
    volumes:
      - ./backup:/mnt/backup
      - ./id_rsa:/home/jobberuser/.ssh/id:ro
      - ./snapdump.yml:/home/jobberuser/snapdump.yml:ro
      - ./jobber.yml:/home/jobberuser/.jobber:ro
```
