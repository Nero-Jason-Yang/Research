#import <Foundation/Foundation.h>

#define AccountType_Cloud @"accounttype_pogoplug"

typedef enum : uint8_t {
    AccountState_Unauthorized,
    AccountState_Authorizing,
    AccountState_Authorized,
    AccountState_Resigning,
} AccountState;

typedef void (^AccountCompletionHandler)(NSError *error);

@class Account;

@interface AccountManager : NSObject
+ (AccountManager *)sharedAccountManager;
- (NSArray *)accounts;
- (NSArray *)accountsWithType:(NSString *)type;
- (Account *)accountForIdentifier:(NSString *)identifier;
- (Account *)accountForUsername:(NSString *)username withType:(NSString *)type;
- (Account *)createAccountWithType:(NSString *)type;
- (void)removeAccountForIdentifier:(NSString *)identifier;
@end

@interface Account : NSObject
@property (nonatomic,readonly) NSString *type; // eg: accounttype_pogoplug or accounttype_pc
@property (nonatomic,readonly) NSString *identifier; // eg: ABCD-...-1234
@end

@interface AuthorizableAccount : Account
@property (nonatomic,readonly) NSString *username; // eg: ja2yang@nero.com
@property (nonatomic,readonly) NSString *password; // eg: 123456
@property (nonatomic,readonly) AccountState state; // eg: AccountState_Authorzied
- (void)loginSync:(BOOL)sync username:(NSString *)username password:(NSString *)password completionHandler:(AccountCompletionHandler)handler;
- (void)logoutSync:(BOOL)sync completionHandler:(AccountCompletionHandler)handler;
@end

@interface CloudAccount : AuthorizableAccount
@property (nonatomic,readonly) NSString *sessionID;
@property (nonatomic,readonly) NSURL *webClientURL;
- (void)changePasswordSync:(BOOL)sync oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completionHandler:(AccountCompletionHandler)handler;
- (void)renewPasswordSync:(BOOL)sync email:(NSString *)email completionHandler:(AccountCompletionHandler)handler;
- (void)acceptTOSSync:(BOOL)sync email:(NSString *)email completionHandler:(AccountCompletionHandler)handler;
@end
