#import "ALAsset+Utils.h"

#define BUFFERSIZE 20480

@implementation ALAsset (Utils)

- (BOOL)saveToFile:(NSString *)filePath
{
    NSOutputStream *os = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    if (!os) {
        return NO;
    }
    return [self saveToOutputStream:os];
}

- (BOOL)saveToURL:(NSURL *)fileURL
{
    NSOutputStream *os = [NSOutputStream outputStreamWithURL:fileURL append:NO];
    if (!os) {
        return NO;
    }
    return [self saveToOutputStream:os];
}

- (BOOL)saveToOutputStream:(NSOutputStream *)os
{
    ALAssetRepresentation *rep = self.defaultRepresentation;
    NSParameterAssert(rep);
    
    int64_t size = rep.size, offset = 0;
    uint8_t buffer[BUFFERSIZE];
    
    [os open];
    NSError *e;
    while (offset < size) {
        NSUInteger gn = [rep getBytes:buffer fromOffset:offset length:20*1024 error:&e];
        if (0 == gn || e) {
            [os close];
            return NO;
        }
        NSInteger wn = [os write:buffer maxLength:gn];
        NSParameterAssert(wn == gn);
        offset += gn;
    }
    [os close];
    
    return YES;
}

@end
