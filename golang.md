# 1、golang的概述

## 1.1 概述及特点

> **什么是go**

- **Go 是一个开源的编程语言，它能让构造简单、可靠且高效的软件变得容易。**

- Go是从2007年末由Robert Griesemer, Rob Pike, Ken Thompson主持开发，后来还加入了Ian Lance Taylor, Russ Cox等人，并最终于2009年11月开源，在2012年早些时候发布了Go 1稳定版本。现在Go的开发已经是完全开放的，并且拥有一个活跃的社区。
- Go 编程语言是一个使得程序员更加有效率的开源项目。**Go 是有表达力、简洁、清晰和有效率的。它的并行机制使其很容易编写多核和网络应用，而新奇的类型系统允许构建有弹性的模块化程序。Go 编译到机器码非常快速，同时具有便利的垃圾回收和强大的运行时反射。它是快速的、静态类型编译语言，但是感觉上是动态类型的，解释型语言。**
- Go 语言保证了既能到达**静态编译语言的安全和性能**，又达到了**动态语言开发维护的高效率** ，使用一个表达式来形容Go语言：**Go=C+Python**，说明Go语言既有**C静态语言程序的运行速度，又能达到Python 动态语言的快速开发**。

> **Go 语言特色**
>
> - 简洁、快速、安全
> - 并行、有趣、开源
> - 内存管理、数组安全、编译迅速



**清晰并且简洁**：Go 努力保持小并且优美，你可以在短短几行代码里做许多事情； 

**并行**： Go 让函数很容易成为非常轻量的线程。这些线程在 Go 中被叫做 goroutines b； 

**Channel**： 这些 goroutines 之间的通讯由 channel[18, 25] 完成； 

**快速**： 编译很快，执行也很快。目标是跟 C 一样快。编译时间用秒计算； 

**安全**： 当转换一个类型到另一个类型的时候需要显式的转换并遵循严格的规则。Go 有垃圾收集，在 Go 中无须 free()，语言会处理这一切； 

**标准格式化**： Go 程序可以被格式化为程序员希望的（几乎）任何形式，但是官方格式是存在的。标准也非常简单：gofmt 的输出就是官方认可的格式； 

**类型后置**： 类型在变量名的后面，像这样 var a int，来代替 C中的 int a； 

**UTF-8**： 任何地方都是 UTF-8 的，包括字符串以及程序代码。你可以在代码中使用 Φ = Φ + 1

## 1.2 环境安装

均已macOS 进行演示操作

1. 使用homebrew安装go

   ```shell
   brew install go@1.22
   ```

2. 配置环境变量，编辑～目录下的.zshrc

   ```sh
   vim .zshrc
   
   # 添加以下内容
   GO_HOME=/opt/homebrew/Cellar/go/1.22.2
   PATH=$PATH:$GO_HOME/bin
   export PATH
   ```

3. 加载一下配置文件

   ```sh
   source ~/.zshrc
   ```

4. 查询go版本好，有输出版本号就是安装成功

   ```sh
   go version
   ```

   ![image-20240411151927413](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240411151927413.png)

## 1.3 开发工具的安装

开发工具非常多的选择，本人推荐使用GoLand。开发Java的时候他家Idea用的很不错。Go语言可以继续使用他家的

1、[下载地址](https://www.jetbrains.com/go/download/#section=mac)

2、[破解教程](https://ziby0nwxdov.feishu.cn/docx/WcJNdnsQDoaGamxnnWYcb1YpnCh)



