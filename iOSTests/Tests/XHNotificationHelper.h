//
//  XHNotificationHelper.h
//  iOSTests
//
//  Created by xianghui on 16/4/14.
//  Copyright © 2016年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XHLocalNotificationBlock)(NSString *identifier,UILocalNotification *notification,NSDictionary *responseInfo);

@interface XHNotificationHelper : NSObject

/**
 *  @author xh, 16-04-14 18:04:30
 *
 *  单例
 *
 *  @return self
 */
+ (id)sharedLogHelper;


/**
 *  @author xh, 16-04-15 10:04:09
 *
 *  用户点击了本地通知按钮
 *
 *  @param identifier   通知标识
 *  @param notification 通知
 *  @param responseInfo 内容
 */
- (void)userActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo;

/**
 *  @author xh, 16-04-15 10:04:24
 *
 *  本地通知Block回调
 */
@property (nonatomic, copy) XHLocalNotificationBlock localNotificationBlock;


@end
