//
//  ViewController.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "ViewController.h"
#import "TestCommon.h"
#import "XHLogHelper.h"
#import "MMWormhole.h"
#import "MMWormholeSession.h"

@interface ViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (nonatomic, strong) MMWormhole *traditionalWormhole;

@property (nonatomic, strong) MMWormhole *watchConnectivityWormhole;
@property (nonatomic, strong) MMWormholeSession *watchConnectivityListeningWormhole;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"test";
    [[XHLogHelper sharedLogHelper] setLogBlock:^(NSString *logText){
        self.textView.text = [self.textView.text stringByAppendingString:logText];
        
        
        CGPoint off = self.textView.contentOffset;
        off.y = self.textView.contentSize.height - self.textView.bounds.size.height + self.textView.contentInset.bottom;
        [self.textView setContentOffset:off animated:NO];
    }];
    
    [self initWormhole];
}

- (void)initWormhole{
    // Initialize the wormhole
    self.traditionalWormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.xh.test"
                                                                    optionalDirectory:@"test"];
//    [self.traditionalWormhole clearMessageContentsForIdentifier:@"test"];
    
    // Initialize the MMWormholeSession listening wormhole.
    // You are required to do this before creating a Wormhole with the Session Transiting Type, as we are below.
    self.watchConnectivityListeningWormhole = [MMWormholeSession sharedListeningSession];
    
    // Initialize the wormhole using the WatchConnectivity framework's application context transiting type
    self.watchConnectivityWormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.xh.test"
                                                                          optionalDirectory:@"test"
                                                                             transitingType:MMWormholeTransitingTypeSessionContext];
    
    id message = [self.traditionalWormhole messageWithIdentifier:@"todaytest"];
    if (message) {
        NSInteger index = [message[@"index"] integerValue];
        [self testIndex:index];
    }
    
    // Become a listener for changes to the wormhole for the button message
    [self.traditionalWormhole listenForMessageWithIdentifier:@"todaytest" listener:^(id messageObject) {
        // The number is identified with the buttonNumber key in the message object
        
        NSInteger index = [messageObject[@"index"] integerValue];
        [self testIndex:index];
    }];
    
    // Become a listener for changes to the wormhole for the button message
    [self.watchConnectivityListeningWormhole listenForMessageWithIdentifier:@"test1" listener:^(id messageObject) {
        // The number is identified with the buttonNumber key in the message object
        NSLog(@"Wormhole === %@",messageObject);
    }];
    
    // Make sure we are activating the listening wormhole so that it will receive new messages from
    // the WatchConnectivity framework.
    [self.watchConnectivityListeningWormhole activateSessionListening];
}



- (IBAction)rightBarDidClicked:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"test" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"RunTime",@"GCD",@"KVO",@"Block",@"RunLoop", nil];
    [sheet showInView:self.view];

}

- (IBAction)leftBarDidClicked:(id)sender {
    self.textView.text = @"";
    
    
    [self.traditionalWormhole passMessageObject:@{@"index" : @(0)} identifier:@"test"];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        
        return;
    }
    
    [self testIndex:buttonIndex];
}

- (void)testIndex:(NSInteger)index{
    NSArray *titles = @[@"RunTime",@"GCD",@"KVO",@"Block",@"RunLoop"];
    self.title = [titles objectAtIndex:index];
    
    NSLog(@"\n\n\n=====%@=====\n\n\n",self.title);
    
    [self.traditionalWormhole passMessageObject:@{@"index" : @(index)} identifier:@"test"];
    
    switch (index) {
        case 0:
        {
            [[[RuntimeTest alloc] init] test];
        }
            break;
        case 1:
        {
            [[GCDTest shareTest] test];
        }
            break;
        case 2:
        {
            [[[KVOTest alloc] init] test];
        }
            break;
        case 3:
        {
            [[[BlockTest alloc] init] test];
        }
            break;
        case 4:
        {
            [[[RunLoopTest alloc] init] test];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
