#import "CompletionWaiter.h"

@interface CompletionWaiter ()
{
    NSCondition *_condition;
    BOOL _completed;
}
@end

@implementation CompletionWaiter

- (id)init
{
    if (self = [super init]) {
        _condition = [[NSCondition alloc] init];
        _completed = NO;
    }
    return self;
}

- (void)complete
{
    _completed = YES;
    [_condition signal];
}

- (void)completeWithObject:(id)object error:(NSError *)error
{
    _object = object;
    _error = error;
    [self complete];
}

- (void)wait
{
    [_condition lock];
    while (!_completed) {
        [_condition wait];
    }
    [_condition unlock];
}

- (void)waitWithInterval:(NSTimeInterval)interval
{
    [_condition lock];
    while (!_completed) {
        [_condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
    [_condition unlock];
}

@end
