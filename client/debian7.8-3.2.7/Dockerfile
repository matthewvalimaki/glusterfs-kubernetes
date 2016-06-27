FROM debian:7.8

ENV GLUSTER_MOUNTPOINT=/gluster_mount/shared0

# Add files
ADD root /

RUN \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y glusterfs-server=3.2.7-3+deb7u1 && \
    apt-get autoclean && \

    chmod +x /usr/local/bin/*
    
VOLUME ["${GLUSTER_MOUNTPOINT}"]
    
CMD /bin/bash