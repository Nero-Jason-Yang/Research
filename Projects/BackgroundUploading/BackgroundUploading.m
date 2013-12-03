#import "BackgroundUploading.h"
#import "ProjectManager.h"
#import "PogoplugAPI.h"
#import "NSURL+Utils.h"
#import "ALAssetsLibrary+Utils.h"
#import "ALAssetsGroup+Utils.h"
#import "ALAsset+Utils.h"

@interface BackgroundUploading ()
@property (nonatomic) PogoplugAPI *api;
@end

@implementation BackgroundUploading

+ (void)load
{
    [ProjectManager registerProject:@"Background Uploading with Pogoplug" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        self.api = [[PogoplugAPI alloc] init];
        [self test];
    }
    return self;
}

- (void)test
{
    NSError *e;
    if (![self.api loginWithUsername:@"ja2yang@nero.com" password:@"123456" error:&e]) {
        NSLog(@"%@", e);
        return;
    }
    
    NSString *fileID = [self.api createFileWithParentID:nil fileName:@"Hello.jpg" error:&e];
    if (!fileID) {
        NSLog(@"%@", e);
        return;
    }
    
    NSURL *url = [NSURL applicationDocumentsDirectory];
    url = [url URLByAppendingPathComponent:@"test.jpg"];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAsset *asset;
    for (ALAssetsGroup *group in library.groups) {
        if (group.numberOfAssets > 0) {
            asset = [group assetAtIndex:0];
        }
    }
    if (!asset) {
        NSLog(@"No photos");
        return;
    }
    
    if (![asset saveToURL:url]) {
        NSLog(@"Failed to save asset file data to: %@", url);
        return;
    }
    
    if (![self.api uploadFileWithFileID:fileID fromContentOfFile:url error:&e]) {
        NSLog(@"%@", e);
        return;
    }
}

@end
