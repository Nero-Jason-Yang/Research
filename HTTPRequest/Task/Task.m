#import "Task.h"
#import "TaskQueue.h"
#import "TaskPriorityConverter.h"

@implementation Task
{
    NSNumber *_priority;
}

- (id)init
{
    if (self = [super init]) {
        _tags = 0;
    }
    return self;
}

- (id)initWithTags:(NSUInteger)tags
{
    if (self = [super init]) {
        _tags = tags;
    }
    return self;
}

- (void)setTags:(NSUInteger)tags
{
    TaskQueue *queue = nil;
    NSUInteger oldTags = 0;
    
    @synchronized(self) {
        if (_tags != tags) {
            queue = _queue;
            if (queue) {
                oldTags = _tags;
                _priority = nil;
            }
            _tags = tags;
        }
    }
    
    if (queue) {
        [queue task:self didChangeTagsFrom:oldTags];
    }
}

- (NSUInteger)priority
{
    @synchronized(self) {
        if (!_priority) {
            NSUInteger priority = 0;
            if (_queue) {
                id<TaskPriorityConverter> converter = _queue.priorityConverter;
                if (converter) {
                    priority = [converter priorityFromTags:_tags];
                }
            }
            _priority = [NSNumber numberWithUnsignedInteger:priority];
        }
        return _priority.unsignedIntegerValue;
    }
}

- (void)performWithCompletion:(dispatch_block_t)completion
{
    completion();
}

- (void)cancel
{
    TaskQueue *queue = _queue;
    if (queue) {
        [queue removeTask:self];
    }
}

- (NSComparisonResult)compare:(Task *)other
{
    NSUInteger a = self.priority;
    NSUInteger b = other.priority;
    if (a > b) {
        return NSOrderedAscending;
    }
    if (a < b) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

@end


@implementation BlockTask
{
    dispatch_block_t _block;
}

- (id)initWithBlock:(dispatch_block_t)block
{
    if (self = [super init]) {
        _block = block;
    }
    return self;
}

- (id)initWithBlock:(dispatch_block_t)block tags:(NSUInteger)tags
{
    if (self = [super initWithTags:tags]) {
        _block = block;
    }
    return self;
}

- (void)performWithCompletion:(dispatch_block_t)completion
{
    if (_block) {
        _block();
    }
    completion();
}

@end
