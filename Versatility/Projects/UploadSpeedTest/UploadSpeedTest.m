#import "UploadSpeedTest.h"
#import "ProjectManager.h"
#import "PogoplugAPI.h"
#import "ALAssetsLibrary+Utils.h"
#import "ALAsset+Utils.h"
#import "ALAsset+Properties.h"
#import "AFNetworking.h"
#import "NSURL+Utils.h"
#import "ALAssetInputStream.h"

@interface UploadSpeedTest ()
{
    PogoplugAPI *_api;
}
@end

@implementation UploadSpeedTest

+ (void)load
{
    [ProjectManager registerProject:@"Upload Speed Test" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        [self test];
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
    
    NSLog(@"login success");
    
    NSMutableArray *assets = [NSMutableArray array];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    for (ALAssetsGroup *group in library.groups) {
        [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            if (asset) {
                [assets addObject:asset];
            }
        }];
    }
    
    NSLog(@"index success");
    
    NSDate *date;
    
    date = [NSDate date];
    if (![self v1_uploadWithAssets:assets]) {
        return;
    }
    NSLog(@"v1 cost %.2f seconds", [[NSDate date] timeIntervalSinceDate:date]);
    
    date = [NSDate date];
    if (![self v2_uploadWithAssets:assets]) {
        return;
    }
    NSLog(@"v2 cost %.2f seconds", [[NSDate date] timeIntervalSinceDate:date]);
    
    date = [NSDate date];
    if (![self v3_uploadWithAssets:assets]) {
        return;
    }
    NSLog(@"v3 cost %.2f seconds", [[NSDate date] timeIntervalSinceDate:date]);
    
    NSLog(@"test end");
}

- (BOOL)v1_uploadWithAssets:(NSArray *)array
{
    for (ALAsset *asset in array) {
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        
        NSData *data = asset.load;
        if (!data) {
            NSLog(@"failed to load data for asset: %@", rep.url);
            return NO;
        }
        
        NSError *e;
        NSString *fileID = [_api createFileWithParentID:nil fileName:rep.filename error:&e];
        if (!fileID) {
            NSLog(@"failed to create file with name: %@, error: %@", rep.filename, e);
            return NO;
        }
        
        if (![_api uploadFileForFileID:fileID withData:data error:&e]) {
            NSLog(@"failed to upload file with error: %@", e);
            return NO;
        }
    }
    return YES;
}

- (BOOL)v2_uploadWithAssets:(NSArray *)array
{
    for (ALAsset *asset in array) {
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        
        NSURL *url = [NSURL applicationDocumentsDirectory];
        url = [url URLByAppendingPathComponent:rep.filename];
        if (![asset saveToURL:url]) {
            NSLog(@"failed to save asset to local path for: %@", rep.filename);
            return NO;
        }
        
        NSError *e;
        NSString *fileID = [_api createFileWithParentID:nil fileName:rep.filename error:&e];
        if (!fileID) {
            NSLog(@"failed to create file with name: %@, error: %@", rep.filename, e);
            return NO;
        }
        
        if (![_api uploadFileForFileID:fileID withFileURL:url error:&e]) {
            NSLog(@"failed to upload file with error: %@", e);
            return NO;
        }
    }
    return YES;
}

- (BOOL)v3_uploadWithAssets:(NSArray *)array
{
    for (ALAsset *asset in array) {
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        
        NSInputStream *inputStream = [[ALAssetInputStream alloc] initWithAsset:asset library:nil];
        
        NSError *e;
        NSString *fileID = [_api createFileWithParentID:nil fileName:rep.filename error:&e];
        if (!fileID) {
            NSLog(@"failed to create file with name: %@, error: %@", rep.filename, e);
            return NO;
        }
        
        if (![_api uploadFileForFileID:fileID withInputStream:inputStream error:&e]) {
            NSLog(@"failed to upload file with error: %@", e);
            return NO;
        }
    }
    return YES;
}

@end
