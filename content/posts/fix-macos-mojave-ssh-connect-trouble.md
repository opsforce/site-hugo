---
title: fix-macos-mojave-ssh-connect-trouble
date: 2018-11-1
tags:
- macOS
---
升级 macos mojave 10.14.1 后 ssh 远程服务器出现如下错误：
```
packet_write_wait: Connection to *.*.*.* port 22: Broken pipe
```
其实是ssh客户端比较新导致的
```
$ ssh -V
OpenSSH_7.8p1, LibreSSL 2.7.3
```
只需添加ssh相关配置，可解决问题
```
$ cat .ssh/config
Host *
    IPQoS lowdelay throughput
```
这个问题困惑了我近半个月