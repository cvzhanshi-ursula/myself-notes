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
   # go语言的sdk安装路径
   GOROOT=/opt/homebrew/Cellar/go/1.22.2
   # 工作路径 也就是自己项目在哪开发，可以自定义  路径下需要有三个文件夹  src、bin、pkg
   GOPATH=/Users/cvzhanshi/cvzhanshi/workspace/golang
   PATH=$PATH:$JAVA_HOME/bin:$GOROOT/bin:$GOPATH/bin
   export GOROOT
   export GOPATH
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

## 1.4 Hello World

1. 通过GoLand创建项目

   ![image-20240415170828401](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240415170828401.png)

2. 创建go文件，输入以下内容

   ```go
   package main
   
   import "fmt"
   
   func main() {
   	fmt.Println("hello world")
   }
   ```

3. 运行就能看到输出hello world

   ![image-20240415171406781](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240415171406781.png)

4. 如果通过命令行来执行的话，可以有以下两种方式

   ```sh
   # 首先进去go文件目录
   # go buil 一个可执行文件
   go build hello.go
   # 执行可执行文件
   ./hello
   
   ```

   ![image-20240415173928898](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240415173928898.png)

   ```sh
   # 第二种方法 
   go run hello.go
   ```

   ![image-20240415174017473](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240415174017473.png)

   **执行流程分析**

   ![image-20240415174406485](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240415174406485.png)

   两种方式的原理都是一样的，使用go run也是经过了build的。

   **两种执行流程的区别**：

   - 如果我们先编译生成了可执行文件，那么我们可以将该可执行文件拷贝到没有go开发环境的机器上，仍然可以运行环境，否则无法执行。
   - 如果我们是直接 go run go源代码，那么如果要在另外一个机器上这么运行，也需要go 开发环境，否则无法运行
   - 在编译时，编译器会将程序运行依赖的库文件包含在可执行文件中，所以，可执行文件变大了很多

**Hello World运行成功**

> 对于hello wold程序的解读

- 首行这个是必须的。所有的 Go 文件以 package  开头，对于独立运行的执行文件必须是 package main
- 这是说需要将 fmt 包加入 main。不是 main 的其他包都被称为库
- package main 必须首先出现，紧跟着是 import。在 Go 中，package 总是首先出现， 然后是 import，然后是其他所有内容。当 Go 程序在执行的时候，首先调用的函数 是 main.main()，这是从 C 中继承而来。这里定义了这个函数
- 调用了来自于 fmt 包的函数打印字符串到屏幕。字符串由 " 包裹，并且可以包 含非 ASCII 的字符

> Go语言开发的简单注意事项

- Go 源文件以 “‘go“为扩展名。
- Go 应用程序的执行入口是 main()函数。这个是和其它编程语言（比如 java/c） 
- Go 语言严格区分大小写
- Go 方法由一条条语句构成，每个语句后不需要分号（Go语言会在每行后自动加分号），这也体现出 Golang的简洁性。
- Go编译器是一行行进行编译的，因此我们一行就写一条语句，不能把多条语句写在同一个，否则报错

# 2、golang的基本语法

## 2.1 注释

注释不会被编译，每一个包应该有相关注释。

单行注释是最常见的注释形式，你可以在任何地方使用以 // 开头的单行注释。多行注释也叫块注释，均已以 /* 开头，并以 */ 结尾。如：

```go
// 单行注释


/*
 Author by 菜鸟教程
 我是多行注释
 */
```

## 2.2 变量和常量

### 2.2.1 **变量**

变量来源于数学，是计算机语言中能储存计算结果或能表示值抽象概念。

变量可以通过变量名访问。

Go 语言变量名由**字母、数字、下划线**组成，其中首个字符不能为数字。

声明变量的一般形式是使用 var 关键字：

```go
// 声明一个变量格式
var identifier type
 
// 声明多个变量格式
var identifier1, identifier2 type

// 实例
package main
import "fmt"
func main() {
    var a string = "Runoob"
    fmt.Println(a)

    var b, c int = 1, 2
    fmt.Println(b, c)
}
```

### 2.2.2 变量声明的三种方法

1. **指定变量类型，如果没有初始化，则变量默认为零值**。零值就是变量没有做初始化时系统默认设置的值。

   - 数值类型（包括complex64/128）为 **0**

   - 布尔类型为 **false**

   - 字符串为 **""**（空字符串）

   - 以下几种类型为 **nil**：

     ```go
     var a *int
     var a []int
     var a map[string] int
     var a chan int
     var a func(string) int
     var a error // error 是接口
     ```

   ```go
   // 示例
   package main
   import "fmt"
   func main() {
   
       // 声明一个变量并初始化
       var a = "RUNOOB"
       fmt.Println(a)
   
       // 没有初始化就为零值
       var b int
       fmt.Println(b)
   
       // bool 零值为 false
       var c bool
       fmt.Println(c)
   }
   ```

2. **根据值自行判定变量类型。**

   ```go
   var v_name = value
   
   package main
   import "fmt"
   func main() {
       var d = true
       fmt.Println(d)
   }
   ```

3. **如果变量已经使用 var 声明过了，再使用 := 声明变量，就产生编译错误，它只能被用在函数体内，而不可以用于全局变量的声明与赋值。使用操作符 := 可以高效地创建一个新的变量，称之为初始化声明。格式：**

   ```go
   v_name := value
   
   var intVal int 
   intVal :=1 // 这时候会产生编译错误，因为 intVal 已经声明，不需要重新声明
   
   // 直接使用下面的语句即可：
   intVal := 1 // 此时不会产生编译错误，因为有声明新的变量，因为 := 是一个声明语句
   
   // 等价于
   var intVal int 
   intVal =1 
   
   // 示例
   package main
   import "fmt"
   func main() {
       f := "Runoob" // var f string = "Runoob"
       fmt.Println(f)
   }
   ```

### 2.2.3 多变量声明

```go
//类型相同多个变量, 非全局变量
var vname1, vname2, vname3 type
vname1, vname2, vname3 = v1, v2, v3

var vname1, vname2, vname3 = v1, v2, v3 // 和 python 很像,不需要显示声明类型，自动推断

vname1, vname2, vname3 := v1, v2, v3 // 出现在 := 左侧的变量不应该是已经被声明过的，否则会导致编译错误


// 这种因式分解关键字的写法一般用于声明全局变量
var (
    vname1 v_type1
    vname2 v_type2
)
```

示例

```go
package main
import "fmt"

var x, y int
var (  // 这种因式分解关键字的写法一般用于声明全局变量
    a int
    b bool
)

var c, d int = 1, 2
var e, f = 123, "hello"

//这种不带声明格式的只能在函数体中出现
//g, h := 123, "hello"

func main(){
    g, h := 123, "hello"
    fmt.Println(x, y, a, b, c, d, e, f, g, h)
}

// 执行结果 0 0 0 false 1 2 123 hello 123 hello
```

### 2.2.4 打印变量内存地址

代码示例

```go
package main

import "fmt"

func main() {
	var str string = "cvzhanshi"

	fmt.Println("str:%d 内存地址：%p", str, &str)
}

//输出
// str:%d 内存地址：%p cvzhanshi 0x14000010040
```

### 2.2.5 变量交换

在Java中需要交换两个变量的值需要有第三个临时变量来辅助，但是go语言中不需要，代码如下：

```go
package main

import "fmt"

func main() {
	var a, b int = 1, 2
	a, b = b, a
	fmt.Println(a, b)
}
```

### 2.2.6 匿名变量

在Go语言中，匿名变量是一个特殊的概念，它用于在函数调用时忽略不需要的返回值。匿名变量在Go中用一个下划线 `_` 表示，它有几个用途和特点：

**特点和用途**

- **忽略返回值**： 匿名变量主要用于函数返回多个值时，而你不需要使用所有的值。使用 `_` 可以忽略特定的返回值，从而避免创建无用的变量。

  ```go
  func compute() (int, int, string) {
      return 5, 6, "hello"
  }
  
  // 在这个例子中，compute 函数返回三个值，但我们只对第一个和第三个返回值感兴趣，所以使用 _ 忽略了第二个返回值。
  func main() {
      a, _, c := compute()
      fmt.Println(a, c) // 输出：5 hello
  }
  ```

- **占位符**： 在某些情况下，你可能需要符合特定的接口签名或满足某个函数调用的参数需求，但实际上并不需要使用某些参数。此时，匿名变量可以作为占位符使用。

  ```go
  func process(input string, debug bool) {
      if debug {
          fmt.Println("Debugging enabled")
      }
      fmt.Println(input)
  }
  
  // 假设某个场景你需要调用process函数，但不关心debug信息，则可以用_作为占位符来忽略这个信息。
  func main() {
      process("Testing", _)
  }
  ```

