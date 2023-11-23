# 一、Redis的概述与安装

## 1.1 NoSQL数据库简介

NoSQL(NoSQL = **Not Only SQL** )，意即“不仅仅是SQL”，泛指**非关系型的数据库**。 

NoSQL 不依赖业务逻辑方式存储，而以简单的key-value模式存储。因此大大的增加了数据库的扩展能力。

- 不遵循SQL标准。
- 不支持ACID。
- 远超于SQL的性能。

**NoSQL适用场景**  

- 对数据高并发的读写
- 海量数据的读写
- 对数据高可扩展性的

**NoSQL不适用场景**

- 需要事务支持
- 基于sql的结构化查询存储，处理复杂的关系,需要即席查询。
- **（用不着sql**的和用了sql也不行的情况，请考虑用NoSql）

**行式数据库**

![1627008126714](Redis6.assets/1627008126714.png)

**列式数据库**

![1627008141257](Redis6.assets/1627008141257.png)

## 1.2 Redis概述

- Redis是一个开源的key-value存储系统。
- 和Memcached类似，它支持存储的value类型相对更多，包括string(字符串)、list(链表)、set(集合)、zset(sorted set --有序集合)和hash（哈希类型）。
- 这些数据类型都支持push/pop、add/remove及取交集并集和差集及更丰富的操作，而且这些操作都是原子性的。
- 在此基础上，Redis支持各种不同方式的排序。
- 与memcached一样，为了保证效率，数据都是缓存在内存中。
- 区别的是Redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件。并且在此基础上实现了主从同步。

## 1.3 Redis安装

### 1.3.1 官网下载

