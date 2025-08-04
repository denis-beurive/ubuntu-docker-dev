# Ubuntu JAMMY docker container for developers

This repository contains the "Dockerfile" that build a development environment for C/C++/Rust developers with Ubuntu [Jammy](jammy/Dockerfile) and [Noble](noble/Dockerfile) docker containers.

> This image is designed to be used with CLION full remote mode (through SSH).
>
> You can easily add other development environments (for Python, Perl, NodeJs, Java...).

## Build the image

```bash
docker build --tag ubuntu-dev-jammy --progress=plain .
```

or:

```bash
docker build --tag ubuntu-dev-noble --progress=plain .
```

> Useful command: `docker system prune -a` (this will clean the cache).
>
> The option `--progress=plain` is useful for debugging (not mandatory).

## Run a container

**Bash**

```bash
CONTAINER_NAME="ubuntu-dev-jammy" # or CONTAINER_NAME="ubuntu-dev-noble"
docker run --cap-add=SYS_PTRACE \
           --security-opt seccomp=unconfined \
           --detach \
           --net=bridge \
           --interactive \
           --tty \
           --rm \
           --publish 2222:22/tcp \
           --publish 7777:7777/tcp \
           --volume="/path/to/host:/path/to/container" \
           "${CONTAINER_NAME}"
```

One liner:

```bash
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --detach --net=bridge --interactive --tty --rm --publish 2222:22/tcp --volume="$(pwd):/home/dev" "${CONTAINER_NAME}"
```


**MSDOS**

```
REM or CONTAINER_NAME="ubuntu-dev-noble"
SET CONTAINER_NAME="ubuntu-dev-jammy"
docker run --cap-add=SYS_PTRACE ^
           --security-opt seccomp=unconfined ^
           --detach ^
           --net=bridge ^
           --interactive ^
           --tty ^
           --rm ^
           --publish 2222:22/tcp ^
           --publish 7777:7777/tcp ^
           --volume="/path/to/host:/path/to/container" ^
           %CONTAINER_NAME%
```

One liner:

```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined --detach --net=bridge --interactive --tty --rm --publish 2222:22/tcp --volume="%cd%:/home/dev" %CONTAINER_NAME%
```

> **Note**
>
> The options `--cap-add=SYS_PTRACE` and `--security-opt seccomp=unconfined` allow you to use GDB.
>
> See:
> * [https://docs.docker.com/engine/containers/run/#runtime-privilege-and-linux-capabilities](Runtime privilege and Linux capabilities).
> * [http://manpagesfr.free.fr/man/man2/ptrace.2.html](ptrace man page).

## Connecting to the container

The OS is configured with 2 UNIX users:

| **User**           | **Password**       | **MobaXterm session**                     | **SSH connections using the private SSH key**                                                                                             | **SSH connection using password**                                                                        |
|--------------------|--------------------|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| `root`             | `root`             | [root](data/ContainerUbuntuSamyRoot.moba) | `ssh -o StrictHostKeychecking=no -o UserKnownHostsFile=NUL -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 root@localhost` | `ssh -o UserKnownHostsFile=NUL -o StrictHostKeychecking=no -o IdentitiesOnly=yes -p 2222 root@localhost` |
| `dev`              | `dev`              | [dev](data/ContainerUbuntuSamyDev.moba)   | `ssh -o StrictHostKeychecking=no -o UserKnownHostsFile=NUL -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 dev@localhost`  | `ssh -o UserKnownHostsFile=NUL -o StrictHostKeychecking=no -o IdentitiesOnly=yes -p 2222 dev@localhost`  |

> `dev` is "_sudoer_".

> Make sure that the private key file has the right permission (`chmod 600 data/private.key`).
>
> You may need to clean the host SSH configuration:
>
> `ssh-keygen -f "%USERPROFILE%\.ssh\known_hosts" -R "[localhost]:2222"`.

## SCP 

From the host, download a file (stored on the container):

```bash
scp -o StrictHostKeychecking=no -o IdentitiesOnly=yes -o IdentityFile=data/private.key -P 2222 dev@localhost:/tmp/sftp-example-download.dump /tmp/
```

> If you don't specify the option `-o StrictHostKeychecking=no`, then you may need to clean the host SSH configuration: `ssh-keygen -f "${HOME}/.ssh/known_hosts" -R "[localhost]:2222"`

# Notes for Windows

## Docker

Path to the CLI executable: `C:\Program Files\Docker\Docker`

> Must be added to the environment variable.

```
C:> where docker
C:\Program Files\Docker\Docker\resources\bin\docker
C:\Program Files\Docker\Docker\resources\bin\docker.exe
```

Before you can build the image, or run a container, you must start the Docker Deamon. This is done through the GUI.

## Docker Desktop - Unexpected WSL error

See: [this document](https://github.com/microsoft/WSL/issues/11273)

```
C:>wsl --status
Le service ne peut pas être démarré parce qu’il est désactivé ou qu’aucun périphérique activé ne lui est associé.
Code d’erreur : Wsl/0x80070422
```

Start `CMD.EXE` as adminitrator, and then:

```
C:>sc.exe config wslservice start= demand
```

> For your information, I found that the problem arose after my antivirus (AVAST) performed a system cleanup.

# Resources

* [StackOverflow](https://stackoverflow.com/questions/75675823/docker-build-script-to-execute-does-not-exist-but-it-actually-exists-works): a workaround for a strange problem on Windows only.
* [StackOverflow](https://stackoverflow.com/questions/54397706/how-to-output-a-multiline-string-in-dockerfile-with-a-single-command): multiline string in a `Dockerfile`.
