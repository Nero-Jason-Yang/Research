#import "TaskQueue.h"

@implementation TaskQueue
{
    NSMutableArray *_waitingTasks;
    Task *_workingTask;
    BOOL _needSort; // need sort while: 1) new task was added; 2) task priority (tags) changed
}

- (id)init
{
    if (self = [super init]) {
        _waitingTasks = [NSMutableArray array];
        _workingTask = nil;
        _needSort = NO;
        _priorityConverter = nil;
        _dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (void)addTask:(Task *)task
{
    @synchronized(task) {
        task.queue = self;
    }
    
    @synchronized(self) {
        [self enqueueTask:task];
        [self tryPerformTask];
    }
}

- (void)removeTask:(Task *)task
{
    @synchronized(self) {
        [_waitingTasks removeObject:task];
    }
}

- (Task *)addTaskWithBlock:(dispatch_block_t)block
{
    BlockTask *task = [[BlockTask alloc] initWithBlock:block];
    [self addTask:task];
    return task;
}

- (Task *)addTaskWithBlock:(dispatch_block_t)block tags:(NSUInteger)tags
{
    BlockTask *task = [[BlockTask alloc] initWithBlock:block tags:tags];
    [self addTask:task];
    return task;
}

- (void)task:(Task *)task didChangeTagsFrom:(NSUInteger)tags;
{
    @synchronized(self) {
        _needSort = YES;
    }
}

#pragma mark private

- (void)enqueueTask:(Task *)task
{
    [_waitingTasks addObject:task];
    
    if (task.priority > 0) {
        _needSort = YES;
    }
}

- (Task *)dequeueTask
{
    Task *task = nil;
    if (_waitingTasks.count > 0) {
        [self sortTasks];
        task = _waitingTasks[0];
        [_waitingTasks removeObjectAtIndex:0];
    }
    return task;
}

- (void)sortTasks
{
    if (_needSort) {
        [_waitingTasks sortUsingSelector:@selector(compare:)];
        _needSort = NO;
    }
}

- (void)tryPerformTask
{
    if (_workingTask) {
        return;
    }
    
    _workingTask = [self dequeueTask];
    if (!_workingTask) {
        return;
    }
    
    dispatch_async(_dispatchQueue, ^{
        [_workingTask performWithCompletion:^{
            [self didFinishWorkingTask];
        }];
    });
}

- (void)didFinishWorkingTask
{
    @synchronized(_workingTask) {
        _workingTask.queue = nil;
    }
    
    @synchronized(self) {
        _workingTask = nil;
        
        [self tryPerformTask];
    }
}

@end
