//
//  RuntimeTest.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "RuntimeTest.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "Person.h"
#import "Student.h"
#import "Person+xh.h"

@implementation RuntimeTest{
    NSString *className;
}

+(void)load{
    
    NSLog(@"%@ load",NSStringFromClass([self class]));
    
    //交换方法
    Method method = class_getInstanceMethod([self class], @selector(test));
    Method method1 = class_getInstanceMethod([self class], @selector(newTest));
    method_exchangeImplementations(method, method1);
}

- (void)test{
    
    
    Person *person = [[Person alloc] init];
    [person eat];
    [person speak];
    
}

-(void)newTest{
    className = @"Person";
    
    
    [self testIvar];
    
    [self testProperty];
    
    [self testMethod];
    
    [self testMsgSend];
    
    [self testCoding];
    
    [self testMsgForwarding];
}


/**
 *  @author xh, 16-04-11 10:04:58
 *
 *  获取成员变量（私有变量）
 */
-(void)testIvar{
    
    unsigned int count;
    //获取成员变量结构体
    Ivar *ivars = class_copyIvarList(NSClassFromString(className), &count);
    
    for (int i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        //获取名称
        const char *name = ivar_getName(ivar);
        //字符串转换
        NSString *nameStr = [NSString stringWithUTF8String:name];
        NSLog(@"%@的成员变量:%@ == %d",NSStringFromClass(NSClassFromString(className)),nameStr,i);
    }
    free(ivars);
}

/**
 *  @author xh, 16-04-11 11:04:27
 *
 *  获取类属性
 */
-(void)testProperty{
    
    unsigned int count;
    
    //获取类所有属性的指针
    objc_property_t *properties = class_copyPropertyList(NSClassFromString(className), &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        
        const char *name = property_getName(property);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        
        NSLog(@"%@的属性:%@ == %d",NSStringFromClass(NSClassFromString(className)),nameStr,i);
    }
    free(properties);
}


/**
 *  @author xh, 16-04-11 11:04:45
 *
 *  获取类的方法
 */
- (void)testMethod{
    
    unsigned int count;
    
    //获取类所有方法的指针
    Method *methods = class_copyMethodList(NSClassFromString(className), &count);
    
    for (int i = 0; i < count; i ++) {
        Method method = methods[i];
        
        SEL methodSEL = method_getName(method);
        
        const char *name = sel_getName(methodSEL);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        
        NSLog(@"%@的方法:%@ == %d",NSStringFromClass(NSClassFromString(className)),nameStr,i);
    }

}


/**
 *  @author xh, 16-04-11 13:04:37
 *
 *  发送消息
 */
- (void)testMsgSend{
    // 1.创建对象
    RuntimeTest *msg =((RuntimeTest* (*)(id, SEL))objc_msgSend)([RuntimeTest class], @selector(alloc));
    
    // 2.初始化对象
    msg = ((RuntimeTest *(*)(id, SEL))objc_msgSend)(msg,@selector(init));
    
    // 3.调用方法
    NSString *str = ((NSString *(*)(id, SEL, NSInteger))objc_msgSend)(msg,@selector(printNum:),1);
    NSLog(@"返回参数：%@",str);
    
    // 4.动态添加方法
    class_addMethod(msg.class, NSSelectorFromString(@"cStyleFunc"), (IMP)cStyleFunc, "i@:r^vr^v");
    int c = ((int (*)(id , SEL, const void*, const void*))objc_msgSend)(msg,NSSelectorFromString(@"cStyleFunc"),"参数1","参数2");
    NSLog(@"调用新增方法返回参数：%d",c);
}

-(NSString *)printNum:(NSInteger)num{
    NSString *str = [NSString stringWithFormat:@"%@",@(num)];
    NSLog(@"%@",str);
    return str;
}

// C函数
int cStyleFunc(id receiver, SEL sel, const void *arg1, const void *arg2) {
    NSLog(@"%s was called, arg1 is %@, and arg2 is %@",
          __FUNCTION__,
          [NSString stringWithUTF8String:arg1],
          [NSString stringWithUTF8String:arg1]);
    return 2;
}

/**
 *  @author xh, 16-04-11 15:04:24
 *
 *  runtime归档解档
 */
-(void)testCoding{
    Person  *person = [[Person alloc] init];
    person.name = @"xh";
    person.age = 25;
    person.address = @"shanghai";
    person.phoneNum = 185;
//    person.heiht = 178; 分类扩展属性 无法归档
    
    NSString *path = NSHomeDirectory();
    path = [NSString stringWithFormat:@"%@/person", path];
    [NSKeyedArchiver archiveRootObject:person
                                toFile:path];
    
    Person *unarchivePerson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"解档后person：%@",unarchivePerson);
}


- (void)testMsgForwarding{
    
    Person  *person = [[Person alloc] init];
    [person cry];
    
    [self performSelector:@selector(cry)];
}

// 第一步：在没有找到方法时，会先调用此方法，可用于动态添加方法
// 我们不动态添加
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return NO;
}

// 第二步：上一步返回NO，就会进入这一步，用于指定备选响应此SEL的对象
// 千万不能返回self，否则就会死循环
// 自己没有实现这个方法才会进入这一流程，因此成为死循环
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

// 第三步：指定方法签名，若返回nil，则不会进入下一步，而是无法处理消息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"cry"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

// 当我们实现了此方法后，-doesNotRecognizeSelector:不会再被调用
// 如果要测试找不到方法，可以注释掉这一个方法
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    // 我们还可以改变方法选择器
    [anInvocation setSelector:@selector(forwardMethod)];
    // 改变方法选择器后，还需要指定是哪个对象的方法
    [anInvocation invokeWithTarget:self];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"无法处理消息：%@", NSStringFromSelector(aSelector));
}

- (void)forwardMethod {
    NSLog(@"由cry方法改成forwardMethod方法");
}



@end
