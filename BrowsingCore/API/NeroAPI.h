#import <Foundation/Foundation.h>

typedef void (^NeroAuthLoginCompletionHandler)(id info, NSError *error);
typedef void (^NeroSubscriptionPogoplugLoginCompletionHandler)(id info, NSError *error);

@interface NeroAPI : NSObject
- (void)authLoginSync:(BOOL)sync email:(NSString *)email password:(NSString *)password completionHandler:(NeroAuthLoginCompletionHandler)handler;
- (void)subscriptionPogoplugLoginSync:(BOOL)sync completionHandler:(NeroSubscriptionPogoplugLoginCompletionHandler)handler;
@end

@interface NeroResponseObject : NSObject
@property (nonatomic,readonly) NSDictionary *dictionary;
@end

@interface NeroResponseObject_AccountInfo : NeroResponseObject
@property (nonatomic,readonly) NSString *email;
@property (nonatomic,readonly) NSString *firstName;
@property (nonatomic,readonly) NSString *lastName;
@property (nonatomic,readonly) NSString *language;
@property (nonatomic,readonly) NSString *country;
@property (nonatomic,readonly) NSDate *creationDate;
@property (nonatomic,readonly) NSString *sessionID;
@end
