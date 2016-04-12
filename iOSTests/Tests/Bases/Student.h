//
//  Student.h
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "Person.h"

@interface Student : Person

@property (nonatomic, strong) NSString *studyType;
@property (nonatomic, assign) NSInteger sudentID;

- (void)learn;

@end
