FROM ubuntu:jammy


RUN (echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker)
RUN (echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker)
RUN (apt update)
RUN (apt install -y ssh expect)
RUN (apt install -y build-essential)
RUN (apt install -y software-properties-common)
RUN (apt install -y wget zip unzip openssl libssl-dev mlocate jq tree)
RUN (rm -rf /var/lib/apt/lists/*)
RUN (apt clean)

# -----------------------------------------------------------------
# Create and configure users.
# -----------------------------------------------------------------

RUN (useradd -rm -d /home/dev -s /bin/bash -g root -G sudo -u 1000 dev)
RUN (echo 'dev:dev' | chpasswd)
RUN (echo 'root:root' | chpasswd)

# -----------------------------------------------------------------
# Configure SSH server.
# -----------------------------------------------------------------

RUN (ssh-keygen -A; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config)

RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)

ADD data/install_ssh_keys.sh /tmp
RUN (chmod a+xr /tmp/install_ssh_keys.sh)

USER dev
RUN (/tmp/install_ssh_keys.sh)
USER root
RUN (/tmp/install_ssh_keys.sh)

# -----------------------------------------------------------------
# Update CMAKE. Use "cmake --version" to check.
# The new version of "cmake" is installed under "/usr/local/bin".
# The original version will still be under "/usr/bin".
# -----------------------------------------------------------------

WORKDIR /tmp
RUN (wget https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3.tar.gz)
RUN (tar zxvf cmake-3.24.3.tar.gz)
WORKDIR /tmp/cmake-3.24.3
RUN (./bootstrap && gmake && make install)
WORKDIR /tmp
RUN (rm -rf /tmp/cmake-3.24.3 cmake-3.24.3.tar.gz)

# -----------------------------------------------------------------
# Start the SSH daemon.
# -----------------------------------------------------------------

# 22 for ssh server. 7777 for gdb server.
EXPOSE 22 7777
CMD ["/usr/sbin/sshd", "-D"]

