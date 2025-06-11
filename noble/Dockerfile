FROM ubuntu:noble


USER root
RUN (echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker)
RUN (echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker)
RUN (apt-get update)
RUN (apt-get install -y ssh expect)
RUN (apt-get install -y build-essential)
RUN (apt-get install -y software-properties-common)
RUN (apt-get update)
RUN (apt-get install -y wget \
                        openssl \
                        man-db \
                        git \
                        gdb \
                        manpages-dev \
                        manpages-posix \
                        manpages-posix-dev \
                        autoconf \
                        automake \
                        libtool \
                        libssl-dev \
                        libc6-dbg \
                        clang-format \
                        doxygen \
                        graphviz \
                        sudo \
                        libxml2-utils)

# -----------------------------------------------------------------
# Create and configure users.
# -----------------------------------------------------------------

USER root
RUN (useradd -rm -d /home/dev -s /bin/bash -g root -G sudo -u 2000 dev)
RUN (echo 'dev:dev' | chpasswd)
RUN (echo 'root:root' | chpasswd)

# -----------------------------------------------------------------
# Configure SSH server.
# -----------------------------------------------------------------

USER root
RUN (ssh-keygen -A; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config; \
     sed -iE 's/\s*#\s*PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config; )

USER root
RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)

# For some unknown reason, if we copy the file "/tmp/install_ssh_keys.sh" from the host to the container, from a Windows host (only), it fails.
# The workaroud is to generate the file here.
#
# See:
#
# https://stackoverflow.com/questions/75675823/docker-build-script-to-execute-does-not-exist-but-it-actually-exists-works
# and
# https://stackoverflow.com/questions/54397706/how-to-output-a-multiline-string-in-dockerfile-with-a-single-command

