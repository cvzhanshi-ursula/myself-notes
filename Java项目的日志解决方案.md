## ① 概述

**在开发中除了使用到的类会打印出日志，开发者自己也需要打印日志来记录开发流程、运行位置以及异常信息等等。**

**项目中的日志能够很好的帮助我们找到bug的出现位置，以及出现bug的原因。由此可见，利用好日志能够大大替身开发者的开发效率。**

目前市面比较流行的日志框架：slf4j、log4j、log4j2、logback。

- **slf4j**：是对所有日志框架制定的一种规范、标准、接口，并不是一个框架的具体的实现，因为接口并不能独立使用，需要和具体的日志框架实现配合使用

- （如log4j、logback），**使用接口的好处是当项目需要更换日志框架的时候，只需要更换jar和配置，不需要更改相关java代码**

- **log4j、log4j2**：log4j2是log4j的升级版。目前log4j以及停止更新了，所以一般用的都是log4j2。而且在多线程情况下，异步日志器具有比Log4j 1.x和Logback

  高出10倍的吞吐性能以及更低的延迟。log4j2还支持scala语言。

- logback：与Log4j同出一源，都出自Ceki Gülcü之手；但是**logback拥有更好的特性**，是用来取代log4j的一个日志实现方案。Logback是slf4j的原生实现，与

  Log4j不同（Log4j可以脱离Slf4j单独使用），logback并不建议单独使用，它需要与sfl4j结合起来使用。

==目前市面上用的最多的结合以及亲测推荐的日志组合就是：slf4j + logback==

> 日志级别

日志级别有8个（从高到低）： OFF（关闭），FATAL（致命），ERROR（错误），WARN（警告），INFO（信息），DEBUG（调试），TRACE（跟踪），ALL

（所有），默认的日志配置在消息写入时将消息回显到控制台。默认情况下，将记录错误级别、警告级别和信息级别的消息。

- **Trace**:是追踪，就是程序推进以下，你就可以写个trace输出，所以trace应该会特别多，不过没关系，我们可以设置最低日志级别不让他输出.
- **Debug**:指出细粒度信息事件对调试应用程序是非常有帮助的.
- **Info**:消息在粗粒度级别上突出强调应用程序的运行过程.
- **Warn**:输出警告及warn以下级别的日志.
- **Error**:输出错误信息日志.

- 此外**OFF**表示关闭全部日志，**ALL**表示开启全部日志。

Log4j定义了上述8个级别的log，而**SLF4J和Logback没有定义FATAL级别**。**Logback没有FATAL致命级别。它被映射到ERROR错误级别**

一般用的最多的是ERROR > WARN > INFO > DEBUG

## ② 依赖与配置

### 2.1 maven依赖

> Spring Boot项目

SpringBoot采用的默认的日志框架就是slf4j+logback，所以配置的时候无需在pom.xml中添加依赖，我们只需要手动添加配置文件就好。

> 普通maven项目

导入依赖

```xml
<dependencies>
    <!--https://mvnrepository.com/artifact/org.slf4j/slf4j-api -->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>1.7.32</version>
    </dependency>
    <!-- https://mvnrepository.com/artifact/ch.qos.logback/logback-classic -->
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.2.7</version>
    </dependency>
    <!-- https://mvnrepository.com/artifact/ch.qos.logback/logback-core -->
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-core</artifactId>
        <version>1.2.7</version>
    </dependency>
    <!-- https://mvnrepository.com/artifact/ch.qos.logback/logback-access -->
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-access</artifactId>
        <version>1.2.7</version>
    </dependency>
</dependencies>
```

### 2.2 logback的配置文件

> **logback.xml 和 logback-spring.xml 的区别**

logback.xml 和 logback-spring.xml 都可以用来配置logback，但是2者的加载顺序是不一样的（logback.xml 由日志框架加载，而 logback-spring.xml 由

SpringBoot来加载）。

- 加载顺序：logback.xml   -->  application.yaml  -->  locback-spring.xml

**logback.xml 加载早于 application.properties，所以如果你在logback.xml使用了变量时，而恰好这个变量是写在application.yaml时，那么就会获取不到。**

logback-spring.xml这样的命名方式是官方推荐的，使用 logback.xml 的命名直接被日志框架识别了，而使用logback-spring.xml这样的命名日志框架就不直接加

