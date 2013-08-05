#import "NSDictionarySlowTransformer.h"

@implementation NSDictionarySlowTransformer

+ (void)initialize {
    NSDictionarySlowTransformer *transformer = [[NSDictionarySlowTransformer alloc] init];
    [NSValueTransformer setValueTransformer:transformer forName:@"NSDictionarySlowTransformer"];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSDictionary class];
}

- (id)transformedValue:(id)value {
    NSLog(@"start save");
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];
    if (error) {
        NSLog(@"File:%s Line:%d error:%@", __FILE__, __LINE__, error);
    }
    [NSThread sleepForTimeInterval:10];
    NSLog(@"end save");
    return data;
}

- (id)reverseTransformedValue:(id)value {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:value options:0 error:&error];
    return json;
}

@end
