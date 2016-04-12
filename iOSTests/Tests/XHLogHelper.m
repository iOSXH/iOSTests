//
//  XHLogHelper.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "XHLogHelper.h"

@implementation XHLogHelper{
    NSString *logPath;
}

+ (id)sharedLogHelper {
    static id _sharedLogHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLogHelper = [[XHLogHelper alloc]init];
    });
    return _sharedLogHelper;
}

- (id)init {
    if (self = [super init]) {
        logPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"xh.log"];
        
        
        [NSFileManager.defaultManager removeItemAtPath:logPath error:nil];
        freopen([logPath fileSystemRepresentation], "a", stderr);
        
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:logPath];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(logChange:) name:@"NSFileHandleReadCompletionNotification" object:fileHandle];
        [fileHandle readInBackgroundAndNotify];
    }
    return self;
}


- (void)logChange:(NSNotification *)notification
{
    NSData *data = notification.userInfo[NSFileHandleNotificationDataItem];
    if (data.length) {
        NSString *string = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
        if (self.logBlock) {
            self.logBlock(string);
        }
        [notification.object readInBackgroundAndNotify];
    }
    else {
        [self performSelector:@selector(refreshLog:) withObject:notification afterDelay:1.0];
    }
}
- (void)refreshLog:(NSNotification *)notification {
    [notification.object readInBackgroundAndNotify];
}
@end
