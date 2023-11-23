## Nginx产生的原因

- 一个公司的项目刚刚上线的时候，并发量小，用户使用的少，所以在低并发的情况下，一个jar包启动应用就够了，然后内部tomcat返回内容给用户

![1628221226329](Nginx.assets/1628221226329.png)

-  慢慢的，使用平台的用户越来越多了，并发量慢慢增大了，这时候一台服务器满足不了我们的需求了 

![1628221258323](Nginx.assets/1628221258323.png)

-  于是我们横向扩展，又增加了服务器。这个时候几个项目启动在不同的服务器上，用户要访问，就需要增加一个代理服务器了，通过代理服务器来帮我们转发和处理请求。

![1628221284447](Nginx.assets/1628221284447.png)

> 我们希望这个**代理服务器可以帮助我们接收用户的请求，然后将用户的请求按照规则帮我们转发到不同的服务器节点之上。这个过程用户是无感知的**，用户并不知道是哪个服务器返回的结果，我们还希望他可以**按照服务器的性能提供不同的权重选择**。保证最佳体验！所以我们使用了Nginx。

## Nginx简介

- Nginx (engine x) 是一个**高性能的HTTP和反向代理web服务器**，**同时也提供了IMAP/POP3/SMTP服务**。Nginx是由伊戈尔·赛索耶夫为俄罗斯访问量第二的Rambler.ru站点（俄文：Рамблер）开发的，第一个公开版本0.1.0发布于2004年10月4日。2011年6月1日，nginx 1.0.4发布。

- 其特点是**占有内存少，并发能力强**，事实上nginx的并发能力在同类型的网页服务器中表现较好，中国大陆使用nginx网站用户有：百度、京东、新浪、网易、腾讯、淘宝等。在全球活跃的网站中有12.18%的使用比率，大约为2220万个网站。

- Nginx 是一个安装非常的简单、配置文件非常简洁（还能够支持perl语法）、Bug非常少的服务。**Nginx 启动特别容易，并且几乎可以做到7*24不间断运行，即使运行数个月也不需要重新启动**。你还能够不间断服务的情况下进行软件版本的升级。

- Nginx代码完全用C语言从头写成。官方数据测试表明能够支持高达 50,000 个并发连接数的响应。

## Nginx的作用

- **Http代理，反向代理：作为web服务器最常用的功能之一，尤其是反向代理。** 

  - 正向代理：代理是代理客户端的

  ![1628221458725](Nginx.assets/1628221458725.png)
  -  反向代理 ：代理是代理服务器的，所以用户是无感知的，比如，百度的服务器是在不同的服务器上，我们只需要搜索baidu.com就行。

  ![1628221515354](Nginx.assets/1628221515354.png)

-  **Nginx提供的负载均衡策略有2种：内置策略和扩展策略。内置策略为轮询，加权轮询，Ip hash。扩展策略，就天马行空，只有你想不到的没有他做不到的。** 

  - 轮询

  ![1628221543126](Nginx.assets/1628221543126.png)
  - 加权轮询，因为可能不同服务器性能不一样，能接收的请求数量不同

  ![1628221558749](Nginx.assets/1628221558749.png)
  -  iphash对客户端请求的ip进行hash操作，然后根据hash结果将同一个客户端ip的请求分发给同一台服务器进行处理，可以解决session不共享的问题。 

  ![1628221600221](Nginx.assets/1628221600221.png)

- **动静分离**，在我们的软件开发中，有些请求是需要后台处理的，有些请求是不需要经过后台处理的（如：css、html、jpg、js等等文件），这些不需要经过后台处理的文件称为静态文件。让动态网站里的动态网页根据一定规则把不变的资源和经常变的资源区分开来，动静资源做好了拆分以后，我们就可以根据静态资源的特点将其做缓存操作。提高资源响应的速度。

![1628221657563](Nginx.assets/1628221657563.png) 

## Nginx的安装

### Windows下的安装

- **下载Nginx**

 http://nginx.org/en/download.html 下载稳定版本 

![1628221929851](Nginx.assets/1628221929851.png)

解压到文件夹中

![1628221954933](Nginx.assets/1628221954933.png)

- **启动Nginx**

有很多种方法启动nginx

(1)直接双击nginx.exe，双击后一个黑色的弹窗一闪而过

(2)打开cmd命令窗口，切换到nginx解压目录下，输入命令 `nginx.exe` ，回车即可