> Redis官网 [Redis](https://redis.io/) 

![1627009536509](Redis6.assets/1627009536509.png)

### 1.3.2 安装

- 准备工作

  - 将下载好的Redis上传到Linux的/opt目录下
  - Linux要具备gcc环境

  ```bash
  #查看是否有gcc环境
  gcc --version
  #安装gcc
  yum -y gcc
  ```

- 解压上传的文件

```bash
tar -zxvf redis-6.2.1.tar.gz
```

- 解压完成后进入目录

```bash
cd redis-6.2.1
```

- 在redis-6.2.1目录下再次执行make命令

```bash
make
```

> 说明：如果没有准备好C语言编译环境，make 会报错—Jemalloc/jemalloc.h：没有那个文件
>
> ![1627011703046](Redis6.assets/1627011703046.png)
>
> 解决办法：1、运行make distclean
>
> ​					2、在redis-6.2.1目录下再次执行make命令

- 跳过make test 继续执行: make install

![1627011804877](Redis6.assets/1627011804877.png)

- 安装目录：/usr/local/bin

> 查看默认安装目录：
>
> redis-benchmark:性能测试工具，可以在自己本子运行，看看自己本子性能如何
>
> redis-check-aof：修复有问题的AOF文件，rdb和aof后面讲
>
> redis-check-dump：修复有问题的dump.rdb文件
>
> redis-sentinel：Redis集群使用
>
> redis-server：Redis服务器启动命令
>
> redis-cli：客户端，操作入口

### 1.3.3 Redis的启动

**前台启动**（不推荐）

>  前台启动，命令行窗口不能关闭，否则服务器停止
>
> 直接在安装目录下运行redis-server

![1627012614013](Redis6.assets/1627012614013.png)

**后台运行**（推荐）

- 先备份redis.conf

```bash
cp redis.conf /etc/redis-conf
```

- 修改/etc/redis.conf(128行)文件将里面的daemonize no 改成 yes，让服务在后台启动

- 启动redis

```bash
redis-server /etc/redis-conf # 配置文件一定是要修改了daemonize的
```

- 查看进程

![1627019209102](Redis6.assets/1627019209102.png)

- 打开客户端

> 在安装目录打开

```bash
redis-cli
```

![1627019796574](Redis6.assets/1627019796574.png)

### 1.3.4 Redis的关闭

- 退出客户端-exit

- 在客户端中输入shundown
- 杀死redis进程

```bash
ps -ef | grep redis # 先查看进程号
kill -9 PID
```

### 1.3.5 Redis的基本介绍

- 默认16个数据库，类似数组下标从0开始，初始默认使用0号库
- 使用命令 select  <dbid>来切换数据库。如: select 8
- 统一密码管理，所有库同样密码
- dbsize查看当前数据库的key的数量
- flushdb清空当前库
- flushall通杀全部库
- **Redis是单线程+多路IO复用技术**  

> 多路复用是指使用一个线程来检查多个文件描述符（Socket）的就绪状态，比如调用select和poll函数，传入多个文件描述符，如果有一个文件描述符就绪，则返回，否则阻塞直到超时。得到就绪状态后进行真正的操作可以在同一个线程里执行，也可以启动线程执行（比如使用线程池。

**（与Memcache三点不同: 支持多数据类型，支持持久化，单线程+多路IO复用）**  

# 二、Redis五大常用的数据类型

## 2.1 Redis键（key）

**关于key的一些命令**

| 命令          | 作用                                                         |
| ------------- | ------------------------------------------------------------ |
| keys *        | 查看当前库所有key                                            |
| exists key    | 判断某个key是否存在                                          |
| type key      | 查看你的key是什么类型                                        |
| del key       | 删除指定的key数据                                            |
| unlink key    | 根据value选择非阻塞删除<br />仅将keys从keyspace元数据中删除，真正的删除会在后续异步操作 |
| expire key 10 | 10秒钟：为给定的key设置过期时间                              |
| ttl key       | 查看还有多少秒过期，-1表示永不过期，-2表示已过期             |
| selec id      | 命令切换数据库                                               |
| dbsize        | 查看当前数据库的key的数量                                    |
| flushdb       | 清空当前库                                                   |
| flushall      | 通杀全部库                                                   |

## 2.2  Redis 字符串(String)

### 2.2.1 概述

- String是Redis最基本的类型，你可以理解成与Memcached一模一样的类型，一个key对应一个value。

- String类型是**二进制安全的**。意味着Redis的string可以包含任何数据。比如jpg图片或者序列化的对象。

- String类型是Redis最基本的数据类型，一个Redis中字符串value最多可以是512M

### 2.2.2 常用命令

| 命令                                      | 作用                                                         |
| ----------------------------------------- | ------------------------------------------------------------ |
| set  <key><value>                         | 添加键值对                                                   |
| get  <key>                                | 查询对应键值                                                 |
| append <key><value>                       | 将给定的<value> 追加到原值的末尾                             |
| strlen <key>                              | 获得值的长度                                                 |
| setnx <key><value>                        | 只有在 key 不存在时  设置 key 的值                           |
| incr <key>                                | 将 key 中储存的数字值增1<br />只能对数字值操作，如果为空，新增值为1 |
| decr <key>                                | 将 key 中储存的数字值减1<br />只能对数字值操作，如果为空，新增值为-1 |
| incrby / decrby <key><步长>               | 将 key 中储存的数字值增减。自定义步长。                      |
| mset <key1><value1><key2><value2>.....    | 同时设置一个或多个 key-value对                               |
| mget <key1><key2><key3> .....             | 同时获取一个或多个 value                                     |
| msetnx <key1><value1><key2><value2> ..... | 同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。 |
| getrange <key><起始位置><结束位置>        | 获得值的范围，类似java中的substring，**前包，后包**          |
| setrange <key><起始位置><value>           | 用 <value> 覆写<key>所储存的字符串值，从<起始位置>开始(**索引从0开始**) |
| setex <过期时间> <value>                  | 设置键值的同时，设置过期时间，单位秒。                       |
| getset <key><value>                       | 以新换旧，设置了新值同时获得旧值。                           |

**原子性**

**所谓原子操作是指不会被线程调度机制打断的操作**；

这种操作一旦开始，就一直运行到结束，中间不会有任何 context switch （切换到另一个线程）。

（1）在单线程中， 能够在单条指令中完成的操作都可以认为是"原子操作"，因为中断只能发生于指令之间。

（2）在多线程中，不能被其它进程（线程）打断的操作就叫原子操作。

**Redis单命令的原子性主要得益于的单线程**。

案例：

> java中的i++是否是原子操作？**不是**
>
> i=0;两个线程分别对进行次值是多少？ 2~200
>
> ![1627026274948](Redis6.assets/1627026274948.png)

-----

- set  <key><value>  添加键值对

![1627026805369](Redis6.assets/1627026805369.png)

- get  <key>查询对应键值

![1627026853953](Redis6.assets/1627026853953.png)

- append <key><value>将给定的<value> 追加到原值的末尾

![1627026883457](Redis6.assets/1627026883457.png)

- strlen <key>获得值的长度

![1627026903733](Redis6.assets/1627026903733.png)

- setnx <key><value>只有在 key 不存在时  设置 key 的值  

![1627027168679](Redis6.assets/1627027168679.png)

- incr <key>

  将 key 中储存的数字值增1

  只能对数字值操作，如果为空，新增值为1

![1627027264362](Redis6.assets/1627027264362.png)

- decr <key>

  将 key 中储存的数字值减1

  只能对数字值操作，如果为空，新增值为-1

![1627027290513](Redis6.assets/1627027290513.png)

- incrby / decrby <key><步长>将 key 中储存的数字值增减。自定义步长。

![1627027324172](Redis6.assets/1627027324172.png)

- mset <key1><value1><key2><value2> ..... 同时设置一个或多个 key-value 

![1627027374556](Redis6.assets/1627027374556.png)

- mget <key1><key2><key3> .....  同时获取一个或多个 value

![1627027417377](Redis6.assets/1627027417377.png)

- msetnx <key1><value1><key2><value2> .....  

  同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。

![1627027510206](Redis6.assets/1627027510206.png)

- getrange <key><起始位置><结束位置>

  获得值的范围，类似java中的substring，**前包，后包**

![1627027578059](Redis6.assets/1627027578059.png)

- setrange <key><起始位置><value>

  用 <value> 覆写<key>所储存的字符串值，从<起始位置>开始(**索引从0****开始**)。

![1627027641106](Redis6.assets/1627027641106.png)

-   setex <过期时间> <value>          设置键值的同时，设置过期时间，单位秒  

![1627027722931](Redis6.assets/1627027722931.png)

- getset <key><value>

  以新换旧，设置了新值同时获得旧值。

![1627027893760](Redis6.assets/1627027893760.png)

### 2.2.3 数据结构

> String的数据结构为简单动态字符串(Simple Dynamic String,缩写SDS)。是可以修改的字符串，内部结构实现上类似于Java的ArrayList，采用预分配冗余空间的方式来减少内存的频繁分配.

![1627027920117](Redis6.assets/1627027920117.png)

如图中所示，内部为当前字符串实际分配的空间capacity一般要高于实际字符串长度len。当字符串长度小于1M时，扩容都是加倍现有的空间，如果超过1M，扩容时一次只会多扩1M的空间。需要注意的是字符串最大长度为512M。

## 2.3 Redis 列表(List)

### 2.3.1 概述

- 单键多值

- Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。

- 它的底层实际是个双向链表，对两端的操作性能很高，通过索引下标的操作中间的节点性能会较差。

![1627029927895](Redis6.assets/1627029927895.png)

### 2.3.2 常用命令

| 命令                                           | 作用                                           |
| ---------------------------------------------- | ---------------------------------------------- |
| lpush/rpush <key><value1><value2><value3> .... | 从左边/右边插入一个或多个值                    |
| lpop/rpop <key> <n>                            | 从左边/右边吐出n个值。**值在键在，值光键亡**。 |
| rpoplpush <key1><key2>                         | 从<key1>列表右边吐出一个值，插到<key2>列表左边 |
| lrange <key><start><stop>                      | 按照索引下标获得元素(从左到右)                 |
| lrange mylist 0 -1                             | 0左边第一个，-1右边第一个，（0-1表示获取所有） |
| lindex <key><index>                            | 按照索引下标获得元素(从左到右)                 |
| llen <key>                                     | 获得列表长度                                   |
| linsert <key> before <value><newvalue>         | 在<value>的后面插入<newvalue>插入值            |
| lrem <key><n><value>                           | 从左边删除n个value(从左到右)                   |
| lset<key><index><value>                        | 将列表key下标为index的值替换成value            |

- lpush/rpush <key><value1><value2><value3> .... 

  从左边/右边插入一个或多个值

- lrange <key><start><stop>

  按照索引下标获得元素(从左到右)

![1627031446678](Redis6.assets/1627031446678.png)

![1627031787436](Redis6.assets/1627031787436.png)

> 说明：因为lrange是从左到右的，左边push类似于一个单道管道，先进去的在后面

![1627031561532](Redis6.assets/1627031561532.png)

![1627031796513](Redis6.assets/1627031796513.png)

> 说明：因为lrange是从左到右的，右边push则是正常的

- lpop/rpop <key><n>从左边/右边吐出n个值（n可以省略，默认1）。值在键在，值光键亡。

![1627031957170](Redis6.assets/1627031957170.png)

-----

![1627032024153](Redis6.assets/1627032024153.png)

- rpoplpush <key1><key2>  从<key1>列表右边吐出一个值，插到<key2>列表左边。![1627032124070](Redis6.assets/1627032124070.png)

- lindex <key><index>   按照索引下标获得元素(从左到右)

![1627032167129](Redis6.assets/1627032167129.png)

- llen <key>获得列表长度  

![1627032193367](Redis6.assets/1627032193367.png)

- linsert <key> before <value><newvalue>    在<value>的后面插入<newvalue>插入值

![1627032410397](Redis6.assets/1627032410397.png)

- lrem <key><n><value>  从左边删除n个value(从左到右)

![1627032468001](Redis6.assets/1627032468001.png)

- lset<key><index><value>  将列表key下标为index的值替换成value

![1627032499973](Redis6.assets/1627032499973.png)

### 2.3.3 数据结构

List的数据结构为快速链表quickList。

> 首先在列表元素较少的情况下会使用一块连续的内存存储，这个结构是ziplist，也即是压缩列表。
>
> 它将所有的元素紧挨着一起存储，分配的是一块连续的内存。
>
> 当数据量比较多的时候才会改成quicklist。
>
> 因为普通的链表需要的附加指针空间太大，会比较浪费空间。比如这个列表里存的只是int类型的数据，结构上还需要两个额外的指针prev和next。
>
> ![1627032551539](Redis6.assets/1627032551539.png)
>
> Redis将链表和ziplist结合起来组成了quicklist。也就是将多个ziplist使用双向指针串起来使用。这样既满足了快速的插入删除性能，又不会出现太大的空间冗余。

## 2.4 Redis 集合(Set)

### 2.4.1 概述

- Redis set对外提供的功能与list类似是一个列表的功能，特殊之处在于set是可以**自动排重**的，当你需要存储一个列表数据，又不希望出现重复数据时，set是一个很好的选择，并且set提供了判断某个成员是否在一个set集合内的重要接口，这个也是list所不能提供的。
- Redis的Set是string类型的无序集合。它底层其实是一个value为null的hash表，所以添加，删除，查找的**复杂度都是**O(1)。

- 一个算法，随着数据的增加，执行时间的长短，如果是O(1)，数据增加，查找数据的时间不变

### 2.4.2 常用命令

- sadd <key><value1><value2> ..... 
  - 将一个或多个 member 元素加入到集合 key 中，已经存在的 member 元素将被忽略
- smembers <key>
  - 取出该集合的所有值。
- sismember <key><value>
  - 判断集合<key>是否为含有该<value>值，有1，没有0
- scard<key>
  - 返回该集合的元素个数。
- srem <key><value1><value2> .... 
  - 删除集合中的某个元素。
- spop <key>
  - **随机从该集合中吐出一个值。**
- srandmember <key><n>
  - 随机从该集合中取出n个值。不会从集合中删除 。
- smove <source><destination>value
  - 把集合中一个值从一个集合移动到另一个集合
- sinter <key1><key2>
  - 返回两个集合的交集元素。
- sunion <key1><key2>
  - 返回两个集合的并集元素。
- sdiff <key1><key2>
  - 返回两个集合的**差集**元素(key1中的，不包含key2中的)

-----

**测试**

- sadd <key><value1><value2> .....   将一个或多个 member 元素加入到集合 key 中，已经存在的 member 元素将被忽略

![1627034233011](Redis6.assets/1627034233011.png)

- smembers <key> 取出该集合的所有值。

![1627034286352](Redis6.assets/1627034286352.png)

- sismember <key><value>   判断集合<key>是否为含有该<value>值，有1，没有0

![1627034328930](Redis6.assets/1627034328930.png)

- scard<key>  返回元素的个数

![1627034381489](Redis6.assets/1627034381489.png)

- srem <key><value1><value2> ....    删除集合中的某个元素。

![1627034445189](Redis6.assets/1627034445189.png)

- spop <key>   随机从集合中吐一个出来

![1627197163579](Redis6.assets/1627197163579.png)

- srandmember <key><n>  随机从该集合中取出n个值。不会从集合中删除 。

![1627197227197](Redis6.assets/1627197227197.png)

- smove <source><destination>  value把集合中一个值从一个集合移动到另一个集合

![1627197306070](Redis6.assets/1627197306070.png)

- sinter <key1><key2>返回两个集合的交集元素。

![1627197356295](Redis6.assets/1627197356295.png)

- sunion <key1><key2>返回两个集合的并集元素

![1627197392743](Redis6.assets/1627197392743.png)

- sdiff <key1><key2>返回两个集合的**差集**元素(key1中的，不包含key2中的)

![1627197422084](Redis6.assets/1627197422084.png)

### 2.4.3 数据结构

Set数据结构是dict字典，字典是用哈希表实现的。

Java中HashSet的内部实现使用的是HashMap，只不过所有的value都指向同一个对象。Redis的set结构也是一样，它的内部也使用hash结构，所有的value都指向同一个内部值。

## 2.5 Redis 哈希(Hash)

### 2.5.1 概述

Redis hash 是一个键值对集合。

Redis hash是一个string类型的field和value的映射表，hash特别适合用于存储对象。

类似Java里面的Map<String,Object>

用户ID为查找的key，存储的value用户对象包含姓名，年龄，生日等信息，如果用普通的key/value结构来存储主要有以下2种存储方式：

| ![1627265052625](Redis6.assets/1627265052625.png) | 每次修改用户的某个属性需要，先反序列化改好后再序列化回去。开销较大。 |
| ------------------------------------------------- | ------------------------------------------------------------ |
| ![1627265074253](Redis6.assets/1627265074253.png) | 用户ID数据冗余                                               |
| ![1627265077333](Redis6.assets/1627265077333.png) | **通过 key(用户ID) + field(属性标签) 就可以操作对应属性数据了，既不需要重复存储数据，也不会带来序列化和并发修改控制的问题** |

### 2.5.2 常用命令

- hset <key><field><value>	给<key>集合中的 <field>键赋值<value>
- hget <key1><field>	从<key1>集合<field>取出 value 
- hmset <key1><field1><value1><field2><value2>... 	批量设置hash的值
- hexists<key1><field>	查看哈希表 key 中，给定域 field 是否存在。 
- hkeys <key>	列出该hash集合的所有field
- hvals <key>	列出该hash集合的所有value
- hincrby <key><field><increment>	为哈希表 key 中的域 field 的值加上增量 1  -1
- hsetnx <key><field><value>	将哈希表 key 中的域 的值设置为 ，当且仅当域 不存在 

-----

**测试**

- hset <key><field><value>	给<key>集合中的 <field>键赋值<value>
- hget <key1><field>	从<key1>集合<field>取出 value 

![1627269598531](Redis6.assets/1627269598531.png)

- hexists<key1><field>	查看哈希表 key 中，给定域 field 是否存在。 存在返回1，不存在返回0

![1627269684060](Redis6.assets/1627269684060.png)

- hkeys <key>	列出该hash集合的所有field
- hvals <key>	列出该hash集合的所有value

![1627269745248](Redis6.assets/1627269745248.png)

- hincrby <key><field><increment>	为哈希表 key 中的域 field 的值加上增量 1或自定义的n(只针对整数)

![1627269816129](Redis6.assets/1627269816129.png)

- hsetnx <key><field><value>	将哈希表 key 中的域 的值设置为 ，当且仅当域 不存在 

![1627269933373](Redis6.assets/1627269933373.png)

### 2.5.3 数据结构

Hash类型对应的数据结构是两种：ziplist（压缩列表），hashtable（哈希表）。当field-value长度较短且个数较少时，使用ziplist，否则使用hashtable

## 2.6 Redis有序集合(Zset)

### 2.6.1 简介

- Redis有序集合zset与普通集合set非常相似，是一个没有重复元素的字符串集合。

- 不同之处是有序集合的每个成员都关联了一个**评分**（score）,这个评分（score）被用来按照从最低分到最高分的方式排序集合中的成员。集合的成员是唯一的，但是评分可以是重复了 。

- 因为元素是有序的, 所以你也可以很快的根据评分（score）或者次序（position）来获取一个范围的元素。

- 访问有序集合的中间元素也是非常快的,因此你能够使用有序集合作为一个没有重复成员的智能列表。

### 2.6.2 常用命令

| 命令                                                         | 作用                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| zadd <key><score1><value1><score2><value2>…                  | 将一个或多个 member 元素及其 score 值加入到有序集 key 当中。 |
| **zrange  [WITHSCORES]**                                     | 返回有序集 key 中，下标在<start><stop>之间的元素<br />带WITHSCORES，可以让分数一起和值返回到结果集。 |
| zrangebyscore key minmax [withscores] [limit offset count]   | 返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列 |
| zrevrangebyscore key maxmin [withscores] [limit offset count] | 同上，改为从大到小排列。                                     |
| zincrby <key><increment><value>                              | 为元素的score加上增量                                        |
| zrem <key><value>                                            | 删除该集合下，指定值的元素                                   |
| zcount <key><min><max>                                       | 统计该集合，分数区间内的元素个数                             |
| zrank <key><value>                                           | 返回该值在集合中的排名，从0开始。                            |

**测试**

- zadd <key><score1><value1><score2><value2>…  将一个或多个 member 元素及其 score 值加入到有序集 key 当中。  

- **zrange  [WITHSCORES]**  返回有序集 key 中，下标在<start><stop>之间的元素<br />带WITHSCORES，可以让分数一起和值返回到结果集。

![1627279078417](Redis6.assets/1627279078417.png)

- zrangebyscore key minmax [withscores] [limit offset count] 	返回有序集 key  值介于min  之间包括等于min  的成员。有序集成员按score (从小到大)次序排列  

![1627279233477](Redis6.assets/1627279233477.png)

- zrevrangebyscore key maxmin [withscores] [limit offset count]        

  同上，改为从大到小排列。

![1627279251809](Redis6.assets/1627279251809.png)

- zincrby <key><increment><value>   为元素的score加上增量

![1627279449221](Redis6.assets/1627279449221.png)

- zrem <key><value>删除该集合下，指定值的元素   

![1627279560995](Redis6.assets/1627279560995.png)

- zcount <key><min><max>统计该集合，分数区间内的元素个数  

![1627279613229](Redis6.assets/1627279613229.png)

- zrank <key><value>返回该值在集合中的排名，从0开始  

![1627279653794](Redis6.assets/1627279653794.png)

### 2.6.3 数据结构

SortedSet(zset)是Redis提供的一个非常特别的数据结构，一方面它等价于Java的数据结构Map<String,Double>，可以给每一个元素value赋予一个权重score，另一方面它又类似于TreeSet，内部的元素会按照权重score进行排序，可以得到每个元素的名次，还可以通过score的范围来获取元素的列表。

**zset底层使用了两个数据结构**

（1）hash，hash的作用就是关联元素value和权重score，保障元素value的唯一性，可以通过元素value找到相应的score值。

（2）跳跃表，跳跃表的目的在于给元素value排序，根据score的范围获取元素列表。

### 2.6.4 跳跃表

**简介**

> 有序集合在生活中比较常见，例如根据成绩对学生排名，根据得分对玩家排名等。对于有序集合的底层实现，可以用数组、平衡树、链表等。数组不便元素的插入、删除；平衡树或红黑树虽然效率高但结构复杂；链表查询需要遍历所有效率低。Redis采用的是跳跃表。跳跃表效率堪比红黑树，实现远比红黑树简单。

**实例**

  对比有序链表和跳跃表，从链表中查询出51

（1）  有序链表

​        ![1627280052116](Redis6.assets/1627280052116.png)        

要查找值为51的元素，需要从第一个元素开始依次查找、比较才能找到。共需要6次比较。

（2）  跳跃表

  ![1627280061527](Redis6.assets/1627280061527.png)

从第2层开始，1节点比51节点小，向后比较。

21节点比51节点小，继续向后比较，后面就是NULL了，所以从21节点向下到第1层

在第1层，41节点比51节点小，继续向后，61节点比51节点大，所以从41向下

在第0层，51节点为要查找的节点，节点被找到，共查找4次。

从此可以看出**跳跃表比有序链表效率要高**

# 三、Redis配置文件的介绍

- **Units单位**  

> 配置大小单位,开头定义了一些基本的度量单位，只支持bytes，不支持bit
>
> 大小写不敏感

![1627293075477](Redis6.assets/1627293075477.png)

------

- **INCLUDES包含**  

> 类似jsp中的include，多实例的情况可以把公用的配置文件提取出来

![1627293133006](Redis6.assets/1627293133006.png)

-----

- **网络相关配置**  

  - bind

  > - 默认情况bind=127.0.0.1只能接受本机的访问请求
  >
  > - 不写的情况下，无限制接受任何ip
  >
  > - 生产环境肯定要写你应用服务器的地址；服务器是需要远程访问的，所以需要将其注释掉
  >
  > - 如果开启了protected-mode，那么在没有设定bind ip且没有设密码的情况下，Redis只允许接受本机的响应  

  ![1627293271954](Redis6.assets/1627293271954.png)
  - **protected-mode**  

  > 将本机访问保护模式设置no

  ![1627293329489](Redis6.assets/1627293329489.png)

  - **PORT**

  > 端口号

  ![1627293365072](Redis6.assets/1627293365072.png)

  - **tcp-backlog**  

  > 设置tcp的backlog，backlog其实是一个连接队列，backlog队列总和=未完成三次握手队列 + 已经完成三次握手队列。
  >
  > 在高并发环境下你需要一个高backlog值来避免慢客户端连接问题。
  >
  > 注意Linux内核会将这个值减小到/proc/sys/net/core/somaxconn的值（128），所以需要确认增大/proc/sys/net/core/somaxconn和/proc/sys/net/ipv4/tcp_max_syn_backlog（128）两个值来达到想要的效果

  ![1627293522374](Redis6.assets/1627293522374.png)
  - timeout

  > 一个空闲的客户端维持多少秒会关闭，0表示关闭该功能。即永不关闭  

  ![1627293556560](Redis6.assets/1627293556560.png)

  - **tcp-keepalive**  

  > 对访问客户端的一种心跳检测，每个n秒检测一次。
  >
  > 单位为秒，如果设置为0，则不会进行Keepalive检测，建议设置成60 

  ![1627293616885](Redis6.assets/1627293616885.png)

- **GENERAL通用**  
  - daemonize

  > 是否为后台进程，设置为yes
  >
  > 守护进程，后台启动

  ![1627348166864](Redis6.assets/1627348166864.png)

  - pidfile

  > 存放pid文件的位置，每个实例会产生一个不同的pid文件

   ![1627348228767](Redis6.assets/1627348228767.png)
  - loglevel

  > 指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为**notice**  
  >
  > 四个级别根据使用阶段来选择，生产环境选择notice 或者warning

  ![1627348296662](Redis6.assets/1627348296662.png)

  - logfile

  > 日志文件名称

  ![1627348350089](Redis6.assets/1627348350089.png)

  - databases 16

  > 设定库的数量 默认16，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id  

  ![1627348418889](Redis6.assets/1627348418889.png)

- SECURITY安全

  - 设置密码

  ![1627348666158](Redis6.assets/1627348666158.png)

  > 访问密码的查看、设置和取消
  >
  > 在命令中设置密码，只是临时的。重启redis服务器，密码就还原了。
  >
  > 永久设置，需要再配置文件中进行设置。

  ![1627348706889](Redis6.assets/1627348706889.png)

- LIMITS限制
  - **maxclients**

  > 设置redis同时可以与多少个客户端进行连接。
  >
  > 默认情况下为10000个客户端。
  >
  > 如果达到了此限制，redismax number of clients reached

  ![1627348766574](Redis6.assets/1627348766574.png)
  - **maxmemory** 

  > 1. 建议**必须设置**，否则，将内存占满，造成服务器宕机
  > 2. 设置redis可以使用的内存量。一旦到达内存使用上限，redis将会试图移除内部数据，移除规则可以通过maxmemory-policy来指定。
  > 3. 如果redis无法根据移除规则来移除内存中的数据，或者设置了“不允许移除”，那么redis则会针对那些需要申请内存的指令返回错误信息，比如SET、LPUSH等。
  > 4. 但是对于无内存申请的指令，仍然会正常响应，比如GET等。如果你的redis是主redis（说明你的redis有从redis），那么在设置内存使用上限时，需要在系统中留出一些内存空间给同步队列缓存，只有在你设置的是“不移除”的情况下，才不用考虑这个因素。

  ![1627348824359](Redis6.assets/1627348824359.png)
  - **maxmemory-policy**  

  > 1.  volatile-lru：使用LRU算法移除key，只对设置了过期时间的键；（最近最少使用）
  > 2. allkeys-lru：在所有集合key中，使用LRU算法移除key
  > 3. volatile-random：在过期集合中移除随机的key，只对设置了过期时间的键
  > 4. allkeys-random：在所有集合key中，移除随机的key
  > 5.  volatile-ttl：移除那些TTL值最小的key，即那些最近要过期的key
  > 6. noeviction：不进行移除。针对写操作，只是返回错误信息

  ![1627348882025](Redis6.assets/1627348882025.png)

  - **maxmemory-samples**

  > 1. 设置样本数量，LRU算法和最小TTL算法都并非是精确的算法，而是估算值，所以你可以设置样本的大小，redis默认会检查这么多个key并选择其中LRU的那个。
  > 2. 一般设置3到7的数字，数值越小样本越不准确，但性能消耗越小。

  ![1627348942753](Redis6.assets/1627348942753.png)

# 四、Redis的发布和订阅

> 什么是发布和订阅？
>
> - Redis 发布订阅 (pub/sub) 是一种消息通信模式：发送者 (pub) 发送消息，订阅者 (sub) 接收消息。
> - Redis 客户端可以订阅任意数量的频道。

-----

1、客户端可以订阅频道如下图

​                   ![1627350602387](Redis6.assets/1627350602387.png)      

2、当给这个频道发布消息后，消息就会发送给订阅的客户端

  	![1627350607364](Redis6.assets/1627350607364.png)


 	

**演示**：

- 打开一个客户端订阅channel1

  SUBSCRIBE channel1

![1627350763425](Redis6.assets/1627350763425.png)

- 打开另一个客户端，给channel1发布消息hello

  publish channel1 hello

![1627350791655](Redis6.assets/1627350791655.png)

> 返回的1是订阅者数量

- 打开第一个客户端可以看到发送的消息  

![1627350824342](Redis6.assets/1627350824342.png)

> 注：发布的消息没有持久化，如果在订阅的客户端收不到hello，只能收到订阅后发布的消息

# 五、Redis新数据类型

## 5.1  Bitmaps

### 5.1.1 简介

> 现代计算机用二进制（位） 作为信息的基础单位， 1个字节等于8位， 例如“abc”字符串是由3个字节组成， 但实际在计算机存储时将其用二进制表示， “abc”分别对应的ASCII码分别是97、 98、 99， 对应的二进制分别是01100001、 01100010和01100011，如下图
>
> ![1627356639595](Redis6.assets/1627356639595.png)
>
> 合理地使用操作位能够有效地提高内存使用率和开发效率。

Redis提供了Bitmaps这个“数据类型”可以实现对位的操作：

1. Bitmaps本身不是一种数据类型， **实际上它就是字符串**（key-value） ， 但是它可以对字符串的位进行操作。
2. Bitmaps单独提供了一套命令，所以在中使用和使用字符串的方法不太相同。**可以把想象成一个以位为单位的数组，数组的每个单元只能存储0和1，数组的下标在中叫做偏移量**

![1627356715585](Redis6.assets/1627356715585.png)

### 5.1.2 命令

- **setbit**  

语法

```bash
setbit<key><offset><value>设置Bitmaps中某个偏移量的值（0或1）# offset:偏移量从0开始
```

实例

每个独立用户是否访问过网站存放在Bitmaps中， 将访问的用户记做1， 没有访问的用户记做0， 用偏移量作为用户的id。

设置键的第offset个位的值（从0算起） ， 假设现在有20个用户，userid=1， 6， 11， 15， 19的用户对网站进行了访问， 那么当前Bitmaps初始化结果如图

![1627379869667](Redis6.assets/1627379869667.png)

users:20000911代表2000-09-11这天的独立访问用户的Bitmaps  

![1627380021024](Redis6.assets/1627380021024.png)

**注**：

> - 很多应用的用户id以一个指定数字（例如10000） 开头， 直接将用户id和Bitmaps的偏移量对应势必会造成一定的浪费， 通常的做法是每次做setbit操作时将用户id减去这个指定数字。
>
> - 在第一次初始化Bitmaps时， 假如偏移量非常大， 那么整个初始化过程执行会比较慢， 可能会造成Redis的阻塞。

-----

- **getbit**

```bash
getbit<key><offset> # 获取Bitmaps中某个偏移量的值
```

**实例**

获取id=8的用户是否在2020-11-06这天访问过， 返回0说明没有访问过  

![1627395250688](Redis6.assets/1627395250688.png)

注：因为12根本不存在，所以也是返回0

- **bitcount**  

> 统计**字符串**被设置为1的bit数。一般情况下，给定的整个字符串都会被进行计数，通过指定额外的 start 或 end 参数，可以让计数只在特定的位上进行。start 和 end 参数的设置，都可以使用负数值：比如 -1 表示最后一个位，而 -2 表示倒数第二个位，start、end 是指bit组的字节的下标数，二者皆包含。

 **实例**

计算2000年9月11访问量

![1627395446570](Redis6.assets/1627395446570.png)

start和end代表起始和结束字节数， 下面操作计算用户id在第1个字节到第3个字节之间的独立访问用户数， 对应的用户id是 15，9 

![1627395516828](Redis6.assets/1627395516828.png)

**举例**： K1 【01000001 01000000 00000000 00100001】，对应【0，1，2，3】

1、bitcount K1 1 2 ： 统计下标1、2字节组中bit=1的个数，即01000000 00000000

--》bitcount K1 1 2 　　--》1

2、bitcount K1 1 3 ： 统计下标1、2字节组中bit=1的个数，即01000000 00000000 00100001

--》bitcount K1 1 3　　--》3

3、bitcount K1 0 -2 ： 统计下标0到下标倒数第2，字节组中bit=1的个数，即01000001 01000000  00000000

--》bitcount K1 0 -2　　--》3

 注意：redis的setbit设置或清除的是bit位置，而bitcount计算的是byte位置。

- **bitop**  

```bash
bitop  and(or/not/xor) <destkey> [key…]
#bitop是一个复合操作， 它可以做多个Bitmaps的and（交集） 、 or（并集） 、 not（非） 、 xor（异或） 操作并将结果保存在destkey中。
```

**实例**

2020-11-04 日访问网站的userid=1,2,5,9。

setbit unique:users:20201104 1 1

setbit unique:users:20201104 2 1

setbit unique:users:20201104 5 1

setbit unique:users:20201104 9 1

 

2020-11-03 日访问网站的userid=0,1,4,9。

setbit unique:users:20201103 0 1

setbit unique:users:20201103 1 1

setbit unique:users:20201103 4 1

setbit unique:users:20201103 9 1

**计算出两天都访问过网站的用户数量**

```bash
bitop and unique:users:and:20201104_03  unique:users:20201103unique:users:20201104
```

![1627395999686](Redis6.assets/1627395999686.png)

![1627396007302](Redis6.assets/1627396007302.png)

### 5.1.3 Bitmaps与set对比

假设网站有1亿用户， 每天独立访问的用户有5千万， 如果每天用集合类型和Bitmaps分别存储活跃用户可以得到表

| set和Bitmaps存储一天活跃用户对比 |                    |                  |                        |
| -------------------------------- | ------------------ | ---------------- | ---------------------- |
| 数据类型                         | 每个用户id占用空间 | 需要存储的用户量 | 全部内存量             |
| 集合类型                         | 64位               | 50000000         | 64位*50000000 = 400MB  |
| Bitmaps                          | 1位                | 100000000        | 1位*100000000 = 12.5MB |

很明显， 这种情况下使用Bitmaps能节省很多的内存空间， 尤其是随着时间推移节省的内存还是非常可观的

| set和Bitmaps存储独立用户空间对比 |        |        |       |
| -------------------------------- | ------ | ------ | ----- |
| 数据类型                         | 一天   | 一个月 | 一年  |
| 集合类型                         | 400MB  | 12GB   | 144GB |
| Bitmaps                          | 12.5MB | 375MB  | 4.5GB |

但Bitmaps并不是万金油， 假如该网站每天的独立访问用户很少， 例如只有10万（大量的僵尸用户） ， 那么两者的对比如下表所示， 很显然， 这时候使用Bitmaps就不太合适了， 因为基本上大部分位都是0。

| set和Bitmaps存储一天活跃用户对比（独立用户比较少） |                    |                  |                        |
| -------------------------------------------------- | ------------------ | ---------------- | ---------------------- |
| 数据类型                                           | 每个userid占用空间 | 需要存储的用户量 | 全部内存量             |
| 集合类型                                           | 64位               | 100000           | 64位*100000 = 800KB    |
| Bitmaps                                            | 1位                | 100000000        | 1位*100000000 = 12.5MB |

 ##  5.2  HyperLogLog

### 5.2.1 简介

​         在工作当中，我们经常会遇到与统计相关的功能需求，比如统计网站PV（PageView页面访问量）,可以使用Redis的incr、incrby轻松实现。但像UV（UniqueVisitor，独立访客）、独立IP数、搜索记录数等需要去重和计数的问题如何解决？这种求集合中不重复元素个数的问题称为基数问题。

解决基数问题有很多种方案：

（1）数据存储在MySQL表中，使用distinct count计算不重复个数

（2）使用Redis提供的hash、set、bitmaps等数据结构来处理

以上的方案结果精确，但随着数据不断增加，导致占用空间越来越大，对于非常大的数据集是不切实际的。

能否能够降低一定的精度来平衡存储空间？Redis推出了**HyperLogLog**

Redis HyperLogLog 是用来做基数统计的算法，HyperLogLog 的优点是，在输入元素的数量或者体积非常非常大时，计算基数所需的空间总是固定的、并且是很小的。

在 Redis 里面，每个 HyperLogLog 键只需要花费 12 KB 内存，就可以计算接近 2^64 个不同元素的基数。这和计算基数时，元素越多耗费内存就越多的集合形成鲜明对比。

但是，因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以**HyperLogLog 不能像集合那样，返回输入的各个元素**。

**什么是基数?**

比如数据集 {1, 3, 5, 7, 5, 7, 8}， 那么这个数据集的基数集为 {1, 3, 5 ,7, 8}, 基数(**不重复元素个**数)为5。 基数估计就是在误差可接受的范围内，快速计算基数。

### 5.2.2 命令

- **pfadd**
- **pfcount**  

```bash
pfadd <key>< element> [element ...]   #添加指定元素到 HyperLogLog 中
pfcount<key> [key ...] # 计算HLL的近似基数，可以计算多个HLL，比如用HLL存储每天的UV，计算一周的UV可以使用7天的UV合并计算即可
```

实例

![1627396866921](Redis6.assets/1627396866921.png)

- **pfmerge**  

```bash
pfmerge<destkey><sourcekey> [sourcekey ...]  #将一个或多个HLL合并后的结果存储在另一个HLL中，比如每月活跃用户可以使用每天的活跃用户来合并计算可得
```

**实例**

![1627396938263](Redis6.assets/1627396938263.png)

## 5.3 Geospatial

### 5.3.1 简介

​         Redis 3.2 中增加了对GEO类型的支持。GEO，Geographic，地理信息的缩写。该类型，就是元素的2维坐标，在地图上就是经纬度。redis基于该类型，提供了经纬度设置，查询，范围查询，距离查询，经纬度Hash等常见操作。

### 5.3.2 命令

- **geoadd**  

```bash
geoadd<key>< longitude><latitude><member> [longitude latitude member...]  # 添加地理位置（经度，纬度，名称）
```

**实例**

```bash
geoadd china:city 121.47 31.23 shanghai
geoadd china:city 106.50 29.53 chongqing 114.05 22.52 shenzhen 116.38 39.90 beijing
```

![1627400356473](Redis6.assets/1627400356473.png)

> 1. 两极无法直接添加，一般会下载城市数据，直接通过 Java 程序一次性导入。
> 2. 有效的经度从 -180 度到 180 度。有效的纬度从 -85.05112878 度到 85.05112878 度。
> 3. 当坐标位置超出指定范围时，该命令将会返回一个错误。
> 4. 已经添加的数据，是无法再次往里面添加的。

- **geopos**   

```bash
geopos  <key><member> [member...]  #获得指定地区的坐标值
```

![1627400425978](Redis6.assets/1627400425978.png)

- **geodist**  

```bash
geodist<key><member1><member2>  [m|km|ft|mi ]  #获取两个位置之间的直线距离
```

获取两个位置之间的直线距离

​                    ![1627400471663](Redis6.assets/1627400471663.png)           

> 单位：
>
> m 表示单位为米[默认值]。
>
> km 表示单位为千米。
>
> mi 表示单位为英里。
>
> ft 表示单位为英尺。
>
> 如果用户没有显式地指定单位参数，  GEODIST 

- **georadius**  

```bash
georadius<key>< longitude><latitude>radius  m|km|ft|mi   # 以给定的经纬度为中心，找出某一半径内的元素 四个参数 -》经度 纬度 距离 单位
```

![1627400533548](Redis6.assets/1627400533548.png)

# 六、Jedsi操作Redis

## 6.1 常用操作

**jedis所需的依赖**

```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>3.3.0</version>
</dependency>
```

**连接Redis的注意事项**

- 禁用Linux的防火墙：Linux(CentOS7)里执行命令

```bash
systemctl stop/disable firewalld.service
```

- redis.conf中注释掉bind 127.0.0.1 ,然后 protected-mode no

**测试程序**

```java
/**
 * @author cVzhanshi
 * @create 2021-07-28 9:13
 */
public class JedisDemo1 {
    public static void main(String[] args) {
        //创建Jedis对象
        Jedis jedis = new Jedis("192.168.242.110", 6379);
        //测试
        String ping = jedis.ping();
        System.out.println(ping);
    }
}
```

![1627454957446](Redis6.assets/1627454957446.png)

**测试相关数据类型**

- 操作Key和String

```java
//操作key string
@Test
public void demo1() {
    //创建Jedis对象
    Jedis jedis = new Jedis("192.168.242.110", 6379);        //添加
    jedis.set("name","lucy");

    //获取
    String name = jedis.get("name");
    System.out.println(name);

    //设置多个key-value
    jedis.mset("k1","v1","k2","v2");
    List<String> mget = jedis.mget("k1", "k2");
    System.out.println(mget);

    Set<String> keys = jedis.keys("*");
    for(String key : keys) {
        System.out.println(key);
    }
    jedis.close();
}
```

![1627455999946](Redis6.assets/1627455999946.png)

- 操作list

```java
//操作list
@Test
public void demo2() {
    //创建Jedis对象
    Jedis jedis = new Jedis("192.168.242.110", 6379);
    jedis.lpush("key1","lucy","mary","jack");
    List<String> values = jedis.lrange("key1", 0, -1);
    System.out.println(values);
    jedis.close();
}
```

![1627456086029](Redis6.assets/1627456086029.png)

- 操作set

```java
//操作set
@Test
public void demo3() {
    //创建Jedis对象
    Jedis jedis = new Jedis("192.168.242.110", 6379);
    jedis.sadd("names","lucy");
    jedis.sadd("names","mary");

    Set<String> names = jedis.smembers("names");
    System.out.println(names);
    jedis.close();
}
```

![1627456272181](Redis6.assets/1627456272181.png)

- 操作hash

```java
//操作hash
@Test
public void demo4() {
    //创建Jedis对象
    Jedis jedis = new Jedis("192.168.242.110", 6379);
    jedis.hset("users","age","20");
    String hget = jedis.hget("users", "age");
    System.out.println(hget);
    jedis.close();
}
```

![1627456305668](Redis6.assets/1627456305668.png)

- 操作zset

```java
//操作zset
@Test
public void demo5() {
    //创建Jedis对象
    Jedis jedis = new Jedis("192.168.242.110", 6379);
    jedis.zadd("china",100d,"shanghai");

    Set<String> china = jedis.zrange("china", 0, -1);
    System.out.println(china);

    jedis.close();
}
```

![1627456388737](Redis6.assets/1627456388737.png)

## 6.2 小实战(手机验证码)

```java
/**
 * @author cVzhanshi
 * @create 2021-07-28 17:02
 */
public class PhoneCode {
    public static void main(String[] args) {
        //模拟验证码发送
        verifyCode("15970387607");

        //模拟验证码校验
        //getRedisCode("15970387607","698264");
    }


    /**
     * 1、生成六位数字验证码
     * @return
     */
    public static String getCode(){
        Random random = new Random();
        String code = "";
        for(int i = 0;i<6;i++){
            int index = random.nextInt(10);
            code += index;
        }
        return code;
    }

    /**
     * 2、每个手机每天只能发送三次，验证码放到redis中，设置过期时间120
     * @param phone
     */
    public static void verifyCode(String phone) {
        //创建Jedis对象 连接Redis
        Jedis jedis = new Jedis("192.168.242.110", 6379);

        //拼接key
        //手机发送次数key
        String countKey = "VerifyCode"+phone+":count";
        //验证码key
        String codeKey = "VerifyCode"+phone+":code";

        String count = jedis.get(countKey);
        if(count == null){
            //没有发送次数，第一次发送
            //设置发送次数是1
            jedis.setex(countKey,24*60*60,"1");
        }else if(Integer.parseInt(count) <= 2){
            //发送次数+1
            jedis.incr(countKey);
        }else{
            System.out.println("今天发送次数已经超过三次");
            jedis.close();
            return;
        }

        //发送验证码放到redis里面
        String vcode = getCode();
        jedis.setex(codeKey,120,vcode);
        jedis.close();

    }

    public static void getRedisCode(String phone,String code) {
        //从redis获取验证码
        Jedis jedis = new Jedis("192.168.242.110", 6379);
        //验证码key
        String codeKey = "VerifyCode"+phone+":code";
        String redisCode = jedis.get(codeKey);
        //判断
        if(redisCode.equals(code)) {
            System.out.println("成功");
        }else {
            System.out.println("失败");
        }
        jedis.close();
    }
}
```

# 七、Spring Boot 整合Redis

>  [Spring Boot 整合Redis博客链接](https://blog.csdn.net/qq_45408390/article/details/119191824) 

# 八、Redis事务操作

## 8.1 事务的概述

> Redis事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。
>
> Redis事务的主要作用就是串联多个命令防止别的命令插队

## 8.2  Multi、Exec、discard

> 从输入Multi命令开始，输入的命令都会依次进入命令队列中，但不会执行，直到输入Exec后，Redis会将之前的命令队列中的命令依次执行。
>
> 组队的过程中可以通过discard。
> Discard 命令用于取消事务，放弃执行事务块内的所有命令
>
> ![1627520499369](Redis6.assets/1627520499369.png)

**实例**

![](Redis6.assets/1627520642569.png)组队成功，提交成功

![1627520657324](Redis6.assets/1627520657324.png)组队阶段报错，提交失败  

![1627520697943](Redis6.assets/1627520697943.png)组队成功，提交有成功有失败情况  

## 8.3 事务的错误处理

- 组队中某个命令出现了报告错误，执行时整个的所有队列都会被取消

![1627520928844](Redis6.assets/1627520928844.png)

- 如果执行阶段某个命令报出了错误，则只有报错的命令不会被执行，而其他的命令都会执行，不会回滚。

![1627520940798](Redis6.assets/1627520940798.png)

## 8.4 事务冲突问题

### 8.4.1 实例

一个请求想给金额减8000

一个请求想给金额减5000

一个请求想给金额减1000

![1627520994084](Redis6.assets/1627520994084.png)

### 8.4.2 悲观锁

![1627521018336](Redis6.assets/1627521018336.png)

> **悲观锁(Pessimistic Lock)**, 顾名思义，就是很悲观，每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，这样别人想拿这个数据就会block直到它拿到锁。**传统的关系型数据库里边就用到了很多这种锁机制**，比如**行锁**，**表锁**等，**读锁**，**写锁**等，都是在做操作之前先上锁。

### 8.4.3 乐观锁

![1627521042092](Redis6.assets/1627521042092.png)

> **乐观锁(Optimistic Lock),** 顾名思义，就是很乐观，每次去拿数据的时候都认为别人不会修改，所以不会上锁，但是在更新的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号等机制。**乐观锁适用于多读的应用类型，这样可以提高吞吐量**。Redis就是利用这种check-and-set机制实现事务的。

### 8.4.4 WATCH **key** **[key ...]**

> 在执行multi之前，先执行watch key1 [key2],可以监视一个(或多个) key ，如果在事务**执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断。**  

**演示**

![1627524676322](Redis6.assets/1627524676322.png)

> 在开启事务的时候，在执行前先修改一下信息，就会执行失败，这是watch key的作用

### 8.4.5 unwatch

取消 WATCH 命令对所有 key 的监视。

如果在执行 WATCH 命令之后，EXEC 命令或DISCARD 命令先被执行了的话，那么就不需要再执行UNWATCH了.  

# 九、Redis事务-秒杀案例

> 案例简介：在redis存入商品数，设定秒杀时间，提供用户秒杀窗口，用户秒杀成功，redis中商品数-1，用户信息也存入redis中(为了相同用户只能秒杀一次)。
>
> ![1627607827733](Redis6.assets/1627607827733.png)

## 9.1 简单版(环境搭建)

- 创建普通web项目
- 导入jar包和jquey

、<img src="Redis6.assets/1627627014580.png" alt="1627627014580" style="zoom:67%;" />

- 创建index.jsp

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Insert title here</title>
    </head>
    <body>
        <h1>iPhone 13 Pro !!!  1元秒杀！！！
        </h1>

        <p>${pageContext.request.contextPath}</p>
        <form id="msform" action="${pageContext.request.contextPath}/doseckill" enctype="application/x-www-form-urlencoded">
            <input type="hidden" id="prodid" name="prodid" value="0101">
            <input type="button"  id="miaosha_btn" name="seckill_btn" value="秒杀点我"/>
        </form>

    </body>
    <script  type="text/javascript" src="${pageContext.request.contextPath}/script/jquery/jquery-3.1.0.js"></script>
    <script  type="text/javascript">
        $(function(){
            $("#miaosha_btn").click(function(){	 
                var url=$("#msform").attr("action");
                $.post(url,$("#msform").serialize(),function(data){
                    if(data=="false"){
                        alert("抢光了" );
                        $("#miaosha_btn").attr("disabled",true);
                    }
                } );    
            })
        })
    </script>
</html>
```

- web.xml

```xml
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">


    <servlet>
        <description></description>
        <display-name>doseckill</display-name>
        <servlet-name>doseckill</servlet-name>
        <servlet-class>cn.cvzhanshi.SecKillServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>doseckill</servlet-name>
        <url-pattern>/doseckill</url-pattern>
    </servlet-mapping>
</web-app>
```

- SecKillServlet.java

```java
/**
 * 秒杀案例
 */
public class SecKillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SecKillServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String userid = new Random().nextInt(50000) +"" ;
        String prodid =request.getParameter("prodid");

        boolean isSuccess= SecKill_redis.doSecKill(userid,prodid);
        response.getWriter().print(isSuccess);
    }

}
```

- SecKill_redis.java

```java
public class SecKill_redis {

