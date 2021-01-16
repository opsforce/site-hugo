---
title: Hi, iterm2 oh-my-zsh solarized
date: 2017-11-13
tags:
- iTerm2
- zsh
- solarized
---
![](https://ws2.sinaimg.cn/large/006tNc79gy1fpp6ihd1g2j30zp0jc0t7.jpg)

### iTerm2
```
brew cask install iterm2
```
如果没安装homebrew，就直接[官方网站](http://iterm2.com/downloads.html)下载安装包

### zsh
http://ohmyz.sh/
https://github.com/robbyrussell/oh-my-zsh

<!-- more -->

```
$ curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  4019  100  4019    0     0   3668      0  0:00:01  0:00:01 --:--:-- 2052k
Cloning Oh My Zsh...
Cloning into '/Users/opsforce/.oh-my-zsh'...
remote: Counting objects: 852, done.
remote: Compressing objects: 100% (716/716), done.
remote: Total 852 (delta 16), reused 787 (delta 10), pack-reused 0
Receiving objects: 100% (852/852), 581.15 KiB | 17.00 KiB/s, done.
Resolving deltas: 100% (16/16), done.
Looking for an existing zsh config...
Using the Oh My Zsh template file and adding it to ~/.zshrc
Time to change your default shell to zsh!
Changing shell for opsforce.
Password for opsforce:
         __                                     __
  ____  / /_     ____ ___  __  __   ____  _____/ /_
 / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \
/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / /
\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/
                        /____/                       ....is now installed!


Please look over the ~/.zshrc file to select plugins, themes, and options.

p.s. Follow us at https://twitter.com/ohmyzsh.

p.p.s. Get stickers and t-shirts at https://shop.planetargon.com.
```

### 使用pip安装Powerline
```
$ sudo pip install powerline-status
```

### Powerline字体下载安装
```
$ git clone https://github.com/powerline/fonts.git
$ ./fonts/install.sh
```
设置iTerm 2的Regular Font 和 Non-ASCII Font
安装完字体库之后，把iTerm 2的设置里的Profile中的Text 选项卡中里的Font的字体设置成 Powerline的字体，我这里设置的字体是12pt Meslo LG L DZ Regular for Powerline

### 修改主题
```
$ vi .zshrc
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"
```

### 安装配色方案
在iTerm 2输入以下命令：
```
$ git clone https://github.com/altercation/solarized.git
$ open solarized/iterm2-colors-solarized # 打开配色所在目录
```
打开配色所在目录，双击 Solarized Dark.itermcolors 和 Solarized Light.itermcolors 两个文件就可以把配置文件导入到 iTerm2 里，然后选择 Solarized 配色：Preferences -> Profiles -> Default -> Colors -> Color Presets...

### 增加指令高亮效果 zsh-syntax-highlighting
```
$ brew install zsh-syntax-highlighting

如果没安装homebrew，就下载源码安装

$ cd ~/.oh-my-zsh/custom/plugins
$ git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
$ echo '# syntax-highlighting
plugins=(zsh-syntax-highlighting)
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc
$ source ~/.zshrc # 立即生效
```

#### 参考
http://smk17.cn/posts/108/
https://gist.github.com/kevin-smets/8568070
https://www.jianshu.com/p/7de00c73a2bb
https://zhuanlan.zhihu.com/p/26373052