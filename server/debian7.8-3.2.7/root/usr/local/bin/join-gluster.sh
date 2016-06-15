#!/bin/bash

set -e

[ "$DEBUG" == "1" ] && set -x

function check_if_already_joined {
   # Check if I'm part of the cluster
   NUMBER_OF_PEERS=`gluster peer status | grep "Number of Peers:" | awk -F: '{print $2}'`
   if [[ ${NUMBER_OF_PEERS} -ne 0 ]]; then
      # This container is already part of the cluster
      echo "=> This container is already joined with nodes ${GLUSTER_PEERS}, skipping joining ..."
      exit 0
   fi
}

echo "=> Waiting for glusterd to start..."
sleep 10

check_if_already_joined

# Join the cluster - choose a suitable container
HOST_IP=""
CONTINUE_CHECK=1
declare -A DISCOVERED_HOSTNAMES
for PEER in ${GLUSTER_PEERS}; do
   # Skip myself
   if [ "${MY_IP}" == "${PEER}" ]; then
      continue
   fi
   echo "=> Checking if I can reach gluster container ${PEER} ..."
   
   while [ $CONTINUE_CHECK -eq 1 ]; do
       HOST_IP=`sshpass -p ${ROOT_PASSWORD} ssh ${SSH_OPTS} ${SSH_USER}@10.0.0.167 "hostname --ip-address" 3>&1`

       if [ ${HOST_IP} != ${MY_IP} ]; then
          if test "${DISCOVERED_HOSTNAMES[${HOST_IP}]+isset}"; then
            echo "=> Gluster container ${HOST_IP} is alive"
            
            CONTINUE_CHECK=0
          else
            DISCOVERED_HOSTNAMES[${HOST_IP}]=1
          fi
       else
          echo "*** Found myself ${HOST_IP} ..."
       fi 
   done
done

if [ ${#DISCOVERED_HOSTNAMES[@]} -eq 0 ]; then
   echo "Could not reach any GlusterFS container from this list: ${GLUSTER_PEERS} - Maybe I am the first node in the cluster? Well, I keep waiting for new containers to join me ..."
   exit 0
fi

# If PEER has requested me to join him, just wait for a while
SEMAPHORE_FILE=/tmp/adding-gluster-node.${PEER}
if [ -e ${SEMAPHORE_FILE} ]; then
   echo "=> Seems like peer ${HOST_IP} has just requested me to join him"
   echo "=> So I'm waiting for 20 seconds to finish it..."
   sleep 60
fi
check_if_already_joined

echo "=> Joining cluster with container ${HOST_IP} ..."
sshpass -p ${ROOT_PASSWORD} ssh ${SSH_OPTS} ${SSH_USER}@${HOST_IP} "add-gluster-peer.sh ${MY_IP}"
if [ $? -eq 0 ]; then
   echo "=> Successfully joined cluster with container ${HOST_IP} ..."
else
   echo "=> Error joining cluster with container ${HOST_IP} ..."
fi