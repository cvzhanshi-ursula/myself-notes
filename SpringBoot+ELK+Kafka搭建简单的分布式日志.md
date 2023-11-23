# ①ELK+Kafka介绍
ELK是一整套解决方案，是三个软件产品的首字母缩写，Elasticsearch，Logstash和Kibana。
- Logstash：负责数据的收集，处理和储存
- Elasticsearch：负责数据的检索和分析
- Kibana：负责可视化
- Kafka是一个分布式消息队列。★Kafka对消息保存时根据Topic进行归类，发送消息者称为Producer，消息接受者称为Consumer，此外kafka集群有多个kafka实例组成，每个实例(server)称为broker。无论是kafka集群，还是consumer都依赖于zookeeper集群保存一些meta信息，来保证系统可用性。

体系结构
基本流程是 logstash 负责从各种数据源里采集数据，然后再写入 Elasticsearch，Elasticsearch 对这些数据创建索引，然后由 Kibana 对其进行各种分析并以图表的形式展示。
如图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/7f95d56195b44adca214680a954e7a0c.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
# ②ELK+Kafka的下载地址
- elasticsearch：https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.6.1-windows-x86_64.zip
- kibana：https://artifacts.elastic.co/downloads/kibana/kibana-7.6.1-windows-x86_64.zip
- logstash（7.6.1）：https://artifacts.elastic.co/downloads/logstash/logstash-7.6.1.zip
- kafka：http://kafka.apache.org/downloads
# ③ELK+Kafka的安装
## 3.1 elasticsearch的安装
- 只需要把下载好的压缩文件解压即可
![(ElasticSearch7.6.assets/1628675377201.png)\]](https://img-blog.csdnimg.cn/bf61019259a34978bb0e9d28e381bc1a.png)
- 解压后的目录解析
![(ElasticSearch.assets/1628734808099.png)\]](https://img-blog.csdnimg.cn/d20f7e1131e6443cb0f6ea10d8aabd8b.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
  ```bash
  bin 启动文件
  config 配置文件
      log4j2 日志配置文件
      jvm.options java 虚拟机相关的配置
      elasticsearch.yml elasticsearch 的配置文件！ 默认 9200 端口！ 跨域！
  lib 相关jar包
  logs 日志！
  modules 功能模块
  plugins 插件！
  ```

- 打开 jvm.options  java虚拟机相关的配置
![(ElasticSearch7.6.assets/1628676065589.png)\]](https://img-blog.csdnimg.cn/766f3682e4f344e29100555131eb0898.png)

- 启动，只需要进去bin目录双击elasticsearch.bat（**切记要使用管理员运行这个文件，不然会报错**）
![在这里插入图片描述](https://img-blog.csdnimg.cn/f7e4600b2f9846d8bd339048f4e72037.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


- 访问测试，访问127.0.0.1:9200
	![在这里插入图片描述](https://img-blog.csdnimg.cn/fca4cda2be3d400fbf004b4be29ab9ad.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
## 3.2 安装可视化界面 es head的插件

-  下载地址：https://github.com/mobz/elasticsearch-head/ 
![在这里插入图片描述](https://img-blog.csdnimg.cn/642c3c9513494fd688d09fcfc04266b8.png)
- 启动项目，到项目主目录下运行命令 

  ```bash
  npm install # 下载依赖
  
  npm run start # 启动项目
  ```
![在这里插入图片描述](https://img-blog.csdnimg.cn/8206d656327a4c9eacf53ab14e151509.png)
- 连接测试发现，存在跨域问题：配置 es 
![在这里插入图片描述](https://img-blog.csdnimg.cn/2042a8e2c28b43f3854eda2066eade57.png)
  - 修改 `elasticsearch/config/elasticsearch.yml`

  - 添加如下内容

    ```yaml
    http.cors.enabled: true  # 开启跨域
    
    http.cors.allow-origin: "*" # 允许所有人
    ```

-  重启 es 服务器，然后再次连接
	![在这里插入图片描述](https://img-blog.csdnimg.cn/6d1cf0ebaeb64690a50605481db9b2a9.png)
## 3.3 安装Logstash
- 在logstash-7.6.1\config文件夹下面创建logstash.conf文件，输入一下内容
	

```java
# For detail structure of  this  file       
# Set: https: //www.elastic.co/guide/en/logstash/current/configuration-file-structure.html
#输入     
input {        
   # For detail config  for  log4j as input,           
   # See: https: //www.elastic.co/guide/en/logstash/current/plugins-inputs-log4j.html          
   tcp {         
     mode =>  "server"          
     host =>  "127.0.0.1" 
        
     port =>  9250         
   }       
}        
#过滤
filter {         
   #Only matched data are send to output.       
} 
# 输出
output { 
     
   # For detail config  for  elasticsearch as output,       
   # See: https: //www.elastic.co/guide/en/logstash/current/plugins-outputs-elasticsearch.html      
   elasticsearch {         
     action =>  "index"           #The operation on ES         
     hosts  =>  "127.0.0.1:9200"    #ElasticSearch host, can be array.        
     index  =>  "applog"          #The index to write data to.        
   }    
}
```
- 在logstash文件夹下鼠标右键+shift,选择在此处打开命令窗口或者在此处打开Powershell窗口，执行命令
```bash
bin\logstash -f config\logstash.conf
```
如图所示，说明启动成功
![在这里插入图片描述](https://img-blog.csdnimg.cn/5b5b767593dc41d69ef16b41e853267d.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
- 测试访问http://localhost:9600/ ， 可以看到返回说明启动成功了
![在这里插入图片描述](https://img-blog.csdnimg.cn/e620e4ceb97d42e1ab0041d0af1ba3c8.png)
> 注意
LogStash启动时若报错【错误: 找不到或无法加载主类 Files\Java\jdk1.8.0_131\lib\dt.jar;C:\Program】
则需要在bin目录下的logstash.bat文件 
将%JAVA% %JAVA_OPTS% -cp %CLASSPATH% org.logstash.Logstash %* 
修改为%JAVA% %JAVA_OPTS% -cp "%CLASSPATH%" org.logstash.Logstash %*
%CLASSPATH%添加双引号
然后尝试再次启动
## 3.4 kibana安装
- 下载解压
- 修改配置文件在config下的kibana.yml文件中指定一下你需要读取的elasticSearch地址和可供外网访问的bind地址

```yaml
server.host: "localhost"
elasticsearch.url: "http://localhost:9200"
```
- 启动kibana，双击bin目录下的kibana.bat
> 启动时报错： FATAL  Error: [config validation of [elasticsearch].url]: definition for this key is missing
> 解决方法：配置文件中需要用： elasticsearch.hosts， 而不是： elasticsearch.url

```java
server.host: "127.0.0.1"
elasticsearch.hosts: ["http://localhost:9200/"]
```
- 启动es，访问http://localhost:5601/，如下所示，表示安装成功
![在这里插入图片描述](https://img-blog.csdnimg.cn/aa25e0b79f754c32aa920f731036fe71.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
## 3.5 kafka的安装
- 首先要安装好Zookeeper
	- 下载安装包http://zookeeper.apache.org/releases.html#download
	-  解压并进入ZooKeeper目录中的conf文件夹
	- 将“zoo_sample.cfg”重命名为“zoo.cfg”
	- 打开“zoo.cfg”找到并编辑
		> 日志存放地址
		dataDir=E:\study\Java\environment\zookeeper\zookeeper-3.4.14\\tmp
	- 添加系统变量：ZOOKEEPER_HOME=E:\study\Java\environment\zookeeper\zookeeper-3.4.14
	- 编辑path系统变量，添加路径：%ZOOKEEPER_HOME%\bin
	- 在zoo.cfg文件中修改默认的Zookeeper端口（默认端口2181）
	- 打开新的cmd，输入“zkServer“，运行Zookeeper
	- 命令行提示如下：说明本地Zookeeper启动成功
![在这里插入图片描述](https://img-blog.csdnimg.cn/22d185ff798e4f09bc6fd6a1e42e1118.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
- 解压并进入Kafka目录
- 找到并编辑log.dirs=D:\Kafka\kafka_2.12-0.11.0.0\kafka-logs
-  找到并编辑zookeeper.connect=localhost:2181
- Kafka会按照默认，在9092端口上运行，并连接zookeeper的默认端口：2181
- 进入Kafka安装目录按下Shift+右键，选择“打开命令窗口”选项，打开命令行，输入：
	

```java
.\bin\windows\kafka-server-start.bat .\config\server.properties
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/9ab5fb010f03419eab985b3de0543dd3.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
1、如果出现**输入行过长**等错误，出现的原因是，kafka的安装路径太深了（在文件夹里的文件夹里....）
解决方法：把kafka文件夹复制到根目录下如：d:/kafka，就能解决错误
![在这里插入图片描述](https://img-blog.csdnimg.cn/83ff10b11d1d4c3da1e0062dba9da25b.png)
2、PS：启动报错示例：找不到或无法加载主类 ...
![在这里插入图片描述](https://img-blog.csdnimg.cn/315b4555a33f45c49d46da75103a12bb.png)
解决办法：首先确保JAVA环境变量没有问题之后，修改 kafka-run-class.bat 中的179行给 %CLASSPATH% 加上双引号即可
![在这里插入图片描述](https://img-blog.csdnimg.cn/555fd10a9f544e4dbd336c9a067d7ff3.png)

```java
set COMMAND=%JAVA% %KAFKA_HEAP_OPTS% %KAFKA_JVM_PERFORMANCE_OPTS% %KAFKA_JMX_OPTS% 
%KAFKA_LOG4J_OPTS% -cp "%CLASSPATH%" %KAFKA_OPTS% %*
```


> 注意：注意：不要关了这个窗口，启用Kafka前请确保ZooKeeper实例已经准备好并开始运行
- **测试**
>创建主题，进入Kafka安装目录，按下Shift+右键，选择“打开命令窗口”选项，打开命令行，输入：
```java
.\bin\windows\kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
```
注意：不要关了这个窗口
查看主题输入：

```java
.\bin\windows\kafka-topics.bat --list --zookeeper localhost:2181
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/409d7fe5abd9432fa19d7c628ec98537.png)
> 创建生产者，进入Kafka安装目录按下Shift+右键，选择“打开命令窗口”选项，打开命令行，输入：

```java
.\bin\windows\kafka-console-producer.bat --broker-list localhost:9092 --topic test
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/f69a9e632bce4c69965d650a31ff71c1.png)
注意：不要关了这个窗口
> 创建消费者，进入Kafka安装目录，按下Shift+右键，选择“打开命令窗口”选项，打开命令行，输入：

```java
.\bin\windows\kafka-console-consumer.bat --bootstrap-server localhost:9092 --topic test --from-beginning
```
![在这里插入图片描述](https://img-blog.csdnimg.cn/93a10f4d61394d14a32ad8eed1cc95e8.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
在生产者输入内容，会发现在消费者中出现，则kafka安装成功
# ④搭建过程
## 4.1 启动Zookeeper
## 4.2 启动Kafka
- 进入kafka安装目录，在config目录下，有一个server.properties。此处是关于kafka-server启动的使用到的配置（也可以自行调整），这里主要调整了日志路径位置和添加了Topic删除设置：
```java
log.dirs=E:/springcloud-log/kafka-log # 路径自定义
#设置可以删除topic，否则只是逻辑删除，不是真正意义删除
delete.topic.enable=true
```
-  然后在安装目录通过cmd命令启动Kafka,默认端口9092

```java
.\bin\windows\kafka-server-start.bat .\config\server.properties
```
- 启动后还需要创建主题topic，使用命令

```java
.\bin\windows\kafka-topics.bat --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testlog
```
**其中，testlog是topic名称，后面会logstash和logback.xml文件会用到）**
> 此处重点讲下删除topic，因为删除kafka可能会提示为标记删除，并没有真正删除，并且我就是因为删除topic不完全，导致后续kafka启动有问题。在没有彻底删除topic之后，大家可以到zookeeper配置文件指定的日志存放目录下删除zookeeper日志，以及删除掉kafka指定日志目录的全部文件，再重启zookeeper和kafka即可。但需要重新创建topic。

删除Topic：
```java
 .\bin\windows\kafka-topics.bat --delete --zookeeper 127.0.0.1 -topic test-channel
```
查看Topic：
```java
 .\bin\windows\kafka-topics.bat --list --zookeeper localhost:2181
```
## 4.3 启动elasticsearch
> 直接进入bin目录下，点击elasticsearch.bat启动即可（管理员运行）
 
## 4.4 启动logstash
-   在启动logstash之前，需要先在根目录下（或其他目录）创建一个配置文件，我的名为logstash.conf，配置文件的内容如下：

```java
input {
   kafka {
    #此处是kafka的ip和端口（千万不要写成zookeeper的ip端口，否则无法收集到日志）
    bootstrap_servers => "localhost:9092"
    #此处是我前面提到的topic名称
    topics => ["testlog"]
    auto_offset_reset => "latest"
  }
}
 
output {
    elasticsearch {
       #es的Ip和端口
       hosts => ["localhost:9200"]
    }
}
```
- 在安装目录下，通过命令启动

```java
bin\logstash -f config\logstash.conf
```
> 使用kafka接收日志呢是为了减少logstash对于日志进入时的压力。kafka的特性使用过的人应该都清楚，拥有这10W级别每秒的单机吞吐量，所以很适合作为数据来源缓冲区
## 4.5 启动kibana
- 直接进入kibana的下载安装目录，进入bin目录点击启动kibana.bat即可。在config目录中，有一个配置文件，里面有如下几行配置：

```java
i18n.locale: "zh-CN"
server.host: "127.0.0.1"
elasticsearch.hosts: ["http://localhost:9200/"]
```
- 双机bin中的启动文件启动就行
## 4.6 SpringBoot项目
- 新建全新的Springboot项目
- 导入依赖

```xml
<dependencies>
       <dependency>
           <groupId>org.springframework.boot</groupId>
           <artifactId>spring-boot-starter-web</artifactId>
       </dependency>
       <!-- https://mvnrepository.com/artifact/com.github.danielwegener/logback-kafka-appender -->
       <dependency>
           <groupId>com.github.danielwegener</groupId>
           <artifactId>logback-kafka-appender</artifactId>
           <version>0.2.0-RC2</version>
       </dependency>
       <dependency>
           <groupId>org.springframework.kafka</groupId>
           <artifactId>spring-kafka</artifactId>
       </dependency>
   </dependencies>
```
- 编写配置文件application.properties

```java
spring.application.name=fast-elk-example
spring.kafka.bootstrap-servers=127.0.0.1:9092
spring.kafka.producer.retries=0
spring.kafka.producer.batch-size=16384
spring.kafka.producer.buffer-memory=33554432
spring.kafka.producer.key-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.producer.value-serializer=org.apache.kafka.common.serialization.StringSerializer
spring.kafka.consumer.group-id=consumer-tutorial
spring.kafka.consumer.auto-commit-interval=100
spring.kafka.consumer.auto-offset-reset=earliest
spring.kafka.consumer.enable-auto-commit=true
spring.kafka.consumer.key-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.value-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.listener.concurrency=3
```
- 在resource目录下新建logback-spring.xml文件，内容如下

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- scan：当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true。 scanPeriod：设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，
	默认单位是毫秒当scan为true时，此属性生效。默认的时间间隔为1分钟。 debug：当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。
	默认值为false。 -->
<!-- <configuration scan="false" scanPeriod="60 seconds" debug="false"> -->

<configuration>

    <!--设置上下文名称,用于区分不同应用程序的记录。一旦设置不能修改, 可以通过%contextName来打印日志上下文名称 -->
    <contextName>kafka-log-test</contextName>
    <!-- 定义日志的根目录 -->
    <property name="logDir" value="E:/kafaka/kafka_2.12-2.8.0/kafka-logs" />
    <!-- 定义日志文件名称 -->
    <property name="logName" value="kafkaLog"></property>


    <!-- ConsoleAppender 表示控制台输出 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <!-- 日志输出格式： %d表示日期时间， %thread表示线程名， %-5level：级别从左显示5个字符宽度, %logger{50}
            表示logger名字最长50个字符，否则按照句点分割。 %msg：日志消息， %n是换行符 -->
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} %contextName [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- 异常错误日志记录到文件  -->
    <appender name="logfile" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- <Encoding>UTF-8</Encoding> -->
        <File>${logDir}/${logName}.log</File>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <FileNamePattern>${logDir}/history/test_log.%d{yyyy-MM-dd}.rar</FileNamePattern>
            <maxHistory>30</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} %contextName [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>


    <appender name="kafkaAppender" class="com.github.danielwegener.logback.kafka.KafkaAppender">
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
        <!-- 此处为kafka的Topic名称，千万不要写错 -->
        <topic>testlog</topic>
        <!-- we don't care how the log messages will be partitioned  -->
        <keyingStrategy class="com.github.danielwegener.logback.kafka.keying.NoKeyKeyingStrategy" />
        <!-- use async delivery. the application threads are not blocked by logging -->
        <deliveryStrategy class="com.github.danielwegener.logback.kafka.delivery.AsynchronousDeliveryStrategy" />
        <!-- each <producerConfig> translates to regular kafka-client config (format: key=value) -->
        <!-- producer configs are documented here: https://kafka.apache.org/documentation.html#newproducerconfigs -->
        <!-- bootstrap.servers is the only mandatory producerConfig -->
        <producerConfig>bootstrap.servers=localhost:9092</producerConfig>
        <!-- don't wait for a broker to ack the reception of a batch.  -->
        <producerConfig>acks=0</producerConfig>
        <!-- wait up to 1000ms and collect log messages before sending them as a batch -->
        <producerConfig>linger.ms=1000</producerConfig>
        <!-- even if the producer buffer runs full, do not block the application but start to drop messages -->
        <producerConfig>max.block.ms=0</producerConfig>
        <!-- define a client-id that you use to identify yourself against the kafka broker -->
        <producerConfig>client.id=0</producerConfig>

    </appender>
    <root level="debug">
        <appender-ref ref="CONSOLE" />
        <appender-ref ref="logfile"/>
        <appender-ref ref="kafkaAppender" />
    </root>

</configuration>
```
- 编写controller，输出日志

```java
/**
 * @author cVzhanshi
 * @create 2021-08-12 16:34
 */
@RestController
public class TestController {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @GetMapping("/test")
    public String test(String name){
        logger.info("hello: {}",name);
        return "hello world" ;
    }
}
```
- 启动项目
![在这里插入图片描述](https://img-blog.csdnimg.cn/1358a37736a548febeaa68b7d2594261.png)
## 4.7 测试
- 在浏览器一直访问http://localhost:8080/test?name=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa，多输出点日志
- 打开kibana界面(localhost:5601)
![在这里插入图片描述](https://img-blog.csdnimg.cn/dd0172c4e350431797d8de38aa8c058b.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
-----
![在这里插入图片描述](https://img-blog.csdnimg.cn/8fdf3c13cc7f4e6e934dd099dc5ff667.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
-----
![在这里插入图片描述](https://img-blog.csdnimg.cn/63065d6d8ae34657af9ccadb76649516.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
----
![在这里插入图片描述](https://img-blog.csdnimg.cn/46ec49bca6884157bd81f019699a66e3.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
-----
![在这里插入图片描述](https://img-blog.csdnimg.cn/ae00677a2f294692be1f287e6f892eb1.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
还提供了搜索功能
![在这里插入图片描述](https://img-blog.csdnimg.cn/65127ce7d00e4229b69258e0419ff738.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70) 
# ⑤ 总结
1、整个框架搭建完成后，全部启动会发现kibana中并没有日志显示。后来一步步慢慢分析，先使用logstash自带的tcp方式与logback整合，收集日志，发现是可以引入到es中并在kibana中显示。于是推断是logback和kafka整合出了问题。所以只能从kafka入手，先看了我存放日志文件的目录:
![在这里插入图片描述](https://img-blog.csdnimg.cn/4926b1c1c4fa4d3a8697ae3eee5e4902.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
发现这个文件中大小一直是0kb，由此可见项目的日志根本没有收集到kafka中。检查了logback中的topic配置无误，然后又检查了kafka的topic列表，最终通过删除所有原先的topic和相关日志，重新创建解决了这个kafka收集项目日志的问题。但最终发现，日志还是没有通过logstash进入到es中，接着继续排查，发现是logstash的配置文件问题。