**注意事项**

- 使用 `_` 作为匿名变量时，**该变量的值会被忽略，并且不占用内存空间，因为Go编译器不会为其分配空间**。
- `_` 是特殊的标识符，你**不能对其赋值**，尝试赋值会导致编译错误。

### 2.2.7 常量

常量是一个简单值的标识符，在程序运行时，不会被修改的量。

常量中的数据类型只可以是**布尔型、数字型（整数型、浮点型和复数）**和字符串型。

常量的定义格式：

```go
const identifier [type] = value
```

你可以省略类型说明符 [type]，因为编译器可以根据变量的值来推断其类型。

- 显式类型定义： `const b string = "abc"`
- 隐式类型定义： `const b = "abc"`

多个相同类型的声明可以简写为：

```go
const c_name1, c_name2 = value1, value2
```

示例：

```go
package main

import "fmt"

func main() {
   const LENGTH int = 10
   const WIDTH int = 5  
   var area int
   const a, b, c = 1, false, "str" //多重赋值

   area = LENGTH * WIDTH
   fmt.Printf("面积为 : %d", area)
   println()
   println(a, b, c)  
}
```

常量还可以用作枚举：

```go
const (
    Unknown = 0
    Female = 1
    Male = 2
)
```

数字 0、1 和 2 分别代表未知性别、女性和男性。

常量可以用len(), cap(), unsafe.Sizeof()函数计算表达式的值。常量表达式中，函数必须是内置函数，否则编译不过：

实例

```go
package main

import "unsafe"
const (
    a = "abc"
    b = len(a)
    c = unsafe.Sizeof(a)
)

func main(){
    println(a, b, c)
}
```

以上实例运行结果为：

```
abc 3 16
```

### 2.2.8 iota

iota，特殊常量，可以认为是一个可以被编译器修改的常量。

iota 在 const关键字出现时将被重置为 0(const 内部的第一行之前)，const 中每新增一行常量声明将使 iota 计数一次(iota 可理解为 const 语句块中的行索引)。

iota 可以被用作枚举值：

```go
const (
    a = iota
    b = iota
    c = iota
)
```

第一个 iota 等于 0，每当 iota 在新的一行被使用时，它的值都会自动加 1；所以 a=0, b=1, c=2 可以简写为如下形式：

```go
const (
    a = iota
    b
    c
)
```

iota的用法

```go
package main

import "fmt"

func main() {
    const (
            a = iota   //0
            b          //1
            c          //2
            d = "ha"   //独立值，iota += 1
            e          //"ha"   iota += 1
            f = 100    //iota +=1
            g          //100  iota +=1
            h = iota   //7,恢复计数
            i          //8
    )
    fmt.Println(a,b,c,d,e,f,g,h,i)
}
// 0 1 2 ha ha 100 100 7 8
```

## 2.3 基本数据类型

在 Go 编程语言中，数据类型用于声明函数和变量。

数据类型的出现是为了把数据分成所需内存大小不同的数据，编程的时候需要用大数据的时候才需要申请大内存，就可以充分利用内存。

![image-20240416113155393](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240416113155393.png)

### 2.3.1 布尔型

布尔型的值只可以是常量 true 或者 false。一个简单的例子：var b bool = true。

```go
package main

import "fmt"

func main() {
	var isFlag bool
	fmt.Println(isFlag) // bool默认值为false

	var isFlags = true

	fmt.Printf("%T,%t", isFlags, isFlags)

}
```

### 2.3.2 数值型

整型 int 和浮点型 float32、float64，Go 语言支持整型和浮点型数字，并且支持复数，其中位的运算采用补码。

Go 也有基于架构的类型，例如：int、uint 和 uintptr。

| 序号 | 类型和描述                                                   |
| :--- | :----------------------------------------------------------- |
| 1    | **uint8** 无符号 8 位整型 (0 到 255)                         |
| 2    | **uint16** 无符号 16 位整型 (0 到 65535)                     |
| 3    | **uint32** 无符号 32 位整型 (0 到 4294967295)                |
| 4    | **uint64** 无符号 64 位整型 (0 到 18446744073709551615)      |
| 5    | **int8** 有符号 8 位整型 (-128 到 127)                       |
| 6    | **int16** 有符号 16 位整型 (-32768 到 32767)                 |
| 7    | **int32** 有符号 32 位整型 (-2147483648 到 2147483647)       |
| 8    | **int64** 有符号 64 位整型 (-9223372036854775808 到 9223372036854775807) |

**浮点型**

| 序号 | 类型和描述                        |
| :--- | :-------------------------------- |
| 1    | **float32** IEEE-754 32位浮点型数 |
| 2    | **float64** IEEE-754 64位浮点型数 |
| 3    | **complex64** 32 位实数和虚数     |
| 4    | **complex128** 64 位实数和虚数    |

**其他数字类型**

以下列出了其他更多的数字类型：

| 序号 | 类型和描述                               |
| :--- | :--------------------------------------- |
| 1    | **byte** 类似 uint8                      |
| 2    | **rune** 类似 int32                      |
| 3    | **uint** 32 或 64 位                     |
| 4    | **int** 与 uint 一样大小                 |
| 5    | **uintptr** 无符号整型，用于存放一个指针 |

示例：

float 默认是 float64

byte 默认是 uint8

int  默认是 32或64位的

```go
package main

import "fmt"

func main() {
	var age int = 23
	var meney = 323.32
	var num byte = 8
	fmt.Printf("%T, %d\n", age, age)       // int, 23
	fmt.Printf("%T, %.2f\n", meney, meney) // float64, 323.32
	fmt.Printf("%T, %d\n", num, num)       // uint8, 8
}
```

### 2.3.3 字符串型

字符串就是一串固定长度的字符连接起来的字符序列。

Go 的字符串是由单个字节连接起来的。Go 语言的字符串的字节使用 UTF-8 编码标识 Unicode 文本。

**string字符串不能被修改**

示例

```go
package main

import "fmt"

func main() {
	var str string
	str = "cvzhanshi"
	fmt.Printf("%T, %s\n", str, str)
	fmt.Printf("%T, %s\n", str, str)
	fmt.Printf("%T, %s\n", str, str)

	// 单引号和双引号的区别   单引号 字符， ascii字符码
	v1 := 'A'
	v2 := "A"
	fmt.Printf("%T, %d\n", v1, v1)
	fmt.Printf("%T, %s\n", v2, v2)

	// 扩展知识
	// 中国的编码表  GBK
	// Unicode编码表， 兼容全世界的文字
	v3 := '中'
	fmt.Printf("%T, %d\n", v3, v3)

	// 字符串连接可以通过 + 来实现
	fmt.Println(str + "2cvzhanshi2")

	// 转义字符   \ 如果字符串想出现 回车  换行 双引号需要转义字符
	fmt.Println(str + "2cvzha\"nshi2")
	fmt.Println(str + "\n2cvzhanshi2")
	
}
```

### 2.3.4 数据类型转换

在必要以及可行的情况下，一个类型的值可以被转换成另一种类型的值。由于Go语言不存在隐式类型转换，因此所有的类型转换都必须显式的声明。

示例：

```go
package main

import "fmt"

func main() {
	var a int = 10
	var b float64 = 30.1
	fmt.Printf("%T, %d\n", a, a)
	fmt.Printf("%T, %f\n", b, b)

	c := int(b)
	fmt.Printf("%T, %d\n", c, c)

	d := float64(a)
	fmt.Printf("%T, %f\n", d, d)
}
```

类型转换只能在定义正确的情况下转换成功。要考虑类型的范围是否合适。

## 2.4 运算符

### 2.4.1 算术运算符

下表列出了所有Go语言的算术运算符。假定 A 值为 10，B 值为 20。

| 运算符 | 描述 | 实例               |
| :----- | :--- | :----------------- |
| +      | 相加 | A + B 输出结果 30  |
| -      | 相减 | A - B 输出结果 -10 |
| *      | 相乘 | A * B 输出结果 200 |
| /      | 相除 | B / A 输出结果 2   |
| %      | 求余 | B % A 输出结果 0   |
| ++     | 自增 | A++ 输出结果 11    |
| --     | 自减 | A-- 输出结果 9     |

### 2.4.2 关系运算符

下表列出了所有Go语言的关系运算符。假定 A 值为 10，B 值为 20。

