FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="William Bright<William.Bright@imd-tec.com"
ENV LANG=en_US.UTF-8
RUN apt-get update && \
    apt-get install -y gawk wget git-core diffstat unzip texinfo \
     gcc-multilib build-essential chrpath socat cpio python3 python3-pip \
     python3-pexpect xz-utils debianutils iputils-ping python3-git \
     python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm \
     python3-subunit python3-newt mesa-common-dev zstd liblz4-tool file locales \
     p7zip-full libyaml-dev rsync curl file tmux \
     libncurses5-dev libncursesw5-dev nano

# Set GID and UID to match host user for file permission consistency
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} imdt && \
    useradd -u ${UID} -g imdt -m imdt
ENV HOME=/home/imdt
WORKDIR /home/imdt
RUN locale-gen en_US.UTF-8
RUN python3 -m pip install kas