-  **检查Nginx是否启动成功** 

 直接在浏览器地址栏输入网址 [http://localhost:80](http://localhost/) 回车，出现以下页面说明启动成功 

![1628222007169](Nginx.assets/1628222007169.png)

- **配置监听**

> nginx的配置文件是conf目录下的nginx.conf，默认配置的nginx监听的端口为80，如果80端口被占用可以修改为未被占用的端口即可。 

![1628222054846](Nginx.assets/1628222054846.png)

> 当我们修改了nginx的配置文件nginx.conf 时，不需要关闭nginx后重新启动nginx，只需要执行命令 `nginx -s reload` 即可让改动生效 

- **关闭Nginx**

如果使用cmd命令窗口启动nginx， 关闭cmd窗口是不能结束nginx进程的，可使用两种方法关闭nginx

(1)输入nginx命令 `nginx -s stop`(快速停止nginx) 或 `nginx -s quit`(完整有序的停止nginx)

(2)使用taskkill `taskkill /f /t /im nginx.exe`

```bash
taskkill是用来终止进程的，
/f是强制终止 .
/t终止指定的进程和任何由此启动的子进程。
/im示指定的进程名称 .
```

### Linux下的安装

- 要确定有gcc环境

```bash
gcc -v  # 查看版本
yum install gcc-c++  # 如果没有的话就安装一下
```

- **PCRE pcre-devel 安装**

PCRE(Perl Compatible Regular Expressions) 是一个Perl库，包括 perl 兼容的正则表达式库。nginx 的 http 模块使用 pcre 来解析正则表达式，所以需要在 linux 上安装 pcre 库，pcre-devel 是使用 pcre 开发的一个二次开发库。nginx也需要此库。命令：

```bash
yum install -y pcre pcre-devel
```

- **zlib 安装**

zlib 库提供了很多种压缩和解压缩的方式， nginx 使用 zlib 对 http 包的内容进行 gzip ，所以需要在 Centos 上安装 zlib 库。

```bash
yum install -y zlib zlib-devel
```

- **OpenSSL 安装**
  OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供丰富的应用程序供测试或其它目的使用。
  nginx 不仅支持 http 协议，还支持 https（即在ssl协议上传输http），所以需要在 Centos 安装 OpenSSL 库。

```bash
yum install -y openssl openssl-devel
```

- 下载安装包，并上传到linux上

![1628233096849](Nginx.assets/1628233096849.png)

- 解压安装包

```java
tar -zxvf nginx-1.20.1.tar.gz # 解压安装包
cd nginx-1.20.1/ # 进入目录，发现和windows没什么区别
```

- 进行自动配置

```bash
./configure
```

![1628233275521](Nginx.assets/1628233275521.png)

- 执行make命令
- 执行make install命令
- 查看是否安装成功

```bash
[root@cVzhanshi nginx-1.20.1]# whereis nginx
nginx: /usr/local/nginx
```

- 到安装目录去看看

![1628233760218](Nginx.assets/1628233760218.png)

- 进入sbin目录，执行可执行文件

![1628233793931](Nginx.assets/1628233793931.png)

- 在浏览器看看是否执行成功

![1628233832542](Nginx.assets/1628233832542.png)

## Nginx常用命令

```bash
cd /usr/local/nginx/sbin/
./nginx  启动
./nginx -s stop  停止
./nginx -s quit  安全退出
./nginx -s reload  重新加载配置文件
ps aux|grep nginx  查看nginx进程
```

>  注意：如何连接不上，检查阿里云安全组是否开放端口，或者服务器防火墙是否开放端口 

 相关命令： 

```bash
# 开启
service firewalld start
# 重启
service firewalld restart
# 关闭
service firewalld stop
# 查看防火墙规则
firewall-cmd --list-all
# 查询端口是否开放
firewall-cmd --query-port=8080/tcp
# 开放80端口
firewall-cmd --permanent --add-port=80/tcp
# 移除端口
firewall-cmd --permanent --remove-port=8080/tcp
#重启防火墙(修改配置后要重启防火墙)
firewall-cmd --reload
# 参数解释
1、firwall-cmd：是Linux提供的操作firewall的一个工具；
2、--permanent：表示设置为持久；
3、--add-port：标识添加的端口；
```

## 演示

- 先进行配置文件的修改

```conf
http {
    ...
	upstream cvzhanshi{
		server 127.0.0.1:8082/ weight=1;
		server 127.0.0.1:8081/ weight=1;
	}


    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
			proxy_pass http://cvzhanshi;
        }
        ...
}
```

- 启动两个端口的项目

![1628236741851](Nginx.assets/1628236741851.png)

- 启动nginx
- 进行测试

![1628237166244](Nginx.assets/1628237166244.png)

-----

![1628237186359](Nginx.assets/1628237186359.png)