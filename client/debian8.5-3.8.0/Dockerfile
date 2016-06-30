FROM debian:7.8

ENV GLUSTER_MOUNTPOINT=/gluster_mount/shared0 \
    GLUSTERFS_VERSION_MAJOR=3.8 \
    GLUSTERFS_VERSION_MINOR=0 \

# Add files
ADD root /

RUN \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget ca-certificates && \
    
    wget -O - https://download.gluster.org/pub/gluster/glusterfs/LATEST/rsa.pub | apt-key add - && \
    echo deb https://download.gluster.org/pub/gluster/glusterfs/${GLUSTERFS_VERSION_MAJOR}/${GLUSTERFS_VERSION_MAJOR}.${GLUSTERFS_VERSION_MINOR}/Debian/jessie/apt/ jessie main > /etc/apt/sources.list.d/gluster.list && \
    
    wget https://github.com/Yelp/dumb-init/releases/download/v1.1.1/dumb-init_1.1.1_amd64.deb && \
    dpkg -i dumb-init_1.1.1_amd64.deb && \

    apt-get remove -y wget ca-certificates && \
    apt-get autoremove -y && \
    
    chmod +x /usr/local/bin/*
    
VOLUME ["${GLUSTER_MOUNTPOINT}"]
    
CMD ["/usr/local/bin/run-init.sh"]