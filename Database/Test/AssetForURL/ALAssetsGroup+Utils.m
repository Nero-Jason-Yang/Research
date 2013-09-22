//
//  ALAssetsGroup+Utils.m
//  Database
//
//  Created by Jason Yang on 13-8-29.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "ALAssetsGroup+Utils.h"

@implementation ALAssetsGroup (Utils)

- (NSArray *)assets
{
    NSMutableArray *assets = [NSMutableArray array];
    [self enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [assets addObject:result];
        }
    }];
    return assets;
}

@end
