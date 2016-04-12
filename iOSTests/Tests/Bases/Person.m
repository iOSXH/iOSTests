//
//  Person.m
//  iOSTests
//
//  Created by xianghui on 16/4/11.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Person
{
    NSString *nickName;
}

#pragma Mark 消息转发
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    // 实现此方法，在调用对象的某方法找不到时，会先调用此方法，允许
    // 我们动态添加方法实现
    if ([NSStringFromSelector(sel) isEqualToString:@"cry"]) {
        class_addMethod(self, sel, (IMP)cry, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}


// 这个方法是我们动态添加的哦
//
void cry(id self, SEL cmd) {
    NSLog(@"%@ cry",NSStringFromClass([self class]));
}

#pragma mark load initialize
//在这个文件被程序装载时调用   只要是在Compile Sources中出现的文件总是会被装载，这与这个类是否被用到无关，因此load方法总是在main函数之前调用。
+(void)load{
    
    NSLog(@"%@ load",NSStringFromClass([self class]));
    
    //交换方法
    Method eatMethod = class_getInstanceMethod([self class], @selector(eat));
    Method speakMethod = class_getInstanceMethod([self class], @selector(speak));
    method_exchangeImplementations(eatMethod, speakMethod);
}

//这个方法在第一次给某个类发送消息时调用（比如实例化一个对象），并且只会调用一次。initialize方法实际上是一种惰性调用，也就是说如果一个类一直没被用到，那它的initialize方法也不会被调用，这一点有利于节约资源。 
+ (void)initialize{
    NSLog(@"%@ initialize",NSStringFromClass([self class]));
}


/*
 
1、load和initialize方法都会在实例化对象之前调用，以main函数为分水岭，前者在main函数之前调用，后者在之后调用。这两个方法会被自动调用，不能手动调用它们。
2、load和initialize方法都不用显式的调用父类的方法而是自动调用，即使子类没有initialize方法也会调用父类的方法，而load方法则不会调用父类。
3、load方法通常用来进行Method Swizzle，initialize方法一般用于初始化全局变量或静态变量。
4、load和initialize方法内部使用了锁，因此它们是线程安全的。实现时要尽可能保持简单，避免阻塞线程，不要再使用锁。

 */


- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark 私有方法
-(void)eat{
    NSLog(@"%@ eat",NSStringFromClass([self class]));
}

- (void)speak{
    NSLog(@"%@ speak",NSStringFromClass([self class]));
}


#pragma mark 自动归档和解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        //获取所有成员变量
        Ivar  *ivars =  class_copyIvarList([self class], &count);
        
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            
            //获取成员变量名
            const void *name = ivar_getName(ivar);
            NSString *nameStr = [NSString stringWithUTF8String:name];
            
            //去掉成员变量名前的下划线
            nameStr = [nameStr substringFromIndex:1];
            
            //获取成员变量对应的geterr方法
            // 生成setter格式
            NSString *setterName = nameStr;
            // 那么一定是字母开头
            if (![setterName hasPrefix:@"_"]) {
                NSString *firstLetter = [NSString stringWithFormat:@"%c", [setterName characterAtIndex:0]];
                setterName = [setterName substringFromIndex:1];
                setterName = [NSString stringWithFormat:@"%@%@", firstLetter.uppercaseString, setterName];
            }
            setterName = [NSString stringWithFormat:@"set%@:", setterName];
            // 获取getter方法
            SEL setter = NSSelectorFromString(setterName);
            if ([self respondsToSelector:setter]) {
                const void *typeEncoding = ivar_getTypeEncoding(ivar);
                NSString *type = [NSString stringWithUTF8String:typeEncoding];
                NSLog(@"成员变量 %@ 的类型：%@", nameStr, type);
                
                if ([type isEqualToString:@"r^v"]) {// const void *
                    NSString *value = [aDecoder decodeObjectForKey:nameStr];
                    if (value) {
                        ((void (*)(id, SEL, const void*))objc_msgSend)(self,setter,value.UTF8String);
                    }
                }else if ([type isEqualToString:@"i"]){// int
                    NSNumber *value = [aDecoder decodeObjectForKey:nameStr];
                    if (value != nil) {
                        ((void (*)(id, SEL, int))objc_msgSend)(self, setter,[value intValue]);
                    }
                }else if ([type isEqualToString:@"f"]) {// float
                    NSNumber *value = [aDecoder decodeObjectForKey:nameStr];
                    if (value != nil) {
                        ((void (*)(id, SEL, float))objc_msgSend)(self, setter, [value floatValue]);
                    }
                }else{// object
                    id value = [aDecoder decodeObjectForKey:nameStr];
                    if (value != nil) {
                        ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
                    }
                }
            }
        }
        
        free(ivars);
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (unsigned int i = 0; i < outCount; ++i) {
        Ivar ivar = ivars[i];
        
        // 获取成员变量名
        const void *name = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:name];
        // 去掉成员变量的下划线
        ivarName = [ivarName substringFromIndex:1];
        
        // 获取getter方法
        SEL getter = NSSelectorFromString(ivarName);
        if ([self respondsToSelector:getter]) {
            const void *typeEncoding = ivar_getTypeEncoding(ivar);
            NSString *type = [NSString stringWithUTF8String:typeEncoding];
            
            // const void *
            if ([type isEqualToString:@"r^v"]) {
                const char *value = ((const void *(*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
                NSString *utf8Value = [NSString stringWithUTF8String:value];
                [aCoder encodeObject:utf8Value forKey:ivarName];
                continue;
            }
            // int
            else if ([type isEqualToString:@"i"]) {
                int value = ((int (*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
                continue;
            }
            // float
            else if ([type isEqualToString:@"f"]) {
                float value = ((float (*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
                continue;
            }
            
            id value = ((id (*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
            if (value != nil && [value respondsToSelector:@selector(encodeWithCoder:)]) {
                [aCoder encodeObject:value forKey:ivarName];
            }
        }
    }
    
    free(ivars);
}


/*
 Type Encoding
 编码值 	含意
 c 	代表char类型
 i 	代表int类型
 s 	代表short类型
 l 	代表long类型，在64位处理器上也是按照32位处理
 q 	代表long long类型
 C 	代表unsigned char类型
 I 	代表unsigned int类型
 S 	代表unsigned short类型
 L 	代表unsigned long类型
 Q 	代表unsigned long long类型
 f 	代表float类型
 d 	代表double类型
 B 	代表C++中的bool或者C99中的_Bool
 v 	代表void类型
 * 	代表char *类型
 @ 	代表对象类型
 # 	代表类对象 (Class)
 : 	代表方法selector (SEL)
 [array type] 	代表array
 {name=type…} 	代表结构体
 (name=type…) 	代表union
 bnum 	A bit field of num bits
 type 	A pointer to type
 ? 	An unknown type (among other things, this code is used for function pointers)
 */

@end
