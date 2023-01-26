# Ubuntu JAMMY docker container for developers

This repository contains the "Dockerfile" that builds a development environment for C/C++/Rust developers under JAMMY docker.

> This image is designed to be used with CLION full remote mode (through SSH).
>
> You can easily add other development environments (for Python, Perl, NodeJs, Java...).

## Build the image

```bash
docker build --tag ubuntu-dev .
```

## Run a container

```bash
docker run --detach \
           --net=bridge \
           --interactive \
           --tty \
           --rm \
           --publish 2222:22/tcp \
           --publish 7777:7777/tcp \
           ubuntu-dev
```

## Connecting to the container

The OS is configured with 2 UNIX users:

| user               | password           |
|--------------------|--------------------|
| `root`             | `root`             |
| `dev`              | `dev`              |

> `dev` is "_sudoer_".

### SSH connexion using private SSK key

```bash
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 dev@localhost
```

> Make sure that the private key file has the right permission (`chmod 600 data/private.key`).
>
> You may need to clean the host SSH configuration: `ssh-keygen -f "/home/denis/.ssh/known_hosts" -R "[localhost]:2222"`

### SSH connexion using UNIX password

```bash
ssh -o IdentitiesOnly=yes -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -p 2222 dev@localhost
```

