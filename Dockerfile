# Dockerfile for Vircle 
# https://vircle.net/
# v0.1 - 2019-10-29

FROM phusion/baseimage
MAINTAINER vpubchain <vpub@vircle.net>
LABEL Name="dockerized Vircle"
LABEL Publisher="official Vircle Project"

ARG USER_ID
ARG GROUP_ID

# set enviroment
ENV USER vircle
ENV HOME /${USER}
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# set user and group
RUN groupadd -g ${GROUP_ID} ${USER} \
    && useradd -u ${USER_ID} -g ${USER} -s /bin/bash -m -d ${HOME} ${USER}

# download and unpack wallet
#ADD https://github.com/John-Tonny/vpub-desktop/releases/download/vircle/vircle-0.19.0.1-x86_64-linux-gnu.tar.gz /tmp/
COPY vircle-0.19.0.1-x86_64-linux-gnu.tar.gz /tmp/
RUN tar -xzvf /tmp/vircle-*.tar.gz -C /tmp/
RUN cp /tmp/vircle-*/bin/*  /usr/local/bin/
#RUN cp /usr/local/bin/vircle-*/bin/* /usr/local/bin
RUN rm -rf /tmp/vircle*

# set rights
RUN chmod a+x /usr/local/bin/*
RUN chown -R ${USER}:${USER} /${HOME}

EXPOSE 9090 9092

VOLUME ["${HOME}"]
WORKDIR ${HOME}
CMD ["vircled"]
