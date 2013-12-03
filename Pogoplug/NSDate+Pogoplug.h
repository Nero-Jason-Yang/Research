#import <Foundation/Foundation.h>

@interface NSDate (Pogoplug)

+ (id)dateWithPogoplugTimeString:(NSString *)string;
- (NSString *)pogoplugTimeString;

@end
