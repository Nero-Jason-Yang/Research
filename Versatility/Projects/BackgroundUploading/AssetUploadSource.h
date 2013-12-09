//
//  AssetUploadSource.h
//  Research
//
//  Created by Jason Yang on 13-12-4.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetUploadSource : NSObject

- (id)initWithAsset:(ALAsset *)asset library:(ALAssetsLibrary *)library;
@property (nonatomic,readonly) ALAsset *asset;
@property (nonatomic,readonly) NSString *fileName;
@property (nonatomic,readonly) NSURL *localFileURL;
@property (nonatomic) NSProgress *progress;
@property (nonatomic) BOOL completed;
@property (nonatomic) NSError *error;
- (void)saveToLocalFilesystem;

@end
