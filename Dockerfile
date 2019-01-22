FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ 'America/New_York'

# Upgrade the machine
# git-lfs is required and need some steps to be installed described in
# https://github.com/git-lfs/git-lfs/wiki/Installation#ubuntu
RUN apt-get update                                                                ;\
    echo 'APT::Get::Assume-Yes "true";'  > /etc/apt/apt.conf.d/90forceyes         ;\
    echo $TZ > /etc/timezone                                                      ;\
    apt-get install --no-install-recommends                                        \
                    make gcc g++ diffstat texinfo chrpath sudo unzip cpio socat    \
                    gcc-multilib git gawk build-essential autoconf libtool curl    \
                    libncurses-dev gettext gperf lib32z1 libc6-i386 g++-multilib   \
                    python-git wget locales python3-pip python3-pexpect tzdata     \
                    software-properties-common bash-completion openssh-server vim ;\
    apt-get upgrade                                                               ;\
    add-apt-repository ppa:git-core/ppa                                           ;\
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash ;\
    sudo apt-get install git-lfs                                                  ;\
    git lfs install                                                               ;\
    apt-get clean all

# Add LC
RUN locale-gen "en_US.UTF-8";  \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8  LANGUAGE=en_US.UTF-8;  \
    dpkg-reconfigure --frontend=noninteractive locales
ENV LC_ALL   en_US.UTF-8
ENV LANG     en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Get the repo tools
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /bin/repo ;\
    chmod a+x /bin/repo                                                              ;\
    mkdir -p /export ; chmod 777 /export ; chmod +t /export

# Reconfigure default shell from dash to bah
RUN cd /bin && rm sh && ln -s bash sh

# Install SSHD
# see https://docs.docker.com/engine/examples/running_ssh_service/#build-an-eg_sshd-image
RUN mkdir -p /var/run/sshd                                                                             ;\
    echo 'root:arris21' | chpasswd                                                                     ;\
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config             ;\
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

# Create user
ARG UNAME=user
ARG UID=1001
ARG GID=1001
RUN groupadd -g $GID $UNAME                                    ;\
    useradd -m -u $UID -g $GID -s /bin/bash $UNAME             ;\
    echo "$UNAME:$UNAME" | chpasswd                            ;\
    echo "$UNAME ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

WORKDIR /export

USER $UNAME
ENV USER=$UNAME

RUN git config --global user.email "user@example.com" ;\
    git config --global user.name "User Name"         ;\
    echo "machine url.com login user password password" > ~/.netrc

ADD files/start_container.sh /start_container.sh
CMD ["/start_container.sh"]