载，而由SpringBoot来加载，这样在日志配置文件中可以使用`<springProfile>`标签，可以指定某配置项只在某个环境下生效（即开发环境dev或是生产环境

pro等）==推荐使用logback-spring.xml==

> **logback.xml 配置文件的加载机制**

logback在启动时，日志框架会根据以下步骤寻找 logback.xml 配置文件（而 logback-spring.xml 是由springboot加载的）：

1. 在classpath中寻找logback-test.xml文件；

2. 如果找不到logback-test.xml，则在 classpath中寻找logback.groovy文件；

3. 如果找不到 logback.groovy，则在classpath中寻找logback.xml文件；

4. 如果上述的文件都找不到，则logback会使用JDK的SPI机制查找 META-INF/services/ch.qos.logback.classic.spi.Configurator中的 logback 配置实现类，这个

   实现类必须实现Configuration接口，使用它的实现来进行配置。

5. 如果上述操作都不成功，logback 就会使用它自带的 BasicConfigurator 来配置，并将日志输出到console。

> loggback配置说明

|                     | 位置（resource目录下） | 说明                                                         |
| ------------------- | ---------------------- | ------------------------------------------------------------ |
| **官方推荐**        | logback-spring.xml     | 默认读取resources目录下的 logback-spring.xml                 |
| **自定义位置**      | log/logback-spring.xml | application.yml或者properties中配置: logging.config=classpath:log/logback-spring.xml |
| **logback.xml**     | logback.xml            | 默认读取resources目录下的 logback.xml                        |
| **logback.xml位置** | log/logback.xml        | application.yml或者properties中配置: logging.config=classpath:log/logback.xml， |

使用官方的推荐配置，在resources目录下新建logback-spring.xml，填写内容如下（只输出日志到控制台）。使用官方推荐配置时，application.yml或者properties中可以不加配置。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <!-- 日志存放路径 -->
    <property name="log.path" value="/home/logs" />
    <!-- 日志输出格式 -->
    <property name="log.pattern" value="%d{HH:mm:ss.SSS} [%thread] %-5level %logger{20} - [%method,%line] - %msg%n" />

    <!-- 控制台输出 -->
    <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${log.pattern}</pattern>
        </encoder>
    </appender>

    <root level="info">
        <appender-ref ref="console" />
    </root>
</configuration> 
```

> Spring Boot配置说明

logback文件名为logback-spring.xml，logback.xml，且位于resources目录下时，可以不添加任何配置。否则至少需要在配置application.properties文件中添加

属性 logging.config=classpath:log/logback-spring.xml 指定日志配置文件的位置。

```yaml
# 日志配置
logging:
  # 指定配置文件的路径
  config: classpath:log/logback-spring.xml
  level:
    # root表示整个项目，默认级别为info
    root: info
    # com.demo包的日志级别为debug
    com.founder: debug
    # org.springframework包的日志级别为warn
    org.springframework: warn
```

### 2.3 logback配置详解

**Logback使用主要依赖于Logger、Appender 和 Layout 这三个类之上**

- Logger：记录日志是使用，把它关联到应用的对应的context上后，主要用于存放日志对象，也可以定义日志类型、级别。
- Appender：用于指定日志输出的目的地，目的地可以是控制台、文件、数据库等。
- Layout：负责把事件转换成字符串，格式化的日志信息的输出。

**主要标签的用处：**

- appender：负责定义日志的输出目的地（控制台、日志文件、滚动日志文件，其他如logstash等）。
- encoder：负责定义日志的输出样式和字符编码，如果在控制台出现?????或乱码，则指定编码（一般是UTF-8）就好了。
- filter：负责过滤日志，即使logger传来了dubug级别以上的日志，如果filter中设定了级别为info，则该appender只会将info级别及以上的日志输出到目的地。
- rollingPolicy：负责制定日志文件的滚动规则，是根据日志文件大小还是根据日期进行滚动。
- logger：负责定义我们实际代码中使用的logger。logger中有一个非常重要的属性name，name必须指定。在logback中，logger有继承关系，而所有的logger的祖先是root。

#### 2.3.1 configuration根节点

configuration节点有三个属性：

- scan：当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true。
- scanPeriod：设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟。
- debug：当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。

```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false"> 
　　  <!--其他配置省略--> 
</configuration>　
```

#### 2.3.2 contextName子节点

用来设置上下文名称，每个logger都关联到logger上下文，默认上下文名称为default。但可以使用<contextName>设置成其他名字，用于区分不同应用程序的记录。一旦设置，不能修改。

```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false"> 
     <contextName>myAppName</contextName> 
