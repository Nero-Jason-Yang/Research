#import <Foundation/Foundation.h>
@class TaskQueue;

@interface Task : NSObject
- (id)init;
- (id)initWithTags:(NSUInteger)tags;
@property (nonatomic) NSUInteger tags;
@property (nonatomic,weak) TaskQueue *queue;
@property (nonatomic,readonly) NSUInteger priority;
- (void)performWithCompletion:(dispatch_block_t)completion;
- (void)cancel;
@end

@interface BlockTask : Task
- (id)initWithBlock:(dispatch_block_t)block;
- (id)initWithBlock:(dispatch_block_t)block tags:(NSUInteger)tags;
@end

typedef void(^AsyncBlock)(dispatch_block_t completion);
@interface AsyncBlockTask : Task
- (id)initWithBlock:(AsyncBlock)block;
- (id)initWithBlock:(AsyncBlock)block tags:(NSUInteger)tags;
@end
