#import "ALAssetsLibrary+Utils.h"

@implementation ALAssetsLibrary (Utils)

- (NSArray *)groups
{
    NSMutableArray *groups = [NSMutableArray array];
    NSCondition *condition = [[NSCondition alloc] init];
    __block BOOL completed = NO;
    
    ALAssetsGroupType types = ALAssetsGroupSavedPhotos|ALAssetsGroupLibrary;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self enumerateGroupsWithTypes:types usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [groups addObject:group];
            }
            else {
                completed = YES;
                [condition signal];
            }
        } failureBlock:^(NSError *error) {
            NBLog(@"File:%s Line:%d error:%@", __FILE__, __LINE__, error);
            completed = YES;
            [condition signal];
        }];
    });
    
    [condition lock];
    while (!completed) {
        [condition wait];
    }
    [condition unlock];
    return groups;
}

- (ALAsset *)assetForURL:(NSURL *)assetURL
{
    __block ALAsset *asset;
    NSCondition *condition = [[NSCondition alloc] init];
    __block BOOL completed = NO;
    
    [self assetForURL:assetURL resultBlock:^(ALAsset *result) {
        asset = result;
        completed = YES;
        [condition signal];
    } failureBlock:^(NSError *error) {
        NBLog(@"File:%s Line:%d error:%@", __FILE__, __LINE__, error);
        completed = YES;
        [condition signal];
    }];
    
    [condition lock];
    while (!completed) {
        [condition wait];
    }
    [condition unlock];
    
    return asset;
}

+ (NSInteger)numberOfAssetsForGroups:(NSArray *)groups
{
    NSInteger total = 0;
    for (ALAssetsGroup *group in groups) {
        total += group.numberOfAssets;
    }
    return total;
}

@end
