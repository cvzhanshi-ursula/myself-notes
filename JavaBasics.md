# Other

## 键盘输入

Scanner scan = new Scanner(System.in);

Datatype a = scan.nextDatatype(); 

Int a = scan.nextInt();

String s = sacn.next(



## Switch结构

   Switch结构中的表达式，只能是以下6种数据类型:

byte、short、char、int、枚举类型、String类型



## Lable(标签)

​	和break、continue一起用

## JDK、JRE、JVM的关系

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415090959939.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

﻿# 数组

## 数组元素默认初始化

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210329133433553.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## JVM内存解析

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210329133519912.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210329133600358.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 一维数组的内存解析

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210329133640938.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 二维数组的使用

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210329133703494.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2021032913374640.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 数组中涉及到的常见算法

### 数组的复制底层实现

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210329134157209.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

### 冒泡排序

~~~java
public class BubbleSortTest {
	public static void main(String[] args) {
		
		int[] arr = new int[]{43,32,76,-98,0,64,33,-21,32,99};
		
		//冒泡排序
		for(int i = 0;i < arr.length - 1;i++){
			
			for(int j = 0;j < arr.length - 1 - i;j++){
				
				if(arr[j] > arr[j + 1]){
					int temp = arr[j];
					arr[j] = arr[j + 1];
					arr[j + 1] = temp;
				}
				
			}
			
		}
		for(int i = 0;i < arr.length;i++){
			System.out.print(arr[i] + "\t");
		}
		
	}
}
~~~

### 快速排序

~~~java
/**
 * 快速排序
 * 通过一趟排序将待排序记录分割成独立的两部分，其中一部分记录的关键字均比另一部分关键字小，
 * 则分别对这两部分继续进行排序，直到整个序列有序。
 * @author ursula
 * 2021-3-25
 */
public class QuickSort {
	private static void swap(int[] data, int i, int j) {
		int temp = data[i];
		data[i] = data[j];
		data[j] = temp;
	}

	private static void subSort(int[] data, int start, int end) {
		if (start < end) {
			int base = data[start];
			int low = start;
			int high = end + 1;
			while (true) {
				while (low < end && data[++low] - base <= 0)
					;
				while (high > start && data[--high] - base >= 0)
					;
				if (low < high) {
					swap(data, low, high);
				} else {
					break;
				}
			}
			swap(data, start, high);
			
			subSort(data, start, high - 1);//递归调用
			subSort(data, high + 1, end);
		}
	}
	public static void quickSort(int[] data){
		subSort(data,0,data.length-1);
	}
	
	
	public static void main(String[] args) {
		int[] data = { 9, -16, 30, 23, -30, -49, 25, 21, 30 };
		System.out.println("排序之前：\n" + java.util.Arrays.toString(data));
		quickSort(data);
		System.out.println("排序之后：\n" + java.util.Arrays.toString(data));
	}
}
~~~

## 数组中常见的异常

ArrayIndexOutOfBoundsException:数组角标越界异常：

合理范围：[0,arr.length -1]

越界：arr[-1],arr[arr.length]

NullPointerException:空指针异常

int[] arr = null;

arr[0];

﻿# 面向对象编程(上)

## 面向对象与面向过程

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091120291.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


**总结:程序员从面向过程的执行者转化成了面向对象的指挥者**



## 对象的内存解析

![](https://img-blog.csdnimg.cn/20210415091147252.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)




## 局部变量与成员变量的区别:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091204529.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091253559.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091307415.png)

## 对象数组的内存解析:

![](https://img-blog.csdnimg.cn/20210415091322139.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)




## 可变形参

![](https://img-blog.csdnimg.cn/20210415091339975.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 方法参数的值传递:

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091417865.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 封装性

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091500227.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)






## 权限修饰符

![](https://img-blog.csdnimg.cn/20210415091510682.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)






## 属性赋值的先后顺序

![](https://img-blog.csdnimg.cn/2021041509152159.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)






## UML类图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091534984.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)






## this关键字

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091553449.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)





## 面向对象三大特征的说明

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091607787.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

# 面向对象编程(中)



﻿## 继承性

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091751193.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 方法重写

![](https://img-blog.csdnimg.cn/20210415091812447.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)




## Super关键字

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415091908983.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)





## 子类对象实例化全过程



![](https://img-blog.csdnimg.cn/20210415091923866.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)






## 多态性

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415092004626.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)






## Instanceof

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415092033918.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)




## Object类

### Object类的结构解析

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415092101239.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)






### "=="运算符的使用 

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415092123335.png)








### Equals()方法

![](https://img-blog.csdnimg.cn/20210415092214629.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)




### ToString()方法

![](https://img-blog.csdnimg.cn/20210415092223418.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)




## 包装类

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415092236794.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)




### 数据类型之间的转换

![](https://img-blog.csdnimg.cn/20210415092248431.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210415092305525.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

﻿# 面向对象编程(下)

## Static关键字

### static关键字修饰属性

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103257620.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


#### 类变量vs实例变量内存解析

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103358494.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## static关键字修饰方法

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103414216.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


## 单例设计模式

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103426406.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


### 饿汉式

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103436982.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

### 懒汉式

![在这里插入图片描述](https://img-blog.csdnimg.cn/2021042510345446.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 代码块:（代码块的执行先于构造器）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103528210.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 对属性赋值

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103543863.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## Final关键字

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103552680.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## abstract关键字

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103604407.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

### 抽象类的匿名子类

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103643735.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


### 抽象类的应用:（模块方法设计模式）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103658719.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103710350.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 接口interface

### 概述

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103731375.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2021042510374035.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

### 代理模式

代理模式是Java开发中使用较多的一种设计模式。代理设计就是为其他对象提供一种代理以控制对这个对象的访问。

#### 举例

~~~java
interface NetWork{
	
	public void browse();
	
}

//被代理类
class Server implements NetWork{

	@Override
	public void browse() {
		System.out.println("真实的服务器访问网络");
	}

}
//代理类
class ProxyServer implements NetWork{
	
	private NetWork work;
	
	public ProxyServer(NetWork work){
		this.work = work;
	}
	

	public void check(){
		System.out.println("联网之前的检查工作");
	}
	
	@Override
	public void browse() {
		check();
		
		work.browse();
		
	}
	
}
~~~

#### 应用场景

![](https://img-blog.csdnimg.cn/20210425103759351.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


### 工厂的设计模式

1. 解决的问题
   实现了创建者与调用者的分离，即将创建对象的具体过程屏蔽隔离起来，达到提高灵活性的目的。

2. 具体模式

   简单工厂模式：用来生产同一等级结构中的任意产品。（对于增加新的产品，需要修改已有代码）
   工厂方法模式：用来生产同一等级结构中的固定产品。（支持增加任意产品)
   抽象工厂模式：用来生产不同产品族的全部产品。（对于增加新的产品，无能为力；支持增加产品族)

### Java8新特性

![在这里插入图片描述](https://img-blog.csdnimg.cn/2021042510391218.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 内部类

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425103957264.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

﻿# 异常处理

## Error

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425113122283.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## Exception体系结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425113133861.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)


## 异常的处理

#### try-catch-finally

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425113150301.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

#### try-catch-finally中finally的使用

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425113200869.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

#### throws处理异常

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425113213845.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)

## 自定义异常

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210425113223362.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQ1NDA4Mzkw,size_16,color_FFFFFF,t_70)



