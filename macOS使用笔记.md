# 命令集合

## 解压带中文的压缩包

```bash
unar -e GBK $ZIPFILE.zip
```

## docker命令合集

### docker run mysql image

- 宿主机的路径下的文件要先创建好（my.cnf），文件夹不需要

```bash
docker run -p 3306:3306 --name docker-mysql -v /Users/cvzhanshi/docker_mnt/mysql8/conf/my.cnf:/etc/my.cnf -v /Users/cvzhanshi/docker_mnt/mysql8/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql
```

## 指定app打开指定文件

```sh
# open -a "指定app" 指定文件
open -a "draw.io" temp.drawio
```

## 打开或关闭SIP

SIP 是 System Integrity Protection 的简写，译为系统完整性保护。 SIP 是 OS X El Capitan 时开始采用的一项安全技术，目的是为了限制 root 账户对系统的完全控制权，也叫 Rootless 保护机制。

Mac 系统中 SIP 状态默认是开启的。近期更新了系统版本导致该状态重新被打开，在终端运行一些命令时提示 "Operation not permitted" 

>  查看 SIP 状态



终端输入 `csrutil status` 即可看到 SIP 的状态是 disable 还是 enable 。

> 关闭或开启 SIP



1. 重启 Mac ，按住 Command + R 直到屏幕上出现苹果的标志和进度条 ，进入 Recovery 模式 ；
2. 在屏幕上方的工具栏找到并打开终端，输入命令 `csrutil disable` ；
3. 关掉终端，重启 Mac ；
4. 重启以后可以在终端中查看状态确认 。

开启 SIP 只需在上面第 2 步命令改为 `csrutil enable` 即可。
