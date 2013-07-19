#import <Foundation/Foundation.h>
#import "Task.h"
#import "TaskPriorityConverter.h"

@interface TaskQueue : NSObject
@property (nonatomic) dispatch_queue_t dispatchQueue;
@property (nonatomic) id<TaskPriorityConverter> priorityConverter;
- (void)addTask:(Task *)task;
- (void)removeTask:(Task *)task;
- (Task *)addTaskWithBlock:(dispatch_block_t)block;
- (Task *)addTaskWithBlock:(dispatch_block_t)block tags:(NSUInteger)tags;
- (Task *)addTaskWithAsyncBlock:(AsyncBlock)block;
- (Task *)addTaskWithAsyncBlock:(AsyncBlock)block tags:(NSUInteger)tags;
- (void)task:(Task *)task didChangeTagsFrom:(NSUInteger)tags;
@end