　　  <!--其他配置省略-->
</configuration>    
```

#### 2.3.3 property子节点

用来定义变量值，它有两个属性name和value，通过<property>定义的值会被插入到logger上下文中，可以使“${}”来使用变量。name: 变量的名称，value: 变量定义的值。

```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false"> 
　　　<property name="name" value="cvzhanshi" /> 
　　　<contextName>${name}</contextName> 
　　　<!--其他配置省略--> 
</configuration>
```

#### 2.3.4 timestamp子节点

获取时间戳字符串，有两个属性key和datePattern，其他节点可以通过${key}来获取到这个时间。

- key：标识此`<timestamp>`的名字；
- datePattern：设置将当前时间（解析配置文件的时间）转换为字符串的模式，遵循java.txt.SimpleDateFormat的格式。

```xml
<configuration scan="true" scanPeriod="60 seconds" debug="false"> 
　　<timestamp key="nowDate" datePattern="yyyyMMdd'T'HHmmss"/> 
　　<contextName>${nowDate}</contextName> 
　　<!-- 其他配置省略--> 
</configuration>
```

#### 2.3.5 appender子节点

负责写日志的组件，它有两个必要属性name和class。name指定appender名称，class指定appender的全限定名。

> **ConsoleAppender，把日志输出到控制台**

有以下子节点

- `<encoder>`：对日志进行格式化。（具体参数稍后讲解 ）
- `<target>`：字符串System.out(默认)或者System.err。

**示例配置表示把>=DEBUG级别的日志都输出到控制台**：

```xml
<configuration> 
　　　<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender"> 
　　　　　 <encoder> 
　　　　　　　　　<pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern> 
　　　　　 </encoder> 
　　　</appender> 
 
　　　<root level="DEBUG"> 
　　　　　　<appender-ref ref="STDOUT" /> 
　　　</root> 
</configuration>
```

> **FileAppender，把日志添加到文件**

有以下子节点

- `<file>`：被写入的文件名，可以是相对目录，也可以是绝对目录，如果上级目录不存在会自动创建，没有默认值。
- `<append>`：如果是 true，日志被追加到文件结尾，如果是 false，清空现存文件，默认是true。
- `<encoder>`：对记录事件进行格式化。
- `<prudent>`：如果是 true，日志会被安全的写入文件，即使其他的FileAppender也在向此文件做写入操作，效率低，默认是 false。

示例配置表示把>=DEBUG级别的日志都输出到testFile.log

```xml
<configuration> 
　　<appender name="FILE" class="ch.qos.logback.core.FileAppender"> 
　　　　<file>testFile.log</file> 
　　　　<append>true</append> 
　　　　<encoder> 
　　　　　　<pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern> 
　　　　</encoder> 
　　</appender> 
 
