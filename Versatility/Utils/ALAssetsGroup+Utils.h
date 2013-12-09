#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsGroup (Utils)

- (ALAsset *)assetAtIndex:(NSUInteger)index;
- (NSArray *)assetsAtIndexes:(NSIndexSet *)indexes;

@end
