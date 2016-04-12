//
//  Person.h
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>


@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) int phoneNum;
@property (nonatomic, strong) Person *mother;
@property (nonatomic, strong) Person *father;
@property (nonatomic, strong) Person *son;


- (void)eat;
- (void)speak;

//只声明 不实现 利用消息转发动态添加方法实现
- (void)cry;

@end
