## CompletableFuture详解

> 概要

- Runnable+Thread虽然提供了多线程的能力**但是没有返回值**。
- Callable+Thread的方法提供多线程和返回值的能力但是在获取返回值的时候**会阻塞主线程**。

上述的情况只适合不关心返回值，只要提交的Task执行了就可以。另外的就是能够容忍等待。

==CompletableFuture是jdk8的新特性。CompletableFuture实现了CompletionStage接口和Future接口，前者是对后者的一个扩展，增加了异步会点、流式处理、多个Future组合处理的能力，使Java在处理多任务的协同工作时更加顺畅便利。==

### ① 创建异步任务

#### 1、supplyAsync

supplyAsync是创建带有返回值的异步任务。它有如下两个方法，一个是使用默认线程池（ForkJoinPool.commonPool()）的方法，一个是带有自定义线程池的重

载方法

```java
// 带返回值异步请求，默认线程池
public static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier)
 
// 带返回值的异步请求，可以自定义线程池
public static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier, Executor executor)
```

#### 2、runAsync

runAsync是创建没有返回值的异步任务。它有如下两个方法，一个是使用默认线程池（ForkJoinPool.commonPool()）的方法，一个是带有自定义线程池的重载

方法

```java
// 不带返回值的异步请求，默认线程池
public static CompletableFuture<Void> runAsync(Runnable runnable)
 
// 不带返回值的异步请求，可以自定义线程池
public static CompletableFuture<Void> runAsync(Runnable runnable, Executor executor)
```

#### 3、获取任务结果

```java
// 如果完成则返回结果，否则就抛出具体的异常
public T get() throws InterruptedException, ExecutionException 
 
// 最大时间等待返回结果，否则就抛出具体异常
public T get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException
 
// 完成时返回结果值，否则抛出unchecked异常。为了更好地符合通用函数形式的使用，如果完成此 CompletableFuture所涉及的计算引发异常，则此方法将引发unchecked异常并将底层异常作为其原因
public T join()
 
// 如果完成则返回结果值（或抛出任何遇到的异常），否则返回给定的 valueIfAbsent。
public T getNow(T valueIfAbsent)
 
// 如果任务没有完成，返回的值设置为给定值
public boolean complete(T value)
 
// 如果任务没有完成，就抛出给定异常
public boolean completeExceptionally(Throwable ex) 
```

### ② 异步回调处理

#### 1、结果转换

将上一段任务的执行结果作为下一阶段任务的入参参与重新计算，产生新的结果。

##### thenApply

`thenApply`接收一个函数作为参数，使用该函数处理上一个`CompletableFuture`调用的结果，并返回一个具有处理结果的`Future`对象。

常用方法：

```java
public <U> CompletableFuture<U> thenApply(Function<? super T,? extends U> fn)
public <U> CompletableFuture<U> thenApplyAsync(Function<? super T,? extends U> fn)
```

具体使用：

```java
CompletableFuture<Integer> future = CompletableFuture.supplyAsync(() -> {
    int result = 100;
    System.out.println("第一次运算：" + result);
    return result;
}).thenApply(number -> {
    int result = number * 3;
    System.out.println("第二次运算：" + result);
    return result;
});
```

##### thenCompose

`thenCompose`的参数为一个返回`CompletableFuture`实例的函数，该函数的参数是先前计算步骤的结果。

常用方法：

```java
public <U> CompletableFuture<U> thenCompose(Function<? super T, ? extends CompletionStage<U>> fn);
public <U> CompletableFuture<U> thenComposeAsync(Function<? super T, ? extends CompletionStage<U>> fn) ;

```

具体使用：

```java
CompletableFuture<Integer> future = CompletableFuture
    .supplyAsync(new Supplier<Integer>() {
        @Override
        public Integer get() {
            int number = new Random().nextInt(30);
            System.out.println("第一次运算：" + number);
            return number;
        }
    })
    .thenCompose(new Function<Integer, CompletionStage<Integer>>() {
        @Override
        public CompletionStage<Integer> apply(Integer param) {
            return CompletableFuture.supplyAsync(new Supplier<Integer>() {
                @Override
                public Integer get() {
                    int number = param * 2;
                    System.out.println("第二次运算：" + number);
                    return number;
                }
            });
        }
    });

```

**thenApply 和 thenCompose的区别**：

- `thenApply`转换的是泛型中的类型，返回的是同一个`CompletableFuture`
- `thenCompose`将内部的`CompletableFuture`调用展开来并使用上一个`CompletableFutre`调用的结果在下一步的`CompletableFuture`调用中进行运算，是生成一个新的`CompletableFuture`。

