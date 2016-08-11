# ZWGCD
300行代码帮助你理解GCD，并且将繁杂的GCD C代码，进行一层封装，让你非常方便的使用GCD

阅读完源码之后，你应当掌握以下知识：

1.GCD串行队列与并发队列

2.GCD延时执行操作

3.GCD线程组的使用

4.GCD定时器的使用

5.用GCD信号量将异步操作转换为同步操作

//封装GCD 

//使用片段，线程组
-(void)queueGroup{
    
  /**场:等待线程1与线程2,线程3，执行完成后  。执行线程4*/
    /**   原始代码
    //创建一个线程组
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    //创建一个线程队列
    dispatch_queue_t Queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    
    //让线程 Queue 在Group中执行 （线程1）
    dispatch_group_async(dispatchGroup, Queue, ^{
        NSLog(@"线程1执行完毕");
    });
    
    //让线程 Queue 在Group中执行 （线程2）
    dispatch_group_async(dispatchGroup, Queue, ^{
        NSLog(@"线程2执行完毕");
    });
    dispatch_group_async(dispatchGroup, Queue, ^{
        NSLog(@"线程3执行完毕");
    });
    //监听线程组是否执行结束，然后执行线程三
    dispatch_group_notify(dispatchGroup, Queue, ^{
        NSLog(@"线程4执行完毕");
    });
    */
    
    //GCD封装代码
    
    GCDGroup *group =[[GCDGroup alloc]init];
    
    GCDQueue *zwQueue =[[GCDQueue alloc]initConcurrent];
    [zwQueue execute:^{
        NSLog(@"线程1执行完毕");
    } inGroup:group];
    [zwQueue execute:^{
        NSLog(@"线程2执行完毕");
    } inGroup:group];
    [zwQueue execute:^{
        NSLog(@"线程3执行完毕");
    } inGroup:group];
    
    //监听线程组是否执行结束，然后执行线程3
    [zwQueue notify:^{
        NSLog(@"线程4执行完毕");
    } inGroup:group];
    
}