| 运算符 | 描述                                                         | 实例              |
| :----- | :----------------------------------------------------------- | :---------------- |
| ==     | 检查两个值是否相等，如果相等返回 True 否则返回 False。       | (A == B) 为 False |
| !=     | 检查两个值是否不相等，如果不相等返回 True 否则返回 False。   | (A != B) 为 True  |
| >      | 检查左边值是否大于右边值，如果是返回 True 否则返回 False。   | (A > B) 为 False  |
| <      | 检查左边值是否小于右边值，如果是返回 True 否则返回 False。   | (A < B) 为 True   |
| >=     | 检查左边值是否大于等于右边值，如果是返回 True 否则返回 False。 | (A >= B) 为 False |
| <=     | 检查左边值是否小于等于右边值，如果是返回 True 否则返回 False。 | (A <= B) 为 True  |

### 2.4.3 逻辑运算符

下表列出了所有Go语言的逻辑运算符。假定 A 值为 True，B 值为 False。

| 运算符 | 描述                                                         | 实例               |
| :----- | :----------------------------------------------------------- | :----------------- |
| &&     | 逻辑 AND 运算符。 如果两边的操作数都是 True，则条件 True，否则为 False。 | (A && B) 为 False  |
| \|\|   | 逻辑 OR 运算符。 如果两边的操作数有一个 True，则条件 True，否则为 False。 | (A \|\| B) 为 True |
| !      | 逻辑 NOT 运算符。 如果条件为 True，则逻辑 NOT 条件 False，否则为 True。 | !(A && B) 为 True  |

### 2.4.4 位运算符

位运算符对整数在内存中的二进制位进行操作。

下表列出了位运算符 &, |, 和 ^ 的计算：

| p    | q    | p & q | p \| q | p ^ q |
| :--- | :--- | :---- | :----- | :---- |
| 0    | 0    | 0     | 0      | 0     |
| 0    | 1    | 0     | 1      | 1     |
| 1    | 1    | 1     | 1      | 0     |
| 1    | 0    | 0     | 1      | 1     |

假定 A = 60; B = 13; 其二进制数转换为：

```sh
A = 0011 1100

B = 0000 1101

-----------------

A&B = 0000 1100

A|B = 0011 1101

A^B = 0011 0001
```

Go 语言支持的位运算符如下表所示。假定 A 为60，B 为13：

| 运算符 | 描述                                                         | 实例                                   |
| :----- | :----------------------------------------------------------- | :------------------------------------- |
| &      | 按位与运算符"&"是双目运算符。 其功能是参与运算的两数各对应的二进位相与。 | (A & B) 结果为 12, 二进制为 0000 1100  |
| \|     | 按位或运算符"\|"是双目运算符。 其功能是参与运算的两数各对应的二进位相或 | (A \| B) 结果为 61, 二进制为 0011 1101 |
| ^      | 按位异或运算符"^"是双目运算符。 其功能是参与运算的两数各对应的二进位相异或，当两对应的二进位相异时，结果为1。 | (A ^ B) 结果为 49, 二进制为 0011 0001  |
| <<     | 左移运算符"<<"是双目运算符。左移n位就是乘以2的n次方。 其功能把"<<"左边的运算数的各二进位全部左移若干位，由"<<"右边的数指定移动的位数，高位丢弃，低位补0。 | A << 2 结果为 240 ，二进制为 1111 0000 |
| >>     | 右移运算符">>"是双目运算符。右移n位就是除以2的n次方。 其功能是把">>"左边的运算数的各二进位全部右移若干位，">>"右边的数指定移动的位数。 | A >> 2 结果为 15 ，二进制为 0000 1111  |

### 2.4.5 赋值运算符

下表列出了所有Go语言的赋值运算符。

| 运算符 | 描述                                           | 实例                                  |
| :----- | :--------------------------------------------- | :------------------------------------ |
| =      | 简单的赋值运算符，将一个表达式的值赋给一个左值 | C = A + B 将 A + B 表达式结果赋值给 C |
| +=     | 相加后再赋值                                   | C += A 等于 C = C + A                 |
| -=     | 相减后再赋值                                   | C -= A 等于 C = C - A                 |
| *=     | 相乘后再赋值                                   | C *= A 等于 C = C * A                 |
| /=     | 相除后再赋值                                   | C /= A 等于 C = C / A                 |
| %=     | 求余后再赋值                                   | C %= A 等于 C = C % A                 |
| <<=    | 左移后赋值                                     | C <<= 2 等于 C = C << 2               |
| >>=    | 右移后赋值                                     | C >>= 2 等于 C = C >> 2               |
| &=     | 按位与后赋值                                   | C &= 2 等于 C = C & 2                 |
| ^=     | 按位异或后赋值                                 | C ^= 2 等于 C = C ^ 2                 |
| \|=    | 按位或后赋值                                   | C \|= 2 等于 C = C \| 2               |

### 2.4.6 其他运算符

下表列出了Go语言的其他运算符。

| 运算符 | 描述             | 实例                       |
| :----- | :--------------- | :------------------------- |
| &      | 返回变量存储地址 | &a; 将给出变量的实际地址。 |
| *      | 指针变量。       | *a; 是一个指针变量         |

以下实例演示了其他运算符的用法：

```go
package main

import "fmt"

func main() {
   var a int = 4
   var b int32
   var c float32
   var ptr *int

   /* 运算符实例 */
   fmt.Printf("第 1 行 - a 变量类型为 = %T\n", a );
   fmt.Printf("第 2 行 - b 变量类型为 = %T\n", b );
   fmt.Printf("第 3 行 - c 变量类型为 = %T\n", c );

   /*  & 和 * 运算符实例 */
   ptr = &a     /* 'ptr' 包含了 'a' 变量的地址 */
   fmt.Printf("a 的值为  %d\n", a);
   fmt.Printf("*ptr 为 %d\n", *ptr);
}
```

### 2.4.7 运算符优先级

有些运算符拥有较高的优先级，二元运算符的运算方向均是从左至右。下表列出了所有运算符以及它们的优先级，由上至下代表优先级由高到低：

| 优先级 | 运算符           |
| :----- | :--------------- |
| 5      | * / % << >> & &^ |
| 4      | + - \| ^         |
| 3      | == != < <= > >=  |
| 2      | &&               |
| 1      | \|\|             |

当然，你可以通过使用括号来临时提升某个表达式的整体运算优先级。

## 2.5 键盘的输入输出

### 2.5.1 输出

在 Go 语言的 `fmt` 包中，`fmt.Println()`, `fmt.Print()`, 和 `fmt.Printf()` 是三种基本的输出函数，它们提供了不同的方式来格式化和输出数据到标凈输出（通常是终端或屏幕）。理解它们之间的区别可以帮助你选择最适合你需求的函数。

> **`fmt.Print()`**

`fmt.Print()` 函数直接输出其参数，参数之间不自动添加空格。它将输入的参数输出到标准输出，参数之间的字符串连接没有任何额外字符插入：

```go
fmt.Print("Hello", "world!")  // Helloworld!
```

注意，`fmt.Print()` 不会在输出的末尾自动添加换行符。

> ### `fmt.Println()`

`fmt.Println()` 函数在其**参数之间自动添加空格**，并在**输出结束后添加一个换行符**。这使得输出更加适合阅读，特别是当你需要输出多个变量时，每个输出项之间会自然地有一个空格分隔：

```go
fmt.Println("Hello", "world!") //Hello world!
```

此外，输出的末尾会自动加上一个换行符，使得多次调用 `fmt.Println()` 的输出不会连在一起。

> ### `fmt.Printf()`

`fmt.Printf()` 函数提供了格式化输出的功能。它使用格式字符串和相应的变量来生成格式化后的字符串并输出。格式字符串中包含占位符，占位符由 `%` 符号引导，用于指定如何格式化输出参数。这是一种非常灵活的输出方式，允许你精确控制每个输出项的格式：

```go
fmt.Printf("Hello %s! You have %d unread messages.\n", "Alice", 129)
// Hello Alice! You have 129 unread messages.
```

这里，`%s` 被替换成了字符串 `"Alice"`，`%d` 被替换成了整数 `129`，而 `\n` 是一个换行符，表示输出结束后换行。

**总结**

- **`fmt.Print()`**：直接输出，参数之间无分隔，输出末尾无换行。
- **`fmt.Println()`**：输出时参数之间自动添加空格，输出末尾自动换行。
- **`fmt.Printf()`**：按照格式字符串指定的格式输出，非常灵活，可以控制输出格式，但需要正确指定占位符。