    public static void main(String[] args) {
        Jedis jedis =new Jedis("192.168.242.110",6379);
        System.out.println(jedis.ping());
        jedis.close();
    }

    //秒杀过程
    public static boolean doSecKill(String uid,String prodid) throws IOException {
        //1 uid和prodid非空判断
        if(uid == null || prodid == null){
            return false;
        }

        //2 连接redis
        Jedis jedis =new Jedis("192.168.242.110",6379);

        //3 拼接key
        // 3.1 库存key
        String kcKey = "sk:"+prodid+":qt";
        // 3.2 秒杀成功用户key
        String userKey = "sk:"+prodid+":user";



        //4 获取库存，如果库存null，秒杀还没有开始
        String kc = jedis.get(kcKey);
        if(kc == null){
            System.out.println("秒杀还没开始，请稍等");
            jedis.close();
            return false;
        }

        // 5 判断用户是否重复秒杀操作

        if(jedis.sismember(userKey, uid)){
            System.out.println("每个用户只能秒杀成功一次，请下次再来");
            jedis.close();
            return false;
        }

        //6 判断如果商品数量，库存数量小于1，秒杀结束
        if(Integer.parseInt(kc) < 1){
            System.out.println("秒杀结束，请下次参与");
            jedis.close();
            return false;
        }

        //7 秒杀过程
        //7.1库存-1
        jedis.decr(kcKey);
        //7.2 把秒杀成功的用户添加到清单里面
        jedis.sadd(userKey,uid);
        System.out.println("用户" + uid + "秒杀成功");
        jedis.close();
        return true;
    }
}
```

- 测试

>  先在redis中设置库存数10，启动项目，进项秒杀

1、设置库存

![1627629322573](Redis6.assets/1627629322573.png)

2、启动项目

![1627629404988](Redis6.assets/1627629404988.png)

3、开始秒杀

![1627629452998](Redis6.assets/1627629452998.png)

4、数量减少、用户入库

![1627629489869](Redis6.assets/1627629489869.png)

5、商品数量秒杀完了

![1627629572190](Redis6.assets/1627629572190.png)

-----

![1627629583302](Redis6.assets/1627629583302.png)

## 9.2 ab工具模拟并发暴露出来的问题

> 使用工具ab模拟测试
>
> CentOS6 默认安装
>
> CentOS7需要手动安装

- 使用命令安装ab

```bash
yum -y install httpd-tools
```

- 编写参数文件

```bash
vim postfile 模拟表单提交参数,以&符号结尾;存放当前目录。
内容：prodid=0101&
```

- 启动项目，通过ab命令并发秒杀

```bash
ab -n 2000 -c 200 -k -p ~/postfile -T application/x-www-form-urlencoded http://192.168.0.43:8080/Seckill/doseckill
```

- 并发暴露出来的问题

1、会出现超卖问题，卖光了还能秒杀成功，库存为负数

![1627632590913](Redis6.assets/1627632590913.png)

超卖产生的原因

![1627636118247](Redis6.assets/1627636118247.png)

2、连接超时问题

3、商品遗留问题

> 秒杀结束了，还有商品库存

![1627694705299](Redis6.assets/1627694705299.png)

## 9.3 问题的解决

- **连接超时问题**

> 连接超时问题使用连接池解决
>
> - 创建工具类
>
> ```java
> public class JedisPoolUtil {
>     private static volatile JedisPool jedisPool = null;
> 
>     private JedisPoolUtil() {
>     }
> 
>     public static JedisPool getJedisPoolInstance() {
>         if (null == jedisPool) {
>             synchronized (JedisPoolUtil.class) {
>                 if (null == jedisPool) {
>                     JedisPoolConfig poolConfig = new JedisPoolConfig();
>                     poolConfig.setMaxTotal(200);
>                     poolConfig.setMaxIdle(32);
>                     poolConfig.setMaxWaitMillis(100*1000);
>                     poolConfig.setBlockWhenExhausted(true);
>                     poolConfig.setTestOnBorrow(true);  // ping  PONG
> 
>                     jedisPool = new JedisPool(poolConfig, "192.168.242.110", 6379, 60000 );
>                 }
>             }
>         }
>         return jedisPool;
>     }
> 
>     public static void release(JedisPool jedisPool, Jedis jedis) {
>         if (null != jedis) {
>             jedisPool.returnResource(jedis);
>         }
>     }
> 
> }
> ```
>
> - 修改代码
>
> ```java
> //2 连接redis
> //Jedis jedis =new Jedis("192.168.242.110",6379);
> 
> //通过连接池获取连接redis的对象
> JedisPool jedisPoolInstance = JedisPoolUtil.getJedisPoolInstance();
> Jedis jedis = jedisPoolInstance.getResource();
> ```

- **利用乐观锁淘汰用户，解决超卖问题**

![1627636142162](Redis6.assets/1627636142162.png)

修改代码

```java
//秒杀过程
public static boolean doSecKill(String uid,String prodid) throws IOException {
    //1 uid和prodid非空判断
    if(uid == null || prodid == null){
        return false;
    }

    //2 连接redis
    //Jedis jedis =new Jedis("192.168.242.110",6379);

    //通过连接池获取连接redis的对象
    JedisPool jedisPoolInstance = JedisPoolUtil.getJedisPoolInstance();
    Jedis jedis = jedisPoolInstance.getResource();


    //3 拼接key
    // 3.1 库存key
    String kcKey = "sk:"+prodid+":qt";
    // 3.2 秒杀成功用户key
    String userKey = "sk:"+prodid+":user";



    //监视库存
    jedis.watch(kcKey);


    //4 获取库存，如果库存null，秒杀还没有开始
    String kc = jedis.get(kcKey);
    if(kc == null){
        System.out.println("秒杀还没开始，请稍等");
        jedis.close();
        return false;
    }

    // 5 判断用户是否重复秒杀操作

    if(jedis.sismember(userKey, uid)){
        System.out.println("每个用户只能秒杀成功一次，请下次再来");
        jedis.close();
        return false;
    }

    //6 判断如果商品数量，库存数量小于1，秒杀结束
    if(Integer.parseInt(kc) < 1){
        System.out.println("秒杀结束，请下次参与");
        jedis.close();
        return false;
    }

    //7 秒杀过程

    //使用事务
    Transaction multi = jedis.multi();

    //组队操作
    multi.decr(kcKey);
    multi.sadd(userKey,uid);

    //执行
    List<Object> results = multi.exec();

    if(results == null || results.size()==0) {
        System.out.println("秒杀失败了....");
        jedis.close();
        return false;
    }

    //		//7.1库存-1
    //		jedis.decr(kcKey);
    //        //7.2 把秒杀成功的用户添加到清单里面
    //        jedis.sadd(userKey,uid);
    System.out.println("用户" + uid + "秒杀成功");
    jedis.close();
    return true;
}
```

**测试**

![1627638400457](Redis6.assets/1627638400457.png)

-----

![1627638410846](Redis6.assets/1627638410846.png)

- **商品遗留问题**

> 用Lua脚本解决商品遗留 问题
>
> **Lua** 是一个小巧的[脚本语言](http://baike.baidu.com/item/脚本语言)，Lua脚本可以很容易的被C/C++ 代码调用，也可以反过来调用C/C++的函数，Lua并没有提供强大的库，一个完整的Lua解释器不过200k，所以Lua不适合作为开发独立应用程序的语言，而是作为嵌入式脚本语言。很多应用程序、游戏使用LUA作为自己的嵌入式脚本语言，以此来实现可配置性、可扩展性。
>
> -----
>
> 将复杂的或者多步的redis操作，写为一个脚本，一次提交给redis执行，减少反复连接redis的次数。提升性能。
>
> LUA脚本是类似redis事务，有一定的原子性，不会被其他命令插队，可以完成一些redis事务性的操作。
>
> 但是注意redis的lua脚本功能，只有在Redis 2.6以上的版本才可以使用。
>
> 利用lua脚本淘汰用户，解决超卖问题。
>
> redis 2.6版本以后，通过lua脚本解决**争抢问题**，实际上是**redis** **利用其单线程的特性，用任务队列的方式解决多任务并发问题**。
>
> ![1627694956562](Redis6.assets/1627694956562.png)

代码编写

```java
public class SecKill_redisByScript {

