#import <Foundation/Foundation.h>

#define HTTPErrorDomain @"NeroAPI"

@interface HTTPError : NSError
+ (NSError *)errorWithCode:(NSInteger)code;
+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description;
+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description info:(NSDictionary *)info;
@end
