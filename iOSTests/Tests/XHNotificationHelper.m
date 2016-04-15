//
//  XHNotificationHelper.m
//  iOSTests
//
//  Created by xianghui on 16/4/14.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "XHNotificationHelper.h"

@implementation XHNotificationHelper

+ (id)sharedLogHelper {
    static id _sharedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[XHNotificationHelper alloc]init];
    });
    return _sharedHelper;
}







- (void)userActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo{
    if (self.localNotificationBlock) {
        self.localNotificationBlock(identifier,notification,responseInfo);
    }
}

@end
