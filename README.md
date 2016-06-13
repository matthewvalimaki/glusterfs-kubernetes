glusterfs-kubernetes
====================

This is based on https://github.com/sterburg/kubernetes-glusterfs-server.

## Server
The [server] shows how to run [GlusterFS] server on Kubernetes. The [all-in-one.yaml] contains 
ReplicationController, Service and ServiceAccount configuration and uses two (2) replicas. Note
that it also uses [emptyDir] as storage. While good for testing change it according to your needs.

### Prerequisites for running
For [GlusterFS] server to run inside of container you need to give it more privileges. With Kubernetes
you need to run [kubelet] and [kube-apiserver] with `--allow-privileged=true` or else [GlusterFS]
pods will not start.

### Once running
If you used [all-in-one.yaml] go into one of the containers and execute `gluster peer status`.
You should see something like this:
```
root@glusterfs-storage-tguzw:/# gluster peer status
Number of Peers: 1

Hostname: 172.16.19.4
Uuid: 501a2a66-f5f1-47d2-aba9-e5e35f68cce3
State: Peer in Cluster (Connected
```

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

[debian8.5-3.7.11]: https://github.com/matthewvalimaki/glusterfs-kubernetes/tree/master/server/debian8.5-3.7.11
[debian8.3-3.5.2]: https://github.com/matthewvalimaki/glusterfs-kubernetes/tree/master/server/debian8.3-3.5.2
[debian7.8-3.2.7]: https://github.com/matthewvalimaki/glusterfs-kubernetes/tree/master/server/debian7.8-3.2.7
