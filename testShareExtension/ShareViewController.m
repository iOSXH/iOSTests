//
//  ShareViewController.m
//  testShareExtension
//
//  Created by xianghui on 16/4/14.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "ShareViewController.h"
#import "MMWormhole.h"

@interface ShareViewController ()


@property (nonatomic, strong) MMWormhole *wormhole;

@end

@implementation ShareViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
//    NSArray *items = self.extensionContext.inputItems;
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
//    btn.backgroundColor = [UIColor redColor];
//    [btn addTarget:self action:@selector(didSelectPost) forControlEvents:UIControlEventTouchUpInside];
//    btn.center = self.view.center;
//    [self.view addSubview:btn];
    
    self.placeholder = @"testshare";
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.xh.test"
                                                         optionalDirectory:@"test"];
    
    [self.wormhole listenForMessageWithIdentifier:@"testshare" listener:^(id messageObject) {
        // The number is identified with the buttonNumber key in the message object
        
    }];
    
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    
//    NSArray *items = self.extensionContext.inputItems;
    
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    
   
    NSArray *items = self.extensionContext.inputItems;
    NSLog(@"text:===%@ \n %@",self.contentText,items);
    
    [self.wormhole passMessageObject:@{@"index" : @(1)} identifier:@"sharetest"];
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
