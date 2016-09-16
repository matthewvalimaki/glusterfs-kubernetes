#!/bin/bash

set -e 

[ "$DEBUG" == "1" ] && set -x && set +e

if [ "${ROOT_PASSWORD}" == "**ChangeMe**" -o -z "${ROOT_PASSWORD}" ]; then
   echo "*** ERROR: you need to define ROOT_PASSWORD environment variable - Exiting ..."
   exit 1
fi

if [ "${SERVICE_NAME}" == "**ChangeMe**" -o -z "${SERVICE_NAME}" ]; then
   echo "*** ERROR: you need to define SERVICE_NAME environment variable - Exiting ..."
   exit 1
fi

# Required stuff to work
sleep 8
export GLUSTER_PEERS=`dig +short ${SERVICE_NAME}`
if [ -z "${GLUSTER_PEERS}" ]; then
   echo "*** WARNING: Could not determine which containers are part of this service '${SERVICE_NAME}'."
fi
export MY_IP=`ip addr show scope global |grep inet | tail -1 | awk '{print $2}' | awk -F\/ '{print $1}'`
if [ -z "${MY_IP}" ]; then
   echo "*** ERROR: Could not determine this container's IP - Exiting ..."
   exit 1
fi

for i in `seq 1 $MAX_VOLUMES`; do
  [ ! -d ${GLUSTER_BRICK_PATH}/$i ] && mkdir ${GLUSTER_BRICK_PATH}/$i
done

echo "root:${ROOT_PASSWORD}" | chpasswd

# Prepare a shell to initialize docker environment variables for ssh
echo "#!/bin/bash" > ${GLUSTER_CONF_FLAG}
echo "ROOT_PASSWORD=\"${ROOT_PASSWORD}\"" >> ${GLUSTER_CONF_FLAG}
echo "SSH_PORT=\"${SSH_PORT}\"" >> ${GLUSTER_CONF_FLAG}
echo "SSH_USER=\"${SSH_USER}\"" >> ${GLUSTER_CONF_FLAG}
echo "SSH_OPTS=\"${SSH_OPTS}\"" >> ${GLUSTER_CONF_FLAG}
echo "GLUSTER_VOL=\"${GLUSTER_VOL}\"" >> ${GLUSTER_CONF_FLAG}
echo "GLUSTER_BRICK_PATH=\"${GLUSTER_BRICK_PATH}\"" >> ${GLUSTER_CONF_FLAG}
echo "DEBUG=\"${DEBUG}\"" >> ${GLUSTER_CONF_FLAG}
echo "MY_IP=\"${MY_IP}\"" >> ${GLUSTER_CONF_FLAG}
echo "MAX_VOLUMES=\"${MAX_VOLUMES}\"" >> ${GLUSTER_CONF_FLAG}

join-gluster.sh &
/usr/bin/supervisord