　　<root level="DEBUG"> 
　　　　<appender-ref ref="FILE" /> 
　　</root> 
</configuration>
```

> **RollingFileAppender，滚动记录文件**

滚动记录文件，先将日志记录到指定文件，当符合某个条件时，将日志记录到其他文件。有以下子节点：

- `<file>`：被写入的文件名，可以是相对目录，也可以是绝对目录，如果上级目录不存在会自动创建，没有默认值。
- `<append>`：如果是 true，日志被追加到文件结尾，如果是 false，清空现存文件，默认是true。
- `<rollingPolicy>`：当发生滚动时，决定RollingFileAppender的行为，涉及文件移动和重命名。属性class定义具体的滚动策略类。

**rollingPolicy**属性class定义具体的滚动策略类，有3类：

- ch.qos.logback.core.rolling.**TimeBasedRollingPolicy**：根据时间来制定滚动策略，既负责滚动也负责出发滚动。有以下子节点
  - **fileNamePattern**：必要节点，包含文件名及“%d”转换符，“%d”可以包含一个java.text.SimpleDateFormat指定的时间格式，如：%d{yyyy-MM}。如果直接使用 %d，默认格式是 yyyy-MM-dd。RollingFileAppender的file子节点可有可无，通过设置file，可以为活动文件和归档文件指定不同位置，当前日志总是记录到file指定的文件（活动文件），活动文件的名字不会改变；如果没设置file，活动文件的名字会根据fileNamePattern 的值，每隔一段时间改变一次。“/”或者“\”会被当做目录分隔符。
  - **maxHistory**：可选节点，控制保留的归档文件的最大数量，超出数量就删除旧文件。假设设置每个月滚动，且<maxHistory>是6，则只保存最近6个月的文件，删除之前的旧文件。注意，删除旧文件时，那些为了归档而创建的目录也会被删除。
- ch.qos.logback.core.rolling.**SizeBasedTriggeringPolicy**：查看当前活动文件的大小，如果超过指定大小会告知RollingFileAppender 触发当前活动文件滚动。有以下子节点
  - **maxFileSize**：这是活动文件的大小，默认值是10MB。
  - **prudent**：当为true时，不支持FixedWindowRollingPolicy。支持TimeBasedRollingPolicy，但是有两个限制，1不支持也不允许文件压缩，2不能设置file属性，必须留空。
  - **triggeringPolicy** ：告知 RollingFileAppender何时激活滚动。
- ch.qos.logback.core.rolling.**FixedWindowRollingPolicy**：根据固定窗口算法重命名文件的滚动策略。有以下子节点
  - **minIndex**：窗口索引最小值。
  - **maxIndex**：窗口索引最大值，当用户指定的窗口过大时，会自动将窗口设置为12。
  - **fileNamePattern**：必须包含“%i”例如，假设最小值和最大值分别为1和2，命名模式为 mylog%i.log,会产生归档文件mylog1.log和mylog2.log。还可以指定文件压缩选项，例如，mylog%i.log.gz 或者 没有log%i.log.zip

配置表示每天生成一个日志文件，保存30天的日志文件

```xml
<configuration> 
　　　<appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender"> 
　　　　　　<rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy"> 
　　　　　　　　　<fileNamePattern>logFile.%d{yyyy-MM-dd}.log</fileNamePattern> 
　　　　　　　　　<maxHistory>30</maxHistory> 
　　　　　　</rollingPolicy> 
　　　　　　<encoder> 
　　　　　　　　　<pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern> 
　　　　　　</encoder> 
　　　</appender> 
 
　　　<root level="DEBUG"> 
　　　　　　<appender-ref ref="FILE" /> 
　　　</root> 
</configuration>
```

#### 2.3.6 logger子节点

用来设置某一个包或具体的某一个类的日志打印级别、以及指定appender。logger仅有一个name属性，一个可选的level和一个可选的additivity属性。可以包含零个或多个appender-ref元素，标识这个appender将会添加到这个logger。

- **name**：用来指定受此logger约束的某一个包或者具体的某一个类。
- **level**：用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL和OFF，还有一个特俗值INHERITED或者同义词NULL，代表强制执行上级的级别。 如果未设置此属性，那么当前logger将会继承上级的级别。
- **additivity**：是否向上级logger传递打印信息。默认是true。

```xml
<logger name="com.deepoove.poi" level="warn" additivity="false">
    <appender-ref ref="console" />
    <appender-ref ref="fileLog" />