    private static final  org.slf4j.Logger logger =LoggerFactory.getLogger(SecKill_redisByScript.class) ;

    public static void main(String[] args) {
        JedisPool jedispool =  JedisPoolUtil.getJedisPoolInstance();

        Jedis jedis=jedispool.getResource();
        System.out.println(jedis.ping());

        Set<HostAndPort> set=new HashSet<HostAndPort>();

        //	doSecKill("201","sk:0101");
    }

    static String secKillScript ="local userid=KEYS[1];\r\n" + 
        "local prodid=KEYS[2];\r\n" + 
        "local qtkey='sk:'..prodid..\":qt\";\r\n" + 
        "local usersKey='sk:'..prodid..\":usr\";\r\n" + 
        "local userExists=redis.call(\"sismember\",usersKey,userid);\r\n" + 
        "if tonumber(userExists)==1 then \r\n" + 
        "   return 2;\r\n" + 
        "end\r\n" + 
        "local num= redis.call(\"get\" ,qtkey);\r\n" + 
        "if tonumber(num)<=0 then \r\n" + 
        "   return 0;\r\n" + 
        "else \r\n" + 
        "   redis.call(\"decr\",qtkey);\r\n" + 
        "   redis.call(\"sadd\",usersKey,userid);\r\n" + 
        "end\r\n" + 
        "return 1" ;

