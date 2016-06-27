glusterfs-kubernetes
====================

This is based on https://github.com/sterburg/kubernetes-glusterfs-server.

## Why image for every single GlusterFS version?
Version differences can lead to unexpected and more unstable behavior. To negate negative effects of
version differences it is recommended that server and client both use exactly the same version.

## Kernel problems
Older versions of Linux Kernel contain a bug that cause aufs errors and the following error:
`dirperm1 breaks the protection by the permission bits on the lower branch`. See Docker issue [21081]
and [the fix].

## Server
The [server] shows how to run [GlusterFS] server on Kubernetes. The [all-in-one.yaml] contains 
ReplicationController, Service and ServiceAccount configuration and uses two (2) replicas. Note
that it also uses [emptyDir] as storage. While good for testing change it according to your needs.
The setup uses `dig` command and environmental variable `SERVICE_NAME` (FQDN) for autodiscovery.

### Prerequisites for running
For [GlusterFS] server to run inside of container you need to give it more privileges. With Kubernetes
you need to run [kubelet] and [kube-apiserver] with `--allow-privileged=true` or else [GlusterFS]
pods will not start.

### Once running
If you used [all-in-one.yaml] go into one of the containers and execute `gluster peer status`.
You should see something like this:
```
root@gfs-strg-d78-327-knwtu:/# gluster peer status
Number of Peers: 1

Hostname: 172.16.19.4
Uuid: 501a2a66-f5f1-47d2-aba9-e5e35f68cce3
State: Peer in Cluster (Connected
```

If you used [all-in-one.yaml] go into one of the containers and execute `gluster volume info`.
You should see something like this:
```
root@gfs-strg-d78-327-knwtu:/# gluster volume info

Volume Name: shared01
Type: Replicate
Status: Started
Number of Bricks: 2
Transport-type: tcp
Bricks:
Brick1: 172.17.0.4:/gluster_volume/1
Brick2: 172.17.0.5:/gluster_volume/1
```

### Mounting client
First create a directory where the mount will be created. The `shared01` in the example command below comes from configuration option `GLUSTER_VOL`.
Then execute the following:
```
mount -t glusterfs 172.17.0.5:/shared01 /mnt/my-path
```

### Configuration
See `all-in-one.yaml`.

|Key                |Purpose                                                       |Value             |
|:------------------|:-------------------------------------------------------------|------------------|
|SERVICE_NAME       |Used for autodiscovery. By default uses `default` namespace.  |                  |
|ROOT_PASSWORD      |Used by SSH server/client for peer joining.                   |                  |
|SSH_PORT           |Used by SSH server/client for listening/connecting to peers.  |                  |
|GLUSTER_VOLUME_TYPE|Used by [GlusterFS] to define whether to distribute or mirror.|distributed/mirror|

## Versions
|Solution          |OS        |Software   |Version|
|:-----------------|:---------|:----------|:------|
|[debian8.5-3.7.11]|Debian 8.5|[GlusterFS]|3.7.11 |
|[debian8.3-3.5.2] |Debian 8.3|[GlusterFS]|3.5.2  |
|[debian7.8-3.2.7] |Debian 7.8|[GlusterFS]|3.2.7  |

[GlusterFS]: https://www.gluster.org/
[server]: https://github.com/matthewvalimaki/glusterfs-kubernetes/tree/master/server
[all-in-one.yaml]: https://github.com/matthewvalimaki/glusterfs-kubernetes/blob/master/server/all-in-one.yaml
[emptyDir]: http://kubernetes.io/docs/user-guide/volumes/#emptydir
[kubelet]: http://kubernetes.io/docs/admin/kubelet/
[kube-apiserver]: http://kubernetes.io/docs/admin/kube-apiserver/
[21081]: https://github.com/docker/docker/issues/21081#issuecomment-214986527
[the fix]: http://www.gossamer-threads.com/lists/linux/kernel/2256803

[debian8.5-3.7.11]: https://github.com/matthewvalimaki/glusterfs-kubernetes/tree/master/server/debian8.5-3.7.11
[debian8.3-3.5.2]: https://github.com/matthewvalimaki/glusterfs-kubernetes/tree/master/server/debian8.3-3.5.2
[debian7.8-3.2.7]: https://github.com/matthewvalimaki/glusterfs-kubernetes/tree/master/server/debian7.8-3.2.7
