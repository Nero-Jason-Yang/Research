//
//  AssetUploadSource.m
//  Research
//
//  Created by Jason Yang on 13-12-4.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "AssetUploadSource.h"
#import "ALAsset+Utils.h"
#import "NSURL+Utils.h"

@interface AssetUploadSource ()
@property (nonatomic) ALAssetsLibrary *library;
@end

@implementation AssetUploadSource

- (id)initWithAsset:(ALAsset *)asset library:(ALAssetsLibrary *)library
{
    if (self = [super init]) {
        _asset = asset;
        _library = library;
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        _fileName = rep.filename;
    }
    return self;
}

- (void)saveToLocalFilesystem
{
    if (self.localFileURL) {
        return;
    }
    
    NSURL *url = [NSURL applicationDocumentsDirectory];
    url = [url URLByAppendingPathComponent:self.fileName];
    if ([self.asset saveToURL:url]) {
        _localFileURL = url;
    }
}

@end