    static String secKillScript2 = 
        "local userExists=redis.call(\"sismember\",\"{sk}:0101:usr\",userid);\r\n" +
        " return 1";

    public static boolean doSecKill(String uid,String prodid) throws IOException {

        JedisPool jedispool =  JedisPoolUtil.getJedisPoolInstance();
        Jedis jedis=jedispool.getResource();

        //String sha1=  .secKillScript;
        String sha1=  jedis.scriptLoad(secKillScript);
        Object result= jedis.evalsha(sha1, 2, uid,prodid);

        String reString=String.valueOf(result);
        if ("0".equals( reString )  ) {
            System.err.println("已抢空！！");
        }else if("1".equals( reString )  )  {
            System.out.println("抢购成功！！！！");
        }else if("2".equals( reString )  )  {
            System.err.println("该用户已抢过！！");
        }else{
            System.err.println("抢购异常！！");
        }
        jedis.close();
        return true;
    }
}
```

修改servlet

```java
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    String userid = new Random().nextInt(50000) +"" ;
    String prodid =request.getParameter("prodid");

    //boolean isSuccess= SecKill_redis.doSecKill(userid,prodid);
    boolean isSuccess = SecKill_redisByScript.doSecKill(userid, prodid);
    response.getWriter().print(isSuccess);
}
```

结果

![1627694908574](Redis6.assets/1627694908574.png)

# 十、Redis持久化

## 10.1 RDB持久化

> 在指定的时间间隔内将内存中的数据集快照写入磁盘， 也就是行话讲的Snapshot快照，它恢复时是将快照文件直接读到内存里  

### 10.1.1 持久化执行流程

> Redis会单独创建（fork）一个子进程来进行持久化，**会先将数据写入到 一个临时文件中，待持久化过程都结束了，再用这个临时文件替换上次持久化好的文件**。 整个过程中，主进程是不进行任何IO操作的，这就确保了极高的性能 如果需要进行大规模数据的恢复，且对于数据恢复的完整性不是非常敏感，**那RDB方式要比AOF方式更加的高效**。**RDB的缺点是最后一次持久化后的数据可能丢失**。

![1627700833926](Redis6.assets/1627700833926.png)

### 10.1.2 Fork过程概述

> - Fork的作用是复制一个与当前进程一样的进程。新进程的所有数据（变量、环境变量、程序计数器等） 数值都和原进程一致，但是是一个全新的进程，并作为原进程的子进程
> - 在Linux程序中，fork()会产生一个和父进程完全相同的子进程，但子进程在此后多会exec系统调用，出于效率考虑，Linux中引入了“**写时复制技术**”
> - **一般情况父进程和子进程会共用同一段物理内存**，只有进程空间的各段的内容要发生变化时，才会将父进程的内容复制一份给子进程。

### 10.1.3 有关的配置

- 在redis.conf中配置文件名称，默认为dump.rdb  

![1627701158159](Redis6.assets/1627701158159.png)

- 配置文件的位置，默认是启动位置

![1627701190949](Redis6.assets/1627701190949.png)

- 配置文件中默认的快照配置

![1627701828186](Redis6.assets/1627701828186.png)

- 命令save VS bgsave

> save ：save时只管保存，其它不管，全部阻塞。手动保存。不建议。
>
> **bgsave**：Redis会在后台异步进行快照操作， **快照同时还可以响应客户端请求。**
>
> 可以通过lastsave 命令获取最后一次成功执行快照的时间

- fulshall也会产生dump.rbg文件，不过是空的，没有意义
- Save

>格式：save 秒钟 写操作次数
>
>RDB是整个内存的压缩过的Snapshot，RDB的数据结构，可以配置复合的快照触发条件，
>
>默认是1分钟内改了1万次，或5分钟内改了10次，或15分钟内改了1次。
>
>禁用: 不设置save指令，或者给save传入空字符串

- stop-writes-on-bgsave-error yes

> 当Redis无法写入磁盘的话，直接关掉Redis的写操作。推荐yes

- rdbcompression压缩文件

> 对于存储到磁盘中的快照，可以设置是否进行压缩存储。如果是的话，redis会采用LZF算法进行压缩。
>
> 如果你不想消耗CPU来进行压缩的话，可以设置为关闭此功能。推荐yes.

- rdbchecksum 检查完整性

> 在存储快照后，还可以让redis使用CRC64算法来进行数据校验，
>
> 但是这样做会增加大约10%的性能消耗，如果希望获取到最大的性能提升，可以关闭此功能->推荐yes

- rdb的备份

> 先通过config get dir 查询rdb文件的目录 
>
> 将*.rdb的文件拷贝到别的地方
>
> **rdb的恢复**
>
> - 关闭Redis
>
> - 先把备份的文件拷贝到工作目录下 cp dump2.rdb dump.rdb
>
> - 启动Redis，备份数据会直接加载  

### 10.1.4 优势与劣势

- **优势**

  - 适合大规模的数据恢复
  - 对数据完整性和一致性要求不高更适合使用
  - 节省磁盘空间
  - 恢复速度快

  ![1627713961545](Redis6.assets/1627713961545.png)

- **劣势**
  - Fork的时候，内存中的数据被克隆了一份，大致2倍的膨胀性需要考虑
  - 虽然Redis在fork时使用了**写时拷贝技术**,但是如果数据庞大时还是比较消耗性能。
  - 在备份周期在一定间隔时间做一次备份，所以如果Redis意外down掉的话，就会丢失最后一次快照后的所有修改。

### 10.1.5 如何停止

> 动态停止RDB：redis-cli config set save ""    #save后给空值，表示禁用保存策略

### 10.1.6小总结

![1627714208540](Redis6.assets/1627714208540.png)



> 注意持久化文件是在启动目录生成，不是一定在/usr/local/bin目录下

## 10.2 AOF持久化

### 10.2.1 概述

> 以**日志**的形式来记录每个写操作（增量保存），将Redis执行过的所有写指令记录下来(**读操作不记录**)， **只许追加文件但不可以改写文件**，redis启动之初会读取该文件重新构建数据，换言之，redis 重启的话就根据日志文件的内容将写指令从前到后执行一次以完成数据的恢复工作

### 10.2.2 AOF持久化流程

（1）客户端的请求写命令会被append追加到AOF缓冲区内；

（2）AOF缓冲区根据AOF持久化策略[always,everysec,no]将操作sync同步到磁盘的AOF文件中；

（3）AOF文件大小超过重写策略或手动重写时，会对AOF文件rewrite重写，压缩AOF文件容量；

（4）Redis服务重启时，会重新load加载AOF文件中的写操作达到数据恢复的目的；

![1627886164444](Redis6.assets/1627886164444.png)

### 10.2.3 AOF的开启与说明

- **开启**

> 可以在redis.conf中配置文件名称，默认为 appendonly.aof
>
> AOF文件的保存路径，同的路径一致.

- **AOF和RDB同时开启，redis听谁的**  

> AOF和RDB同时开启，系统默认取AOF的数据（数据不会存在丢失）  

- **AOF启动/修复/恢复**

> - AOF的备份机制和性能虽然和RDB不同, 但是备份和恢复的操作同RDB一样，都是拷贝备份文件，需要恢复时再拷贝到Redis工作目录下，启动系统即加载。
> - 正常恢复
>   - 修改默认的appendonly no，改为yes
>   - 将有数据的aof文件复制一份保存到对应目录(查看目录：config get dir)
>   - 恢复：重启redis然后重新加载
> - 异常恢复
>   - 修改默认的appendonly no，改为yes
>   - 如遇到**AOF文件损坏**，通过/usr/local/bin/**redis-check-aof--fix appendonly.aof**进行恢复
>   - 备份被写坏的AOF文件
>   - 恢复：重启redis，然后重新加载

- **AOF同步频率设置**

> appendfsync always
>
> ​	始终同步，每次Redis的写入都会立刻记入日志；性能较差但数据完整性比较好
>
> appendfsync everysec
>
> ​	每秒同步，每秒记入日志一次，如果宕机，本秒的数据可能丢失。
>
> appendfsync no
>
> ​	redis不主动进行同步，把同步时机交给操作系统。  

- **Rewrite压缩**

  - 概述

  > AOF采用文件追加方式，文件会越来越大为避免出现此种情况，新增了重写机制, 当AOF文件的大小超过所设定的阈值时，Redis就会启动AOF文件的内容压缩， 只保留可以恢复数据的最小指令集.可以使用命令bgrewriteaof.

  - **重写原理，如何实现重写**

  > AOF文件持续增长而过大时，会fork出一条新进程来将文件重写(也是先写临时文件最后再rename)，redis4.0版本后的重写，是指上就是把rdb 的快照，以二级制的形式附在新的aof头部，作为已有的历史数据，替换掉原来的流水账操作。
  >
  > **no-appendfsync-on-rewrite**：
  >
  > - 如果 **no-appendfsync-on-rewrite=yes** ,不写入aof文件只写入缓存，用户请求不会阻塞，但是在这段时间如果宕机会丢失这段时间的缓存数据。（降低数据安全性，提高性能）
  >
  > - 如果 **no-appendfsync-on-rewrite=no**, 还是会把数据往磁盘里刷，但是遇到重写操作，可能会发生阻塞。（数据安全，但是性能降低）
  >
  > **触发机制，何时重写**
  >
  > - Redis会记录上次重写时的AOF大小，默认配置是当AOF文件大小是上次rewrite后大小的一倍且文件大于64M时触发
  >
  > - 重写虽然可以节约大量磁盘空间，减少恢复时间。但是每次重写还是有一定的负担的，因此设定Redis要满足一定条件才会进行重写。 
  >
  > - auto-aof-rewrite-percentage：设置重写的基准值，文件达到100%时开始重写（文件是原来重写后文件的2倍时触发）
  >
  > - auto-aof-rewrite-min-size：设置重写的基准值，最小文件64MB。达到这个值开始重写。
  >
  > 例如：文件达到70MB开始重写，降到50MB，下次什么时候开始重写？100MB
  >
  > 系统载入时或者上次重写完毕时，Redis会记录此时AOF大小，设为base_size,
  >
  > 如果Redis的AOF当前大小>= base_size +base_size*100% (默认)且当前大小>=64mb(默认)的情况下，Redis会对AOF进行重写。  

  - **重写流程**  

  > - bgrewriteaof触发重写，判断是否当前有bgsave或bgrewriteaof在运行，如果有，则等待该命令结束后再继续执行。
  > - 主进程fork出子进程执行重写操作，保证主进程不会阻塞。
  > - 子进程遍历redis内存中数据到临时文件，客户端的写请求同时写入aof_buf缓冲区和aof_rewrite_buf重写缓冲区保证原AOF文件完整以及新AOF文件生成期间的新的数据修改动作不会丢失。
  > - 1).子进程写完新的AOF文件后，向主进程发信号，父进程更新统计信息。2).主进程把aof_rewrite_buf中的数据写入到新的AOF文件。
  > - 使用新的AOF文件覆盖旧的AOF文件，完成AOF重写。
  >
  > ![1627887434005](Redis6.assets/1627887434005.png)

### 10.2.4 优势与劣势

- **优势**

![1627887501788](Redis6.assets/1627887501788.png)

> - 备份机制更稳健，丢失数据概率更低。
>
> - 可读的日志文本，通过操作AOF

- 劣势

> - 比起RDB占用更多的磁盘空间。
> - 恢复备份速度要慢。
> - 每次读写都同步的话，有一定的性能压力。
> - 存在个别Bug，造成恢复不能。

### 10.2.5 总结

![1627887563478](Redis6.assets/1627887563478.png)

### 10.2.6 AOF和RDB的选择

官方推荐两个都启用。

如果对数据不敏感，可以选单独用RDB。

不建议单独用 AOF，因为可能会出现Bug。

如果只是做纯内存缓存，可以都不用。

- RDB持久化方式能够在指定的时间间隔能对你的数据进行快照存储
- AOF持久化方式记录每次对服务器写的操作,当服务器重启的时候会重新执行这些命令来恢复原始的数据,AOF命令以redis协议追加保存每次写的操作到文件末尾. 
- Redis还能对AOF文件进行后台重写,使得AOF文件的体积不至于过大
- 只做缓存：如果你只希望你的数据在服务器运行的时候存在,你也可以不使用任何持久化方式.
- 同时开启两种持久化方式
- 在这种情况下,当redis重启的时候会优先载入AOF文件来恢复原始的数据, 因为在通常情况下AOF文件保存的数据集要比RDB文件保存的数据集要完整.
- RDB的数据不实时，同时使用两者时服务器重启也只会找AOF文件。那要不要只使用AOF呢？ 
- 建议不要，因为RDB更适合用于备份数据库(AOF在不断变化不好备份)， 快速重启，而且不会有AOF可能潜在的bug，留着作为一个万一的手段。

- 性能建议

> 因为RDB文件只用作后备用途，建议只在Slave上持久化RDB文件，而且只要15分钟备份一次就够了，只保留save 900 1这条规则。     
>
> 如果使用AOF，好处是在最恶劣情况下也只会丢失不超过两秒数据，启动脚本较简单只load自己的AOF文件就可以了。  
>
> 代价,一是带来了持续的IO，二是AOF rewrite的最后将rewrite过程中产生的新数据写到新文件造成的阻塞几乎是不可避免的。 
>
>  只要硬盘许可，应该尽量减少AOF  rewrite的频率，AOF重写的基础大小默认值64M太小了，可以设到5G以上。 
>
> 默认超过原大小100%大小时重写可以改到适当的数值。  

# 十一、Redis主从复制

## 11.1 概述

> 主机数据更新后根据配置和策略， 自动同步到备机的master/slaver机制，**Master**以写为主，**Slave以读为主**

**作用**

- 读写分离，性能扩展
- 容灾快速恢复

![1627892133400](Redis6.assets/1627892133400.png)

## 11.2 搭建主从复制

- 在根目录下创建文件夹myredis，把redis的配置文件复制过来，要把aof持久化关掉
- 创建三个文件redis6379.conf、redis6381.conf、redis6380.conf内容如下

```bash
######################redis6379.conf#######################
include /myredis/redis.conf
pidfile /var/run/redis_6379.pid
port 6379
dbfilename dump6379.rdb

