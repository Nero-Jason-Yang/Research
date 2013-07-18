#import <Foundation/Foundation.h>

@protocol TaskPriorityConverter <NSObject>

- (NSUInteger)priorityFromTags:(NSUInteger)tags;

@end
