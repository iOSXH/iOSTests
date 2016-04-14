//
//  TodayViewController.m
//  testTodayExtension
//
//  Created by xianghui on 16/4/14.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "MMWormhole.h"

@interface TodayViewController () <NCWidgetProviding>


@property (nonatomic, strong) MMWormhole *wormhole;



@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *RunTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *GCDBtn;
@property (weak, nonatomic) IBOutlet UIButton *KVOBtn;
@property (weak, nonatomic) IBOutlet UIButton *BlockBtn;
@property (weak, nonatomic) IBOutlet UIButton *RunLoopBtn;

@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.preferredContentSize = CGSizeMake(0, 80.0f);
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.xh.test"
                                                         optionalDirectory:@"test"];
    
    
    id message = [self.wormhole messageWithIdentifier:@"testtoday"];
    if (message) {
        NSLog(@"test====%@",message);
        [self dealwithMessage:message];
    }
    
    [self.wormhole listenForMessageWithIdentifier:@"test" listener:^(id messageObject) {
        // The number is identified with the buttonNumber key in the message object
        [self dealwithMessage:messageObject];
    }];
}


- (void)dealwithMessage:(id)messageObject{
    NSInteger index = [messageObject[@"index"] integerValue];
    
    UIButton *btn = [self.view viewWithTag:10+index];
    btn.selected = YES;
    if (self.selectedBtn && self.selectedBtn!= btn) {
        self.selectedBtn.selected = NO;
    }
    self.selectedBtn = btn;
    self.titleLab.text =  [btn titleForState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.preferredContentSize = CGSizeMake(0, 80.0f);
}



- (IBAction)btnDidClicked:(id)sender {
    UIButton *btn = sender;
    btn.selected = YES;
    if (self.selectedBtn && self.selectedBtn!= btn) {
        self.selectedBtn.selected = NO;
    }
    self.selectedBtn = btn;
    self.titleLab.text =  [btn titleForState:UIControlStateNormal];
    
    [self.wormhole passMessageObject:@{@"index" : @(btn.tag-10)} identifier:@"todaytest"];
    
}


- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
