#import "NSError+Core.h"
#import "NSError+Pogoplug.h"

@implementation NSError (Core)

+ (NSString *)errorDescriptionForCode:(NSInteger)code
{
    switch (code) {
        case ErrorCode_NotImplement:
            return @"Not implement.";
            
        case ErrorCode_Internal:
            return @"Internal error.";
            
        case ErrorCode_NotFound:
            return @"Not found.";
            
        default:
            return nil;
    }
}

+ (id)errorWithCode:(NSInteger)code;
{
    NSString *desc = [NSError errorDescriptionForCode:code];
    NSDictionary *info = desc ? @{NSLocalizedDescriptionKey:desc} : nil;
    return [NSError errorWithDomain:ErrorDomain code:code userInfo:info];
}

+ (id)errorWithCode:(NSInteger)code reason:(NSString *)reason
{
    NSString *desc = [NSError errorDescriptionForCode:code];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    if (desc) {
        [info setObject:desc forKey:NSLocalizedDescriptionKey];
    }
    if (reason) {
        [info setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
    }
    return [NSError errorWithDomain:ErrorDomain code:code userInfo:info];
}

+ (id)errorWithInternalReason:(NSString *)reason file:(char *)file line:(int)line
{
    NSString *fullReason = [reason stringByAppendingFormat:@" file:%s line:%d", file, line];
    return [NSError errorWithCode:ErrorCode_Internal reason:fullReason];
}

- (BOOL)isTimeout
{
    // TODO
    return NO;
}

- (BOOL)isNotFound
{
    if ([self.domain isEqualToString:ErrorDomain]) {
        if (self.code == ErrorCode_NotFound) {
            return YES;
        }
    }
    
    if ([self.domain isEqualToString:ErrorDomain_Pogoplug]) {
        if (self.code == 804) {
            return YES;
        }
    }
    
    // TODO
    return NO;
}

- (BOOL)isOutOfStorage
{
    // TODO
    return NO;
}

- (BOOL)isServerMaintenance
{
    // TODO
    return NO;
}

- (BOOL)isNetworkNotAvailable
{
    if ([self.domain isEqualToString:NSURLErrorDomain]) {
        if (self.code == NSURLErrorNotConnectedToInternet) {
            return YES;
        }
    }
    return NO;
}

@end
