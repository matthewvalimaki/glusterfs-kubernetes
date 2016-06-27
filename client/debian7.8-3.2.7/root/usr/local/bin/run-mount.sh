#!/bin/bash

mount -t glusterfs ${GLUSTER_VOLUME_SERVER}:/${GLUSTER_VOLUMEID} ${GLUSTER_MOUNTPOINT}

/bin/bash