//
//  UploadByRange.m
//  Research
//
//  Created by Jason Yang on 13-12-7.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "UploadByRange.h"
#import "ProjectManager.h"
#import "PogoplugAPI.h"
#import "ALAssetsLibrary+Utils.h"
#import "ALAsset+Utils.h"
#import "NSURL+Utils.h"

@interface UploadByRange ()
{
    PogoplugAPI *_api;
    ALAssetsLibrary *_library;
}
@end

@implementation UploadByRange

+ (void)load
{
    [ProjectManager registerProject:@"Upload by Range" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self test];
        });
    }
    return self;
}

- (void)test
{
    _api = [[PogoplugAPI alloc] init];

    NSError *e;
    if (![_api loginWithUsername:@"ja2yang@nero.com" password:@"123456" error:&e]) {
        NSLog(@"login failed, error: %@", e);
        return;
    }
    NSLog(@"OK. login success");
    
    _library = [[ALAssetsLibrary alloc] init];
    __block ALAsset *asset;
    for (ALAssetsGroup *group in _library.groups) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                asset = result;
                *stop = YES;
            }
        }];
    }
    if (!asset) {
        NBLog(@"can not find a asset");
        return;
    }
    NSString *fileName = asset.defaultRepresentation.filename;
    NSLog(@"OK. find asset file: %@", fileName);
    
    NSURL *url = [NSURL applicationDocumentsDirectory];
    NSURL *fileURL = [url URLByAppendingPathComponent:@"temp.data"];
    if (![asset saveToURL:fileURL]) {
        NBLog(@"failed to save temp file for asset: %@", fileName);
        return;
    }
    NBLog(@"OK. save temp file for asset: %@", fileName);
    
    NSString *fileID = [_api createFileWithParentID:nil fileName:fileName error:&e];
    if (!fileID) {
        NBLog(@"cloud failed to create file: %@", fileName);
        return;
    }
    NBLog(@"OK. cloud create file: %@ with fileid: %@", fileName, fileID);
    
    if (![_api uploadFileWithFileID:fileID fromContentOfFile:fileURL sectionSize:20*1024 error:&e]) {
        NBLog(@"failed to upload file: %@", fileName);
    }
    NBLog(@"OK. upload file: %@", fileName);
}

@end
