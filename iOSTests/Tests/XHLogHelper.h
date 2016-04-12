//
//  XHLogHelper.h
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XHLogBlock)(NSString *LogText);

@interface XHLogHelper : NSObject

+ (id)sharedLogHelper;

@property (nonatomic, copy) XHLogBlock logBlock;

@end
