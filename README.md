

# Build the container

```bash
docker build --tag ubuntu-dev .
```

# Run the container

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

# Connecting to the container

The OS is configured with 2 UNIX users:

| user               | password           |
|--------------------|--------------------|
| `root`             | `root`             |
| `dev`              | `dev`              |

Open a SSH connexion to the container:

```bash
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 dev@localhost
```

> Make sure that the private key file has the right permission (`chmod 600 data/private.key`).
>
> You may need to clean the host SSH configuration: `ssh-keygen -f "/home/denis/.ssh/known_hosts" -R "[localhost]:2222"`

SSH connexions using UNIX password:

```bash
ssh -o IdentitiesOnly=yes -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -p 2222 dev@localhost
```

