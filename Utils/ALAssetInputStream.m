#import "ALAssetInputStream.h"

@interface ALAssetInputStream () <NSCopying>
@property (nonatomic) id<NSStreamDelegate> delegate;
@property (nonatomic, assign) NSStreamStatus streamStatus;
@property (nonatomic, strong) NSError *streamError;
@property (nonatomic) ALAsset *asset;
@property (nonatomic) ALAssetsLibrary *library;
@property (nonatomic) ALAssetRepresentation *rep;
@property (nonatomic) long long offset;
@end

@implementation ALAssetInputStream

- (id)initWithAsset:(ALAsset *)asset library:(ALAssetsLibrary *)library
{
    if (self = [super init]) {
        self.asset = asset;
        self.library = library;
    }
    return self;
}

- (int64_t)totalSize
{
    return self.rep.size;
}

#pragma mark - NSInputStream

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)length
{
    if (self.streamStatus == NSStreamStatusClosed) {
        return 0;
    }
    
    long long remain = self.rep.size - self.offset;
    NSError *error; NSUInteger readed = 0;
    if (remain > length) {
        readed = [self.rep getBytes:buffer fromOffset:self.offset length:length error:&error];
    }
    else {
        readed = [self.rep getBytes:buffer fromOffset:self.offset length:(NSUInteger)remain error:&error];
    }
    
    if (error) {
        self.streamError = error;
        [self.delegate stream:self handleEvent:NSStreamEventErrorOccurred];
        return -1;
    }
    
    self.offset += readed;
    if (readed == remain) {
        self.streamStatus = NSStreamStatusAtEnd;
        [self.delegate stream:self handleEvent:NSStreamEventEndEncountered];
    }
    return readed;
}

- (BOOL)getBuffer:(__unused uint8_t **)buffer length:(__unused NSUInteger *)len
{
    return NO;
}

- (BOOL)hasBytesAvailable
{
    return self.streamStatus == NSStreamStatusOpen;
}

#pragma mark - NSStream

- (void)open {
    if (self.streamStatus == NSStreamStatusOpen) {
        return;
    }
    
    self.streamStatus = NSStreamStatusOpen;
    self.rep = self.asset.defaultRepresentation;
    [self.delegate stream:self handleEvent:NSStreamEventOpenCompleted];
    [self.delegate stream:self handleEvent:NSStreamEventHasBytesAvailable];
}

- (void)close {
    self.streamStatus = NSStreamStatusClosed;
    self.rep = nil;
}

- (id)propertyForKey:(__unused NSString *)key
{
    return nil;
}

- (BOOL)setProperty:(__unused id)property forKey:(__unused NSString *)key
{
    return NO;
}

- (void)scheduleInRunLoop:(__unused NSRunLoop *)aRunLoop forMode:(__unused NSString *)mode
{
    NBLog(@"scheduleInRunLoop");
    [aRunLoop runMode:mode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

- (void)removeFromRunLoop:(__unused NSRunLoop *)aRunLoop forMode:(__unused NSString *)mode
{
    NBLog(@"removeFromRunLoop");
}

//#pragma mark - Undocumented CFReadStream Bridged Methods
//
//- (void)_scheduleInCFRunLoop:(__unused CFRunLoopRef)aRunLoop forMode:(__unused CFStringRef)aMode
//{
//}
//
//- (void)_unscheduleFromCFRunLoop:(__unused CFRunLoopRef)aRunLoop forMode:(__unused CFStringRef)aMode
//{
//}
//
//- (BOOL)_setCFClientFlags:(__unused CFOptionFlags)inFlags callback:(__unused CFReadStreamClientCallBack)inCallback context:(__unused CFStreamClientContext *)inContext
//{
//    return NO;
//}

#pragma mark - NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    return [[ALAssetInputStream alloc] initWithAsset:self.asset library:self.library];
}

@end
