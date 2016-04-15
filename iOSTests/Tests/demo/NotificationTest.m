//
//  NotificationTest.m
//  iOSTests
//
//  Created by xianghui on 16/4/15.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "NotificationTest.h"
#import "XHNotificationHelper.h"



@implementation NotificationTest{
    NSArray *identifiers;
}

- (void)test{
    identifiers = @[@"test1",@"test2",@"test3",@"test4",@"test5"];
    
    [self registerLocalNotification];
    [self sendLocalNotification];
    
    [[XHNotificationHelper sharedLogHelper] setLocalNotificationBlock:^(NSString *identifier,UILocalNotification *notification,NSDictionary *responseInfo){
        NSLog(@"用户对本地通知进行操作：\n identifier:%@,\n notification:%@,\n responseInfo:%@",identifier,notification,responseInfo);
    }];
}


- (void)sendLocalNotification{
    for (NSInteger i = 0; i < identifiers.count; i++) {
        if (i != 3) {
            continue;
        }
        
        NSString *identifier = [identifiers objectAtIndex:i];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        //触发通知时间
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        //重复间隔
        //    localNotification.repeatInterval = kCFCalendarUnitMinute;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        //通知内容
        localNotification.alertBody = [NSString stringWithFormat:@"i am a local notification ==== %@",identifier];
        localNotification.applicationIconBadgeNumber = 1;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        //通知参数
        localNotification.userInfo = @{@"kLocalNotificationInfoKey": [NSString stringWithFormat:@"i am a local notification userinfo ==== %@",identifier]};
        
        localNotification.category = identifier;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
}


- (void)registerLocalNotification
{
    
    for (NSInteger i = 0; i < identifiers.count; i++) {
        if (i != 3) {
            continue;
        }
        
        NSString *identifier = [identifiers objectAtIndex:i];
        
        //创建消息上面要添加的动作
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = [NSString stringWithFormat:@"action test %@",@(i+1)];
        action1.title = [NSString stringWithFormat:@"action test %@",@(i+1)];
        //当点击的时候不启动程序，在后台处理
        action1.activationMode = i==0?UIUserNotificationActivationModeForeground:UIUserNotificationActivationModeBackground;
        //需要解锁才能处理(意思就是如果在锁屏界面收到通知，并且用户设置了屏幕锁，用户点击了赞不会直接进入我们的回调进行处理，而是需要用户输入屏幕锁密码之后才进入我们的回调)，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action1.authenticationRequired = YES;
        /*
         destructive属性设置后，在通知栏或锁屏界面左划，按钮颜色会变为红色
         如果两个按钮均设置为YES，则均为红色（略难看）
         如果两个按钮均设置为NO，即默认值，则第一个为蓝色，第二个为浅灰色
         如果一个YES一个NO，则都显示对应的颜色，即红蓝双色 (CP色)。
         */
        action1.destructive = NO;
        
        //第二个动作
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = [NSString stringWithFormat:@"action1 test %@",@(i+1)];
        action2.title = [NSString stringWithFormat:@"action1 test %@",@(i+1)];;
        //当点击的时候不启动程序，在后台处理
        action2.activationMode = i==1?UIUserNotificationActivationModeForeground:UIUserNotificationActivationModeBackground;
        //设置了behavior属性为 UIUserNotificationActionBehaviorTextInput 的话，则用户点击了该按钮会出现输入框供用户输入
        action2.behavior = i == 1 ? UIUserNotificationActionBehaviorDefault:UIUserNotificationActionBehaviorTextInput;
        //这个字典定义了当用户点击了评论按钮后，输入框右侧的按钮名称，如果不设置该字典，则右侧按钮名称默认为 “发送”
        if (i >1) {
            action2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey: @"test"};
        }
        
        //创建动作(按钮)的类别集合
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        //这组动作的唯一标示
        category.identifier = identifier;
        //最多支持两个，如果添加更多的话，后面的将被忽略
        [category setActions:i == 0?@[action1]:(i ==2?@[action2]:@[action1, action2]) forContext:(UIUserNotificationActionContextMinimal)];
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObject:category]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
}



@end