### 2.5.2 输入

在 Go 语言中，`fmt` 包提供了多个函数用于从标准输入读取数据，其中 `fmt.Scanln`, `fmt.Scanf`, 和 `fmt.Scan` 是常用的三种。这些函数虽然都用于输入，但在使用方法和行为上有所不同。了解它们之间的区别可以帮助你根据不同的需要选择合适的函数。

> ### `fmt.Scanln`

`fmt.Scanln` 用于读取一行的输入，直到遇到换行符 `\n`。它会在换行符处停止扫描，并且从输入中移除换行符，但不包括换行符在内的任何内容。如果一行中的输入项少于需要读取的变量数量，`Scanln` 会报错。

示例：

```go
package main

import "fmt"

func main() {
    var name string
    var age int
    fmt.Println("Enter your name and age:")
    n, err := fmt.Scanln(&name, &age)
    if err != nil {
        fmt.Println(err)
    }
    fmt.Printf("%d items scanned: Name is %s, Age is %d\n", n, name, age)
}
```

在这个例子中，如果用户输入的内容不包括足够的数据来填满所有的变量（在这里是 `name` 和 `age`），或者输入的数据类型与变量类型不匹配，`Scanln` 会返回错误。

> ### `fmt.Scanf`

`fmt.Scanf` 根据指定的格式来读取输入，并根据格式字符串指定的格式解析输入的数据。格式字符串明确指定了如何读取输入的每个部分。它可以从输入中读取多种类型的数据，但对格式的要求非常严格。

**示例**：

```go
package main

import "fmt"

func main() {
    var name string
    var age int
    fmt.Println("Enter your name and age:")
    n, err := fmt.Scanf("%s %d", &name, &age)
    if err != nil {
        fmt.Println(err)
    }
    fmt.Printf("%d items scanned: Name is %s, Age is %d\n", n, name, age)
}
```

在这个例子中，用户必须严格按照 "姓名 年龄" 的格式输入（例如 "John 30"），其中姓名和年龄由空格分开。如果输入不符合这种格式，`Scanf` 将返回错误。

> ### `fmt.Scan`

`fmt.Scan` 从标准输入中读取空白分隔的值，并存储到传递的参数中。它会在遇到空白字符（如空格、制表符或换行符）时停止读取当前值，并且从下一个非空白字符开始读取下一个值。

示例：

```go
package main

import "fmt"

func main() {
    var name string
    var age int
    fmt.Println("Enter your name and age:")
    n, err := fmt.Scan(&name, &age)
    if err != nil {
        fmt.Println(err)
    }
    fmt.Printf("%d items scanned: Name is %s, Age is %d\n", n, name, age)
}
```

这个例子中，用户可以输入 "John 30" 这样的数据，甚至可以在姓名和年龄之间输入多个空格或包含换行符，`Scan` 都能正确解析。

**总结**

- **`Scanln`**：读取一行，直到遇到换行符，且仅此一行；对输入格式较为灵活。
- **`Scanf`**：根据格式字符串精确解析输入；要求输入格式与指定的格式字符串严格匹配。
- **`Scan`**：读取空白分隔的值，对输入中的空白字符不敏感；适用于简单的分隔数据输入。

## 2.6 流程控制

### 2.6.1 if语句

条件语句需要开发者通过指定一个或多个条件，并通过测试条件是否为 true 来决定是否执行指定语句，并在条件为 false 的情况在执行另外的语句。

下图展示了程序语言中条件语句的结构：

<img src="https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240417112800629.png" alt="image-20240417112800629" style="zoom:50%;" />

| 语句           | 描述                                                         |
| :------------- | :----------------------------------------------------------- |
| if 语句        | **if 语句** 由一个布尔表达式后紧跟一个或多个语句组成。       |
| if...else 语句 | **if 语句** 后可以使用可选的 **else 语句**, else 语句中的表达式在布尔表达式为 false 时执行。 |
| if 嵌套语句    | 你可以在 **if** 或 **else if** 语句中嵌入一个或多个 **if** 或 **else if** 语句。 |

Go 编程语言中 if...else 语句的语法如下：

```go
if 布尔表达式 1 {
   /* 在布尔表达式 1 为 true 时执行 */
   if 布尔表达式 2 {
      /* 在布尔表达式 2 为 true 时执行 */
   } else {
      /* 在布尔表达式2 为 false 时执行 */
    }
}
```

示例：

```go
package main

import "fmt"

func main() {
	/* 定义局部变量 */
	var a int = 100
	var b int = 200

	/* 判断条件 */
	if a == 100 {
		/* if 条件语句为 true 执行 */
		if b == 200 {
			/* if 条件语句为 true 执行 */
			fmt.Printf("a 的值为 100 ， b 的值为 200\n" );
		} else {
			fmt.Print("+++++")
		}
	}
	fmt.Printf("a 值为 : %d\n", a );
	fmt.Printf("b 值为 : %d\n", b );
}
```

### 2.6.2 switch语句

switch 语句用于基于不同条件执行不同动作，每一个 case 分支都是唯一的，从上至下逐一测试，直到匹配为止。

switch 语句执行的过程从上至下，直到找到匹配项，匹配项后面也不需要再加 break。

switch 默认情况下 case 最后自带 break 语句，匹配成功后就不会执行其他 case，如果我们需要执行后面的 case，可以使用 **fallthrough** 

**语法**

Go 编程语言中 switch 语句的语法如下：

```go
switch var1 {
    case val1:
        ...
    case val2:
        ...
    default:
        ...
}
```

变量 var1 可以是任何类型，而 val1 和 val2 则可以是同类型的任意值。类型不被局限于常量或整数，但必须是相同的类型；或者最终结果为相同类型的表达式。

您可以同时测试多个可能符合条件的值，使用逗号分割它们，例如：case val1, val2, val3。

<img src="https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240417144829362.png" alt="image-20240417144829362" style="zoom:50%;" />

示例：

```go
package main

import "fmt"

func main() {
   /* 定义局部变量 */
   var grade string = "B"
   var marks int = 90

   switch marks {
      case 90: grade = "A"
      case 80: grade = "B"
      case 50,60,70 : grade = "C"
      default: grade = "D"  
   }

   switch {
      case grade == "A" :
         fmt.Printf("优秀!\n" )     
      case grade == "B", grade == "C" :
         fmt.Printf("良好\n" )      
      case grade == "D" :
         fmt.Printf("及格\n" )      
      case grade == "F":
         fmt.Printf("不及格\n" )
      default:
         fmt.Printf("差\n" );
   }
   fmt.Printf("你的等级是 %s\n", grade );      
}
```

> fallthrough

使用 fallthrough 会强制执行后面的 case 语句，fallthrough 不会判断下一条 case 的表达式结果是否为 true。

```go
package main

import "fmt"

func main() {

    switch {
    case false:
            fmt.Println("1、case 条件语句为 false")
            fallthrough
    case true:
            fmt.Println("2、case 条件语句为 true")
            fallthrough
    case false:
            fmt.Println("3、case 条件语句为 false")
            fallthrough
    case true:
            fmt.Println("4、case 条件语句为 true")
    case false:
            fmt.Println("5、case 条件语句为 false")
            fallthrough
    default:
            fmt.Println("6、默认 case")
    }
}

// 执行结果为
// 2、case 条件语句为 true
// 3、case 条件语句为 false
// 4、case 条件语句为 true
```

从以上代码输出的结果可以看出：switch 从第一个判断表达式为 true 的 case 开始执行，如果 case 带有 fallthrough，程序会继续执行下一条 case，且它不会去判断下一个 case 的表达式是否为 true。

### 2.6.3 for语句

for 循环是一个循环控制结构，可以执行指定次数的循环。

**语法**

Go 语言的 For 循环有 3 种形式，只有其中的一种使用分号。

和 C 语言的 for 一样：

```go
for init; condition; post { }
```

和 C 的 while 一样：

```go
for condition { }
```

和 C 的 for(;;) 一样：

```go
for { }
```

- init： 一般为赋值表达式，给控制变量赋初值；
- condition： 关系表达式或逻辑表达式，循环控制条件；
- post： 一般为赋值表达式，给控制变量增量或减量。

for语句执行过程如下：

- 1、先对表达式 1 赋初值；
- 2、判别赋值表达式 init 是否满足给定条件，若其值为真，满足循环条件，则执行循环体内语句，然后执行 post，进入第二次循环，再判别 condition；否则判断 condition 的值为假，不满足条件，就终止for循环，执行循环体外语句。

代码示例：

