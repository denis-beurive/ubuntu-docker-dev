# Ubuntu JAMMY docker container for developers

This repository contains the "Dockerfile" that builds a development environment for C/C++/Rust developers under JAMMY docker.

> This image is designed to be used with CLION full remote mode (through SSH).
>
> You can easily add other development environments (for Python, Perl, NodeJs, Java...).

## Build the image

```bash
docker build --tag ubuntu-dev --progress=plain .
```

> Useful command: `docker system prune -a` (this will clean the cache).
>
> The option `--progress=plain` is useful for debugging (not mandatory).

## Run a container

Bash:

```bash
docker run --cap-add=SYS_PTRACE \
           --security-opt seccomp=unconfined \
           --detach \
           --net=bridge \
           --interactive \
           --tty \
           --rm \
           --publish 2222:22/tcp \
           --publish 7777:7777/tcp \
           ubuntu-dev
```

MSDOS:

```bash
docker run --cap-add=SYS_PTRACE ^
           --security-opt seccomp=unconfined ^
           --detach ^
           --net=bridge ^
           --interactive ^
           --tty ^
           --rm ^
           --publish 2222:22/tcp ^
           --publish 7777:7777/tcp ^
           ubuntu-dev
```

> The options `--cap-add=SYS_PTRACE` and `--security-opt seccomp=unconfined` allow you to use GDB.

## Connecting to the container

The OS is configured with 2 UNIX users:

| user               | password           | MobaXterm session                         |
|--------------------|--------------------|-------------------------------------------|
| `root`             | `root`             | [root](data/ContainerUbuntuSamyRoot.moba) |
| `dev`              | `dev`              | [dev](data/ContainerUbuntuSamyDev.moba)   |

> `dev` is "_sudoer_".

### SSH connexion using private SSH key

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

## SCP 

From the host, download a file (stored on the container):

```bash
scp -o IdentitiesOnly=yes -o IdentityFile=data/private.key -P 2222 dev@localhost:/tmp/sftp-example-download.dump /tmp/
```

# Notes for Windows

## Docker

Path to the CLI executable: `C:\Program Files\Docker\Docker`

> Must be added to the environment variable.

```
> where docker
C:\Program Files\Docker\Docker\resources\bin\docker
C:\Program Files\Docker\Docker\resources\bin\docker.exe
```

Before you can build the image, or run a container, you must start the Docker Deamon. This is done through the GUI.

# Resources

* [StackOverflow](https://stackoverflow.com/questions/75675823/docker-build-script-to-execute-does-not-exist-but-it-actually-exists-works): a workaround for a strange problem on Windows only.
* [StackOverflow](https://stackoverflow.com/questions/54397706/how-to-output-a-multiline-string-in-dockerfile-with-a-single-command): multiline string in a `Dockerfile`.
