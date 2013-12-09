//
//  AssetsLibrary.m
//  Research
//
//  Created by Jason Yang on 13-12-6.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "AssetsLibrary.h"
#import "ProjectManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+Utils.h"
#import "ALAsset+Properties.h"

@interface AssetsLibrary ()
{
    ALAssetsLibrary *_library;
}
@end

@implementation AssetsLibrary

+ (void)load
{
    [ProjectManager registerProject:@"Assets Library" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        _library = [[ALAssetsLibrary alloc] init];
        //[ALAssetsLibrary disableSharedPhotoStreamsSupport];
        NBLog(@"init assets library: %@", _library);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryChanged:) name:ALAssetsLibraryChangedNotification object:nil];
        [self indexAllAssets];
    }
    return self;
}

- (void)indexAllAssets
{
    NSArray *groups = [_library groups];
    for (ALAssetsGroup *group in groups) {
        
    }
}

- (void)assetsLibraryChanged:(NSNotification *)notification
{
    NSParameterAssert([notification isKindOfClass:NSNotification.class]);
    NSParameterAssert([notification.name isEqualToString:ALAssetsLibraryChangedNotification]);
    ALAssetsLibrary *library = notification.object;
    NSParameterAssert([library isKindOfClass:ALAssetsLibrary.class]);
    NBLog(@"assetsLibraryChanged start for library: %@", library);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        if (userInfo.count > 0) {
            //NBLog(@"assetsLibraryChanged userInfo: %@", userInfo);
            NSArray *array;
            
            array = userInfo[ALAssetLibraryInsertedAssetGroupsKey];
            for (NSURL *url in array) {
                dispatch_async(queue, ^{
                    [library groupForURL:url resultBlock:^(ALAssetsGroup *group) {
                        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                        NSInteger total = group.numberOfAssets;
                        NBLog(@"find inserted group with name: %@, total: %d", name, total);
                        if (total > 0) {
                            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:total - 1] options:0 usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                if (asset) {
                                    NBLog(@"inside group with name: %@, last asset name: %@", name, asset.defaultRepresentation.filename);
                                }
                            }];
                        }
                    } failureBlock:^(NSError *error) {
                        NBLog(@"failed to find inserted group: %@, error: %@", url, error);
                    }];
                });
            }
            
            array = userInfo[ALAssetLibraryUpdatedAssetGroupsKey];
            for (NSURL *url in array) {
                dispatch_async(queue, ^{
                    [library groupForURL:url resultBlock:^(ALAssetsGroup *group) {
                        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                        NSInteger total = group.numberOfAssets;
                        NBLog(@"find updated group with name: %@, total: %d", name, total);
                        if (total > 0) {
                            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:total - 1] options:0 usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                if (asset) {
                                    NBLog(@"inside group with name: %@, last asset name: %@", name, asset.defaultRepresentation.filename);
                                }
                            }];
                        }
                    } failureBlock:^(NSError *error) {
                        NBLog(@"failed to find updated group: %@, error: %@", url, error);
                    }];
                });
            }
            
            array = userInfo[ALAssetLibraryDeletedAssetGroupsKey];
            for (NSURL *url in array) {
                dispatch_async(queue, ^{
                    [library groupForURL:url resultBlock:^(ALAssetsGroup *group) {
                        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
                        NSInteger total = group.numberOfAssets;
                        NBLog(@"find deleted group with name: %@, total: %d", name, total);
                        if (total > 0) {
                            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:total - 1] options:0 usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                if (asset) {
                                    NBLog(@"inside group with name: %@, last asset name: %@", name, asset.defaultRepresentation.filename);
                                }
                            }];
                        }
                    } failureBlock:^(NSError *error) {
                        NBLog(@"failed to find deleted group: %@, error: %@", url, error);
                    }];
                });
            }
            
            array = [userInfo objectForKey:ALAssetLibraryUpdatedAssetsKey];
            for (NSURL *url in array) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [library assetForURL:url resultBlock:^(ALAsset *asset) {
                        ALAssetRepresentation *rep = asset.defaultRepresentation;
                        NSLog(@"find updated asset with name: %@, size: %lld, date: %.2f", rep.filename, rep.size, asset.creationDate.timeIntervalSinceNow);
                    } failureBlock:^(NSError *error) {
                        NBLog(@"failed to find updated asset: %@, error: %@", url, error);
                    }];
                });
            }
        }
        else {
            NBLog(@"assetsLibraryChanged userInfo is empty");
        }
    }
    else {
        NBLog(@"assetsLibraryChanged userInfo is nil");
    }
    
    NBLog(@"assetsLibraryChanged end - for library: %@", library);
}

@end
