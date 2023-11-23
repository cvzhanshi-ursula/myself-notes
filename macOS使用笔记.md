# 命令集合

## 解压带中文的压缩包

```bash
unar -e GBK $ZIPFILE.zip
```

## docker run mysql image

- 宿主机的路径下的文件要先创建好（my.cnf），文件夹不需要

```bash
docker run -p 3306:3306 --name docker-mysql -v /Users/cvzhanshi/docker_mnt/mysql8/conf/my.cnf:/etc/my.cnf -v /Users/cvzhanshi/docker_mnt/mysql8/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql
```

