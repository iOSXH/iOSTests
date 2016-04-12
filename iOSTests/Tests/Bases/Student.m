//
//  Student.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "Student.h"

@implementation Student

+(void)load{
    
    NSLog(@"%@ load",NSStringFromClass([self class]));
}


- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)learn{
    
    NSLog(@"%@ learn",NSStringFromClass([self class]));
}

@end
