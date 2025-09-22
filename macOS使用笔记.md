# 命令集合

## 解压带中文的压缩包

```bash
unar -e GBK $ZIPFILE.zip
```

## docker bask

## docker run mysql image

- 宿主机的路径下的文件要先创建好（my.cnf），文件夹不需要

```bash
docker run -p 3306:3306 --name docker-mysql -v /Users/cvzhanshi/docker_mnt/mysql8/conf/my.cnf:/etc/my.cnf -v /Users/cvzhanshi/docker_mnt/mysql8/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql

# docker run: 这是 Docker 命令，用于创建并启动一个新的容器实例。

# -p 3306:3306: 这个选项将容器的 3306 端口映射到主机的 3306 端口。这样，您可以通过主机的 3306 端口访问容器内的 MySQL 服务。

# --name docker-mysql: 这个选项为容器指定一个名称（在这个例子中是 docker-mysql）。这样您可以使用这个名字来引用容器，而不是使用自动生成的容器 ID。

# -v /Users/cvzhanshi/docker_mnt/mysql8/conf/my.cnf:/etc/my.cnf: 这个选项将主机上的 my.cnf 配置文件挂载到容器内的 /etc/my.cnf。这样，MySQL 会使用这个配置文件，而不是容器内的默认配置文件。

# -v /Users/cvzhanshi/docker_mnt/mysql8/data:/var/lib/mysql: 这个选项将主机上的数据目录挂载到容器内的 /var/lib/mysql。这样，MySQL 的数据文件会保存在主机上指定的目录中，从而确保数据在容器重新启动或删除后不会丢失。

# -e MYSQL_ROOT_PASSWORD=123456: 这个选项设置了 MySQL 根用户（root）的密码。在这个例子中，密码是 123456。

# -d: 这个选项表示以分离模式（detached mode）运行容器，即在后台运行容器，而不是在前台显示容器的输出。

# mysql: 这是要使用的 Docker 镜像的名称。默认情况下，这将从 Docker Hub 拉取最新的 MySQL 镜像。


```