</logger>
```

#### 2.3.7 root子节点

它也是logger元素，是根logger，所有logger的上级。只有一个level属性，因为name已经被命名为"root"，且已经是最上级了。

- level: 用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL和OFF，不能设置为INHERITED或者同义词NULL。 默认是DEBUG。

#### 2.3.8 springProperty标签

通过springProperty标签来引用spring boot的配置文件信息

```xml
<springProperty scope="context" name="log.path" source="path.log"/>
```

> 示例

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- 日志级别从低到高分为TRACE < DEBUG < INFO < WARN < ERROR < FATAL，如果设置为WARN，则低于WARN的信息都不会输出 -->
<!-- scan:当此属性设置为true时，配置文件如果发生改变，将会被重新加载，默认值为true -->
<!-- scanPeriod:设置监测配置文件是否有修改的时间间隔，如果没有给出时间单位，默认单位是毫秒。当scan为true时，此属性生效。默认的时间间隔为1分钟。 -->
<!-- debug:当此属性设置为true时，将打印出logback内部日志信息，实时查看logback运行状态。默认值为false。 -->
<configuration  scan="true" scanPeriod="10 seconds">
 
    <!--<include resource="org/springframework/boot/logging/logback/base.xml" />-->
 
    <contextName>logback</contextName>
    <!-- name的值是变量的名称，value的值时变量定义的值。通过定义的值会被插入到logger上下文中。定义变量后，可以使“${}”来使用变量。 -->
    <property name="log.path" value="D:/nmyslog/nmys" />
 
    <!-- 彩色日志 -->
    <!-- 彩色日志依赖的渲染类 -->
    <conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" />
    <conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" />
    <conversionRule conversionWord="wEx" converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter" />
    <!-- 彩色日志格式 -->
    <property name="CONSOLE_LOG_PATTERN" value="${CONSOLE_LOG_PATTERN:-%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint} %clr(${LOG_LEVEL_PATTERN:-%5p}) %clr(${PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${LOG_EXCEPTION_CONVERSION_WORD:-%wEx}}"/>
 
 
    <!--输出到控制台-->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <!--此日志appender是为开发使用，只配置最底级别，控制台输出的日志级别是大于或等于此级别的日志信息-->
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>info</level>
        </filter>
        <encoder>
            <Pattern>${CONSOLE_LOG_PATTERN}</Pattern>
            <!-- 设置字符集 -->
            <charset>UTF-8</charset>
        </encoder>
    </appender>
 
 
    <!--输出到文件-->
 
    <!-- 时间滚动输出 level为 DEBUG 日志 -->
    <appender name="DEBUG_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 正在记录的日志文件的路径及文件名 -->
        <file>${log.path}/log_debug.log</file>
        <!--日志文件输出格式-->
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            <charset>UTF-8</charset> <!-- 设置字符集 -->
        </encoder>
        <!-- 日志记录器的滚动策略，按日期，按大小记录 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 日志归档 -->
            <fileNamePattern>${log.path}/debug/log-debug-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>100MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!--日志文件保留天数-->
            <maxHistory>15</maxHistory>
        </rollingPolicy>
        <!-- 此日志文件只记录debug级别的 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>debug</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>
 
    <!-- 时间滚动输出 level为 INFO 日志 -->
    <appender name="INFO_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 正在记录的日志文件的路径及文件名 -->
        <file>${log.path}/log_info.log</file>
        <!--日志文件输出格式-->
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
        <!-- 日志记录器的滚动策略，按日期，按大小记录 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!-- 每天日志归档路径以及格式 -->
            <fileNamePattern>${log.path}/info/log-info-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>100MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!--日志文件保留天数-->
            <maxHistory>15</maxHistory>
        </rollingPolicy>
        <!-- 此日志文件只记录info级别的 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>info</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>
 
    <!-- 时间滚动输出 level为 WARN 日志 -->
    <appender name="WARN_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 正在记录的日志文件的路径及文件名 -->
        <file>${log.path}/log_warn.log</file>
        <!--日志文件输出格式-->
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            <charset>UTF-8</charset> <!-- 此处设置字符集 -->
        </encoder>
        <!-- 日志记录器的滚动策略，按日期，按大小记录 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.path}/warn/log-warn-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>100MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!--日志文件保留天数-->
            <maxHistory>15</maxHistory>
        </rollingPolicy>
        <!-- 此日志文件只记录warn级别的 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>warn</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>
 
 
    <!-- 时间滚动输出 level为 ERROR 日志 -->
    <appender name="ERROR_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <!-- 正在记录的日志文件的路径及文件名 -->
        <file>${log.path}/log_error.log</file>
        <!--日志文件输出格式-->
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n</pattern>
            <charset>UTF-8</charset> <!-- 此处设置字符集 -->
        </encoder>
        <!-- 日志记录器的滚动策略，按日期，按大小记录 -->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${log.path}/error/log-error-%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>100MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!--日志文件保留天数-->
            <maxHistory>15</maxHistory>
        </rollingPolicy>
        <!-- 此日志文件只记录ERROR级别的 -->
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>ERROR</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
    </appender>
 
    <!--
        <logger>用来设置某一个包或者具体的某一个类的日志打印级别、
        以及指定<appender>。<logger>仅有一个name属性，
        一个可选的level和一个可选的addtivity属性。
        name:用来指定受此logger约束的某一个包或者具体的某一个类。
        level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，
              还有一个特俗值INHERITED或者同义词NULL，代表强制执行上级的级别。
              如果未设置此属性，那么当前logger将会继承上级的级别。
        addtivity:是否向上级logger传递打印信息。默认是true。
    -->
    <!--<logger name="org.springframework.web" level="info"/>-->
    <!--<logger name="org.springframework.scheduling.annotation.ScheduledAnnotationBeanPostProcessor" level="INFO"/>-->
    <!--
        使用mybatis的时候，sql语句是debug下才会打印，而这里我们只配置了info，所以想要查看sql语句的话，有以下两种操作：
        第一种把<root level="info">改成<root level="DEBUG">这样就会打印sql，不过这样日志那边会出现很多其他消息
        第二种就是单独给dao下目录配置debug模式，代码如下，这样配置sql语句会打印，其他还是正常info级别：
     -->
 
 
    <!--
        root节点是必选节点，用来指定最基础的日志输出级别，只有一个level属性
        level:用来设置打印级别，大小写无关：TRACE, DEBUG, INFO, WARN, ERROR, ALL 和 OFF，
        不能设置为INHERITED或者同义词NULL。默认是DEBUG
        可以包含零个或多个元素，标识这个appender将会添加到这个logger。
    -->
 
    <!--开发环境:打印控制台-->
    <springProfile name="dev">
        <logger name="com.nmys.view" level="debug"/>
    </springProfile>
 
    <root level="info">
        <appender-ref ref="CONSOLE" />
        <appender-ref ref="DEBUG_FILE" />
        <appender-ref ref="INFO_FILE" />
        <appender-ref ref="WARN_FILE" />
        <appender-ref ref="ERROR_FILE" />
    </root>
 
    <!--生产环境:输出到文件-->
    <!--<springProfile name="pro">-->
        <!--<root level="info">-->
            <!--<appender-ref ref="CONSOLE" />-->
            <!--<appender-ref ref="DEBUG_FILE" />-->
            <!--<appender-ref ref="INFO_FILE" />-->
            <!--<appender-ref ref="ERROR_FILE" />-->
            <!--<appender-ref ref="WARN_FILE" />-->
        <!--</root>-->
    <!--</springProfile>-->
 
</configuration>
```

