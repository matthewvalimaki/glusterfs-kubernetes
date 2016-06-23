FROM debian:7.8

RUN \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y glusterfs-server=3.2.7-3+deb7u1 && \
    apt-get autoclean

CMD bash