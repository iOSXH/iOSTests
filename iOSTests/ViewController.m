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

@interface ViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[XHLogHelper sharedLogHelper] setLogBlock:^(NSString *logText){
        self.textView.text = [self.textView.text stringByAppendingString:logText];
        
        
        CGPoint off = self.textView.contentOffset;
        off.y = self.textView.contentSize.height - self.textView.bounds.size.height + self.textView.contentInset.bottom;
        [self.textView setContentOffset:off animated:NO];
    }];
}




- (IBAction)rightBarDidClicked:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"test" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"RunTime",@"GCD",@"KVO",@"Block",@"RunLoop", nil];
    [sheet showInView:self.view];

}

- (IBAction)leftBarDidClicked:(id)sender {
    self.textView.text = @"";
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"\n\n\n=====%@=====\n\n\n",[actionSheet buttonTitleAtIndex:buttonIndex]);
    
    switch (buttonIndex) {
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