######################redis6380.conf#######################
include /myredis/redis.conf
pidfile /var/run/redis_6380.pid
port 6380
dbfilename dump6380.rdb

######################redis6381.conf#######################
include /myredis/redis.conf
pidfile /var/run/redis_6381.pid
port 6381
dbfilename dump6381.rdb
```

- 同时启动三个端口的redis

![1627957326117](Redis6.assets/1627957326117.png)

- 查看服务是否启动

![1627957343314](Redis6.assets/1627957343314.png)

- 查看三台主机运行情况

```bash
info replication  # 打印主从复制的相关信息
```

![1627957638952](Redis6.assets/1627957638952.png)

- 配从(库)不配主(库)

```bash
slaveof  <ip><port>  # 在从机上配置主机的ip和端口 在6380和6381上执行: slaveof 127.0.0.1 6379
```

![1627957869590](Redis6.assets/1627957869590.png)

![1627957902726](Redis6.assets/1627957902726.png)

- 在主机上写，在从机上可以读取数据，在从机上写数据报错

![1627958072184](Redis6.assets/1627958072184.png)

-----

![1627958095128](Redis6.assets/1627958095128.png)

- 主机挂掉，重启就行，一切如初，从机重启需重设：slaveof 127.0.0.1 6379

## 11.3 常用3招

### 11.3.1 一主二仆

- 切入点问题？slave1、slave2是从头开始复制还是从切入点开始复制?比如从k4进来，那之前的k1,k2,k3是否也可以复制？

> 从机会全量复制主机的内容，k1,k2,k3,k4都会复制

- 从机是否可以写？set可否？ 

> 从机只可读，不可写

- 主机shutdown后情况如何？从机是上位还是原地待命？

> 主机shutdown后，从机原地待命，等待主机重新启动，一切回复正常

- 主机又回来了后，主机新增记录，从机还能否顺利复制？  

> 可以复制，因为主机重启后和之前一样，主机写内容，会同步到从机中

- 其中一台从机down后情况如何？依照原有它能跟上大部队吗？

> 从机down后，会脱离大部队，如果重新启动，还想同步主机内容的话，需要重新执行命令
>
> slaveof  <ip><port>

**复制原理**

- Slave启动成功连接到master后会发送一个sync命令

- Master接到命令启动后台的存盘进程，同时收集所有接收到的用于修改数据集命令， 在后台进程执行完毕之后，master将传送整个数据文件到slave,以完成一次完全同步

- 全量复制：而slave服务在接收到数据库文件数据后，将其存盘并加载到内存中。
- 增量复制：Master继续将新的所有收集到的修改命令依次传给slave,完成同步
- 但是只要是重新连接master,一次完全同步（全量复制)将被自动执行

![1627975137107](Redis6.assets/1627975137107.png)

### 11.3.2 薪火相传

> - 上一个Slave可以是下一个slave的Master，Slave同样可以接收其他 slaves的连接和同步请求，那么该slave作为了链条中下一个的master, 可以有效减轻master的写压力,去中心化降低风险。 
>
> - 用 slaveof <ip><port>
>
>   中途变更转向:会清除之前的数据，重新建立拷贝最新的
>
>   风险是一旦某个slave宕机，后面的slave都没法备份
>
>   主机挂了，从机还是从机，无法写数据了

![1627982707481](Redis6.assets/1627982707481.png)

-----

![1627982975525](Redis6.assets/1627982975525.png)

-----

![1627983003439](Redis6.assets/1627983003439.png)

-----

![1627983026228](Redis6.assets/1627983026228.png)

### 11.3.3 反客为主

> 当一个master宕机后，后面的slave可以立刻升为master，其后面的slave不用做任何修改。
>
> 用slaveof no one  将从机变为主机    

- 6379down了

![1627983141889](Redis6.assets/1627983141889.png)

- 让6380反客为主

![1627983217713](Redis6.assets/1627983217713.png)

## 11.4 哨兵模式

> **反客为主的自动版**，能够后台监控主机是否故障，如果故障了根据投票数自动将从库转换为主库  

**实例** 

- 先搭建一主二从的环境
- 自定义的/myredis目录下新建sentinel.conf文件，名字绝不能错
-  配置哨兵，填写内容

```bash
sentinel monitor mymaster 127.0.0.1 6379 1
#其中mymaster为监控对象起的服务器名称， 1 为至少有多少个哨兵同意迁移的数量。
```

- 启动哨兵，执行redis-sentinel /myredis/sentinel.conf   

![1628041262719](Redis6.assets/1628041262719.png)

- 当主机挂掉，从机选举中产生新的主机

![1628041549919](Redis6.assets/1628041549919.png)

- 重新启动原主机，原主机重启后会变为从机  

**复制延时**

> 由于所有的写操作都是先在Master上操作，然后同步更新到Slave上，所以从Master同步到Slave机器有一定的延迟，当系统很繁忙的时候，延迟问题会更加严重，Slave机器数量的增加也会使这个问题更加严重。

**故障恢复**

![1628041803626](Redis6.assets/1628041803626.png)

> 优先级在redis.conf中默认：slave-priority 100，值越小优先级越高
>
> 偏移量是指获得原主机数据最全的
>
> 每个redis实例启动后都会随机生成一个40位的runid

**主从复制**

> Jedis对象用这个方法取得

```java
private static JedisSentinelPool jedisSentinelPool=null;

