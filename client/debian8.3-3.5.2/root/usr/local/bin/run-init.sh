#!/usr/bin/dumb-init /bin/sh
mkdir -p ${GLUSTER_MOUNTPOINT}
mount -t glusterfs ${GLUSTER_VOLUME_SERVER}:/${GLUSTER_VOLUMEID} ${GLUSTER_MOUNTPOINT}
sleep 5

MOUNTS=`mount | grep glusterfs`
if [ -z "${MOUNTS}" ]; then
    exit;
fi
tail -f /dev/null