# ① 概述

> **什么是Retrofit**

- retrofit是现在比较流行的网络请求框架，可以理解为okhttp的加强版，底层封装的就是Okhttp。准确来说，**Retrofit是一个RESTful的http网络请求框架的封装**。因为网络请求工作本质上是由okhttp来完成，而Retrofit负责网络请求接口的封装。

本质过程：App应用程序通过Retrofit请求网络，实质上是使用Retrofit接口层封装请求参数、Header、Url等信息，之后由okhttp来完成后续的请求工作。在服务端返回数据后，okhttp将原始数据交给Retrofit，Retrofit根据用户需求解析。

> **Retrofit的优点**

- 超级解耦 ，接口定义、接口参数、接口回调不在耦合在一起
- 可以配置不同的httpClient来实现网络请求，如okhttp、httpclient
- 支持同步、异步、Rxjava
- 可以配置不同反序列化工具类来解析不同的数据，如json、xml
- 请求速度快，使用方便灵活简洁

# ② 注解介绍

Retrofit使用大量注解来简化请求，Retrofit将okhttp请求抽象成java接口，使用注解来配置和描述网络请求参数。

## 1、请求方法注解

| 请求方法注解 | 说明    |
| ------------ | ------- |
| @GET         | get请求 |
|@POST|	post请求|
|@PUT	|put请求|
|@DELETE|	delete请求|
|@PATCH|	patch请求，该请求是对put请求的补充，用于更新局部资源|
|@HEAD	|head请求|
|@OPTIONS|	options请求|
|@HTTP	|通过注解，可以替换以上所有的注解，它拥有三个属性：method、path、hasBody|

## 2、请求头注解

| 请求头注解 | 说明    |
| ------------ | ------- |
|@Headers|	用于添加固定请求头，可以同时添加多个，通过该注解的请求头不会相互覆盖，而是共同存在|
|@Header|	作为方法的参数传入，用于添加不固定的header，它会更新已有请求头|

## 3、请求参数注解

| 请求参数注解 | 说明    |
| ------------ | ------- |
|@Body|	多用于Post请求发送非表达数据，根据转换方式将实例对象转化为对应字符串传递参数，比如使用Post发送Json数据，添加GsonConverterFactory则是将body转化为json字符串进行传递|
|@Filed	|多用于Post方式传递参数，需要结合@FromUrlEncoded使用，即以表单的形式传递参数|
|@FiledMap	|多用于Post请求中的表单字段，需要结合@FromUrlEncoded使用|
|@Part	|用于表单字段，Part和PartMap与@multipart注解结合使用，适合文件上传的情况|
|@PartMap|	用于表单字段，默认接受类型是Map<String,RequestBody>，可用于实现多文件上传|
|@Path|	用于Url中的占位符|
|@Query	|用于Get请求中的参数|
|@QueryMap|	与Query类似，用于不确定表单参数|
|@Url	|指定请求路径|

## 4、请求和响应格式(标记)注解

| 标记类注解 | 说明    |
| ------------ | ------- |
|@FromUrlCoded|	表示请求发送编码表单数据，每个键值对需要使用@Filed注解|
|@Multipart|	表示请求发送form_encoded数据(使用于有文件上传的场景)，每个键值对需要用@Part来注解键名，随后的对象需要提供值|
|@Streaming|	表示响应用字节流的形式返回，如果没有使用注解，默认会把数据全部载入到内存中，该注解在下载大文件时特别有用|

# ③ 基本注解的使用

> @Get 基本注解

```java
@GET("blog/{id}") //这里的{id} 表示是一个变量
Call<ResponseBody> getBlog(/** 这里的id表示的是上面的{id} */@Path("id") int id);
```

> @Http 全名注解

```java
/**
 * method 表示请求的方法，区分大小写，retrofit 不会做处理
 * path表示路径
 * hasBody表示是否有请求体
 */
@HTTP(method = "GET", path = "blog/{id}", hasBody = false)
Call<ResponseBody> getBlog(@Path("id") int id);
```

> @Post 

```java
/**
 * {@link FormUrlEncoded} 表明是一个表单格式的请求（Content-Type:application/x-www-form-urlencoded）
 * <code>Field("username")</code> 表示将后面的 <code>String name</code> 中name的取值作为 username 的值
 */
@POST("/form")
@FormUrlEncoded
Call<ResponseBody> testFormUrlEncoded1(@Field("username") String name, @Field("age") int age);

/**
 * Map的key作为表单的键
 */
@POST("/form")
@FormUrlEncoded
Call<ResponseBody> testFormUrlEncoded2(@FieldMap Map<String, Object> map);
```

> @Headers 和 @Header

```java
@GET("/headers?showAll=true")
@Headers({"CustomHeader1: customHeaderValue1", "CustomHeader2: customHeaderValue2"})
Call<ResponseBody> testHeader(@Header("CustomHeader3") String customHeaderValue3);
```

@Headers ： 用在方法上面，请求的时候添加固定的 Header 值

@Header ： 只能用在方法参数中，可以动态的传递 Header 参数

> @Query 和 @QueryMap

```java
/**
 * 当GET、POST...HTTP等方法中没有设置Url时，则必须使用 {@link Url}提供
 * 对于Query和QueryMap，如果不是String（或Map的第二个泛型参数不是String）时
 * 会被默认会调用toString转换成String类型
 * Url支持的类型有 okhttp3.HttpUrl, String, java.net.URI, android.net.Uri
 * {@link retrofit2.http.QueryMap} 用法和{@link retrofit2.http.FieldMap} 用法一样，不再说明
 */
@GET //当有URL注解时，这里的URL就省略了
Call<ResponseBody> testUrlAndQuery(@Url String url, @Query("showAll") boolean showAll);
```

当@GET、POST...HTTP等注解中没有设置Url时，则必须在方法参数中使用 @Url 来提供 Url

@Query 和 @QueryMap 会自动当成参数来拼接 Url

> @Body

```java
@POST("blog")
Call<Result<Blog>> createBlog(@Body Blog blog);
```

当参数比较多的时候，一种是使用 @FieldMap 注解，一种是使用 @Body 传递一个对象，当对象作为参数的时候，需要在 Retrofit 配置一个转换器，例如下面，这样就会自动把这个对象进行一次转换放到 request 的 body 里传过去

```java
Retrofit retrofit = new Retrofit.Builder()
        .baseUrl("http://localhost:4567/")
        //可以接收自定义的Gson，当然也可以不传
        .addConverterFactory(GsonConverterFactory.create(gson))
        .build();
```
