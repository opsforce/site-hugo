#!/bin/sh

tag=2.1.0
wget https://github.com/panr/hugo-theme-hello-friend/archive/${tag}.tar.gz -O hello-friend-${tag}.tar.gz
tar -vxzf hello-friend-${tag}.tar.gz -C themes
mv themes/*hello-friend* themes/hello-friend
rm -rf hello-friend-${tag}.tar.gz