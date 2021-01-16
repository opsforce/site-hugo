---
title: Remove All Iptables PREROUTING Nat Rules
date: 2016-06-09
tags:
- Security
- Firewall
- Iptables
---
To Flush iptables PREROUTING chains cannot be achieved by -F iptables option. To remove PREROUTING nat rules from you system first display all PREROUTING chains using a following iptables command:

```
iptables -t nat --line-numbers -L
```

<!-- more -->

![](https://ws1.sinaimg.cn/large/006tKfTcgy1fjgr3n1znnj316o0nhwm7.jpg)

As you can see the above command will display all PREROUTING chains with relevant line numbers. Next, we can use these line numbers to remove all PREROUTING chains one by one. For example to remove PREROUTING chain with line number 1 we can do:

```
iptables -t nat -D PREROUTING 1
```
![](https://ws1.sinaimg.cn/large/006tKfTcgy1fjgr43on6oj30vc0d944q.jpg)

In case that you wish to remove all PREROUTING chains with a single command you can try the following command chaining example:

```
for i in $( iptables -t nat --line-numbers -L | grep ^[0-9] | awk '{ print $1 }' | tac ); do iptables -t nat -D PREROUTING $i; done
```

## Reference
[Remove All Iptables PREROUTING Nat Rules](http://lubos.rendek.org/remove-all-iptables-prerouting-nat-rules/)