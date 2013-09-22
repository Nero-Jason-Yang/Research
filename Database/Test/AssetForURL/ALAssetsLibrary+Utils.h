//
//  ALAssetsLibrary+Utils.h
//  Database
//
//  Created by Jason Yang on 13-8-29.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (Utils)

- (NSArray *)groups;
- (ALAsset *)assetForURL:(NSURL *)assetURL;

@end
