//
//  KVOTest.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "KVOTest.h"

#import "Person.h"
#import "Student.h"
#import "Person+xh.h"

@implementation KVOTest{
    Student *student;
    Student* son;
}

- (void)test{
    son = [[Student alloc] init];
    son.name = @"xly";
    son.age = 1;
    son.address = @"shanghai";
    son.phoneNum = 185;
    son.heiht = 65;
    son.studyType = @"无";
    son.sudentID = 0;
    
    student = [[Student alloc] init];
    student.name = @"xh";
    student.age = 25;
    student.address = @"shanghai";
    student.phoneNum = 185;
    student.heiht = 178;
    student.sudentID = 1;
    student.studyType = @"iOS";
    student.son = son;
    
    //添加KVO监听
    [student addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [student addObserver:self forKeyPath:@"son" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [student addObserver:self forKeyPath:@"son.phoneNum" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [son addObserver:self forKeyPath:@"address" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self change];
}

- (void)dealloc{
    //移除KVO监听
    [student removeObserver:self forKeyPath:@"age"];
    [student removeObserver:self forKeyPath:@"son"];
    [student removeObserver:self forKeyPath:@"son.phoneNum"];
    [son removeObserver:self forKeyPath:@"address"];
    
}

- (void)change{
    
    
    student.age += 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        son.address = @"sh";
     
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        student.son.phoneNum = 188;
        
        student.son = nil;
    });
}

//KVO监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"age"]) {
        NSLog(@"%@  age发生变化：%@",object,@(student.age));
    }else if ([keyPath isEqualToString:@"address"]){
        
        NSLog(@"%@  age发生变化：%@  ===  %@",object,son.address, student.son.address);
    }else{
        NSLog(@"%@  %@发生变化：%@",object,keyPath,change);
    }
}

@end