USER root
RUN echo '#!/bin/bash\n\
#\n\
# The set -e option instructs bash to immediately exit if any command has a\n\
# non-zero exit status. \n\
\n\
set -e\n\
\n\
if [ -z ${HOME+x} ]; then\n\
    echo "FATAL: variable HOME is NOT defined! What is wrong!";\n\
    exit 1\n\
fi\n\
\n\
# -------------------------------------------------\n\
# Configuration\n\
# -------------------------------------------------\n\
\n\
# Doc: https://www.thedigitalcatonline.com/blog/2018/04/25/rsa-keys/\n\
#\n\
# Note: the last "field" of the public key (here: "denis@lab") is is a comment, and can be \n\
#       changed or ignored at will. It is set to "user@host" by default by ssh-keygen.\n\
#       See: https://serverfault.com/questions/743548/what-significance-does-the-user-host-at-the-end-of-an-ssh-public-key-file-hold\n\
\n\
SSH_PUB_KEY=$(cat <<"EOS"\n\
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6rAizPSuknx5LH6QAHVlPBcu44/euG42MEJ2sPtC2Ht5Ln9sI7T2xZxvRYTWXCEzGv3yB16ZH3zJm5liTP+V7CmahgpfagX0gm6/3+EFaKeRNQ1Lvh0d7rVO8L1DpCOG3oP952flboy2U7SuKcNHjNo+a4NYInkz+wqjnFEERbahyBgKLsKo6fyTu9g9gSIxBorsbDud37fQ6VJ424Ub69gRELRTQbmcUhJEuLATgYHx0CZPRopEU5JSdBVq6UfkcnQ9AGTH5VdhLmLnj04NEqyhA1cNu2H5E7L/Sx7xPNGoUhzmN4Z/EhvVHqSO/YfzZnxuMcmTJfIrsVXajR/xb denis@lab\n\
EOS\n\
)\n\
declare -r SSH_PUB_KEY\n\
\n\
# Note: The private key must be store with file permission "600" (chmod 600 /path/to/file)\n\
\n\
SSH_PRIV_KEY=$(cat <<"EOS"\n\
-----BEGIN RSA PRIVATE KEY-----\n\
MIIEogIBAAKCAQEAuqwIsz0rpJ8eSx+kAB1ZTwXLuOP3rhuNjBCdrD7Qth7eS5/b\n\
CO09sWcb0WE1lwhMxr98gdemR98yZuZYkz/lewpmoYKX2oF9IJuv9/hBWinkTUNS\n\
74dHe61TvC9Q6Qjht6D/edn5W6MtlO0rinDR4zaPmuDWCJ5M/sKo5xRBEW2ocgYC\n\
i7CqOn8k7vYPYEiMQaK7Gw7nd+30OlSeNuFG+vYERC0U0G5nFISRLiwE4GB8dAmT\n\
0aKRFOSUnQVaulH5HJ0PQBkx+VXYS5i549ODRKsoQNXDbth+ROy/0se8TzRqFIc5\n\
jeGfxIb1R6kjv2H82Z8bjHJkyXyK7FV2o0f8WwIDAQABAoIBAFuLusiMGzckgaq9\n\
3aPgwMesQ/hsdC8CfCxQicLLG3f1M3dK8hQypKq3skDAt5NWErD1f439wCJHJ2Sn\n\
WpD8KQJqW2KhtO8HyeGP+IBXU1VwbfImLioh4cCZhBMp8TgXjvqLDj8n0s5J/DSp\n\
C01dftE7FLoTwWOAnqnhtQt+N1rf4eA6ZONnGGWJc58h3nZr1MbwMaME869btjXS\n\
mnD8j+BSL4dpyNVk20Lr8oLmm2DkYQpc2e4qBu0apuX6MZXU59PkXvgFNw6iZ94t\n\
6kc/q5xVunM8jdVQbdgC+1zBYvBGWO2Ecfqst+IrNf0aQClZ+q3sCgO9pIjuRIGO\n\
XYjE8WECgYEA330REFVPtPKhQU7D653m6N8NMhIDp/2qx4wuKTJfZyFQKFYbMC2s\n\
dlUMLg6yWjBhlp7T1HPgD6LcPbZhMpBLC7ne04gvniKf6BaGjJDpu8ifGnlr1XdT\n\
GcO8+mbEn9lGnRVR+i0M4BNU/ggiT3FSgOi2UFUeNR4BGRala7NdY8cCgYEA1dPi\n\
I7WhUXLM1aJh4tM3pv7B0SRkPrXg3z8sWWXRS8lyPwDz6QoBHWLr5wDRAqibIHdl\n\
sgZFWTZgf2wxNRFIjANqIV3XS/6GWbmY0PuJL9wgxdykEQ/41I4NPUBz5nGV62zE\n\
BNt5EMEh+HTT27MjHCs5dyNCZ+Ih9/gjUlf8Os0CgYA0KvuKtn9Om7xshDhTjZ5T\n\
CY4I/A+CbUIqJly4HRwL9MjDQaZDDsZNMPkQ3zleuCBvik+kLhBFVhzXAvWZWflK\n\
mW6cLhP/c9Gj2W467bDBtsj84w7620m4n+pDAS4wqgVDsbBbF50DyT9ztO5dYPSD\n\
Rs8X3WaZu5FCC/k9NLc+DQKBgAwnT+oxr6qeeNAHu8KVuMsQHdoSVHRQCCkIQTAP\n\
nnbNS2YTWsm7HNcbwUbPABJDnRWaU7hrrNNmSNPVRXK7ucDjjMu6trsGC4LcDriK\n\
I4EJ5P76DIU/wCfsrwn1OOE3QYsxEm8oPlhaceDaWxRYuT0no8uGwIaBDuc2PmO2\n\
xopdAoGAUjTmdKTaLCXTxa1bIiTTp++sG6wo9WWY0iPyK2CZg6bTt+iUKqcRVLmi\n\
oYvYkHykqCyZQOWKnSjM/Hu4LlbH88jVa/9AClALP9CupUWWJDSRkLuQgjFraPrk\n\
kTLvjpvfekRQdAIsPN9uHCEUnKtgKQKCTSwPCmE2nL1EVj7SLOw=\n\
-----END RSA PRIVATE KEY-----\n\
EOS\n\
)\n\
declare -r SSH_PRIV_KEY\n\
\n\
# -------------------------------------------------\n\
# End of configuration\n\
# -------------------------------------------------\n\
\n\
declare -r SSH_DIR="${HOME}/.ssh"\n\
\n\
# Create the ".ssh" directory if necessary.\n\
if [ ! -d "${SSH_DIR}" ]; then\n\
    echo "Create directory \"${SSH_DIR}\""\n\
    mkdir "${SSH_DIR}"\n\
    chmod 0700 "${SSH_DIR}"\n\
fi\n\
\n\
\n\
cd "${SSH_DIR}"\n\
echo "${SSH_PUB_KEY}" >> authorized_keys\n\
chmod 0444 authorized_keys\n\
cd "${HOME}"\n\
' > /tmp/install_ssh_keys.sh

