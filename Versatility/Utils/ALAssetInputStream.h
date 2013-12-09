#import <Foundation/Foundation.h>

@interface ALAssetInputStream : NSInputStream  <NSStreamDelegate>

- (id)initWithAsset:(ALAsset *)asset library:(ALAssetsLibrary *)library;
- (int64_t)totalSize;

@end
