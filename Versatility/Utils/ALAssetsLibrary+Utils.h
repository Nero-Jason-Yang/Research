#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (Utils)

- (NSArray *)groups;
- (ALAsset *)assetForURL:(NSURL *)assetURL;
+ (NSInteger)numberOfAssetsForGroups:(NSArray *)groups;

@end
