#import <Foundation/Foundation.h>

@interface CompletionWaiter : NSObject
@property (nonatomic,readonly) id object;
@property (nonatomic,readonly) NSError *error;
- (void)complete;
- (void)completeWithObject:(id)object error:(NSError *)error;
- (void)wait;
- (void)waitWithInterval:(NSTimeInterval)interval;
@end