```go
package main

import "fmt"

func main() {
	sum := 0
	for i := 0; i <= 10; i++ {
		sum += i
	}
	fmt.Println(sum)

	sum2 := 1
	for sum2 <= 10 {
		sum2 += sum2
	}
	fmt.Println(sum2)

	sum = 10
	// 这样写也可以，更像 While 语句形式
	for sum <= 10 {
		sum += sum
	}
	fmt.Println(sum)
  
  // 无限循环
  sum = 0
   for {
      sum++ // 无限循环下去
   }
   fmt.Println(sum) // 无法输出
}
```

> string的遍历

```go
package main

import "fmt"

func main() {
	str := "cvzhanshi"

	for i, v := range str {
		fmt.Printf("%d %c\n", i, v)
	}
}
```

### 2.6.4 break语句

在 Go 语言中，break 语句用于终止当前循环或者 switch 语句的执行，并跳出该循环或者 switch 语句的代码块。

break 语句可以用于以下几个方面：。

- 用于循环语句中跳出循环，并开始执行循环之后的语句。
- break 在 switch 语句中在执行一条 case 后跳出语句的作用。
- break 可应用在 select 语句中。
- 在多重循环中，可以用标号 label 标出想 break 的循环。

流程图如下：

<img src="https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240417154537761.png" alt="image-20240417154537761" style="zoom:50%;" />

代码示例：

```go
package main

import "fmt"

func main() {
    for i := 0; i < 10; i++ {
      if i == 5 {
          break // 当 i 等于 5 时跳出循环
      }
      fmt.Println(i)
    }
}
```

### 2.6.5 continue语句

Go 语言的 continue 语句 有点像 break 语句。但是 continue 不是跳出循环，而是跳过当前循环执行下一次循环语句。

for 循环中，执行 continue 语句会触发 for 增量语句的执行。

在多重循环中，可以用标号 label 标出想 continue 的循环。

流程如图所示：

<img src="https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240417155738046.png" alt="image-20240417155738046" style="zoom:50%;" />

代码示例：

```go
package main

import "fmt"
// 在变量 a 等于 15 的时候跳过本次循环执行下一次循环
func main() {
   /* 定义局部变量 */
   var a int = 10

   /* for 循环 */
   for a < 20 {
      if a == 15 {
         /* 跳过此次循环 */
         a = a + 1;
         continue;
      }
      fmt.Printf("a 的值为 : %d\n", a);
      a++;     
   }  
}
```

## 2.7 函数

- 函数是基本的代码块，用于执行一个任务。

- Go 语言最少有个 main() 函数。

- 你可以通过函数来划分不同功能，逻辑上每个函数执行的是指定的任务。

- 函数声明告诉了编译器函数的名称，返回类型，和参数。

### 2.7.1 函数的声明与调用

Go 语言函数定义格式如下：

```go
func function_name( [parameter list] ) [return_types] {
   funtion body
}
```

函数定义解析：

- func：函数由 func 开始声明
- function_name：函数名称，参数列表和返回值类型构成了函数签名。
- parameter list：参数列表，参数就像一个占位符，当函数被调用时，你可以将值传递给参数，这个值被称为实际参数。参数列表指定的是参数类型、顺序、及参数个数。参数是可选的，也就是说函数也可以不包含参数。
- return_types：返回类型，函数返回一列值。return_types 是该列值的数据类型。有些功能不需要返回值，这种情况下 return_types 不是必须的。
- 函数体：函数定义的代码集合。

> 函数的声明
>
> - 无参无返回值的函数
> - 有一个参数的函数
> - 有两个参数的函数
> - 有一个返回值的函数
> - 有两个返回值的函数

```go
/*
* @Description: 函数的声明
* @Version: 1.0.0
* @File: demo12
* @Time: 2024-08-21 17:52
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	noParamNoReturn()

	oneParamNoReturn(9)

	twoParamNoReturn(19, 20000)

	maxNum := maxNumber(5, 9)
	fmt.Println(maxNum)

	num1, num2 := swap(90, 100)
	fmt.Println(num1, num2)

}

// - 无参无返回值的函数
func noParamNoReturn() {
	fmt.Println("无参无返回值的函数")
}

// - 有一个参数的函数
func oneParamNoReturn(age int) {
	fmt.Printf("一个参数的函数 参数age = %d\n", age)
}

// - 有两个参数的函数
func twoParamNoReturn(age, money int) {
	fmt.Printf("一个参数的函数 参数age = %d money = %d\n", age, money)
}

// - 有一个返回值的函数
func maxNumber(num1, num2 int) int {
	/* 声明局部变量 */
	var result int

	if num1 > num2 {
		result = num1
	} else {
		result = num2
	}
	return result
}

// - 有两个返回值的函数
func swap(num1, num2 int) (int, int) {
	return num2, num1
}

```

### 2.7.2 函数的参数

> **形式参数和实际参数**

形式参数：定义函数时用来接受外部传入数据的参数时形式参数

实际参数：调用函数时传给形式参数的实际数据时实际参数

```go
// num1, num2 int 形式参数
func maxNumber(num1, num2 int) int {
	/* 声明局部变量 */
	var result int

	if num1 > num2 {
		result = num1
	} else {
		result = num2
	}
	return result
}

func main() {
	// 5, 9 是实际参数
	maxNum := maxNumber(5, 9)
	fmt.Println(maxNum)

}
```

> **可变参数**

概念：一个函数的参数类型确定，个数不确定，就可以使用可变参数

```go
/*
* @Description: 可变参数
* @Version: 1.0.0
* @File: demo13
* @Time: 2024-08-21 19:07
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	fmt.Println(getSum(1, 2, 3, 4))
}

func getSum(nums ...int) int {
	sum := 0
	for _, num := range nums {
		sum += num
	}
	return sum
}
```

### 2.7.3 值传递和引用传递

- **值传递**是指在调用函数时将实际参数复制一份传递到函数中，这样在函数中如果对参数进行修改，将不会影响到实际参数，一般有int、string、bool、array、float64....
- **引用传递**是指在调用函数时将实际参数的地址传递到函数中，那么在函数中对参数所进行的修改，将影响到实际参数，一般有slice、map、chan...

> 值传递

```go
/*
* @Description:值传递
* @Version: 1.0.0
* @File: demo14
* @Time: 2024-08-21 23:42
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	array1 := [4]int{1, 2, 3, 4}
	fmt.Println("array1默认的数据", array1)
	update(array1)
	fmt.Println("array1修改后的数据", array1)

}

func update(array [4]int) {
	fmt.Println("array接收的数据", array)
	array[2] = 100
	fmt.Println("array修改后的数据", array)
}
//array1默认的数据 [1 2 3 4]
//array接收的数据 [1 2 3 4]
//array修改后的数据 [1 2 100 4]
//array1修改后的数据 [1 2 3 4]

```

> 引用传递

变量在内存中是存放在一定的地址上的，修改变量其实就是修改变量地址上的内容

```go
/*
* @Description: 引用传递
* @Version: 1.0.0
* @File: demo15
* @Time: 2024-08-21 23:47
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	s1 := []int{1, 2, 3, 4}
	fmt.Println("s1默认的数据", s1)
	update2(s1)
	fmt.Println("s1修改后的数据", s1)

}

func update2(array []int) {
	fmt.Println("array接收的数据", array)
	array[2] = 100
	fmt.Println("array修改后的数据", array)
}
//s1默认的数据 [1 2 3 4]
//array接收的数据 [1 2 3 4]
//array修改后的数据 [1 2 100 4]
//s1修改后的数据 [1 2 100 4]

```

### 2.7.4 变量作用域

作用域为已声明标识符所表示的常量、类型、变量、函数或包在源代码中的作用范围。

Go 语言中变量可以在三个地方声明：

- 函数内定义的变量称为局部变量
- 函数外定义的变量称为全局变量
- 函数定义中的变量称为形式参数

> **局部变量**

在函数体内声明的变量称之为局部变量，它们的作用域只在函数体内，参数和返回值变量也是局部变量。

以下实例中 main() 函数使用了局部变量 a, b, c：

```go
package main

import "fmt"

func main() {
   /* 声明局部变量 */
   var a, b, c int 

   /* 初始化参数 */
   a = 10
   b = 20
   c = a + b

   fmt.Printf ("结果： a = %d, b = %d and c = %d\n", a, b, c)
}
```

以上实例执行输出结果为：

```go
结果： a = 10, b = 20 and c = 30
```

------

> 全局变量

在函数体外声明的变量称之为全局变量，全局变量可以在整个包甚至外部包（被导出后）使用。