RUN (chmod a+wxr /tmp/install_ssh_keys.sh)
RUN (chown dev:root /tmp/install_ssh_keys.sh)
USER dev
RUN (if [ -f /tmp/install_ssh_keys.sh ]; then echo "file exists"; else echo "failure!"; fi)
RUN (if [ -x /tmp/install_ssh_keys.sh ]; then echo "file can be executed"; else echo "failure!"; fi)
RUN (/tmp/install_ssh_keys.sh)
USER root
RUN (if [ -f /tmp/install_ssh_keys.sh ]; then echo "file exists"; else echo "failure!"; fi)
RUN (if [ -x /tmp/install_ssh_keys.sh ]; then echo "file can be executed"; else echo "failure!"; fi)
RUN (/tmp/install_ssh_keys.sh)
RUN (rm /tmp/install_ssh_keys.sh)

# -----------------------------------------------------------------
# Update CMAKE. Use "cmake --version" to check.
# The new version of "cmake" is installed under "/usr/local/bin".
# The original version will still be under "/usr/bin".
# -----------------------------------------------------------------

USER root
WORKDIR /tmp
RUN (wget https://github.com/Kitware/CMake/releases/download/v3.31.6/cmake-3.31.6.tar.gz)
RUN (tar zxvf cmake-3.31.6.tar.gz)
WORKDIR /tmp/cmake-3.31.6
RUN (./bootstrap && gmake && make install)
WORKDIR /tmp
RUN (rm -rf /tmp/cmake-3.24.3 cmake-3.31.6.tar.gz)

# -----------------------------------------------------------------
# Add packages here so we can add more without the need to
# recompile CMAKE.
# -----------------------------------------------------------------

USER root
RUN (apt-get update)
RUN (apt-get install -y zip unzip locate jq tree vim curl iputils-ping net-tools)

# Specific tools
RUN (apt clean)

# -----------------------------------------------------------------
# Install RUST compilation toolchain.
# -----------------------------------------------------------------

USER dev
RUN (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y)
ENV PATH="${PATH}:/home/dev/.cargo/bin"
RUN (rustup update)

# -----------------------------------------------------------------
# Install Valgrind
# -----------------------------------------------------------------

USER root
WORKDIR /tmp
RUN (wget https://sourceware.org/pub/valgrind/valgrind-3.20.0.tar.bz2)
RUN (bzip2 -d valgrind-3.20.0.tar.bz2)
RUN (tar -xvf valgrind-3.20.0.tar)
RUN (rm valgrind-3.20.0.tar)
WORKDIR /tmp/valgrind-3.20.0
RUN (./configure)
RUN (make && make install)
WORKDIR /tmp
RUN (rm -rf /tmp/valgrind-3.20.0)

# -----------------------------------------------------------------
# Install various Perl modules
# -----------------------------------------------------------------

USER root
RUN (export PERL_MM_USE_DEFAULT=1 && yes | cpan -i JSON)

# -----------------------------------------------------------------
# Configure the system for SSH
# Look at the SSHD startup script "/etc/init.d/ssh".
# This script prepares the environment for the SSH daemon to start.
# -----------------------------------------------------------------

USER root
RUN (mkdir /run/sshd)
RUN (chmod 0755 /run/sshd)

# -----------------------------------------------------------------
# Configure the boot
# -----------------------------------------------------------------

USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# -----------------------------------------------------------------
# Update tools and environments.
# -----------------------------------------------------------------

USER root
RUN (updatedb)

# -----------------------------------------------------------------
# Start the SSH daemon.
# -----------------------------------------------------------------

STOPSIGNAL SIGTERM
CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["/entrypoint.sh"]