#### 2、结果消费

结果消费系列函数只对结果执行`Action`，而不返回新的计算值。

根据对结果的处理方式，结果消费函数又可以分为下面三大类：

- `thenAccept()`：对单个结果进行消费
- `thenAcceptBoth()`：对两个结果进行消费
- `thenRun()`：不关心结果，只对结果执行`Action`

##### thenAccept

常用方法：

```java
public CompletionStage<Void> thenAccept(Consumer<? super T> action);
public CompletionStage<Void> thenAcceptAsync(Consumer<? super T> action);
```

具体使用：

```java
CompletableFuture<Void> future = CompletableFuture
    .supplyAsync(() -> {
        int number = new Random().nextInt(10);
        System.out.println("第一次运算：" + number);
        return number;
    }).thenAccept(number ->
                  System.out.println("第二次运算：" + number * 5));
```

##### thenAcceptBoth

`thenAcceptBoth`函数的作用是，当两个`CompletionStage`都正常完成计算的时候，就会执行提供的`action`消费两个异步的结果。

常用方法：

```java
public <U> CompletionStage<Void> thenAcceptBoth(CompletionStage<? extends U> other,BiConsumer<? super T, ? super U> action);
public <U> CompletionStage<Void> thenAcceptBothAsync(CompletionStage<? extends U> other,BiConsumer<? super T, ? super U> action);
```

具体使用：

```java
CompletableFuture<Integer> futrue1 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
    @Override
    public Integer get() {
        int number = new Random().nextInt(3) + 1;
        try {
            TimeUnit.SECONDS.sleep(number);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("任务1结果：" + number);
        return number;
    }
});

CompletableFuture<Integer> future2 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
    @Override
    public Integer get() {
        int number = new Random().nextInt(3) + 1;
        try {
            TimeUnit.SECONDS.sleep(number);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("任务2结果：" + number);
        return number;
    }
});

futrue1.thenAcceptBoth(future2, new BiConsumer<Integer, Integer>() {
    @Override
    public void accept(Integer x, Integer y) {
        System.out.println("最终结果：" + (x + y));
    }
});
```

##### thenRun

`thenRun`也是对线程任务结果的一种消费函数，与`thenAccept`不同的是，`thenRun`会在上一阶段 `CompletableFuture`计算完成的时候执行一个`Runnable`，而`Runnable`并不使用该`CompletableFuture`计算的结果。

常用方法：

```java
public CompletionStage<Void> thenRun(Runnable action);
public CompletionStage<Void> thenRunAsync(Runnable action);
```

具体使用：

```java
CompletableFuture<Void> future = CompletableFuture.supplyAsync(() -> {
    int number = new Random().nextInt(10);
    System.out.println("第一阶段：" + number);
    return number;
}).thenRun(() ->
           System.out.println("thenRun 执行"));
```

#### 3、结果组合

##### thenCombine

合并两个线程任务的结果，并进一步处理。

常用方法：

```java
public <U,V> CompletableFuture<V> thenCombine(CompletionStage<? extends U> other,BiFunction<? super T,? super U,? extends V> fn);

public <U,V> CompletableFuture<V> thenCombineAsync(CompletionStage<? extends U> other,BiFunction<? super T,? super U,? extends V> fn);

public <U,V> CompletableFuture<V> thenCombineAsync(CompletionStage<? extends U> other,BiFunction<? super T,? super U,? extends V> fn, Executor executor);
```

具体使用：

```java
CompletableFuture<Integer> future1 = CompletableFuture
    .supplyAsync(new Supplier<Integer>() {
        @Override
        public Integer get() {
            int number = new Random().nextInt(10);
            System.out.println("任务1结果：" + number);
            return number;
        }
    });
CompletableFuture<Integer> future2 = CompletableFuture
    .supplyAsync(new Supplier<Integer>() {
        @Override
        public Integer get() {
            int number = new Random().nextInt(10);
            System.out.println("任务2结果：" + number);
            return number;
        }
    });
CompletableFuture<Integer> result = future1
    .thenCombine(future2, new BiFunction<Integer, Integer, Integer>() {
        @Override
        public Integer apply(Integer x, Integer y) {
            return x + y;
        }
    });
System.out.println("组合后结果：" + result.get());
```

#### 4、结果交互

线程交互指**将两个线程任务获取结果的速度相比较，按一定的规则进行下一步处理**。

##### applyToEither

