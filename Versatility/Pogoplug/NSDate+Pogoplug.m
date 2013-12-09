#import "NSDate+Pogoplug.h"

@implementation NSDate (Pogoplug)

+ (id)dateWithPogoplugTimeString:(NSString *)string
{
    return [NSDate dateWithTimeIntervalSince1970:string.longLongValue/1000.0];
}

- (NSString *)pogoplugTimeString
{
    long long value = (long long)(self.timeIntervalSince1970 * 1000.0);
    return [NSString stringWithFormat:@"%lld", value];
}

@end
