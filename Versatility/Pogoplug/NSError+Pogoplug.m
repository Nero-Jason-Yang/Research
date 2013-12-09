#import "NSError+Pogoplug.h"

@implementation NSError (Pogoplug)

+ (id)pogoplugErrorWithCode:(NSInteger)code message:(NSString *)message
{
    NSDictionary *userInfo = nil;
    if (message) {
        userInfo = @{NSLocalizedDescriptionKey:message};
    }
    return [NSError errorWithDomain:ErrorDomain_Pogoplug code:code userInfo:userInfo];
}

@end
