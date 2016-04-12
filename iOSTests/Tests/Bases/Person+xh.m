//
//  Person+xh.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "Person+xh.h"
#import <objc/runtime.h>


static const void *xhHeightKey = "xhHeightKey";

@implementation Person (xh)

//+(void)load{
//    
//    NSLog(@"%@+xh load",NSStringFromClass([self class]));
//}


//- (void)dealloc{
//    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
//}

- (void)run{
    
    NSLog(@"%@ run",NSStringFromClass([self class]));
}



/*
 objc_setAssociatedObject(object, key, value, policy)
 object：与谁关联，通常是传self
 key：唯一键，在获取值时通过该键获取，通常是使用static const void *来声明
 value：关联所设置的值
 policy：内存管理策略，比如使用copy

 */
- (void)setHeiht:(float)heiht{
    objc_setAssociatedObject(self, xhHeightKey, @(heiht), OBJC_ASSOCIATION_ASSIGN);
}

- (float)heiht{
    return [objc_getAssociatedObject(self, xhHeightKey) floatValue];
}

@end
