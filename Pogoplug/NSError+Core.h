#import <Foundation/Foundation.h>

#define ErrorDomain @"Core"
#define ErrorCode_NotImplement 0
#define ErrorCode_Internal     1
#define ErrorCode_NotFound     2

@interface NSError (Core)

+ (NSString *)errorDescriptionForCode:(NSInteger)code;

+ (id)errorWithCode:(NSInteger)code;
+ (id)errorWithCode:(NSInteger)code reason:(NSString *)reason;
+ (id)errorWithInternalReason:(NSString *)reason file:(char *)file line:(int)line;

- (BOOL)isTimeout;
- (BOOL)isNotFound;
- (BOOL)isOutOfStorage;
- (BOOL)isServerMaintenance;
- (BOOL)isNetworkNotAvailable;

@end