两个线程任务相比较，先获得执行结果的，就对该结果进行下一步的转化操作。

常用方法：

```java
public <U> CompletionStage<U> applyToEither(CompletionStage<? extends T> other,Function<? super T, U> fn);
public <U> CompletionStage<U> applyToEitherAsync(CompletionStage<? extends T> other,Function<? super T, U> fn);
```

具体使用：

```java
CompletableFuture<Integer> future1 = CompletableFuture
    .supplyAsync(new Supplier<Integer>() {
        @Override
        public Integer get() {
            int number = new Random().nextInt(10);
            try {
                TimeUnit.SECONDS.sleep(number);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("任务1结果:" + number);
            return number;
        }
    });
CompletableFuture<Integer> future2 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
    @Override
    public Integer get() {
        int number = new Random().nextInt(10);
        try {
            TimeUnit.SECONDS.sleep(number);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("任务2结果:" + number);
        return number;
    }
});

future1.applyToEither(future2, new Function<Integer, Integer>() {
    @Override
    public Integer apply(Integer number) {
        System.out.println("最快结果：" + number);
        return number * 2;
    }
});
```

##### acceptEither

两个线程任务相比较，先获得执行结果的，就对该结果进行下一步的消费操作。

常用方法：

```java
public CompletionStage<Void> acceptEither(CompletionStage<? extends T> other,Consumer<? super T> action);
public CompletionStage<Void> acceptEitherAsync(CompletionStage<? extends T> other,Consumer<? super T> action);
```

具体使用：

```java
CompletableFuture<Integer> future1 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
    @Override
    public Integer get() {
        int number = new Random().nextInt(10) + 1;
        try {
            TimeUnit.SECONDS.sleep(number);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("第一阶段：" + number);
        return number;
    }
});

CompletableFuture<Integer> future2 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
    @Override
    public Integer get() {
        int number = new Random().nextInt(10) + 1;
        try {
            TimeUnit.SECONDS.sleep(number);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("第二阶段：" + number);
        return number;
    }
});

future1.acceptEither(future2, new Consumer<Integer>() {
    @Override
    public void accept(Integer number) {
        System.out.println("最快结果：" + number);
    }
});
```

##### runAfterEither

两个线程任务相比较，有任何一个执行完成，就进行下一步操作，不关心运行结果。

常用方法：

```java
public CompletionStage<Void> runAfterEither(CompletionStage<?> other,Runnable action);
public CompletionStage<Void> runAfterEitherAsync(CompletionStage<?> other,Runnable action);
```

具体使用：

```java
CompletableFuture<Integer> future1 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
    @Override
    public Integer get() {
        int number = new Random().nextInt(5);
        try {
            TimeUnit.SECONDS.sleep(number);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("任务1结果：" + number);
        return number;
    }
});

CompletableFuture<Integer> future2 = CompletableFuture.supplyAsync(new Supplier<Integer>() {
    @Override
    public Integer get() {
        int number = new Random().nextInt(5);
        try {
            TimeUnit.SECONDS.sleep(number);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("任务2结果:" + number);
        return number;
    }
});

future1.runAfterEither(future2, new Runnable() {
    @Override
    public void run() {
        System.out.println("已经有一个任务完成了");
    }
}).join();
```

##### anyOf

`anyOf() `的参数是多个给定的 `CompletableFuture`，当其中的任何一个完成时，方法返回这个 `CompletableFuture`。

常用方法：

```java
public static CompletableFuture<Object> anyOf(CompletableFuture<?>... cfs)
```

具体使用：

```java
Random random = new Random();
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(random.nextInt(5));
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    return "hello";
});

CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(random.nextInt(1));
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    return "world";
});
CompletableFuture<Object> result = CompletableFuture.anyOf(future1, future2);
```

##### allOf

allOf方法用来实现多 CompletableFuture 的同时返回。

常用方法：

```java
public static CompletableFuture<Void> allOf(CompletableFuture<?>... cfs)
```

具体使用：

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> {
    try {
        TimeUnit.SECONDS.sleep(2);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    System.out.println("future1完成！");
    return "future1完成！";
});

CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> {
    System.out.println("future2完成！");
    return "future2完成！";
});

CompletableFuture<Void> combindFuture = CompletableFuture.allOf(future1, future2);

try {
    combindFuture.get();
} catch (InterruptedException e) {
    e.printStackTrace();
} catch (ExecutionException e) {
    e.printStackTrace();
}
```

> 汇总

![a](CompletableFuture详解.assets/a.png)

## 