//
//  AssetForURLTest.m
//  Database
//
//  Created by Jason Yang on 13-8-29.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "AssetForURLTest.h"
#import "ALAssetsLibrary+Utils.h"
#import "ALAssetsGroup+Utils.h"

@implementation AssetForURLTest

- (void)test
{
    NSURL *assetURL;
    @autoreleasepool {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSArray *groups = [library groups];
        for (ALAssetsGroup *group in groups) {
            NSArray *assets = [group assets];
            if (assets.count > 0) {
                ALAsset *asset = assets[0];
                assetURL = asset.defaultRepresentation.url;
                break;
            }
        }
    }
    
    @autoreleasepool {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSDate *start = [NSDate date];
        ALAsset *asset = [library assetForURL:assetURL];
        NSDate *stop = [NSDate date];
        NSLog(@"assetForURL cose %.4f seconds", [stop timeIntervalSinceDate:start]);
        if (asset) {
            UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
            CGSize size = image.size;
            NSLog(@"got image with size (%.2f,%.2f)", size.width, size.height);
        }
    }
}

@end