### 2.4 注意事项

- 必需appender 配置为rolling的才能滚动

- 在FixedWindowRollingPolicy里面不能配置%d{yyyy-MM-dd}, 如果配置了的话，会导致滚动失败，不仅不能生成滚动文件，当前文件也不再写入，只能且必需配置%i。FixedWindowRollingPolicy可以和SizeBasedTriggeringPolicy配合使用。

  ```xml
  <rollingPolicy class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
       <FileNamePattern>tests.%i.log.zip</FileNamePattern>
       <MinIndex>1</MinIndex>
       <MaxIndex>3</MaxIndex>
  </rollingPolicy>
   
  <triggeringPolicy class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
       <MaxFileSize>5MB</MaxFileSize>
  </triggeringPolicy>
  ```

- TimeBasedRollingPolicy 不能和SizeBasedTriggeringPolicy配合使用，如果两个同时配置，在达到最大文件大小的时候，会导致即不会生成滚动文件，当前文件也不再写入。

  ```xml
  <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">        
      <fileNamePattern>logFile.%d{yyyy-MM-dd}.log</fileNamePattern>          
      <maxHistory>30</maxHistory>         
  </rollingPolicy>
  ```

- springProfile 配置为dev时, 输出端可以为console, 但配成prod时, 切记关闭console输出。

- SpringBoot默认读取resources下的，若是放到了自定义的路径下, 则需要在application.yml中配置其具体路径。

- 有时候需要打印低级别（如debug）的日志，不要把`<root level="info">`改成`<root level="DEBUG">`，这样日志会出现很多其他框架的输出的信息，不利于排查日志，可以单独给某个包指定日志输出级别，这样只有被设置为debug模式的包下的代码会打印debug日志，其他包还按照设置的默认级别如info打印日志。
  





















