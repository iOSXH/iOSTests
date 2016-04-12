//
//  Person+xh.h
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "Person.h"

@interface Person (xh)

/**
 *  @author xh, 16-04-11 13:04:31
 *
 *  分类中添加属性 （runtime）
 */
@property (nonatomic, assign) float heiht;

- (void)run;

@end
