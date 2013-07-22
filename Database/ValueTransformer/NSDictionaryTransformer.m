#import "NSDictionaryTransformer.h"

@implementation NSDictionaryTransformer

+ (void)initialize {
    NSParameterAssert(self == NSDictionaryTransformer.class);
    NSDictionaryTransformer *transformer = [[NSDictionaryTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"NSDictionaryTransformer"];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSDictionary class];
}

- (id)transformedValue:(id)value {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
    if (error) {
        NSLog(@"File:%s Line:%d error:%@", __FILE__, __LINE__, error);
    }
    return data;
}

- (id)reverseTransformedValue:(id)value {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:value options:0 error:&error];
    return json;
}

@end
