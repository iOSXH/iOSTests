//
//  ShareTestViewController.m
//  iOSTests
//
//  Created by xianghui on 16/4/14.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "ShareTestViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MMWormhole.h"

@interface ShareTestViewController ()


@property (nonatomic, strong) MMWormhole *wormhole;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ShareTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.com.xh.test"
                                                         optionalDirectory:@"test"];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 200, 100)];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.textView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 250, 200, 200)];
    self.imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.imageView];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 10, 80, 50)];
    btn.backgroundColor = [UIColor redColor];
    btn.tag = 1;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 80, 50)];
    btn1.backgroundColor = [UIColor redColor];
    btn1.tag = 2;
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self dealWithContext];
    });
}




- (void)btnDidClicked:(UIButton*)sender{
    if (sender.tag == 1) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if (self.imageView.image) {
            [data setObject:self.imageView.image forKey:@"image"];
        }
        if (self.textView.text.length>0) {
            [data setObject:self.textView.text forKey:@"text"];
        }
        
        [self.wormhole passMessageObject:data identifier:@"sharetest"];
        
    }else{
        
    }
    
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}


- (void)dealWithContext{
    NSExtensionItem *imageItem = [self.extensionContext.inputItems firstObject];
    
    if(!imageItem){
        
        return;
        
    }
    
    NSItemProvider *itemProvider = [[imageItem attachments] firstObject];
    
    if(!itemProvider){
        
        return;
        
    }
    
    NSLog(@"itemProvider types:====%@",itemProvider.registeredTypeIdentifiers);
    
    for (NSString *type in itemProvider.registeredTypeIdentifiers) {
        if ([type isEqualToString:(NSString *)kUTTypeImage] || [type isEqualToString:(NSString *)kUTTypeJPEG]) {
            [itemProvider loadItemForTypeIdentifier:type options:nil completionHandler:^(UIImage *image, NSError *error) {
                
                if(image){
                    //处理图片
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageView.image = image;
                    });
                    
                }
                
            }];
        }else if ([type isEqualToString:(NSString *)kUTTypeText]){
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeText options:nil completionHandler:^(NSAttributedString *string, NSError *error) {
                
                if (string) {
                    
                    // 在这里处理文本
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textView.attributedText = string;
                    });
                }
                
            }];
        }else if ([type isEqualToString:(NSString *)kUTTypeURL]){
            [itemProvider loadItemForTypeIdentifier:type options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                if (item) {
                    
                    // 在这里处理url
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.textView.text = ((NSURL *)item).absoluteString;
                    });
                }
                
            }];
        }else{
            NSLog(@"未解析类型：%@",type);
            [itemProvider loadItemForTypeIdentifier:type options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                if (item) {
                    
                    // 在这里处理url
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"未解析数据：%@",item);
                    });
                }
                
            }];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
