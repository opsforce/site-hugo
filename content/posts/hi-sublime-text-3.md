---
title: Hi, sublime text 3
date: 2017-12-09
tags:
- Develop
---
<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=300 height=80 src="http://music.163.com/outchain/player?type=2&id=28285910&auto=1&height=66"></iframe>

![](https://ws3.sinaimg.cn/large/006tNc79gy1fpp6pb8snvj311y0jnwfs.jpg)

### 安装Package Control
Tools -> Install Package Control

### 安装主题
到package control里面搜索相应主题安装即可，推荐一款主题Ayu

<!-- more -->

### Preferences.sublime-settings-User
```
{
	"font_size": 13,
	"ignored_packages":
	[
		"Vintage"
	],
    "theme": "ayu-light.sublime-theme",
    "color_scheme": "Packages/ayu/ayu-light.tmTheme",
	"update_check": false // 禁止软件自动更新
}
```

### plugins
Package Control - 包控制管理工具
Alignment - 行对齐工具
SideBarEnhancements - 侧边栏右键加强
A File Icon - 主题ayu依赖的图标插件
Git

### 设置 package 代理(shadowsocks)
Preferences -> Package Settings -> Package Control -> Settings - User
```
	"http_proxy": "http://127.0.0.1:1087",
	"https_proxy": "http://127.0.0.1:1087"
```

### 快捷键
Command+Shift+P - Package Control
Command+, - Settings