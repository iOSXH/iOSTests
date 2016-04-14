//
//  XHSpotlightHelper.h
//  iOSTests
//
//  Created by xianghui on 16/4/14.
//  Copyright © 2016年 xh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XHSpotlightBlock)(NSString *identifier);

@interface XHSpotlightMedol : NSObject



@end


@interface XHSpotlightHelper : NSObject

@property (nonatomic, copy) XHSpotlightBlock block;

+ (id)sharedLogHelper;


- (void)saveDataWithUniqueIdentifier:(NSString *)identifier domainIdentifier:(NSString *)domainIdentifier title:(NSString *)title description:(NSString *)desc thumbImage:(UIImage*)image;

- (void)deleteDataWithUniqueIdentifier:(NSArray<NSString *> *)identifiers;


- (void)deleteDataWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers;


- (void)deleteAllData;


- (void)userActivityWithIdentifier:(NSString *)identifier;

@end
