#import "Basic.h"
#import "ProjectManager.h"

@implementation Basic

+ (void)load
{
    [ProjectManager registerProject:@"Basic" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        [self test_isKindOfClass];
    }
    return self;
}

- (void)test_isKindOfClass
{
    NSString *str = nil;
    NSParameterAssert(![str isKindOfClass:NSString.class]);
    NSDictionary *dic = @{@"a":@"hello", @"b":[NSNumber numberWithInt:100], @"c":@[@"Tom",@"Jerry"], @"d":@{@"good":@"bye"}};
    str = [dic objectForKey:@"a"];
    NSParameterAssert([str isKindOfClass:NSString.class]);
    str = [dic objectForKey:@"b"];
    NSParameterAssert(![str isKindOfClass:NSString.class]);
    str = [dic objectForKey:@"c"];
    NSParameterAssert(![str isKindOfClass:NSString.class]);
    str = [dic objectForKey:@"d"];
    NSParameterAssert(![str isKindOfClass:NSString.class]);
    str = [dic objectForKey:@"e"];
    NSParameterAssert(![str isKindOfClass:NSString.class]);
}

@end
