FROM debian:7.8

ENV GLUSTER_MOUNTPOINT=/gluster_mount/shared0

# Add files
ADD root /

RUN \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y glusterfs-server=3.2.7-3+deb7u1 wget ca-certificates && \
    
    wget https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64.deb && \
    dpkg -i dumb-init_1.1.1_amd64.deb && \

    apt-get remove -y wget ca-certificates && \
    apt-get autoremove -y && \
    
    chmod +x /usr/local/bin/*
    
VOLUME ["${GLUSTER_MOUNTPOINT}"]
    
CMD ["/usr/local/bin/run-init.sh"]