全局变量可以在任何函数中使用，以下实例演示了如何使用全局变量：

```go
package main

import "fmt"

/* 声明全局变量 */
var g int

func main() {

   /* 声明局部变量 */
   var a, b int

   /* 初始化参数 */
   a = 10
   b = 20
   g = a + b

   fmt.Printf("结果： a = %d, b = %d and g = %d\n", a, b, g)
}
```

以上实例执行输出结果为：

```go
结果： a = 10, b = 20 and g = 30
```

Go 语言程序中全局变量与局部变量名称可以相同，但是函数内的局部变量会被优先考虑。实例如下：

```go
package main

import "fmt"

/* 声明全局变量 */
var g int = 20

func main() {
   /* 声明局部变量 */
   var g int = 10

   fmt.Printf ("结果： g = %d\n",  g)
}
```

以上实例执行输出结果为：

```go
结果： g = 10
```

------

> 形式参数

形式参数会作为函数的局部变量来使用。实例如下：

```go
package main

import "fmt"

/* 声明全局变量 */
var a int = 20;

func main() {
   /* main 函数中声明局部变量 */
   var a int = 10
   var b int = 20
   var c int = 0

   fmt.Printf("main()函数中 a = %d\n",  a);
   c = sum( a, b);
   fmt.Printf("main()函数中 c = %d\n",  c);
}

/* 函数定义-两数相加 */
func sum(a, b int) int {
   fmt.Printf("sum() 函数中 a = %d\n",  a);
   fmt.Printf("sum() 函数中 b = %d\n",  b);

   return a + b;
}
```

以上实例执行输出结果为：

```go
main()函数中 a = 10
sum() 函数中 a = 10
sum() 函数中 b = 20
main()函数中 c = 30
```

### 2.7.5 递归函数

一个函数自己调用自己

注意：递归函数需要有一个出口，每次递归逐渐靠近出口，如果没有会形成死循环

```go
/*
* @Description: 递归函数
* @Version: 1.0.0
* @File: demo16
* @Time: 2024-08-22 00:05
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
  // 求和 1-100
	fmt.Println(getSum2(100))
}

func getSum2(num int) int {
	if num == 1 {
		return 1
	}
	return getSum2(num-1) + num
}
```

### 2.7.6 defer

defer函数或者方法：一个函数或方法的执行被延迟了

- 你可以在函数中添加多个defer语句，当函数执行到最后时，这些defer语句会按照逆序执行，最后该函数返回，特别是当你在进行一些打开资源的操作时，遇到错误需要提前返回，在返回前你需要关闭相应的资源，不然很容易造成资源泄露等问题 
- 如果有很多调用 defer，那么 defer 是采用后进先出（栈）模式。

```go
/*
* @Description: defer
* @Version: 1.0.0
* @File: demo17
* @Time: 2024-08-22 00:13
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	f(1)
	fmt.Println(2)
	defer f(3)
	fmt.Println(4)
	defer f(5)
	defer f(6)
	fmt.Println(7)
	// 1 2 4 7 6 5 3 
}

func f(num int) {
	fmt.Println(num)
}
```

特别的

```go
/*
* @Description: defer
* @Version: 1.0.0
* @File: demo17
* @Time: 2024-08-22 00:13
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	num := 10
	fmt.Println(num)
	defer f(num)  // 10在这里已经传进去了，一切准备就绪，就是最后执行
	num++
	fmt.Println(num)
  // 10 11 10
}

func f(num int) {
	fmt.Println(num)
}

```

### 2.7.7 函数的本质

> 函数的数据类型

```go
/*
* @Description: 函数的数据类型
* @Version: 1.0.0
* @File: demo18
* @Time: 2024-08-22 09:59
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	num := 10
	fmt.Printf("%T\n", num) // int
	fmt.Printf("%T\n", getSum3) // func(int) int
}

func getSum3(num int) int {
	if num == 1 {
		return 1
	}
	return getSum3(num-1) + num
}
```

函数的类型：func(参数类型) 返回类型

**函数也是一种数据类型**

> 函数的本质

```go
/*
* @Description: 函数的数据类型
* @Version: 1.0.0
* @File: demo18
* @Time: 2024-08-22 09:59
* @Author: cvzhanshi
 */
package main

import (
	"fmt"
)

func main() {
	num := 10

	fmt.Printf("%T\n", num) // int
	// 函数名不加括号，函数就是一个变量
	// 函数名加括号就变成了函数的调用
	fmt.Printf("%T\n", getSum3) // func(int) int

	// 把函数变量赋值给属性f1
	// f1就成了函数变量了，加括号就能调用方法了
	var f1 func(int) int
	f1 = getSum3
	sum := f1(10)
	fmt.Println(sum) //55

	// 查看两个属性的地址
	fmt.Println(f1) //0x1003aa660
	fmt.Println(getSum3) //0x1003aa660
}

func getSum3(num int) int {
	if num == 1 {
		return 1
	}
	return getSum3(num-1) + num
}
```

**函数在go语言中是复合类型，可以看作是一个特殊的变量**

函数名()：函数的调用

函数名：指向函数的内存地址，一种特殊类型的指针变量

### 2.7.8 匿名函数

```go
/*
* @Description: 匿名函数
* @Version: 1.0.0
* @File: demo19
* @Time: 2024-08-22 10:24
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {

	// 定义匿名函数，赋值给变量f1
	f1 := func() {
		fmt.Println("我是匿名函数1")
	}

	f1()

	// 定义一个匿名函数，加括号执行
	func() {
		fmt.Println("我是匿名函数2")
	}()
	// 我是匿名函数1
	// 我是匿名函数2

	// 有返回值可以有参数接收返回值
	sum := func(num1, num2 int) int {
		fmt.Println("我是匿名函数2")
		return num1 + num2
	}(1, 4)

	fmt.Println(sum)

}
```

Go语言是支持函数式编程的：

1. 将匿名函数作为另外一个函数的参数，回掉函数
2. 将匿名函数作为另外一个函数的返回值，可以形成闭包结构

### 2.7.9 回调函数

高阶函数：根据go语言的数据类型的特点，可以将一个函数作为另外一个函数的參数。

fun1()， fun2()

将 fun1 函数作为 fun2 这个函数的参数

fun2函数：就叫做高阶函数，接收了一个函数作为參数的函数

fun1函数：就叫做回调函数，作为另外一个函数的参数

```go
/*
* @Description: 回调函数
* @Version: 1.0.0
* @File: demo20
* @Time: 2024-08-22 10:46
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	sum := oper(3, 1, add)
	fmt.Println(sum)
	num := oper(3, 1, sub)
	fmt.Println(num)
}

func oper(num1, num2 int, fun func(int, int) int) int {
	return fun(num1, num2)
}

func add(num1, num2 int) int {
	return num1 + num2
}

func sub(num1, num2 int) int {
	return num1 - num2
}
```

### 2.7.10 闭包

一个外层函数中，有内层函效，该内层函数中，会操作外层函数的局部变量并且该外层函效的返回值就是这个内层函效。

这个**内层函效和外层函效的局部变量，统称为闭包结构**

**局部变量的生命周期就会发生改变，正常的局部变量会随着函效的调用而创建，随着函效的结束而销毁但是闭包结构中的外层函效的局部变量并不会随着外层函效的结束而销毁，因为内层函数还在继续使用**

```go
/*
* @Description: 闭包
* @Version: 1.0.0
* @File: demo21
* @Time: 2024-08-22 11:05
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	f2 := increment()
	fmt.Println("f2() -> ", f2())
	fmt.Println("f2() -> ", f2())
	fmt.Println("f2() -> ", f2())

	f3 := increment()
	fmt.Println("f3() -> ", f3())
	fmt.Println("f3() -> ", f3())
	fmt.Println("f2() -> ", f2())
	fmt.Println("f3() -> ", f3())

}
func increment() func() int { // 外层函数
	// 外层函数定义一个变量
	i := 0
	fun := func() int { // 内层函数  没有执行 赋值给fun返回出去了
		// 内层函数使用了外层函数的变量 形成闭包
		i++
		return i
	}
	return fun
}
// f2() ->  1
// f2() ->  2
// f2() ->  3
// f3() ->  1
// f3() ->  2
// f2() ->  4
// f3() ->  3
```

可以看出f2中的参数i在结束后并没有销毁，因为内存函数使用了i

## 2.8 数组

Go 语言提供了数组类型的数据结构。

数组是具有相同唯一类型的一组已编号且长度固定的数据项序列，这种类型可以是任意的原始类型例如整型、字符串或者自定义类型。

