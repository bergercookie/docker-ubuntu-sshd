ARG version=20.04
FROM ubuntu:${version}
ARG version

RUN apt-get update
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    apt-get install -q -y --no-install-recommends \
    apt-utils \
    bash-completion \
    build-essential \
    curl \
    git \
    gnupg2 \
    libcurl4-openssl-dev \
    python3 \
    python3-pip \
    sudo \
    vim \
    wget \
    patch \
    ssh \
    tmux \
    # OpenCV
    libopencv-dev \
    libopencv-core-dev \
    opencv-data \
    # C++ Dev
    cmake \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

ARG PASSWORD
ARG USERNAME=berger
ARG UID=1000
ARG GID=1000
ARG HOME=/home/$USERNAME
ARG SSH_PORT=2022
ENV SSH_PORT=${SSH_PORT}
ENV SHELL=/bin/bash


RUN groupadd -g $GID -o $USERNAME
RUN useradd -m -u $UID -g $GID --groups sudo -p $(openssl passwd -1 $PASSWORD) $USERNAME
RUN usermod -aG sudo $USERNAME
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME
RUN cat /etc/sudoers.d/$USERNAME
RUN chsh -s /bin/bash $USER

# SSH settings
RUN sed -e 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' \
        -e 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication yes/' \
        -e 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' \
        -e 's/^#?AuthorizedKeysFile\s+.*/AuthorizedKeysFile .ssh\/authorized_keys/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN ssh-keygen -A

# As user ----------------------------------------------------------------------
USER $USERNAME
ENV USER=$USERNAME
RUN mkdir $HOME/.ssh/
RUN touch $HOME/.ssh/authorized_keys
EXPOSE ${SSH_PORT}
CMD ["sudo", "-E", "bash", "-c", "/usr/sbin/sshd -D -p $SSH_PORT"]
