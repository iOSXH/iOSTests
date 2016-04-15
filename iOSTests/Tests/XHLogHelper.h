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

/**
 *  @author xh, 16-04-14 18:04:41
 *
 *  单例
 *
 *  @return self
 */
+ (id)sharedLogHelper;

/**
 *  @author xh, 16-04-14 18:04:00
 *
 *  block 有log时进行回调
 */
@property (nonatomic, copy) XHLogBlock logBlock;

@end
