//
//  BlockTest.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "BlockTest.h"

typedef NSInteger(^XHBlock1)(NSInteger a, NSInteger b);
typedef void(^XHBlock2)(NSInteger a);


@interface BlockTest ()

@property (nonatomic, assign) NSInteger testA;

@end

@implementation BlockTest{
    XHBlock1 block1;
    XHBlock2 block2;
    

}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)test{
    [self testBlock];
}

- (void)testBlock{
    block1 = ^(NSInteger a, NSInteger b){
        return a+b;
    };
    NSLog(@"block1 === %@",@(block1(1,2)));
    
    __weak BlockTest *weakSelf = self;
    __block NSInteger testB = 100;//__block 修饰 在Block中可被修改
    block2 = ^(NSInteger a){
        
        NSLog(@"block2 === %@",@(a));
        // 直接调用私有变量 如果是对象时 没有用self 是隐式调用 也会引起循环引用 修改为weakSelf->？
        if (a == 5) {
            weakSelf.testA = 10;
            [weakSelf changTest];//弱引用  避免循环引用
//            [self changTest];//这样调用对self强引用 引起循环引用 self无法释放 dealloc方法不调用
        }
        
        if (weakSelf.testA == 11) {
            testB = 101;
            NSLog(@"TestB == %@",@(testB));
        }
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changTest];
    });
}

- (void)changTest{
    self.testA ++;
    
    if (block2) {
        block2(self.testA);
    }
    
    if (self.testA<5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changTest];
        });
    }
}

@end
