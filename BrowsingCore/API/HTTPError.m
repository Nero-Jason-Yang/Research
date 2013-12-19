#import "HTTPError.h"

@implementation HTTPError

+ (NSString *)descriptionForCode:(NSInteger)code
{
    switch (code) {
            // TODO
            
        default: return @"Unknown HTTP status code.";
    }
}

+ (NSError *)errorWithCode:(NSInteger)code
{
    return [self errorWithCode:code description:nil info:nil];
}

+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description
{
    return [self errorWithCode:code description:description info:nil];
}

+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description info:(NSDictionary *)info
{
    if (0 == description.length) {
        description = [self descriptionForCode:code];
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:description};
    if (info) {
        NSMutableDictionary *mdic = userInfo.mutableCopy;
        [mdic addEntriesFromDictionary:info];
        userInfo = mdic;
    }
    return [NSError errorWithDomain:HTTPErrorDomain code:code userInfo:userInfo];
}

@end
