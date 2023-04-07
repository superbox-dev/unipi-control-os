FROM debian:bullseye

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update && apt upgrade -y

# Default tools
RUN apt install -y --no-install-recommends apt-transport-https ca-certificates locales

# Set locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Build tools
RUN apt install -y --no-install-recommends bash bc binutils build-essential bzip2 cpio file git make ncurses-dev patch perl python3 rsync unzip wget

RUN rm -rf /var/lib/apt/lists/*

# Get buildroot
WORKDIR /build
