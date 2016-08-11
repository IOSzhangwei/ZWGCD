//
//  ViewController.m
//  ZWGCD
//
//  Created by 章为 on 16/8/11.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "ViewController.h"
#import "GCD.h"
@interface ViewController ()
@property (nonatomic, strong) dispatch_source_t timer;
@property(nonatomic,strong)GCDTimer *gcdTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

/**==============GCD 串行队列与并发队列 =================  */
      //执行串行队列 demo1
   // [self serailQueue];
    //执行并发队列  demo2
   // [self initConcurrent];
    
    //子线程处理业务逻辑，主线程刷新UI  demo3
 //   [self mainQueue];
  
    
/**==============延迟操作 =================  */
    //NSThread方式的延迟操作
   // [self waitThread];
    
    //GCD 方式的延迟操作
   // [self waitGCD];
    /**NSThread（无误差） 的延迟要优于GCD（GCD延迟3S会有0.2S的误差）优点：1，精确度高，2.可取消延迟执行操作
     
      [NSObject cancelPreviousPerformRequestsWithTarget:self];
     GCD缺点：1、 延迟操作，无法用上边的这段代码取消的
             2、 延迟操作会有误差
     优点：代码比较简洁
     */
 /**==============线程组 （进阶）================= */
    /**场景1，等待线程1，线程2。线程3。。执行完成后，执行线程4*/
   // [self queueGroup];
    
/**==============GCD定时器 （进阶）================= */
    //GCD 定时器
   // [self ZWGCDTimer];
    
    //NSThread 定时器
  //  [self normalTimer];
    
    /**
     NSThread : 作用于当前的runloop 里边去的。如果用在tableView 里边会出现一些奇怪的问题 （GCD则不会出现）
     定时时间精度NSThread 要优于GCD
     
     */
/**==============GCD信号量（进阶）================= */
    //场景，2个异步线程，，线程1，线程2.。。需要线程1执行完成后，在执行线程2
    
    
    [self Semaphore];

}

-(void)Semaphore{
    
    //原始代码
    /**
    dispatch_semaphore_t dispatchSemaphore =dispatch_semaphore_create(0);
    
    dispatch_queue_t Queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(Queue, ^{
        
        NSLog(@"线程11");
        //线程执行完毕，发送信 号
        dispatch_semaphore_signal(dispatchSemaphore);
    });
    dispatch_async(Queue, ^{
        
        //线程等待信号，当收到信号的时候，执行方法，否则锁住
        dispatch_semaphore_wait(dispatchSemaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"线程22");
    });
    */
    
    //GCD封装
    
    GCDSemaphore *semaphore = [[GCDSemaphore alloc]init];
    
    
    
    [GCDQueue executeInGlobalQueue:^{
        NSLog(@"异步线程1");
        [semaphore signal];
    }];
    [GCDQueue executeInGlobalQueue:^{
        [semaphore wait];
        NSLog(@"异步线程2");
       // [semaphore signal];
    }];
//    [GCDQueue executeInGlobalQueue:^{
//        [semaphore wait];
//        NSLog(@"异步线程3");
//    }];
    
    
    
    
}

-(void)normalTimer{
    
    //初始化定时器，并激活，2S执行一次
    NSTimer *normalTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    
}
-(void)timerEvent{
    
    NSLog(@"NSThread 定时器");
    
}
-(void)ZWGCDTimer{
   //原始代码
    /**
    //初始化定时器
    self.timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    //构建参数。指定时间间隔
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1.0 * NSEC_PER_SEC, 0);
    //要执行的时间
    dispatch_source_set_event_handler(self.timer, ^{
       
        NSLog(@"多久打印一次");
    });
    //运行GSD
    dispatch_resume(self.timer);
    //取消定时器
    //dispatch_cancel(self.timer); self.timer = nil;
     */
    
    //GCD封装
    self.gcdTimer = [[GCDTimer alloc]initInQueue:[GCDQueue mainQueue]];  //将定时器放入主线程中
    [self.gcdTimer event:^{
        
        NSLog(@"2S执行一次。GCD封装定时器");
    } timeInterval:NSEC_PER_SEC*2];
    
    [self.gcdTimer start];
    
}

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





-(void)waitGCD{
    NSLog(@"启动");
    
    //主线程延迟执行。。（子线程延迟此处未做demo） 原始代码
    /**
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"延迟三秒");
        
    });
     */
    //GCD封装
    [GCDQueue executeInMainQueue:^{
        
        NSLog(@"GCD 封装，延迟2S执行");
        
    } afterDelaySecs:2.f];
    
}

-(void)waitThread{
    NSLog(@"启动");
    [self performSelector:@selector(threadEvent:) withObject:self afterDelay:3];
}

-(void)threadEvent:(id)sender{
    
    NSLog(@"是否延迟三秒执行");
}

-(void)mainQueue{
    /**
     原始代码
    dispatch_queue_t dispatchQueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        
        NSLog(@"子线程处理业务逻辑");
        
        dispatch_queue_t mainQueue=dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            
            NSLog(@"刷新UI操作");
        });
        
    });
     */
    //GCD封装
    [GCDQueue executeInGlobalQueue:^{
        
        //处理业务逻辑
        
       [GCDQueue executeInMainQueue:^{
           //更新UI
       }];
        
    }];
    
    
}


-(void)initConcurrent{
    //原始代码
    /**
    dispatch_queue_t Queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(Queue, ^{
        
        NSLog(@"1");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"2");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"3");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"4");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"5");
    });
     */
    //GCD封装
    GCDQueue *queueConcurrent= [[GCDQueue alloc]initConcurrent];
    [queueConcurrent execute:^{
        NSLog(@"执行队列中的线程1");
    }];
    
    [queueConcurrent execute:^{
        NSLog(@"执行队列中的线程2");
    }];
    
    [queueConcurrent execute:^{
        NSLog(@"执行队列中的线程3");
    }];
    
    [queueConcurrent execute:^{
        NSLog(@"执行队列中的线程4");
    }];
    
    
}

//串行队列  顺序执行
-(void)serailQueue{
    
    //原始代码
 /**   dispatch_queue_t Queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(Queue, ^{
        
        NSLog(@"1");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"2");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"3");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"4");
    });
    dispatch_async(Queue, ^{
        
        NSLog(@"5");
    });
  */
    //GCD封装
    GCDQueue *queue= [[GCDQueue alloc]initSerial];
    [queue execute:^{
        NSLog(@"执行队列中的线程1");
    }];
    [queue execute:^{
        NSLog(@"执行队列中的线程2");
    }];
    [queue execute:^{
        NSLog(@"执行队列中的线程3");
    }];
    [queue execute:^{
        NSLog(@"执行队列中的线程4");
    }];
}

@end
