FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

ARG  SUPERVISORD_VERSION="0.6.3"
ARG  FULLNAME="Anthony Rusdi"
ARG  USERNAME="anthony"
ARG  PASSWORD="p@ssw0rd@021"

COPY supervisor.conf /etc/supervisor.conf
COPY start-xrdp-server /usr/sbin/start-xrdp-server

RUN  apt-get update && \
     apt-get dist-upgrade -y  && \
     apt-get --no-install-recommends install -y sudo \
                                                curl \
                                                xrdp \
                                                xorgxrdp \
                                                dbus-x11 \
                                                x11-apps \
                                                readline-common \
                                                bash-completion \
                                                ca-certificates \
                                                xubuntu-icon-theme \
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
     mkdir -p /home/${USERNAME} && \
     echo "${USERNAME}:x:1000:1000:${FULLNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
     echo "${USERNAME}:x:1000:" >> /etc/group && \
     echo "${USERNAME}:*:::::::" >> /etc/shadow && \
     echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
     cp -a /etc/skel/.[a-z]* /home/${USERNAME}/ && \
     chmod 0440 /etc/sudoers.d/${USERNAME} && \
     chown 1000:1000 -R /home/${USERNAME} && \
     echo ${USERNAME}:${PASSWORD} | chpasswd -c SHA512 && \
     curl -L -o /usr/sbin/supervisord https://github.com/ochinchina/supervisord/releases/download/v${SUPERVISORD_VERSION}/supervisord_${SUPERVISORD_VERSION}_linux_amd64 && \
     chmod 0755 /usr/sbin/supervisord /usr/sbin/start-xrdp-server

RUN  add-apt-repository ppa:thomas-schiex/blender && \
     apt-get update && \
     apt-get install -y blender

RUN  curl -L -o /tmp/dragondisk_1.0.5-0ubuntu_amd64.deb http://www.s3-client.com/download-amazon-s3-client/dragondisk_1.0.5-0ubuntu_amd64.deb && \
     apt install -y /tmp/dragondisk_1.0.5-0ubuntu_amd64.deb && \
     curl -L -o /tmp/rclone-v1.49.5-linux-amd64.deb https://downloads.rclone.org/v1.49.5/rclone-v1.49.5-linux-amd64.deb && \
     apt install -y /tmp/rclone-v1.49.5-linux-amd64.deb && \
     rm -fr /tmp/*
