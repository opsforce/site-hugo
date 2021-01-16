---
title: Deploy kubernetes [Continually updating]
date: 2017-9-8
tags:
- Docker
- Kubernetes
---
## Architecture
![](https://ws3.sinaimg.cn/large/006tKfTcgy1fjj6575asqj30kj0gn3zl.jpg)

## Tutorial

### Deploy docker-engine 1.12.6 on ubuntu 16.04 xenial [all node]
``` bash
$ sudo apt-get update
$ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
$ sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
$ sudo apt-get update
$ sudo apt-cache policy docker-engine # find docker-engine version you need to install
docker-engine:
  Installed: (none)
  Candidate: 17.05.0~ce-0~ubuntu-xenial
  Version table:
     17.05.0~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     17.04.0~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     17.03.1~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     17.03.0~ce-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.13.1-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.13.0-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.6-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.5-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.4-0~ubuntu-xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.3-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.2-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.1-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.12.0-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.11.2-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.11.1-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages
     1.11.0-0~xenial 500
        500 https://apt.dockerproject.org/repo ubuntu-xenial/main amd64 Packages

## 如果Ubuntu为14.04,建议先装上以下两个软件包。
$ apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual

## 这里安装docker-engine 1.12.6，官方兼容版本
$ sudo apt-get -y install docker-engine=1.12.6-0~ubuntu-xenial
$ sudo systemctl restart docker && sudo systemctl enable docker && sudo systemctl status docker
$ sudo usermod -aG docker $(whoami) # 退出当前终端，docker相关命令才能生效
```

<!-- more -->

### Deploy kubernetes 1.6.7 on ubuntu 16.04 xenial [all node]

#### prepare
``` bash
$ sudo apt-get update && sudo apt-get install -y apt-transport-https
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

$ sudo -i

# cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# apt-get update
# exit
```

#### install kubernetes
``` bash
$ sudo apt-get purge -y kubelet kubeadm kubectl kubernetes-cni # remove latest kubernetes
$ sudo apt-get -y install kubelet=1.6.7-00 kubeadm=1.6.7-00 kubectl=1.6.7-00 kubernetes-cni=0.5.1-00 socat=1.7.3.1-1 # install specific version kubernetes
$ sudo apt-get install -d --reinstall kubelet=1.6.7-00 kubeadm=1.6.7-00 kubectl=1.6.7-00 kubernetes-cni=0.5.1-00 socat=1.7.3.1-1 # download specific version kubernetes
$ sudo ls -l /var/cache/apt/archives # checkout downloaded applications packages
```

### Deploy kubernetes 1.6.7 on ubuntu 16.04 xenial [master node]

#### init kubernetes cluster
``` bash
$ sudo -i
# kubeadm init --apiserver-advertise-address <master node ip>
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
[apiclient] Created API client, waiting for the control plane to become ready
[apiclient] All control plane components are healthy after 19.392838 seconds
[apiclient] Waiting for at least one node to register
[apiclient] First node has registered after 2.006249 seconds
[token] Using token: 4d044f.b88c78b31c9fd9e4
[apiconfig] Created RBAC rules
[addons] Created essential addon: kube-proxy
[addons] Created essential addon: kube-dns

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run (as a regular user):

  cp /etc/kubernetes/admin.conf $HOME/
  chown $(id -u):$(id -g) $HOME/admin.conf
  export KUBECONFIG=$HOME/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  http://kubernetes.io/docs/admin/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join --token 4****f.****78b31****9** <master node ip>:6443
```

#### install weave network for kubernetes
``` bash
$ kubectl apply -f https://git.io/weave-kube-1.6
## 或者
$ kubectl apply -f weave-daemonset-k8s-1.6.yaml

## test DNS network
$ kubectl run curl --image=radial/busyboxplus:curl -i --tty
If you don't see a command prompt, try pressing enter.
[ root@curl-2716574283-xr8zd:/ ]$
```

### Deploy kubernetes 1.6.7 on ubuntu 16.04 xenial [minion node]

``` bash
## master node
$ sudo -i
# kubeadm token list | grep authentication,signing | awk '{prin t $1}'
4****f.****78b31****9**
```

``` bash
## minion node
$ sudo -i
# kubeadm join --token 4****f.****78b31****9** <master node ip>:6443
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
[preflight] Running pre-flight checks
[discovery] Trying to connect to API Server "172.31.10.219:6443"
[discovery] Created cluster-info discovery client, requesting info from "https://172.31.10.219:6443"
[discovery] Cluster info signature and contents are valid, will use API Server "https://172.31.10.219:6443"
[discovery] Successfully established connection with API Server "172.31.10.219:6443"
[bootstrap] Detected server version: v1.6.7
[bootstrap] The server supports the Certificates API (certificates.k8s.io/v1beta1)
[csr] Created API client to obtain unique certificate for this node, generating keys and certificate signing request
[csr] Received signed certificate from the API server, generating KubeConfig...
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"

Node join complete:
* Certificate signing request sent to master and response
  received.
* Kubelet informed of new secure connection details.

Run 'kubectl get nodes' on the master to see this machine join.
```

### Kompose Helps Developers Move Docker Compose Files to Kubernetes
[http://blog.kubernetes.io/2017/08/kompose-helps-developers-move-docker.html](http://blog.kubernetes.io/2017/08/kompose-helps-developers-move-docker.html)

### Deploy applications

[Specifying ImagePullSecrets on a Pod](https://kubernetes.io/docs/concepts/containers/images/)
Note: This approach is currently the recommended approach for GKE, GCE, and any cloud-providers where node creation is automated.
Kubernetes supports specifying registry keys on a pod.

Creating a Secret with a Docker Config,Run the following command, substituting the appropriate uppercase values:
``` bash
$ kubectl create secret docker-registry myregistrykey --docker-server=DOCKER_REGISTRY_SERVER --docker-username=DOCKER_USER --docker-password=DOCKER_PASSWORD --docker-email=DOCKER_EMAIL
secret "myregistrykey" created.

$ kubectl -n development create secret docker-registry m4g-harbor-registry --docker-server=harbor.madeforgoods.com --docker-username=docker --docker-password=****** --docker-email=**********
```

### Storage use glusterfs
```
现在ami市场启动三台centos机器
$ sudo yum update -y && sudo setenforce 0 && sudo sed -i 's|SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config && sudo systemctl disable firewalld && sudo systemctl stop firewalld


# 先安装 gluster 源
$ sudo yum install centos-release-gluster -y 
# 安装 glusterfs 组件 
$ sudo yum install -y glusterfs glusterfs-server glusterfs-fuse glusterfsrdma glusterfs-geo-replication glusterfs-devel 
## 创建 glusterfs 目录 
#$ mkdir /opt/glusterd
## 修改 glusterd 目录 
#$ sed -i 's/var\/lib/opt/g' /etc/glusterfs/glusterd.vol 
# 启动 glusterfs 
$ sudo systemctl start glusterd.service && sudo systemctl enable glusterd.service && sudo systemctl status glusterd.service


# 配置 hosts 
$ sudo vi /etc/hosts 
172.31.2.93 gfs-01
172.31.3.19 gfs-02
172.31.6.141 gfs-03
# 开放端口
$ sudo iptables -I INPUT -p tcp --dport 24007 -j ACCEPT 
# 创建存储目录 
$ sudo mkdir /data/glusterfs/data -p
# 添加节点到 集群 
# 执行操作的本机不需要probe 本机 
[root@sz-pg-oam-docker-test-001 ~]#
gluster peer probe gfs-02 
gluster peer probe gfs-03 
# 查看集群状态 
# gluster peer status 
Number of Peers: 2 
Hostname: sz-pg-oam-docker-test-002.tendcloud.com 
Uuid: f25546cc-2011-457d-ba24-342554b51317 
State: Peer in Cluster (Connected) 
Hostname: sz-pg-oam-docker-test-003.tendcloud.com 
Uuid: 42b6cad1-aa01-46d0-bbba-f7ec6821d66d 
State: Peer in Cluster (Connected)


# 创建分布卷 
# sudo gluster volume create k8s-volume transport tcp gfs-01:/data/glusterfs/data gfs-02:/data/glusterfs/data gfs-03:/data/glusterfs/data force

sudo fdisk /dev/xvdf
sudo mkfs.xfs /dev/xvdf1
sudo umount /data/glusterfs/data
sudo mount /dev/xvdf1 /data/glusterfs/data

# 查看volume状态 
# sudo gluster volume info
Volume Name: k8s-volume
Type: Distribute
Volume ID: 43358010-b01b-400a-93c9-945e3bb5dc1c
Status: Created
Snapshot Count: 0
Number of Bricks: 3
Transport-type: tcp
Bricks:
Brick1: gfs-01:/data/glusterfs/data
Brick2: gfs-02:/data/glusterfs/data
Brick3: gfs-03:/data/glusterfs/data
Options Reconfigured:
transport.address-family: inet
nfs.disable: on


# 启动 分布卷 
# sudo gluster volume start k8s-volume


# 开启 指定 volume 的配额 
$ sudo gluster volume quota k8s-volume enable 
# 限制 指定 volume 的配额 
$ sudo gluster volume quota k8s-volume limit-usage / 30GB 
# 设置 cache 大小, 默认32MB 
$ sudo gluster volume set k8s-volume performance.cache-size 500MB
# 设置 io 线程, 太大会导致进程崩溃 
$ sudo gluster volume set k8s-volume performance.io-thread-count 16 
# 设置 网络检测时间, 默认42s 
$ sudo gluster volume set k8s-volume network.ping-timeout 10 
# 设置 写缓冲区的大小, 默认1M 
$ sudo gluster volume set k8s-volume performance.write-behind-window-size 500MB


# k8s nodes
[https://packages.ubuntu.com/xenial/glusterfs-client]

sudo add-apt-repository ppa:gluster/glusterfs-3.11
sudo apt-get update -y
sudo apt-get install glusterfs-common fuse glusterfs-client -y

sudo apt-get install glusterfs-client -y
```


# Maintain && Common Commands
``` bash
$ kubectl get nodes
NAME                  STATUS    AGE       VERSION
ip-***-***-***-***    Ready     17d       v1.6.7
ip-***-***-***-***    Ready     32m       v1.6.7
ip-***-***-***-***    Ready     27m       v1.6.7
ip-***-***-***-***    Ready     17d       v1.6.7
ip-***-***-***-***    Ready     7d        v1.6.7
ip-***-***-***-***    Ready     17d       v1.6.7

$ kubectl get po --all-namespaces -o wide

$ kubectl get nodes --show-labels

$ kubectl delete node <minion-hostname>

$ kubectl label nodes <minion-hostname> ***=***

$ kubectl label nodes <minion-hostname> role-

$ kubectl get services

$ kubectl -n development delete service <service name>

$ kubectl -n development delete StatefulSet <StatefulSet name>

$ kubectl -n development delete deployment <deployment name>

$ kubectl create namespace <namespace name>

$ kubectl get Deployments --all-namespaces

$ kubectl -n kube-system describe po <pod name>

$ kubectl apply -f <yaml name>.yaml
```

# Issue && Todo
* 使用dpkg -i *.deb 的时候出现依赖没有安装

使用apt-get -f -y install 解决依赖问题后再执行dpkg安装deb包

* master node cluster

* elasticsearch cluster

* efk cluster

* monitor

* [Upgrading kubeadm clusters from 1.6 to 1.7](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm-upgrade-1-7/)
```
升级master
## [ubuntu中apt-get upgrade如何忽略某项 - SegmentFault](https://segmentfault.com/q/1010000000657514)
# apt-mark hold docker-engine
# apt-get upgrade -y
$ export KUBECONFIG=$HOME/admin.conf
$ kubectl delete daemonset kube-proxy -n kube-system
[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.
[init] Using Kubernetes version: v1.7.5
[init] Using Authorization modes: [Node RBAC]
[preflight] Skipping pre-flight checks
[kubeadm] WARNING: starting in 1.8, tokens expire after 24 hours by default (if you require a non-expiring token use --token-ttl 0)
[certificates] Using the existing CA certificate and key.
[certificates] Using the existing API Server certificate and key.
[certificates] Using the existing API Server kubelet client certificate and key.
[certificates] Using the existing service account token signing key.
[certificates] Using the existing front-proxy CA certificate and key.
[certificates] Using the existing front-proxy client certificate and key.
[certificates] Valid certificates and keys now exist in "/etc/kubernetes/pki"
[kubeconfig] Using existing up-to-date KubeConfig file: "/etc/kubernetes/admin.conf"
[kubeconfig] Using existing up-to-date KubeConfig file: "/etc/kubernetes/kubelet.conf"
[kubeconfig] Using existing up-to-date KubeConfig file: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Using existing up-to-date KubeConfig file: "/etc/kubernetes/scheduler.conf"
[apiclient] Created API client, waiting for the control plane to become ready
[apiclient] All control plane components are healthy after 54.502116 seconds
[token] Using token: 6060e2.e9f36106911664fc
[apiconfig] Created RBAC rules
[addons] Applied essential addon: kube-proxy
[addons] Applied essential addon: kube-dns

Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run (as a regular user):

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  http://kubernetes.io/docs/admin/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join --token 6060e2.e9f36106911664fc 172.31.10.219:6443

## [Integrating Kubernetes via the Addon](https://www.weave.works/docs/net/latest/kubernetes/kube-addon/)
# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

升级Node
1. 升级安装包 
$ sudo apt-mark hold docker-engine
$ sudo apt-get upgrade -y
2. 重启kubelet
$ sudo systemctl restart kubelet
```

* ingress
https://kubernetes.io/docs/concepts/services-networking/ingress/

# Reference && Document
