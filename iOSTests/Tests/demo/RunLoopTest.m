//
//  RunLoopTest.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "RunLoopTest.h"

@implementation RunLoopTest{
    NSTimer *timer1;
    NSTimer *timer2;
    
    NSInteger tag;
}


- (void)test{
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEnd) userInfo:nil repeats:YES];
    
    
}

- (void)timerEnd{
    if (timer1) {
        NSLog(@"\n\nTimer1定时器 没有加入runloop 滑动ScrollView会影响计时\n%@\n\n",@(tag++));
        
        if (tag == 10) {
            [timer1 invalidate];
            timer1 = nil;
            tag = 0;
            timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerEnd) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        }
    }
    
    
    if (timer2) {
        NSLog(@"\n\nTimer2定时器 加入runloop 滑动ScrollView不影响计时\n%@\n\n",@(tag++));
        
        if (tag == 20) {
            [timer2 invalidate];
            timer2 = nil;
            
        }
    }
}

@end
