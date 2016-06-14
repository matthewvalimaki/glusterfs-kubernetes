FROM debian:8.3

ENV GLUSTERFS_VERSION_MAJOR=3.5 \
    GLUSTERFS_VERSION_MINOR=2 \
    
    GLUSTER_VOL=vol0 \
    GLUSTER_BRICK_PATH=/gluster_volume \
    GLUSTER_CONF_FLAG=/etc/gluster.env \
    SERVICE_NAME=gluster \
    MAX_VOLUMES=1 \
    
    DEBUG=0 \
    
    SSH_PORT=2222 \
    SSH_USER=root
    
# execute this on its own as it contains references to previous call
ENV SSH_OPTS="-p ${SSH_PORT} -o ConnectTimeout=20 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Add files
ADD root /

RUN \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget supervisor openssh-server dnsutils sshpass apt-transport-https && \

    wget -O - https://download.gluster.org/pub/gluster/glusterfs/3.5/3.5.2/Debian/jessie/pub.key | apt-key add - && \
    echo deb https://download.gluster.org/pub/gluster/glusterfs/${GLUSTERFS_VERSION_MAJOR}/${GLUSTERFS_VERSION_MAJOR}.${GLUSTERFS_VERSION_MINOR}/Debian/jessie/apt jessie main > /etc/apt/sources.list.d/gluster.list && \
    
    apt-get update && \
    apt-get install -y --force-yes glusterfs-server=${GLUSTERFS_VERSION_MAJOR}.${GLUSTERFS_VERSION_MINOR}* && \
    apt-get autoclean && \
    
    mkdir -p /var/run/sshd /root/.ssh /var/log/supervisor && \
    perl -p -i -e "s/^Port .*/Port ${SSH_PORT}/g" /etc/ssh/sshd_config && \
    perl -p -i -e "s/#?PasswordAuthentication .*/PasswordAuthentication yes/g" /etc/ssh/sshd_config && \
    perl -p -i -e "s/#?PermitRootLogin .*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    grep ClientAliveInterval /etc/ssh/sshd_config >/dev/null 2>&1 || echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    
    chmod +x /usr/local/bin/*
    
VOLUME ["${GLUSTER_BRICK_PATH}"]

CMD ["/usr/local/bin/run.sh"]