public static  Jedis getJedisFromSentinel(){
    if(jedisSentinelPool==null){
        Set<String> sentinelSet=new HashSet<>();
        sentinelSet.add("192.168.11.103:26379");

        JedisPoolConfig jedisPoolConfig =new JedisPoolConfig();
        jedisPoolConfig.setMaxTotal(10); //最大可用连接数
        jedisPoolConfig.setMaxIdle(5); //最大闲置连接数
        jedisPoolConfig.setMinIdle(5); //最小闲置连接数
        jedisPoolConfig.setBlockWhenExhausted(true); //连接耗尽是否等待
        jedisPoolConfig.setMaxWaitMillis(2000); //等待时间
        jedisPoolConfig.setTestOnBorrow(true); //取连接的时候进行一下测试 ping pong

        jedisSentinelPool=new JedisSentinelPool("mymaster",sentinelSet,jedisPoolConfig);
        return jedisSentinelPool.getResource();
    }else{
        return jedisSentinelPool.getResource();
    }
}
```

# 十二、Redis集群

## 12.1 集群的简介

**集群之前遇到的问题**

1、容量不够，redis如何进行扩容？

2、并发写操作， redis如何分摊？

3、另外，主从模式，薪火相传模式，主机宕机，导致ip地址发生变化，应用程序中配置需要修改对应的主机地址、端口等信息。 

 之前通过**代理主机**来解决，但是redis3.0中提供了解决方案。就是**无中心化集群**配置。

![1628043521426](Redis6.assets/1628043521426.png)

-----

**集群概述**

> Redis 集群实现了对Redis的水平扩容，即启动N个redis节点，将整个数据库分布存储在这N个节点中，每个节点存储总数据的1/N。
>
> Redis 集群通过分区（partition）来提供一定程度的可用性（availability）： 即使集群中有一部分节点失效或者无法进行通讯， 集群也可以继续处理命令请求。

## 12.2 集群的搭建

> 搭建结果：制作6个实例，6379,6380,6381
>
> ​											6389,6390,6391 上下对应主从

- **删除文件夹中的全部持久化文件rdb或者aof**
- **新建六个配置文件，内容如下：(除了端口号不一样，其他都一样)**

```bash
include /myredis/redis.conf
pidfile "/var/run/redis_6391.pid"
port 6391
dbfilename "dump6391.rdb"
cluster-enabled yes
cluster-config-file nodes-6391.conf
cluster-node-timeout 15000
```

> cluster-enabled yes  打开集群模式
>
> cluster-config-file nodes-6379.conf 设定节点配置文件名
>
> cluster-node-timeout 15000  设定节点失联时间，超过该时间（毫秒），集群自动进行主从切换。

其中：%s/6379/6380  是vim的替换命令

- **启动6个服务**

![1628047161485](Redis6.assets/1628047161485.png)

> 要确保nodes-xxxx.conf生成

- **将六个节点合成一个集群**

> 组合之前，请确保所有redis实例启动后，nodes-xxxx.conf文件都生成正常  

先到redis的src目录中

```bash
cd  /opt/redis-6.2.1/src
```

运行集成集群命令

```bash
redis-cli --cluster create --cluster-replicas 1 192.168.242.110:6379 192.168.242.110:6380 192.168.242.110:6381 192.168.242.110:6389 192.168.242.110:6390 192.168.242.110:6391
```

说明：ip一定要真实ip，不能是localhost或者127.0.0.1

​			 --replicas 1 采用最简单的方式配置集群，一台主机，一台从机，正好三组。  

![1628047587662](Redis6.assets/1628047587662.png)

- **查看是否集成成功**

```bash
# 连接Redis
redis-cli -c -p 6379
# 查看集群信息
cluster nodes
```

![1628047794396](Redis6.assets/1628047794396.png)

## 12.3 集群操作和故障恢复

### 12.3.1 集群操作

- 查看集群信息

```
cluster nodes
```

![1628047794396](Redis6.assets/1628047794396.png)

- **redis cluster 如何分配这六个节点** 

> 一个集群至少要有三个主节点。
>
> 选项 --cluster-replicas 1 表示我们希望为集群中的每个主节点创建一个从节点。
>
> 分配原则尽量保证每个主数据库运行在不同的IP地址，每个从库和主库不在一个IP地址上。

- 什么是slots？

> 在运行集成集群命令后，会出现“**[OK] All 16384 slots covered** ”
>
> 说明：一个 Redis 集群包含 16384 个插槽（hash slot）， 数据库中的每个键都属于这 16384 个插槽的其中一个， 集群使用公式CRC16(key) %16384 来计算键key属于哪个槽.其中 CRC16(key) 语句用于计算键 key 的 CRC16 校验和 。
>
> 集群中的每个节点负责处理一部分插槽。 举个例子， 如果一个集群可以有主节点， 其中：
>
> 节点 A 负责处理 0 号至 5460 号插槽。
>
> 节点 B 负责处理 5461 号至 10922 号插槽。
>
> 节点 C 负责处理 10923 号至 16383 号插槽。
>
> ![1628087888364](Redis6.assets/1628087888364.png)

- **在集群中录入值**

![1628130586957](Redis6.assets/1628130586957.png)

-----

![1628130637703](Redis6.assets/1628130637703.png)

注意：在用mset 同时设置多个值的时候，需要把这些key放到同一个组中，不然会报错。可以通过{}来定义组的概念，从而使key中{}内相同内容的键值对放到一个slot中去  

![1628130819302](Redis6.assets/1628130819302.png)

- **查询集群中的值**

```bash
CLUSTER KEYSLOT k1 # 查询k1的插槽值
```

![1628133733690](Redis6.assets/1628133733690.png)

```bash
CLUSTER COUNTKEYSINSLOT 12706 # 查看指定插槽中的key数量，注意只能在插槽值所在的主机上能成功，例如：12706插槽在6381端口的主机上，但是在其他端口则查询失败
```

![1628133694643](Redis6.assets/1628133694643.png)

```bash
CLUSTER GETKEYSINSLOT 5474 2 # 返回指定插槽的指定数量的key
```

![1628133806288](Redis6.assets/1628133806288.png)

### 12.3.2 故障恢复

如果主节点下线？从节点能否自动升为主节点？注意：**15秒超时**

![1628135629291](Redis6.assets/1628135629291.png)

主节点恢复后，主从关系会如何？主节点回来变成从机。

![1628135653006](Redis6.assets/1628135653006.png)

如果所有某一段插槽的主从节点都宕掉，redis服务是否还能继续?

> 如果某一段插槽的主从都挂掉，而cluster-require-full-coverage 为yes ，那么 ，整个集群都挂掉
>
> 如果某一段插槽的主从都挂掉，而cluster-require-full-coverage 为no ，那么，该插槽数据全都不能使用，也无法存储。
>
> redis.conf中的参数 cluster-require-full-coverage  

### 12.3.3 集群的Jedis开发

> 即使连接的不是主机，集群会自动切换主机存储。主机写，从机读。
>
> 无中心化主从集群。无论从哪台主机写的数据，其他主机上都能读到数据。

```java
/**
 * @author cVzhanshi
 * @create 2021-08-05 11:58
 */
