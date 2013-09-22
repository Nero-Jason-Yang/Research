//
//  ALAssetsLibrary+Utils.m
//  Database
//
//  Created by Jason Yang on 13-8-29.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "ALAssetsLibrary+Utils.h"

@implementation ALAssetsLibrary (Utils)

- (NSArray *)groups
{
    NSMutableArray *groups = [NSMutableArray array];
    NSCondition *condition = [[NSCondition alloc] init];
    
    ALAssetsGroupType types = ALAssetsGroupSavedPhotos|ALAssetsGroupLibrary;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self enumerateGroupsWithTypes:types usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [groups addObject:group];
            }
            else {
                [condition signal];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"File:%s Line:%d error:%@", __FILE__, __LINE__, error);
            [condition signal];
        }];
    });
    
    [condition lock];
    [condition wait];
    [condition unlock];
    return groups;
}

- (ALAsset *)assetForURL:(NSURL *)assetURL
{
    __block ALAsset *asset;
    NSCondition *condition = [[NSCondition alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self assetForURL:assetURL resultBlock:^(ALAsset *result) {
            asset = result;
            [condition signal];
        } failureBlock:^(NSError *error) {
            NSLog(@"%@", error);
            [condition signal];
        }];
    });
    
    [condition lock];
    [condition wait];
    [condition unlock];
    return asset;
}

@end
