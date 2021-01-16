---
title: 使用 Travis CI 自动部署 Hexo
date: 2017-7-13
tags:
- CI/CD
- Github
- TravisCI
---
branch: master   - 网站源码
branch: gh-pages - html网页

使用GitHub登录travis-ci.org

![](https://ws2.sinaimg.cn/large/006tKfTcgy1fjgqumntn0j30us0gk78k.jpg)

登录后，点击红色区域选择想要自动部署的repo

![](https://ws1.sinaimg.cn/large/006tKfTcgy1fjgqv5rt8aj30rm0ew400.jpg)

到GitHub-setting申请Personal access token

![](https://ws3.sinaimg.cn/large/006tKfTcgy1fjgqw6gokoj30r70iemzi.jpg)

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fjgqxcwx9cj30ss0j2tcx.jpg)

得到Personal access token后，添加到travisci对应repo的环境变量GH_TOKEN

![](https://ws3.sinaimg.cn/large/006tKfTcgy1fjgqy82w12j310b0hejt9.jpg)

<!-- more -->

编写.travis.yml，并上传到master分支
```
# file: .travis.yml

language: node_js  #设置语言

node_js: stable  #设置相应的版本

# S: Build Lifecycle
install:
  - npm install  #安装hexo及插件

#before_script:
 # - npm install -g gulp

script:
  - hexo clean  #清除
  - hexo generate  #生成静态网页

after_script:
  - cd ./public
  - git init
  - git config user.name "your name"  #修改name
  - git config user.email "your email"  #修改email
  - git add .
  - git commit -m "update myblog" #此处看情况修改
  - git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages #GH_TOKEN是在TravisCI中配置token的名称
# E: Build LifeCycle

branches:
  only:
    - master  #只监测master分支，对应的源码分支

env:
  global:
    - GH_REF: github.com/<github username>/<your repo>.git #设置GH_REF，注意更改
```

不出意外的，现在现在新建一遍文章push到GitHub就会自动部署到gh-pages分支了

good luck ~:~

## 注意
环境变量名称必须是‘GH_TOKEN’，什么小写或改成其他都不可用

## 参考
http://www.jianshu.com/p/e22c13d85659