//
//  GCDTest.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "GCDTest.h"

@implementation GCDTest

/**
 *  @author xh, 16-04-12 13:04:53
 *
 *  单例
 *
 *  @return self
 */
+(id)shareTest{
    static GCDTest *test;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[GCDTest alloc] init];
    });
    
//    @synchronized(<#token#>) {
//        <#statements#>
//    }
    return test;
}

- (void)test{
    [self testQueue];
}

/**
 *  @author xh, 16-04-12 14:04:37
 *
 *  GCD队列
 */
- (void)testQueue{
    //获取全局并发调度队列 无需创建直接获取
    /*
     优先级  依次降低
     DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
     DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
     DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
     DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建串行调度队列 1、队列名称 2、相关属性NULL
    dispatch_queue_t sequalQueue = dispatch_queue_create("com.xh.sequalQueueTest", NULL);
    
    //获取主线程串行调度队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(sequalQueue, ^{
        NSLog(@"开启异步线程：%@",[NSThread currentThread]);
        dispatch_async(mainQueue, ^{
            NSLog(@"切换到主线程：%@",[NSThread currentThread]);
        });
    });
    
    dispatch_sync(sequalQueue, ^{
        NSLog(@"开启同步线程：%@",[NSThread currentThread]);
        dispatch_async(mainQueue, ^{
            NSLog(@"切换到主线程：%@",[NSThread currentThread]);
        });
    });
    
    //并发地循环迭代任务 并发 顺序不确定
    //dispatch_apply或dispatch_apply_f函数也是在所有迭代完成之后才会返回，因此这两个函数会阻塞当前线程。
    size_t gcount = 10;//十次任务
    dispatch_apply(gcount, globalQueue, ^(size_t i) {
        NSLog(@"迭代任务，顺序：%zu",i);
    });
    
    dispatch_async(globalQueue, ^{
        NSLog(@"异步任务 休眠3秒");
        sleep(3);
        dispatch_async(mainQueue, ^{
            NSLog(@"任务完成，切换到主线程");
        });
    });
    
    //暂停
    dispatch_suspend(globalQueue);
    NSLog(@"暂停队列：%@",globalQueue);
    //继续
    dispatch_resume(globalQueue);
    NSLog(@"继续队列：%@",globalQueue);
    
    //调度组 Dispatch Group
    //开启异步任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //创建组
        dispatch_group_t group = dispatch_group_create();
        
        //添加任务
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"开始第一个任务 休眠1秒");
            sleep(1);
        });
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"开始第二个任务 休眠2秒");
            sleep(2);
        });
        
        //组中任务执行完毕，通知主线程回调
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"两个任务完成，切换主线程");
        });
    });
    
    //延迟线程
    NSLog(@"开始，5秒倒计时");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"5秒结束");
        
        [self testTargetQueue];
    });
}


/**
 *  @author xh, 16-04-12 14:04:39
 *
 *  子队列
 */
- (void)testTargetQueue{
    dispatch_queue_t serialQueue = dispatch_queue_create("com.xh.targetQueueTest", DISPATCH_QUEUE_SERIAL);
    
    //将serialQueue放入全局队列中作为子队列，优先级：最低
    //dispatch_set_target_queue，通过它可以设置调整目标队列，比如我们可以设置目标队列为全局队列，那么这个全局队列可以先设置优先级，如此就可以解决子队列优先级的问题。
    dispatch_set_target_queue(serialQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
    
    dispatch_async(serialQueue, ^{
        NSLog(@"任务1，优先级：最低：%d",DISPATCH_QUEUE_PRIORITY_LOW);
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"任务2，优先级：最低：%d",DISPATCH_QUEUE_PRIORITY_LOW);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"任务3，优先级：默认：%d",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"任务4，优先级：默认：%d",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSLog(@"任务5，优先级：BACKGROUND：%d",DISPATCH_QUEUE_PRIORITY_BACKGROUND);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSLog(@"任务6，优先级：BACKGROUND：%d",DISPATCH_QUEUE_PRIORITY_BACKGROUND);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSLog(@"任务7，优先级：最高：%d",DISPATCH_QUEUE_PRIORITY_HIGH);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSLog(@"任务8，优先级：最高：%d",DISPATCH_QUEUE_PRIORITY_HIGH);
    });
    
    
    [self performSelector:@selector(testSCQueue) withObject:nil afterDelay:5];
}

/**
 *  @author xh, 16-04-12 14:04:18
 *
 *  串行队列  并发队列
 */
-(void)testSCQueue{
    //串行队列 顺序执行
    dispatch_queue_t serialQueue = dispatch_queue_create("com.xh.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"串行队列，任务1");
    });
    
    dispatch_async(serialQueue, ^{
        sleep(2);
        NSLog(@"串行队列，任务2，休眠了2秒");
    });
    
    dispatch_async(serialQueue, ^{
        sleep(1);
        NSLog(@"串行队列，任务3，休眠了1秒");
    });
    
    //并发队列 线程分别执行 互不干扰
    dispatch_queue_t concurrencyQueue = dispatch_queue_create("com.xh.concurrencyQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrencyQueue, ^{
        
        NSLog(@"并发队列，任务1");
    });
    
    dispatch_async(concurrencyQueue, ^{
        sleep(2);
        NSLog(@"并发队列，任务2，休眠了2秒");
    });
    
    dispatch_async(concurrencyQueue, ^{
        sleep(1);
        NSLog(@"并发队列，任务3，休眠了1秒");
    });
}

@end
