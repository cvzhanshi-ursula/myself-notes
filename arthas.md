# Arthas

`Arthas` 是 Alibaba 开源的 Java 诊断工具

## 作用

1. 这个类从哪个 jar 包加载的？为什么会报各种类相关的 Exception？
2. 我改的代码为什么没有执行到？难道是我没 commit？分支搞错了？
3. 遇到问题无法在线上 debug，难道只能通过加日志再重新发布吗？
4. 线上遇到某个用户的数据处理有问题，但线上同样无法 debug，线下无法重现！
5. 是否有一个全局视角来查看系统的运行状况？
6. 有什么办法可以监控到JVM的实时运行状态？
7. 怎么快速定位应用的热点，生成火焰图？
8. 怎样直接从JVM内查找某个类的实例？

## 下载安装

> 方式一：使用`arthas-boot`（Linux推荐）

下载`arthas-boot.jar`，然后用`java -jar`的方式启动：

```sh
curl -O https://arthas.aliyun.com/arthas-boot.jar
java -jar arthas-boot.jar
```

- 如果下载速度比较慢，可以使用 aliyun 的镜像：

  ```sh
  java -jar arthas-boot.jar --repo-mirror aliyun --use-http
  ```

> 方式二：全量安装（Windows推荐）

[下载地址](https://arthas.aliyun.com/download/latest_version?mirror=aliyun)

解压后，在文件夹里有`arthas-boot.jar`，直接用`java -jar`的方式启动：

```sh
java -jar arthas-boot.jar 
```

打印帮助信息：

```sh
java -jar arthas-boot.jar -h
```

## 用法

### 前提

arthas是基于依赖JDK环境运行，要配置JDK环境变量，只有jre环境不行，启动时内部依赖jps命令，如果机器jps找不到命令，arthas无法启动。

### 启动

直接运行arthas-boot.jar

```bash
C:\cvzhanshi\workspace\arthas-packaging-3.6.6-bin>java -jar arthas-boot.jar
[INFO] arthas-boot version: 3.6.6
[INFO] Process 10520 already using port 3658
[INFO] Process 10520 already using port 8563
[INFO] Found existing java process, please choose one and input the serial number of the process, eg : 1. Then hit ENTER.
* [1]: 10520 cn.cvzhanshi.TestApplication
  [2]: 19600
  [3]: 13604 org.jetbrains.idea.maven.server.RemoteMavenServer36
  [4]: 11752 org.apache.zookeeper.server.quorum.QuorumPeerMain
  [5]: 2376 org.jetbrains.jps.cmdline.Launcher
  [6]: 24712 C:\cvzhanshi\environment\nacos\target\nacos-server.jar
  [7]: 7656 org.jetbrains.jps.cmdline.Launcher
  [8]: 15484 org.jetbrains.jps.cmdline.Launcher
  [9]: 8124 org.jetbrains.jps.cmdline.Launcher
```

- 执行该程序的用户需要和目标进程具有相同的权限。比如以`admin`用户来执行：`sudo su admin && java -jar arthas-boot.jar` 或 `sudo -u admin -EH java -jar arthas-boot.jar`。
- 如果 attach 不上目标进程，可以查看`~/logs/arthas/` 目录下的日志。
- 如果下载速度比较慢，可以使用 aliyun 的镜像：`java -jar arthas-boot.jar --repo-mirror aliyun --use-http`
- `java -jar arthas-boot.jar -h` 打印更多参数信息。

选择需要诊断的java进程的编号，回车，进入命令行。			

### 命令列表

#### jvm 相关

- [dashboard](https://arthas.aliyun.com/doc/dashboard.html) - 当前系统的实时数据面板
- [getstatic](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看类的静态属性
- [heapdump](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - dump java heap, 类似 jmap 命令的 heap dump 功能
- [jvm](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看当前 JVM 的信息
- [logger](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看和修改 logger
- [mbean](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看 Mbean 的信息
- [memory](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看 JVM 的内存信息
- [ognl](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 执行 ognl 表达式
- [perfcounter](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看当前 JVM 的 Perf Counter 信息
- [sysenv](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看 JVM 的环境变量
- [sysprop](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看和修改 JVM 的系统属性
- [thread](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看当前 JVM 的线程堆栈信息
- [vmoption](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看和修改 JVM 里诊断相关的 option
- [vmtool](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 从 jvm 里查询对象，执行 forceGc

#### class/classloader 相关

- [classloader](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看 classloader 的继承树，urls，类加载信息，使用 classloader 去 getResource
- [dump](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - dump 已加载类的 byte code 到特定目录
- [jad](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 反编译指定已加载类的源码
- [mc](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 内存编译器，内存编译`.java`文件为`.class`文件
- [redefine](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 加载外部的`.class`文件，redefine 到 JVM 里
- [retransform](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 加载外部的`.class`文件，retransform 到 JVM 里
- [sc](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看 JVM 已加载的类信息
- [sm](https://arthas.aliyun.com/download/latest_version?mirror=aliyun) - 查看已加载类的方法信息

#### monitor/watch/trace 相关

> 注意
>
> 请注意，这些命令，都通过字节码增强技术来实现的，会在指定类的方法中插入一些切面来实现数据统计和观测，因此在线上、预发使用时，请尽量明确需要观测的类、方法以及条件，诊断结束要执行 `stop` 或将增强过的类执行 `reset` 命令。

- [monitor](https://arthas.aliyun.com/doc/monitor.html) - 方法执行监控
- [stack](https://arthas.aliyun.com/doc/stack.html) - 输出当前方法被调用的调用路径
- [trace](https://arthas.aliyun.com/doc/trace.html) - 方法内部调用路径，并输出方法路径上的每个节点上耗时
- [tt](https://arthas.aliyun.com/doc/tt.html) - 方法执行数据的时空隧道，记录下指定方法每次调用的入参和返回信息，并能对这些不同的时间下调用进行观测
- [watch](https://arthas.aliyun.com/doc/watch.html) - 方法执行数据观测

#### profiler/火焰图

- [profiler](https://arthas.aliyun.com/doc/profiler.html) - 使用[async-profiler在新窗口打开](https://github.com/jvm-profiling-tools/async-profiler)对应用采样，生成火焰图
- [jfr](https://arthas.aliyun.com/doc/jfr.html) - 动态开启关闭 JFR 记录

#### 鉴权

- [auth](https://arthas.aliyun.com/doc/auth.html) - 鉴权

#### options

- [options](https://arthas.aliyun.com/doc/options.html) - 查看或设置 Arthas 全局开关

#### 管道

Arthas 支持使用管道对上述命令的结果进行进一步的处理，如`sm java.lang.String * | grep 'index'`

- [grep](https://arthas.aliyun.com/doc/grep.html) - 搜索满足条件的结果
- plaintext - 将命令的结果去除 ANSI 颜色
- wc - 按行统计输出结果

#### 后台异步任务

当线上出现偶发的问题，比如需要 watch 某个条件，而这个条件一天可能才会出现一次时，异步后台任务就派上用场了，详情请参考[这里](https://arthas.aliyun.com/doc/async.html)

- 使用 `>` 将结果重写向到日志文件，使用 `&` 指定命令是后台运行，session 断开不影响任务执行（生命周期默认为 1 天）
- jobs - 列出所有 job
- kill - 强制终止任务
- fg - 将暂停的任务拉到前台执行
- bg - 将暂停的任务放到后台执行

#### 基础命令

- [base64](https://arthas.aliyun.com/doc/base64.html) - base64 编码转换，和 linux 里的 base64 命令类似
- [cat](https://arthas.aliyun.com/doc/cat.html) - 打印文件内容，和 linux 里的 cat 命令类似
- [cls](https://arthas.aliyun.com/doc/cls.html) - 清空当前屏幕区域
- [echo](https://arthas.aliyun.com/doc/echo.html) - 打印参数，和 linux 里的 echo 命令类似
- [grep](https://arthas.aliyun.com/doc/grep.html) - 匹配查找，和 linux 里的 grep 命令类似
- [help](https://arthas.aliyun.com/doc/help.html) - 查看命令帮助信息
- [history](https://arthas.aliyun.com/doc/history.html) - 打印命令历史
- [keymap](https://arthas.aliyun.com/doc/keymap.html) - Arthas 快捷键列表及自定义快捷键
- [pwd](https://arthas.aliyun.com/doc/pwd.html) - 返回当前的工作目录，和 linux 命令类似
- [quit](https://arthas.aliyun.com/doc/quit.html) - 退出当前 Arthas 客户端，其他 Arthas 客户端不受影响
- [reset](https://arthas.aliyun.com/doc/reset.html) - 重置增强类，将被 Arthas 增强过的类全部还原，Arthas 服务端关闭时会重置所有增强过的类
- [session](https://arthas.aliyun.com/doc/session.html) - 查看当前会话的信息
- [stop](https://arthas.aliyun.com/doc/stop.html) - 关闭 Arthas 服务端，所有 Arthas 客户端全部退出
- [tee](https://arthas.aliyun.com/doc/tee.html) - 复制标准输入到标准输出和指定的文件，和 linux 里的 tee 命令类似
- [version](https://arthas.aliyun.com/doc/version.html) - 输出当前目标 Java 进程所加载的 Arthas 版本号

### 常用命令

#### help

```bash
[arthas@10520]$ help
 NAME         DESCRIPTION
 help         Display Arthas Help
 auth         Authenticates the current session
 keymap       Display all the available keymap for the specified connection.
 sc           Search all the classes loaded by JVM
 sm           Search the method of classes loaded by JVM
 classloader  Show classloader info
 jad          Decompile class
 getstatic    Show the static field of a class
 monitor      Monitor method execution statistics, e.g. total/success/failure count, average rt, fail rate, etc.
 stack        Display the stack trace for the specified class and method
 thread       Display thread info, thread stack
 trace        Trace the execution time of specified method invocation.
 watch        Display the input/output parameter, return object, and thrown exception of specified method invocation
 tt           Time Tunnel
 jvm          Display the target JVM information
 memory       Display jvm memory info.
 perfcounter  Display the perf counter information.
 ognl         Execute ognl expression.
 mc           Memory compiler, compiles java files into bytecode and class files in memory.
 redefine     Redefine classes. @see Instrumentation#redefineClasses(ClassDefinition...)
 retransform  Retransform classes. @see Instrumentation#retransformClasses(Class...)
 dashboard    Overview of target jvm's thread, memory, gc, vm, tomcat info.
 dump         Dump class byte array from JVM
 heapdump     Heap dump
 options      View and change various Arthas options
 cls          Clear the screen
 reset        Reset all the enhanced classes
 version      Display Arthas version
 session      Display current session information
 sysprop      Display, and change the system properties.
 sysenv       Display the system env.
 vmoption     Display, and update the vm diagnostic options.
 logger       Print logger info, and update the logger level
 history      Display command history
 cat          Concatenate and print files
 base64       Encode and decode using Base64 representation
 echo         write arguments to the standard output
 pwd          Return working directory name
 mbean        Display the mbean information
 grep         grep command for pipes.
 tee          tee command for pipes.
 profiler     Async Profiler. https://github.com/jvm-profiling-tools/async-profiler
 vmtool       jvm tool
 stop         Stop/Shutdown Arthas server and exit the console.
```

其中每个命令都可以加-help或者-h选项，打印帮助信息

#### jad

反编译类或方法

```sh
[arthas@10520]$ jad cn.cvzhanshi.TestApplication

ClassLoader:
+-sun.misc.Launcher$AppClassLoader@58644d46
  +-sun.misc.Launcher$ExtClassLoader@1996cd68

Location:
/C:/cvzhanshi/workspace/BootTest/target/classes/

       /*
        * Decompiled with CFR.
        */
       package cn.cvzhanshi;

       import org.springframework.boot.SpringApplication;
       import org.springframework.boot.autoconfigure.SpringBootApplication;

       @SpringBootApplication
       public class TestApplication {
           public static void main(String[] args) {
/*10*/         SpringApplication.run(TestApplication.class, args);
           }
       }

Affect(row-cnt:2) cost in 874 ms.
```

反编译方法

```bash
[arthas@10520]$ jad cn.cvzhanshi.TestApplication getInitPara
```

#### stack

打印方法的调用堆栈信息，当不知道某个方法从哪里被调用使时，推荐使用。

```bash
stack cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl listAllQuickCheck
```

可以指定添加表达式

```txt
           target : the object
            clazz : the object's class
           method : the constructor or method
           params : the parameters array of method
     params[0..n] : the element of parameters array
        returnObj : the returned object of method
         throwExp : the throw exception of method
         isReturn : the method ended by return
          isThrow : the method ended by throwing exception
            #cost : the execution time in ms of method invocation
```

如果某个方法有重载，可以指定 'params.length`==`2'，是否有返回值'isReturn`==`true'

|            参数名称 | 参数说明                             |
| ------------------: | :----------------------------------- |
|     *class-pattern* | 类名表达式匹配                       |
|    *method-pattern* | 方法名表达式匹配                     |
| *condition-express* | 条件表达式                           |
|                 [E] | 开启正则表达式匹配，默认为通配符匹配 |
|              `[n:]` | 执行次数限制v                        |

这里重点要说明的是观察表达式，观察表达式的构成主要由 ognl 表达式组成，所以你可以这样写`"{params,returnObj}"`，只要是一个合法的 ognl 表达式，都能被正常支持。

#### trace

**检测指定方法的执行时间**，分析性能问题常用。可以显示方法总耗时，方法内部每个方法的耗时

```bash
[arthas@22249]$ trace cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl listAllQuickCheck
Press Q or Ctrl+C to abort.
Affect(class count: 2 , method count: 2) cost in 453 ms, listenerId: 12
`---ts=2022-09-25 16:16:26;thread_name=https-jsse-nio-7443-exec-9;id=7c;is_daemon=true;priority=5;TCCL=org.apache.catalina.loader.ParallelWebappClassLoader@5e5d171f
    `---[29.427293ms] cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl$$EnhancerBySpringCGLIB$$9a53710:listAllQuickCheck()
        `---[29.269844ms] org.springframework.cglib.proxy.MethodInterceptor:intercept()
            `---[27.574802ms] cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl:listAllQuickCheck()
                +---[0.043715ms] cn.cvzhanshi.project.quickcheck.vo.ReturnVO:<init>() #1252
                +---[0.045866ms] cn.cvzhanshi.project.system.cache.ICacheService:getQuickVOs() #1257
                +---[0.017484ms] cn.cvzhanshi.project.system.cache.ICacheService:getQuickVOs() #1283
                +---[0.335878ms] org.slf4j.Logger:info() #1288
                +---[min=0.010004ms,max=0.021479ms,total=0.031483ms,count=2] cn.cvzhanshi.project.quickcheck.vo.QueryVO:getPage() #1290
                +---[0.01918ms] cn.cvzhanshi.project.system.common.Page:getCheckType() #1290
                +---[0.032272ms] cn.cvzhanshi.project.system.user.vo.UserVO:getPkOrg() #1297
                +---[0.024467ms] cn.cvzhanshi.project.system.common.DataAuth:getSubUsers() #1297
                +---[6.412332ms] cn.cvzhanshi.project.system.common.DataAuth:getAdminsInSameOrg() #1298
                +---[0.027311ms] cn.cvzhanshi.project.system.common.DataAuth:getQueryConditions2() #1299
                +---[0.014522ms] cn.cvzhanshi.project.quickcheck.vo.QueryVO:getConditions() #1315
                +---[0.355064ms] org.slf4j.Logger:info() #1374
                +---[0.019006ms] cn.cvzhanshi.project.quickcheck.vo.ReturnVO:setTotalCount() #1377
                +---[0.139323ms] org.slf4j.Logger:info() #1378
                +---[0.010446ms] cn.cvzhanshi.project.quickcheck.vo.QueryVO:getPage() #1379
                +---[0.015853ms] cn.cvzhanshi.project.system.common.Page:getPageIndex() #1383
                +---[0.017482ms] cn.cvzhanshi.project.system.common.Page:getPageSize() #1383
                +---[0.118588ms] org.slf4j.Logger:info() #1384
                +---[0.031007ms] cn.cvzhanshi.project.quickcheck.vo.ReturnVO:setQuickVOS() #1398
                `---[0.125891ms] org.slf4j.Logger:info() #1420
```

|            参数名称 | 参数说明                             |
| ------------------: | :----------------------------------- |
|     *class-pattern* | 类名表达式匹配                       |
|    *method-pattern* | 方法名表达式匹配                     |
| *condition-express* | 条件表达式                           |
|                 [E] | 开启正则表达式匹配，默认为通配符匹配 |
|              `[n:]` | 命令执行次数                         |
|             `#cost` | 方法执行耗时                         |

这里重点要说明的是观察表达式，观察表达式的构成主要由 ognl 表达式组成，所以你可以这样写`"{params,returnObj}"`，只要是一个合法的 ognl 表达式，都能被正常支持。

#### watch

监控方法的入参，出参，返回值，异常信息。分析代码运行逻辑错误常用

```sh
[arthas@22249]$ watch cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl listAllQuickCheck
Press Q or Ctrl+C to abort.
Affect(class count: 2 , method count: 2) cost in 325 ms, listenerId: 13
method=cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl.listAllQuickCheck location=AtExit
ts=2022-09-25 16:20:52; [cost=26.88488ms] result=@ArrayList[
    @Object[][isEmpty=false;size=2],
    @QuickCheckServiceImpl[cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl@1d93574],
    @ReturnVO[ReturnVO(totalCount=12, quickVOS=[QuickVO [pkTemplate=null, pkQuick=10, pkCode=12, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=10, pkCode=12, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=9, pkCode=11, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=9, pkCode=11, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=8, pkCode=10, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=7, pkCode=8, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=null], QuickVO [pkTemplate=null, pkQuick=6, pkCode=7, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=5, pkCode=6, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=4, pkCode=5, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=3, pkCode=4, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=2, pkCode=3, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=], QuickVO [pkTemplate=null, pkQuick=1, pkCode=1, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]])],
]

```

location=AtExit，标识正常结束，AtExceptionExit异常退出

如果只想打印入参和出参，可以添加'{params,returnObj}'。

如果想打印更详细的参数内部信息，可以执行 -x选项，-x 2标识展开参数内部一层属性，例如：

```sh
[arthas@22249]$ watch cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl listAllQuickCheck '{params,returnObj}' -x 2
Press Q or Ctrl+C to abort.
Affect(class count: 2 , method count: 2) cost in 317 ms, listenerId: 15
method=cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl.listAllQuickCheck location=AtExit
ts=2022-09-25 16:27:00; [cost=27.125728ms] result=@ArrayList[
    @Object[][
        @UserVO[UserVO(username=admin, remark=超级管理员)],
        @QueryVO[QueryVO(conditions=null, page=Page(pageIndex=0, pageSize=15, checkType=0), dataAuthConditions=null)],
    ],
    @ReturnVO[
        serialVersionUID=@Long[2869465919425993293],
        totalCount=@Integer[12],
        quickVOS=@ArrayList[isEmpty=false;size=12],
    ],
]
```

再深一层，指定-x 3

```sh
[arthas@22249]$ watch cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl listAllQuickCheck '{params,returnObj}' -x 3
Press Q or Ctrl+C to abort.
Affect(class count: 2 , method count: 2) cost in 313 ms, listenerId: 16
method=cn.cvzhanshi.project.quickcheck.service.impl.QuickCheckServiceImpl.listAllQuickCheck location=AtExit
ts=2022-09-25 16:30:58; [cost=29.749962ms] result=@ArrayList[
    @Object[][
        @UserVO[
            serialVersionUID=@Long[1],
            IS_SYS_INIT=@String[Y],
            NOT_SYS_INIT=@String[N],
            IS_FROZEN=@String[Y],
            NOT_FROZEN=@String[N],
            USER_NAME_MAX_LENGTH=@Integer[50],
            USER_PASSWORD_MAX_LENGTH=@Integer[30],
            USER_REMARK_MAX_LENGTH=@Integer[500],
            USER_SVNGIT_URL_MAX_LENGTH=@Integer[1000],
            USER_PASSWORD_MIN_LENGTH=@Integer[8],
            USER_EMAIL_MAX_LENGTH=@Integer[200],
            USER_PHONE_MAX_LENGTH=@Integer[50],
            pkUser=@Long[1],
            username=@String[admin],
            displayName=null,
            password=null,
            phone=null,
            email=null,
            remark=@String[超级管理员],
            pkOrg=@Long[1],
            orgName=@String[系统默认],
            roleName=null,
            pkRole=null,
            isFirst=@Integer[0],
            isInit=@String[Y],
            leader=null,
            leaderName=null,
            roles=@ArrayList[isEmpty=false;size=1],
            roleList=null,
            svnGits=null,
            isFrozen=null,
            isDel=null,
            type=@Integer[1],
            isAdmin=@Boolean[true],
            disabled=null,
            enablePlatform=@Integer[0],
            authorities=@UnmodifiableSet[isEmpty=false;size=177],
            accountNonExpired=@Boolean[true],
            accountNonLocked=@Boolean[true],
            credentialsNonExpired=@Boolean[true],
            enabled=@Boolean[true],
            includeDeleted=null,
            license=null,
            captcha=null,
            orgChains=null,
        ],
        @QueryVO[
            serialVersionUID=@Long[4880479368610906456],
            conditions=null,
            page=@Page[Page(pageIndex=0, pageSize=15, checkType=0)],
            dataAuthConditions=null,
        ],
    ],
    @ReturnVO[
        serialVersionUID=@Long[2869465919425993293],
        totalCount=@Integer[12],
        quickVOS=@ArrayList[
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=10, pkCode=12, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=10, pkCode=12, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=9, pkCode=11, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=9, pkCode=11, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=8, pkCode=10, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=7, pkCode=8, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=null]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=6, pkCode=7, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=5, pkCode=6, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=4, pkCode=5, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=3, pkCode=4, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=2, pkCode=3, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
            @QuickVO[QuickVO [pkTemplate=null, pkQuick=1, pkCode=1, checkType=0, pkUser=1, user_name=admin, quickPerm=0, auditPkTask=null, disabled=false, taskDesc=]],
        ],
    ],
]

```

#### jvm

显示jvm信息

```sh
[arthas@22249]$ jvm
 RUNTIME
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 MACHINE-NAME                                                       22249@localhost.localdomain
 JVM-START-TIME                                                     2022-08-24 11:16:20
 MANAGEMENT-SPEC-VERSION                                            1.2
 SPEC-NAME                                                          Java Virtual Machine Specification
 SPEC-VENDOR                                                        Oracle Corporation
 SPEC-VERSION                                                       1.8
 VM-NAME                                                            Java HotSpot(TM) 64-Bit Server VM
 VM-VENDOR                                                          Oracle Corporation
 VM-VERSION                                                         25.144-b01
 INPUT-ARGUMENTS                                                    -Djava.util.logging.config.file=/usr/local/project/projectserver/conf/logging.properties
                                                                    -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
                                                                    -Xms20G
                                                                    -Xmx20G
                                                                    -Djdk.tls.ephemeralDHKeySize=2048

```

#### dashboard

输入dashboard，按`回车/enter`，会展示当前进程的信息，按`ctrl+c`可以中断执行。

监控jvm线程，内存，gc信息

可加参数：

- -h 帮助信息

- -n 监控次数

- -i  刷新间隔

```sh
# -n监控一次就结束
[arthas@10520]$ dashboard -n 1
ID   NAME                          GROUP          PRIORITY  STATE    %CPU      DELTA_TIM TIME      INTERRUPT DAEMON
41   DestroyJavaVM                 main           5         RUNNABLE 0.0       0.000     0:3.921   false     false
35   cluster_scheduler_QuartzSched QuartzSchedule 5         TIMED_WA 0.0       0.000     0:2.687   false     false
-1   C1 CompilerThread3            -              -1        -        0.0       0.000     0:2.140   false     true
39   QuartzScheduler_cluster_sched main           7         TIMED_WA 0.0       0.000     0:0.406   false     false
83   arthas-NettyWebsocketTtyBoots system         5         RUNNABLE 0.0       0.000     0:0.265   false     true
13   RMI TCP Accept-0              system         5         RUNNABLE 0.0       0.000     0:0.234   false     true
31   cluster_scheduler_Worker-2    main           5         TIMED_WA 0.0       0.000     0:0.125   false     false
-1   VM Thread                     -              -1        -        0.0       0.000     0:0.125   false     true
30   cluster_scheduler_Worker-1    main           5         TIMED_WA 0.0       0.000     0:0.109   false     false
89   arthas-NettyHttpTelnetBootstr system         5         RUNNABLE 0.0       0.000     0:0.078   false     true
34   cluster_scheduler_Worker-5    main           5         TIMED_WA 0.0       0.000     0:0.078   false     false
Memory                    used    total    max     usage    GC
heap                      74M     328M     3621M   2.05%    gc.ps_scavenge.count          8
ps_eden_space             28M     163M     1323M   2.13%    gc.ps_scavenge.time(ms)       68
ps_survivor_space         12M     13M      13M     99.82%   gc.ps_marksweep.count         2
ps_old_gen                33M     152M     2716M   1.22%    gc.ps_marksweep.time(ms)      67
nonheap                   71M     74M      -1      95.47%
code_cache                10M     10M      240M    4.44%
metaspace                 53M     56M      -1      94.90%
compressed_class_space    7M      7M       1024M   0.70%
Runtime
os.name                                                     Windows 8.1
os.version                                                  6.3
java.version                                                1.8.0_25
java.home                                                   C:\Program Files\Java\jdk1.8.0_25\jre
systemload.average                                          -1.00
processors                                                  8
timestamp/uptime                                            Mon Nov 07 17:08:17 CST 2022/1506s
```

#### heapdump

dump堆，出现对内存溢出时，可以分析哪些对象占用内存多，eclipse插件可以分析

```sh
[arthas@10520]$ heapdump
Dumping heap to C:\Users\LIANLI~1\AppData\Local\Temp\heapdump2022-11-07-17-195132433322158585166.hprof ...
Heap dump file created
```

#### vmoption

显示，更新jvm参数

```bash
[arthas@22249]$ vmoption PrintGC
 KEY                                                       VALUE                                                      ORIGIN                                                    WRITEABLE
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 PrintGC                                                   false                                                      DEFAULT                                                   true
[arthas@22249]$ vmoption PrintGC true
Successfully updated the vm option.
 NAME     BEFORE-VALUE  AFTER-VALUE
------------------------------------
 PrintGC  false         true

```

#### 退出arthas

如果只是退出当前的连接，可以用`quit`或者`exit`命令。Attach 到目标进程上的 arthas 还会继续运行，端口会保持开放，下次连接时可以直接连接上。

如果想完全退出 arthas，可以执行`stop`命令。