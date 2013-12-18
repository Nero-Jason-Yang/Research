#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (NSString *)stringObjectForKey:(id)key
{
    NSString *value = [self objectForKey:key];
    if ([value isKindOfClass:NSString.class]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)dictionaryObjectForKey:(id)key
{
    NSDictionary *value = [self objectForKey:key];
    if ([value isKindOfClass:NSDictionary.class]) {
        return value;
    }
    return nil;
}

- (NSArray *)arrayObjectForKey:(id)key
{
    NSArray *value = [self objectForKey:key];
    if ([value isKindOfClass:NSArray.class]) {
        return value;
    }
    return nil;
}

@end
