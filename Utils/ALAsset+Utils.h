#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (Utils)

- (BOOL)saveToFile:(NSString *)filePath;
- (BOOL)saveToURL:(NSURL *)fileURL;

@end
