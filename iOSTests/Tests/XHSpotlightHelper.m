//
//  XHSpotlightHelper.m
//  iOSTests
//
//  Created by xianghui on 16/4/14.
//  Copyright © 2016年 xh. All rights reserved.
//

#import "XHSpotlightHelper.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>


@implementation XHSpotlightMedol



@end

@implementation XHSpotlightHelper

+ (id)sharedLogHelper {
    static id _sharedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[XHSpotlightHelper alloc]init];
    });
    return _sharedHelper;
}


- (void)saveDataWithUniqueIdentifier:(NSString *)identifier domainIdentifier:(NSString *)domainIdentifier title:(NSString *)title description:(NSString *)desc thumbImage:(UIImage *)image{
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //创建SearchableItems的数组
        NSMutableArray *searchableItems = [[NSMutableArray alloc] init];
        
        //1.创建条目的属性集合
        CSSearchableItemAttributeSet * attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString*)kUTTypeImage];
        
        //2.给属性集合添加属性
        attributeSet.title = title;
        attributeSet.contentDescription = desc;
        attributeSet.thumbnailData = UIImagePNGRepresentation(image);
        
        //3.属性集合与条目进行关联
        CSSearchableItem *searchableItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:identifier domainIdentifier:domainIdentifier attributeSet:attributeSet];
        
        //把该条目进行暂存
        [searchableItems addObject:searchableItem];
        
        //4.把条目数组与索引进行关联
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItems completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"save spotilight error %s, %@", __FUNCTION__, [error localizedDescription]);
            }
        }];
    });
}


- (void)deleteDataWithUniqueIdentifier:(NSArray<NSString *> *)identifiers{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:identifiers completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"del spotilight error %s, %@", __FUNCTION__, [error localizedDescription]);
        }
    }];
}

- (void)deleteDataWithDomainIdentifiers:(NSArray<NSString *> *)domainIdentifiers{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:domainIdentifiers completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"del domain spotilight error %s, %@", __FUNCTION__, [error localizedDescription]);
        }
    }];
}

- (void)deleteAllData{
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"del all spotilight error %s, %@", __FUNCTION__, [error localizedDescription]);
        }
    }];
}


- (void)userActivityWithIdentifier:(NSString *)identifier{
    if (self.block) {
        self.block(identifier);
    }
}

@end
