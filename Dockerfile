FROM ubuntu:18.04

ARG  SUPERVISORD_VERSION="0.6.3"
ARG  FULL_NAME="Anthony Rusdi"
ARG  USERNAME="anthony"
ARG  PASSWORD="p@ssw0rd@021"

RUN  echo "deb http://archive.ubuntu.com/ubuntu bionic main restricted universe multiverse" > /etc/apt/sources.list && \
     echo "deb http://archive.ubuntu.com/ubuntu bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
     echo "deb http://archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
     echo "deb http://security.ubuntu.com/ubuntu bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && \
     apt-get update && \
     apt-get --no-install-recommends install -y xubuntu-icon-theme && \
     apt-get --no-install-recommends install -y sudo \
                                                curl \
                                                xrdp \
                                                xorgxrdp \
                                                dbus-x11 \
                                                x11-apps \
                                                openssh-server \
                                                readline-common \
                                                bash-completion \
                                                ca-certificates \
                                                software-properties-common \
                                                firefox \
                                                xfce4 \
                                                xfce4-clipman-plugin \
                                                xfce4-cpugraph-plugin \
                                                xfce4-netload-plugin \
                                                xfce4-screenshooter \
                                                xfce4-taskmanager \
                                                xfce4-terminal \
                                                gtk2-engines-xfce \
                                                gtk3-engines-xfce && \
     mkdir -p /run/sshd && \
     mkdir -p /home/${USERNAME} && \
     echo "${USERNAME}:x:1000:1000:${FULL_NAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
     echo "${USERNAME}:x:1000:" >> /etc/group && \
     echo "${USERNAME}:*:::::::" >> /etc/shadow && \
     echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
     cp -a /etc/skel/.[a-z]* /home/${USERNAME}/ && \
     chmod 0440 /etc/sudoers.d/${USERNAME} && \
     chown 1000:1000 -R /home/${USERNAME} && \
     echo ${USERNAME}:${PASSWORD} | chpasswd -c SHA512 && \
     curl -L -o /usr/sbin/supervisord https://github.com/ochinchina/supervisord/releases/download/v${SUPERVISORD_VERSION}/supervisord_${SUPERVISORD_VERSION}_linux_amd64 && \
     chmod 0755 /usr/sbin/supervisord

RUN  add-apt-repository ppa:thomas-schiex/blender && \
     apt-get update && \
     apt-get install -y blender

COPY supervisor.conf /etc/supervisor.conf
