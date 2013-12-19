#import <Foundation/Foundation.h>

@class NeroResponseObject_AccountInfo;
@class NeroResponseObject_PogoplugInfo;
typedef void (^NeroAPICompletionHandler)(NSError *error);
typedef void (^NeroAPISubscriptionPogoplugLoginCompletionHandler)(NeroResponseObject_PogoplugInfo *pogoplugInfo, NSError *error);
typedef void (^NeroAPIAuthLoginCompletionHandler)(NeroResponseObject_AccountInfo *accountInfo, NSError *error);
typedef void (^NeroAPIAuthRegisterCompletionHandler)(NeroResponseObject_AccountInfo *accountInfo, NSError *error);

@interface NeroAPI : NSObject
- (void)subscriptionPogoplugLoginSync:(BOOL)sync completionHandler:(NeroAPISubscriptionPogoplugLoginCompletionHandler)handler;
- (void)authLoginSync:(BOOL)sync email:(NSString *)email password:(NSString *)password completionHandler:(NeroAPIAuthLoginCompletionHandler)handler;
- (void)authLogoutSync:(BOOL)sync completionHandler:(NeroAPICompletionHandler)handler;
- (void)authRegisterSync:(BOOL)sync email:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName language:(NSString *)language country:(NSString *)country completionHandler:(NeroAPIAuthRegisterCompletionHandler)handler;
- (void)authPasswordChangeSync:(BOOL)sync email:(NSString *)email passwordold:(NSString *)passwordold passwordnew:(NSString *)passwordnew completionHandler:(NeroAPICompletionHandler)handler;
- (void)authPasswordRenewSync:(BOOL)sync email:(NSString *)email completionHandler:(NeroAPICompletionHandler)handler;
- (void)userAcceptTOSSync:(BOOL)sync email:(NSString *)email completionHandler:(NeroAPICompletionHandler)handler;
@end

@interface NeroResponseObject_Data : NSObject
@end

@interface NeroResponseObject_AccountInfo : NeroResponseObject_Data
@property (nonatomic,readonly) NSString *email;
@property (nonatomic,readonly) NSString *firstName;
@property (nonatomic,readonly) NSString *lastName;
@property (nonatomic,readonly) NSString *language;
@property (nonatomic,readonly) NSString *country;
@property (nonatomic,readonly) NSDate *creationDate;
@property (nonatomic,readonly) NSString *sessionID; // available for login
@end

@interface NeroResponseObject_PogoplugInfo : NeroResponseObject_Data
@property (nonatomic,readonly) NSString *token;
@property (nonatomic,readonly) NSString *api_host;
@property (nonatomic,readonly) NSString *webclient_url;
@end
