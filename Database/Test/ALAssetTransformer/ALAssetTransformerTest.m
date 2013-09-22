//
//  ALAssetTransformerTest.m
//  Database
//
//  Created by Jason Yang on 13-9-6.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "ALAssetTransformerTest.h"
#import "Database.h"
#import "ALAssetTransformerItem.h"
#import "ALAssetsLibrary+Utils.h"

@implementation ALAssetTransformerTest

- (void)test
{
    NSString *modelName = @"ALAssetTransformer";
    Database *db = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSArray *groups = library.groups;
    __block ALAsset *asset;
    for (ALAssetsGroup *group in groups) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                asset = result;
                *stop = YES;
            }
        }];
        if (asset) {
            break;
        }
    }
    
    @autoreleasepool {
        ALAssetTransformerItem *item = (ALAssetTransformerItem *)[db createObjectWithEntityName:@"Item"];
        item.asset = asset;
        [db saveContext];
    }
    @autoreleasepool {
        NSArray *items = [db fetchObjectsForEntity:@"Item"];
        ALAssetTransformerItem *item = items[0];
        ALAsset *asset = item.asset;
        NSString *url = asset.defaultRepresentation.url.absoluteString;
    }
}

@end