public class JedisClusterTest {
    public static void main(String[] args) {
        HostAndPort hostAndPort = new HostAndPort("192.168.242.110", 6381);
        JedisCluster jedisCluster = new JedisCluster(hostAndPort);
        jedisCluster.set("k5","v5");
        String k5 = jedisCluster.get("k5");
        System.out.println(k5);
    }
}
```

![1628144859925](Redis6.assets/1628144859925.png)

### 12.4 Redis的好处与不足

**好处**

- 实现扩容
- 分摊压力
- 无中心配置相对简单

**不足**

- 多键操作是不被支持的 
- 多键的Redis事务是不被支持的。lua脚本不被支持
- 由于集群方案出现较晚，很多公司已经采用了其他的集群方案，而代理或者客户端分片的方案想要迁移至redis cluster，需要整体迁移而不是逐步过渡，复杂度较大。

# 十三、Redis应用问题的解决

## 13.1 缓存穿透

### 13.1.1 问题描述

> key对应的数据在数据源并不存在，每次针对此key的请求从缓存获取不到，请求都会压到数据源，从而可能压垮数据源。比如用一个不存在的用户id获取用户信息，不论缓存还是数据库都没有，若黑客利用此漏洞进行攻击可能压垮数据库。

![1628150662444](Redis6.assets/1628150662444.png)

### 13.1.2 解决方案

> 一个一定不存在缓存及查询不到的数据，由于缓存是不命中时被动写的，并且出于容错考虑，如果从存储层查不到数据则不写入缓存，这将导致这个不存在的数据每次请求都要到存储层去查询，失去了缓存的意义。

解决方案：

- **对空值缓存：**如果一个查询返回的数据为空（不管是数据是否不存在），我们仍然把这个空结果（null）进行缓存，设置空结果的过期时间会很短，最长不超过五分钟

- **设置可访问的名单（白名单）：**使用bitmaps类型定义一个可以访问的名单，名单id作为bitmaps的偏移量，每次访问和bitmap里面的id进行比较，如果访问id不在bitmaps里面，进行拦截，不允许访问。、

- **采用布隆过滤器**：(布隆过滤器（Bloom Filter）是1970年由布隆提出的。它实际上是一个很长的二进制向量(位图)和一系列随机映射函数（哈希函数）。布隆过滤器可以用于检索一个元素是否在一个集合中。它的优点是空间效率和查询时间都远远超过一般的算法，缺点是有一定的误识别率和删除困难。

  将所有可能存在的数据哈希到一个足够大的bitmaps中，一个一定不存在的数据会被 这个bitmaps拦截掉，从而避免了对底层存储系统的查询压力。

- **进行实时监控：**当发现的命中率开始急速降低，需要排查访问对象和访问的数据，和运维人员配合，可以设置黑名单限制服务

## 13.2 缓存击穿

### 13.2.1 问题描述

> key对应的数据存在，但在redis中过期，此时若有大量并发请求过来，这些请求发现缓存过期一般都会从后端DB加载数据并回设到缓存，这个时候大并发的请求可能会瞬间把后端DB压垮。

![1628150995953](Redis6.assets/1628150995953.png)

### 13.2.2 解决方案

> key可能会在某些时间点被超高并发地访问，是一种非常“热点”的数据。这个时候，需要考虑一个问题：缓存被“击穿”的问题。

**解决方案**

- **预先设置热门数据**：在redis高峰访问之前，把一些热门数据提前存入到redis里面，加大这些热门数据key的时长
- **实时调整**：现场监控哪些数据热门，实时调整key的过期时长

- **使用锁**：

（1）  就是在缓存失效的时候（判断拿出来的值为空），不是立即去load db。

（2）  先使用缓存工具的某些带成功操作返回值的操作（比如Redis的SETNX）去set一个mutex key

（3）  当操作返回成功时，再进行load db的操作，并回设缓存,最后删除mutex key；

（4）  当操作返回失败，证明有线程在load db，当前线程睡眠一段时间再重试整个get缓存的方法。

![1628151381663](Redis6.assets/1628151381663.png)

## 13.3 缓存雪崩

### 13.3.1 问题描述

> ​		key对应的数据存在，但在redis中过期，此时若有大量并发请求过来，这些请求发现缓存过期一般都会从后端DB加载数据并回设到缓存，这个时候大并发的请求可能会瞬间把后端DB压垮。
>
> ​		缓存雪崩与缓存击穿的区别在于这里针对很多key缓存，前者则是某一个key正常访问

![1628153894577](Redis6.assets/1628153894577.png)

### 13.3.2 解决方案

**（1）**  **构建多级缓存架构：**nginx缓存 + redis缓存 +其他缓存（ehcache等）

**（2）**  **使用锁或队列：**用加锁或者队列的方式保证来保证不会有大量的线程对数据库一次性进行读写，从而避免失效时大量的并发请求落到底层存储系统上。不适用高并发情况

**（3）**  **设置过期标志更新缓存：**记录缓存数据是否过期（设置提前量），如果过期会触发通知另外的线程在后台去更新实际key的缓存。

**（4）**  **将缓存失效时间分散开：**比如我们可以在原有的失效时间基础上增加一个随机值，比如1-5

## 13.4 分布式锁

> 随着业务发展的需要，原单体单机部署的系统被演化成分布式集群系统后，由于分布式系统多线程、多进程并且分布在不同机器上，这将使原单机部署情况下的并发控制锁策略失效，单纯的Java API并不能提供分布式锁的能力。为了解决这个问题就需要一种跨JVM的互斥机制来控制共享资源的访问，这就是分布式锁要解决的问题。
>
> 分布式锁主流的实现方案：
>
> -  基于数据库实现分布式锁
> - 基于缓存（Redis等）
> - 基于Zookeeper
>
> 每一种分布式锁解决方案都有各自的优缺点：
>
> - 性能：redis最高
> - 可靠性：zookeeper最高  

-----

**优化设置锁和过期时间**

-----

**设置锁的命令**

```bash
SETNX KEY VALUE  # 设置锁
del key   # 删除锁
```

**给锁设置过期时间**

```
expire users 30
```

![1628174793004](Redis6.assets/1628174793004.png)

> 这样设置的问题：如果设置时间和上锁分开进行的话，可能存在上完锁，服务器down了，就没有设置过期时间。

**优化**：上锁和设置过期时间同时

```bash
set key value nx ex time
```

**java代码实现**

```java
@GetMapping("testLock")
public void testLock(){
    //1获取锁，setne ,顺便设置过期时间
    Boolean lock = redisTemplate.opsForValue().setIfAbsent("lock", "111",3,TimeUnit.SECONDS);
    //2获取锁成功、查询num的值
    if(lock){
        Object value = redisTemplate.opsForValue().get("num");
        //2.1判断num为空return
        if(StringUtils.isEmpty(value)){
            return;
        }
        //2.2有值就转成成int
        int num = Integer.parseInt(value+"");
        //2.3把redis的num加1
        redisTemplate.opsForValue().set("num", ++num);
        //2.4释放锁，del
        redisTemplate.delete("lock");

    }else{
        //3获取锁失败、每隔0.1秒再获取
        try {
            Thread.sleep(100);
            testLock();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

-----

**优化之UUID防止误删**

-----

**不过代码除了修改的设置过期时间问题，还存在问题，入下图所示**：

![1628176244385](Redis6.assets/1628176244385.png)

解决方法：

![1628176390441](Redis6.assets/1628176390441.png)

代码实现：

```java
@GetMapping("testLock")
public void testLock(){
	String uuid = UUID.randomUUID().toString();
    //1获取锁，setne ,顺便设置过期时间
    Boolean lock = redisTemplate.opsForValue().setIfAbsent("lock", uuid,3,TimeUnit.SECONDS);
    //2获取锁成功、查询num的值
    if(lock){
       ...
        String lockUuid = (String)redisTemplate.opsForValue().get("lock");
        if(uuid.equals(lockUuid)){
             //2.4释放锁，del
        	redisTemplate.delete("lock");
        }
    }else{
       ...
    }
}
```

-----

 **优化之LUA脚本保证删除的原子性**  

-----

原因：

![1628176941934](Redis6.assets/1628176941934.png)

解决方案：使用lua脚本保证删除的原子性

```java
@GetMapping("testLockLua")
public void testLockLua() {
    //1 声明一个uuid ,将做为一个value 放入我们的key所对应的值中
    String uuid = UUID.randomUUID().toString();
    //2 定义一个锁：lua 脚本可以使用同一把锁，来实现删除！
    String skuId = "25"; // 访问skuId 为25号的商品 100008348542
    String locKey = "lock:" + skuId; // 锁住的是每个商品的数据

    // 3 获取锁
    Boolean lock = redisTemplate.opsForValue().setIfAbsent(locKey, uuid, 3, TimeUnit.SECONDS);

    // 第一种： lock 与过期时间中间不写任何的代码。
    // redisTemplate.expire("lock",10, TimeUnit.SECONDS);//设置过期时间
    // 如果true
    if (lock) {
        // 执行的业务逻辑开始
        // 获取缓存中的num 数据
        Object value = redisTemplate.opsForValue().get("num");
        // 如果是空直接返回
        if (StringUtils.isEmpty(value)) {
            return;
        }
        // 不是空 如果说在这出现了异常！ 那么delete 就删除失败！ 也就是说锁永远存在！
        int num = Integer.parseInt(value + "");
        // 使num 每次+1 放入缓存
        redisTemplate.opsForValue().set("num", String.valueOf(++num));
        /*使用lua脚本来锁*/
        // 定义lua 脚本
        String script = "if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) else return 0 end";
        // 使用redis执行lua执行
        DefaultRedisScript<Long> redisScript = new DefaultRedisScript<>();
        redisScript.setScriptText(script);
        // 设置一下返回值类型 为Long
        // 因为删除判断的时候，返回的0,给其封装为数据类型。如果不封装那么默认返回String 类型，
        // 那么返回字符串与0 会有发生错误。
        redisScript.setResultType(Long.class);
        // 第一个要是script 脚本 ，第二个需要判断的key，第三个就是key所对应的值。
        redisTemplate.execute(redisScript, Arrays.asList(locKey), uuid);
    } else {
        // 其他线程等待
        try {
            // 睡眠
            Thread.sleep(1000);
            // 睡醒了之后，调用方法。
            testLockLua();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

**总结**

为了确保分布式锁可用，我们至少要确保锁的实现同时**满足以下四个条件**：

- 互斥性。在任意时刻，只有一个客户端能持有锁。

- 不会发生死锁。即使有一个客户端在持有锁的期间崩溃而没有主动解锁，也能保证后续其他客户端能加锁。

- 解铃还须系铃人。加锁和解锁必须是同一个客户端，客户端自己不能把别人加的锁给解了。

- 加锁和解锁必须具有原子性。

# 十四、Redis6.0的新功能

## 14.1 ACL

### 14.1.1 简介

> Redis ACL是Access Control List（访问控制列表）的缩写，该功能允许根据可以执行的命令和可以访问的键来限制某些连接。
>
> ​         在Redis 5版本之前，Redis 安全规则只有密码控制 还有通过rename 来调整高危命令比如 flushdb ， KEYS* ， shutdown 等。Redis 6 则提供ACL的功能对用户进行更细粒度的权限控制：
>
> （1）接入权限:用户名和密码 
>
> （2）可以执行的命令 
>
> （3）可以操作的 KEY  

### 14.1.2 命令

- **使用acl list命令展现用户权限列表** 

![1628212514704](Redis6.assets/1628212514704.png)

- **使用acl cat命令**  
  - 查看添加权限指令类别

  ![1628212569972](Redis6.assets/1628212569972.png)
  - 加参数类型名可以查看类型下具体命令

  ![1628212588155](Redis6.assets/1628212588155.png)

- 使用acl whoami命令查看当前用户

![1628212611582](Redis6.assets/1628212611582.png)

- 使用aclsetuser命令创建和编辑用户ACL

  - ACL规则

  > 下面是有效ACL规则的列表。某些规则只是用于激活或删除标志，或对用户ACL执行给定更改的单个单词。其他规则是字符前缀，它们与命令或类别名称、键模式等连接在一起
  >
  > |       ACL规则        |                  |                                                              |
  > | :------------------: | ---------------- | ------------------------------------------------------------ |
  > |         类型         | 参数             | 说明                                                         |
  > |    启动和禁用用户    | **on**           | 激活某用户账号                                               |
  > |    启动和禁用用户    | **off**          | 禁用某用户账号。注意，已验证的连接仍然可以工作。如果默认用户被标记为off，则新连接将在未进行身份验证的情况下启动，并要求用户使用AUTH选项发送AUTH或HELLO，以便以某种方式进行身份验证。 |
  > |    权限的添加删除    | +<command>       | 将指令添加到用户可以调用的指令列表中                         |
  > |    权限的添加删除    | -<command>       | 从用户可执行指令列表移除指令                                 |
  > |    权限的添加删除    | **+@**<categroy> | 添加该类别中用户要调用的所有指令，有效类别为@admin、@set、@sortedset…等，通过调用ACL CAT命令查看完整列表。特殊类别@all表示所有命令，包括当前存在于服务器中的命令，以及将来将通过模块加载的命令 |
  > |    权限的添加删除    | -@<actegory>     | 从用户可调用指令中移除类别                                   |
  > |    权限的添加删除    | **allcommands**  | +@all的别名                                                  |
  > |    权限的添加删除    | **nocommand**    | -@all的别名                                                  |
  > | 可操作键的添加或删除 | **~**  <pattarn> | 添加可作为用户可操作的键的模式。例如~*允许所有的键           |
  - 通过命令创建新用户默认权限

    ```bash
    acl setuser user1
    ```

     ![1628213063179](Redis6.assets/1628213063179.png)

    > 在上面的示例中，我根本没有指定任何规则。如果用户不存在，这将使用just created的默认属性来创建用户。如果用户已经存在，则上面的命令将不执行任何操作。

  - 设置有用户名、密码、ACL权限、并启用的用户

    ```bash
    acl setuser user2 on >password ~cached:* +get
    ```

    ![1628213146249](Redis6.assets/1628213146249.png)

  - 切换用户，验证权限

    ![1628213174346](Redis6.assets/1628213174346.png) 

## 14.2 IO多线程

> Redis6终于支撑多线程了，告别单线程了吗？
>
> IO多线程其实指**客户端交互部分**的**网络IO**交互处理模块**多线程**，而非**执行命令多线程**。Redis6执行命令依然是单线程

**原理架构**

​         Redis 6 加入多线程,但跟 Memcached 这种从 IO处理到数据访问多线程的实现模式有些差异。Redis 的多线程部分只是用来处理网络数据的读写和协议解析，**执行命令仍然是单线程**。之所以这么设计是不想因为多线程而变得复杂，需要去控制 key、lua、事务，LPUSH/LPOP 等等的并发问题。整体的设计大体如下:  

![1628217001710](Redis6.assets/1628217001710.png)

> 另外，多线程IO默认也是不开启的，需要再配置文件中配置
>
> io-threads-do-reads yes 
>
> io-threads 4

## 14.3  工具支持 Cluster

之前老版Redis想要搭集群需要单独安装ruby环境，Redis 5 将 redis-trib.rb 的功能集成到 redis-cli 。另外官方 redis-benchmark 工具开始支持 cluster 模式了，通过多线程的方式对多个分片进行压测压。

![1628217092455](Redis6.assets/1628217092455.png)

-----

> Redis6新功能还有：
>
> 1、RESP3新的 Redis 通信协议：优化服务端与客户端之间通信
>
> 2、Client side caching客户端缓存：基于 RESP3 协议实现的客户端缓存功能。为了进一步提升缓存的性能，将客户端经常访问的数据cache到客户端。减少TCP网络交互。
>
> 3、Proxy集群代理模式：Proxy 功能，让 Cluster 拥有像单实例一样的接入方式，降低大家使用cluster的门槛。不过需要注意的是代理不改变 Cluster 的功能限制，不支持的命令还是不会支持，比如跨 slot 的多Key操作。
>
> 4、Modules API：Redis 6中模块开发进展非常大，因为为了开发复杂的功能，从一开始就用上模块。可以变成一个框架，利用来构建不同系统，而不需要从头开始写然后还要许可。一开始就是一个向编写各种系统开放的平台。

