---
title: Deploy docker swarm use multi consul and swarm-manager
date: 2017-7-13
tags:
- Docker
- Swarm
- Consul
---
## Architecture
![](https://ws2.sinaimg.cn/large/006tKfTcgy1fjj6athl6ij30kk0ardgm.jpg)

## Prepare
``` bash
# useradd mfg
# passwd mfg
# echo '
mfg        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers
# exit
$ ssh <no_root>@*.*.*.*
$ curl -fsSL https://get.docker.com/ | sh
$ sudo usermod -aG docker $(whoami)
$ sudo systemctl restart docker && sudo systemctl enable docker
```

<!-- more -->

## Consul
``` bash
#####################################################################################################
# consul  https://hub.docker.com/r/progrium/consul/  
# https://github.com/gliderlabs/docker-consul 
# https://docs.docker.com/swarm/reference/manage/ 
# https://docs.docker.com/swarm/reference/join/
#####################################################################################################

Running a real Consul cluster in a production environment
Setting up a real cluster on separate hosts is very similar to our single host cluster setup process, but with a few differences:

We assume there is a private network between hosts. Each host should have an IP on this private network
We're going to pass this private IP to Consul via the -advertise flag
We're going to publish all ports, including internal Consul ports (8300, 8301, 8302), on this IP
We set up a volume at /data for persistence. As an example, we'll bind mount /mnt from the host
Assuming we're on a host with a private IP of 172.16.2.9 and the IP of docker bridge docker0 is 172.17.0.1 we can start the first host agent:

$ docker run --restart=always --name consul-01 -d -h node1 -v /data/consul/data:/data \
    -p 172.16.2.9:8300:8300 \
    -p 172.16.2.9:8301:8301 \
    -p 172.16.2.9:8301:8301/udp \
    -p 172.16.2.9:8302:8302 \
    -p 172.16.2.9:8302:8302/udp \
    -p 172.16.2.9:8400:8400 \
    -p 172.16.2.9:8500:8500 \
    -p 172.17.0.1:53:53/udp \
    progrium/consul -server -advertise 172.16.2.9 -bootstrap-expect 3

## On the second host, we'd run the same thing, but passing a -join to the first node's IP. Let's say the private IP for this host is 172.16.2.10:

$ docker run --restart=always --name consul-02 -d -h node2 -v /data/consul/data:/data  \
    -p 172.16.2.10:8300:8300 \
    -p 172.16.2.10:8301:8301 \
    -p 172.16.2.10:8301:8301/udp \
    -p 172.16.2.10:8302:8302 \
    -p 172.16.2.10:8302:8302/udp \
    -p 172.16.2.10:8400:8400 \
    -p 172.16.2.10:8500:8500 \
    -p 172.17.0.1:53:53/udp \
    progrium/consul -server -advertise 172.16.2.10 -join 172.16.2.9

## And the third host with an IP of 172.16.2.11:

$ docker run --restart=always --name consul-03 -d -h node3 -v /data/consul/data:/data  \
    -p 172.16.2.11:8300:8300 \
    -p 172.16.2.11:8301:8301 \
    -p 172.16.2.11:8301:8301/udp \
    -p 172.16.2.11:8302:8302 \
    -p 172.16.2.11:8302:8302/udp \
    -p 172.16.2.11:8400:8400 \
    -p 172.16.2.11:8500:8500 \
    -p 172.17.0.1:53:53/udp \
    progrium/consul -server -advertise 172.16.2.11 -join 172.16.2.9

## That's it! Once this last node connects, it will bootstrap into a cluster. You now have a working cluster running in production on a private network.
```

## Lb for consul using nginx [或者使用云服务商的lb]
``` bash
$ docker run -d --name nginx -v ${HOME}/nginx/conf.d:/etc/nginx/conf.d -p 8000:80 nginx:1.13.3-alpine
$ vi ${HOME}/nginx/conf.d/consul.conf
upstream docker-consul {
  server 172.16.2.9:8500;
  server 172.16.2.10:8500;
  server 172.16.2.11:8500;
}

server {
  listen 80;
  server_name nginx-consul;

  location / {
    proxy_pass                          http://docker-consul;
    proxy_set_header  Host              $http_host;
    proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
  }

}

$ docker cp consul.conf nginx:/etc/nginx/conf.d
$ docker exec -it nginx nginx -s reload

```

## Swarm manager nodes
``` bash
#####################################################################################################
# [Swarm: A Docker-native clustering system | Docker Documentation](https://docs.docker.com/swarm/reference/swarm/)
# [High availability in Docker Swarm | Docker Documentation](https://docs.docker.com/swarm/multi-manager-setup/)
# [Build a Swarm cluster for production | Docker Documentation](https://docs.docker.com/swarm/install-manual/#step-2-create-your-instances)
#####################################################################################################

#### swarm manager

$ docker run -d -p 4000:4000 --restart=always --name=swarm-manager-01 swarm manage -H :4000 --replication --advertise 172.16.2.9:4000 consul://172.16.2.12:8500

$ docker run -d -p 4000:4000 --restart=always --name=swarm-manager-02 swarm manage -H :4000 --replication --advertise 172.16.2.10:4000 consul://172.16.2.12:8500

$ docker run -d -p 4000:4000 --restart=always --name=swarm-manager-03 swarm manage -H :4000 --replication --advertise 172.16.2.11:4000 consul://172.16.2.12:8500

```

## Swarm slave nodes
``` bash
$ sudo vi /usr/lib/systemd/system/docker.service

ExecStart=/usr/bin/dockerd

change to  ===>>>

ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://172.16.2.12:8500 --cluster-advertise=172.16.2.9:2375


#### swarm slave
$ docker run -d --restart=always --name=swarm-slave swarm join --advertise=172.16.2.10:2375 consul://172.16.2.12:8500

$ sudo systemctl daemon-reload && sudo systemctl restart docker
```

## Test
``` bash
$ docker -H :4000 run -d --name nginx-test -e constraint:node==iZuf654mu2j1ottom86sm9Z -p 80:80 nginx:1.13.3-alpine

```

## Maintain
``` bash
## common command
$ docker -H :4000 info
$ docker -H :4000 ps
$ docker-compose -H :4000 -f ~/docker-compose.yml ps

## common issue
* 如果出现docker -H :4000 info 显示没有节点或者缺少某个节点，到缺少的节点上执行docker restart slave
```

## Other [Danger!!!]
``` bash
$ docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && sudo rm -rf /data/consul && sudo rm -rf /etc/docker/key.json
```

## Reference
https://hub.docker.com/r/progrium/consul/
[GitHub - gliderlabs/docker-consul: Dockerized Consul](https://github.com/gliderlabs/docker-consul)
[manage — Create a Swarm manager | Docker Documentation](https://docs.docker.com/swarm/reference/manage/)
[join — Create a Swarm node | Docker Documentation](https://docs.docker.com/swarm/reference/join/)
[Swarm: A Docker-native clustering system | Docker Documentation](https://docs.docker.com/swarm/reference/swarm/) [High availability in Docker Swarm | Docker Documentation](https://docs.docker.com/swarm/multi-manager-setup/)
[Build a Swarm cluster for production | Docker Documentation](https://docs.docker.com/swarm/install-manual/#step-2-create-your-instances)