相对于去声明 **number0, number1, ..., number99** 的变量，使用数组形式 **numbers[0], numbers[1] ..., numbers[99]** 更加方便且易于扩展。

数组元素可以通过索引（位置）来读取（或者修改），索引从 0 开始，第一个元素索引为 0，第二个索引为 1，以此类推。

![image-20240822235413758](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240822235413758.png)

> 数组的声明

Go 语言数组声明需要指定元素类型及元素个数，语法格式如下：

```go
var arrayName [size]dataType
```

其中，**arrayName** 是数组的名称，**size** 是数组的大小，**dataType** 是数组中元素的数据类型。

以下定义了数组 balance 长度为 10 类型为 float32：

```go
var balance [10]float32
```

> 数组的初始化

声明一个名为 numbers 的整数数组，其大小为 5，在声明时，数组中的每个元素都会根据其数据类型进行默认初始化，对于整数类型，初始值为 0。

```go
var numbers [5]int
```

还可以使用初始化列表来初始化数组的元素：

```go
var numbers = [5]int{1, 2, 3, 4, 5}
```

以上代码声明一个大小为 5 的整数数组，并将其中的元素分别初始化为 1、2、3、4 和 5。

另外，还可以使用 **:=** 简短声明语法来声明和初始化数组：

```go
numbers := [5]int{1, 2, 3, 4, 5}
```

以上代码创建一个名为 numbers 的整数数组，并将其大小设置为 5，并初始化元素的值。

**注意：**在 Go 语言中，数组的大小是类型的一部分，因此不同大小的数组是不兼容的，也就是说 **[5]int** 和 **[10]int** 是不同的类型。

如果数组长度不确定，可以使用 **...** 代替数组的长度，编译器会根据元素个数自行推断数组的长度：

```go
var balance = [...]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
或
balance := [...]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
```

如果设置了数组的长度，我们还可以通过指定下标来初始化元素：

```go
//  将索引为 1 和 3 的元素初始化
balance := [5]float32{1:2.0,3:7.0}
```

初始化数组中 **{}** 中的元素个数不能大于 **[]** 中的数字。

```go
/*
* @Description: 数组
* @Version: 1.0.0
* @File: demo22
* @Time: 2024-08-23 00:01
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	array := [5]int{1, 2, 3, 4, 5}
	array[3] = 100
	fmt.Println(array)

	var i, j, k int
	// 声明数组的同时快速初始化数组
	balance := [5]float32{1000.0, 2.0, 3.4, 7.0, 50.0}

	/* 输出数组元素 */
	for i = 0; i < 5; i++ {
		fmt.Printf("balance[%d] = %f\n", i, balance[i])
	}

	balance2 := [...]float32{1000.0, 2.0, 3.4, 7.0, 50.0}
	/* 输出每个数组元素的值 */
	for j = 0; j < 5; j++ {
		fmt.Printf("balance2[%d] = %f\n", j, balance2[j])
	}

	//  将索引为 1 和 3 的元素初始化
	balance3 := [5]float32{1: 2.0, 3: 7.0}
	for k = 0; k < 5; k++ {
		fmt.Printf("balance3[%d] = %f\n", k, balance3[k])
	}
}
```

> **向函数传递数组**

如果你想向函数传递数组参数，你需要在函数定义时，声明形参为数组，我们可以通过以下两种方式来声明：

**方式一**

形参设定数组大小：

```go
func myFunction(param [10]int) {
    ....
}
```

**方式二**

形参未设定数组大小：

```go
func myFunction(param []int) {
    ....
}
```

```go
/*
* @Description: 数组
* @Version: 1.0.0
* @File: demo22
* @Time: 2024-08-23 00:01
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {

	/* 数组长度为 5 */
	var balance = [5]int{1000, 2, 3, 17, 50}
	var avg float32

	/* 数组作为参数传递给函数 */
	avg = getAverage(balance, 5)

	/* 输出返回的平均值 */
	fmt.Printf("平均值为: %f ", avg)
}

func getAverage(arr [5]int, size int) float32 {
	var i, sum int
	var avg float32

	for i = 0; i < size; i++ {
		sum += arr[i]
	}

	avg = float32(sum / size)

	return avg
}

```
如果你想要在函数内修改原始数组，可以通过传递数组的指针来实现。

```go
/*
* @Description: 数组
* @Version: 1.0.0
* @File: demo22
* @Time: 2024-08-23 00:01
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	// 创建一个包含5个元素的整数数组
	myArray := [5]int{1, 2, 3, 4, 5}

	fmt.Println("Original Array:", myArray)

	// 传递数组给函数，但不会修改原始数组的值
	modifyArray(myArray)
	fmt.Println("Array after modifyArray:", myArray)

	// 传递数组的指针给函数，可以修改原始数组的值
	modifyArrayWithPointer(&myArray)
	fmt.Println("Array after modifyArrayWithPointer:", myArray)
}

// 函数接受一个数组作为参数
func modifyArray(arr [5]int) {
	for i := 0; i < len(arr); i++ {
		arr[i] = arr[i] * 2
	}
}

// 函数接受一个数组的指针作为参数
func modifyArrayWithPointer(arr *[5]int) {
	for i := 0; i < len(*arr); i++ {
		(*arr)[i] = (*arr)[i] * 2
	}
}

```

## 2.9 指针

变量是一种使用方便的占位符，用于引用计算机内存地址中的内容。Go 语言的取地址符是 &，放到一个变量前使用就会返回相应变量的内存地址。

```go
/*
* @Description: 指针
* @Version: 1.0.0
* @File: demo23
* @Time: 2024-08-23 10:18
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	num := 10

	fmt.Printf("%d\n", num) // 10
	fmt.Printf("%p\n", &num) // 0x1400000e0b0
}
```

### **什么是指针**

一个指针变量指向了一个值的内存地址。

类似于变量和常量，在使用指针前你需要声明指针。指针声明格式如下：

```go
var var_name *var-type
```

var-type 为指针类型，var_name 为指针变量名，* 号用于指定变量是作为一个指针。以下是有效的指针声明：

```go
var ip *int        /* 指向整型*/
var fp *float32    /* 指向浮点型 */
```

### **使用指针**

指针使用流程：

- 定义指针变量。
- 为指针变量赋值。
- 访问指针变量中指向地址的值。

在指针类型前面加上 * 号（前缀）来获取指针所指向的内容。

```go
/*
* @Description: 指针
* @Version: 1.0.0
* @File: demo23
* @Time: 2024-08-23 10:18
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {

	var p1 int // 变量p1
	p1 = 10
	var p2 *int             // 指针变量p2
	p2 = &p1                // 指针变量指向 变量p1的地址
	fmt.Println(p1)         // 10
	fmt.Printf("%p\n", &p1) //0x140000a6018
	fmt.Printf("%p\n", p2)  //0x140000a6018
	*p2 = 100               // 修改指向地址的值，
	fmt.Println(p1)         // p1的地址就是指针变量p2指向的地址  所以值会被改变 100
	fmt.Printf("%d\n", *p2)  // 100
}
```

### **空指针**

当一个指针被定义后没有分配到任何变量时，它的值为 nil。

nil 指针也称为空指针。

nil在概念上和其它语言的null、None、nil、NULL一样，都指代零值或空值。

一个指针变量通常缩写为 ptr。

```go
package main

import "fmt"

func main() {
   var  ptr *int

   fmt.Printf("ptr 的值为 : %x\n", ptr  ) //ptr 的值为 : 0
}
```

空指针判断：

```go
if(ptr != nil)     /* ptr 不是空指针 */
if(ptr == nil)    /* ptr 是空指针 */

if ptr == nil {
  fmt.Println("nil")
} else {
  fmt.Println("not nil")
}
```

### **指针数组**

声明整型指针数组：

```go
var ptr [MAX]*int;
```

ptr 为整型指针数组。因此每个元素都指向了一个值。

```go
/*
* @Description: 指针数组
* @Version: 1.0.0
* @File: demo24
* @Time: 2024-08-26 11:01
* @Author: cvzhanshi
 */
package main

import "fmt"

const MAX int = 3

func main() {
	a := []int{10, 100, 200}
	var i int
	var ptr [MAX]*int

	for i = 0; i < MAX; i++ {
		ptr[i] = &a[i] /* 整数地址赋值给指针数组 */
	}

	for i = 0; i < MAX; i++ {
		fmt.Printf("a[%d] = %d\n", i, *ptr[i])
	}
}
```

### 指向指针的指针

