#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (Properties)

- (BOOL)isPhoto;
- (BOOL)isVideo;
- (NSDate *)creationDate;

@end
