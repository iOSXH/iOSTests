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

/**
 *  @author xh, 16-04-14 18:04:30
 *
 *  单例
 *
 *  @return self
 */
+ (id)sharedLogHelper;


/**
 *  @author xh, 16-04-14 18:04:47
 *
 *  保存Spotlight数据
 *
 *  @param identifier       标识
 *  @param domainIdentifier domain标识
 *  @param title            标题
 *  @param desc             描述
 *  @param image            图片
 */
- (void)saveDataWithUniqueIdentifier:(NSString *)identifier domainIdentifier:(NSString *)domainIdentifier title:(NSString *)title description:(NSString *)desc thumbImage:(UIImage*)image;

/**
 *  @author xh, 16-04-14 18:04:24
 *
 *  根据标识删除
 *
 *  @param identifiers 标识
 */
- (void)deleteDataWithUniqueIdentifier:(NSArray<NSString *> *)identifiers;

/**
 *  @author xh, 16-04-14 18:04:41
 *
 *  根据Domain标识删除
 *
 *  @param domainIdentifiers Domain标识
 */
- (void)deleteDataWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers;

/**
 *  @author xh, 16-04-14 18:04:12
 *
 *  删除所有Spotlight数据
 */
- (void)deleteAllData;

/**
 *  @author xh, 16-04-14 18:04:26
 *
 *  用户Spotlight搜索后点击进入app
 *
 *  @param identifier 点击的标识
 */
- (void)userActivityWithIdentifier:(NSString *)identifier;

@end