如果一个指针变量存放的又是另一个指针变量的地址，则称这个指针变量为指向指针的指针变量。

当定义一个指向指针的指针变量时，第一个指针存放第二个指针的地址，第二个指针存放变量的地址：

![image-20240826110535831](https://cvzhanshi-notes.oss-cn-beijing.aliyuncs.com/notes/image-20240826110535831.png)

指向指针的指针变量声明格式如下：

```go
var ptr **int
```

访问指向指针的指针变量值需要使用两个 * 号，如下所示：

```go
package main

import "fmt"

func main() {

   var a int
   var ptr *int
   var pptr **int

   a = 3000

   /* 指针 ptr 地址 */
   ptr = &a

   /* 指向指针 ptr 地址 */
   pptr = &ptr

   /* 获取 pptr 的值 */
   fmt.Printf("变量 a = %d\n", a )
   fmt.Printf("指针变量 *ptr = %d\n", *ptr )
   fmt.Printf("指向指针的指针变量 **pptr = %d\n", **pptr)
}


// 变量 a = 3000
// 指针变量 *ptr = 3000
// 指向指针的指针变量 **pptr = 3000
```

### 指针作为函数参数

Go 语言允许向函数传递指针，只需要在函数定义的参数上设置为指针类型即可。

```go
/*
* @Description: 指针作为函数参数
* @Version: 1.0.0
* @File: demo26
* @Time: 2024-08-26 11:22
* @Author: cvzhanshi
 */
package main

import "fmt"

func main() {
	/* 定义局部变量 */
	var a int = 100
	var b int = 200

	fmt.Printf("交换前 a 的值 : %d\n", a)
	fmt.Printf("交换前 b 的值 : %d\n", b)

	/* 调用函数用于交换值
	 * &a 指向 a 变量的地址
	 * &b 指向 b 变量的地址
	 */
	swap2(&a, &b)

	fmt.Printf("交换后 a 的值 : %d\n", a)
	fmt.Printf("交换后 b 的值 : %d\n", b)
}

func swap2(x *int, y *int) {
	var temp int
	temp = *x /* 保存 x 地址的值 */
	*x = *y   /* 将 y 赋值给 x */
	*y = temp /* 将 temp 赋值给 y */
}
```

## 2.10 结构体

Go 语言中数组可以存储同一类型的数据，但在结构体中我们可以为不同项定义不同的数据类型。

结构体是由一系列具有相同类型或不同类型的数据构成的数据集合。

结构体表示一项记录，比如保存图书馆的书籍记录，每本书有以下属性：

- Title ：标题
- Author ： 作者
- Subject：学科
- ID：书籍ID

------

### 定义结构体

结构体定义需要使用 type 和 struct 语句。struct 语句定义一个新的数据类型，结构体中有一个或多个成员。type 语句设定了结构体的名称。结构体的格式如下：

```go
type struct_variable_type struct {
   member definition
   member definition
   ...
   member definition
}
```

一旦定义了结构体类型，它就能用于变量的声明，语法格式如下：

```go
variable_name := structure_variable_type {value1, value2...valuen}
或
variable_name := structure_variable_type { key1: value1, key2: value2..., keyn: valuen}
```

```go
/*
* @Description: 结构体
* @Version: 1.0.0
* @File: demo27
* @Time: 2024-08-26 14:44
* @Author: cvzhanshi
 */
package main

import "fmt"

type Books struct {
	title   string
	author  string
	subject string
	book_id int
}

func main() {
	// 创建一个新的结构体
	fmt.Println(Books{"Go 语言", "www.runoob.com", "Go 语言教程", 6495407})

	// 也可以使用 key => value 格式
	fmt.Println(Books{title: "Go 语言", author: "www.runoob.com", subject: "Go 语言教程", book_id: 6495407})

	// 忽略的字段为 0 或 空
	fmt.Println(Books{title: "Go 语言", author: "www.runoob.com"})
}
	//{Go 语言 www.runoob.com Go 语言教程 6495407}
	//{Go 语言 www.runoob.com Go 语言教程 6495407}
	//{Go 语言 www.runoob.com  0}
```

### 访问结构体成员

如果要访问结构体成员，需要使用点号 **.** 操作符，格式为：

```go
// 结构体.成员名"

/*
* @Description: 结构体
* @Version: 1.0.0
* @File: demo27
* @Time: 2024-08-26 14:44
* @Author: cvzhanshi
 */
package main

import "fmt"

type Books struct {
	title   string
	author  string
	subject string
	book_id int
}

func main() {
	var Book1 Books /* 声明 Book1 为 Books 类型 */
	var Book2 Books /* 声明 Book2 为 Books 类型 */

	/* book 1 描述 */
	Book1.title = "Go 语言"
	Book1.author = "www.runoob.com"
	Book1.subject = "Go 语言教程"
	Book1.book_id = 6495407

	/* book 2 描述 */
	Book2.title = "Python 教程"
	Book2.author = "www.runoob.com"
	Book2.subject = "Python 语言教程"
	Book2.book_id = 6495700

	/* 打印 Book1 信息 */
	fmt.Printf("Book 1 title : %s\n", Book1.title)
	fmt.Printf("Book 1 author : %s\n", Book1.author)
	fmt.Printf("Book 1 subject : %s\n", Book1.subject)
	fmt.Printf("Book 1 book_id : %d\n", Book1.book_id)

	/* 打印 Book2 信息 */
	fmt.Printf("Book 2 title : %s\n", Book2.title)
	fmt.Printf("Book 2 author : %s\n", Book2.author)
	fmt.Printf("Book 2 subject : %s\n", Book2.subject)
	fmt.Printf("Book 2 book_id : %d\n", Book2.book_id)
}
```

### 结构体作为函数参数

```go
package main

import "fmt"

type Books struct {
   title string
   author string
   subject string
   book_id int
}

func main() {
   var Book1 Books        /* 声明 Book1 为 Books 类型 */
   var Book2 Books        /* 声明 Book2 为 Books 类型 */

   /* book 1 描述 */
   Book1.title = "Go 语言"
   Book1.author = "www.runoob.com"
   Book1.subject = "Go 语言教程"
   Book1.book_id = 6495407

   /* book 2 描述 */
   Book2.title = "Python 教程"
   Book2.author = "www.runoob.com"
   Book2.subject = "Python 语言教程"
   Book2.book_id = 6495700

   /* 打印 Book1 信息 */
   printBook(Book1)

   /* 打印 Book2 信息 */
   printBook(Book2)
}

func printBook( book Books ) {
   fmt.Printf( "Book title : %s\n", book.title)
   fmt.Printf( "Book author : %s\n", book.author)
   fmt.Printf( "Book subject : %s\n", book.subject)
   fmt.Printf( "Book book_id : %d\n", book.book_id)
}
```

### 结构体指针

定义指向结构体的指针类似于其他指针变量，格式如下：

```go
var struct_pointer *Books
```

以上定义的指针变量可以存储结构体变量的地址。查看结构体变量地址，可以将 & 符号放置于结构体变量前：

```go
struct_pointer = &Book1
```

使用结构体指针访问结构体成员，使用 "." 操作符：

```go
struct_pointer.title
```

demo

```go
/*
* @Description: 结构体
* @Version: 1.0.0
* @File: demo27
* @Time: 2024-08-26 14:44
* @Author: cvzhanshi
 */
package main

import "fmt"

type Books struct {
	title   string
	author  string
	subject string
	book_id int
}

func main() {
	var Book1 Books /* 声明 Book1 为 Books 类型 */
	var Book2 Books /* 声明 Book2 为 Books 类型 */

	/* book 1 描述 */
	Book1.title = "Go 语言"
	Book1.author = "www.runoob.com"
	Book1.subject = "Go 语言教程"
	Book1.book_id = 6495407

	/* book 2 描述 */
	Book2.title = "Python 教程"
	Book2.author = "www.runoob.com"
	Book2.subject = "Python 语言教程"
	Book2.book_id = 6495700

	printBook2(Book1)

	printBook(&Book2)
}

func printBook(book *Books) {
	fmt.Printf("Book title : %s\n", book.title)
	fmt.Printf("Book author : %s\n", book.author)
	fmt.Printf("Book subject : %s\n", book.subject)
	fmt.Printf("Book book_id : %d\n", book.book_id)
}

func printBook2(book Books) {
	fmt.Printf("Book title : %s\n", book.title)
	fmt.Printf("Book author : %s\n", book.author)
	fmt.Printf("Book subject : %s\n", book.subject)
	fmt.Printf("Book book_id : %d\n", book.book_id)
}
```

