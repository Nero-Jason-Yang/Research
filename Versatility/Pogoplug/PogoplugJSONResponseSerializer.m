#import "PogoplugJSONResponseSerializer.h"

@implementation PogoplugJSONResponseSerializer

- (NSSet *)acceptableContentTypes
{
    NSMutableSet *set = [super acceptableContentTypes].mutableCopy;
    [set addObject:@"application/x-javascript"];
    return set;
}

- (NSIndexSet *)acceptableStatusCodes
{
    NSMutableIndexSet *set = [super acceptableStatusCodes].mutableCopy;
    [set addIndex:500];
    return set;
}

@end
