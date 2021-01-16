---
title: Mac下配置Python2和Python3共存
date: 2016-7-10
tags:
- macOS
- Python
- Virtualenv
---
Mac默认是安装了Python2的，所以只需要安装Python3
```
$ brew install python3 # 使用homebrew安装python3
$ python3 -V
Python 3.6.5

$ brew install pyenv-virtualenv # 安装virtualenv
或者
$ sudo easy_install virtualenv # 安装virtualenv

$ mkdir myenv && cd myenv # 创建本地工作目录
$ which python3 # 找出Python3路径
/usr/local/bin/python3

# python2
$ virtualenv --no-site-packages pyenv # 配置Python2虚拟路径
$ source pyenv/bin/activate # 使Python2虚拟路径生效
$ deactivate # 使Python2虚拟路径失效

# python3
$ virtualenv --no-site-packages --python=/usr/local/bin/python3 pyenv3 # 配置Python3虚拟路径
$ source pyenv3/bin/activate # 使Python3虚拟路径生效
$ deactivate # 使Python3虚拟路径失效
```