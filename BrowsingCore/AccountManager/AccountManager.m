#import "AccountManager.h"
#import "NSManagedObjectContext+Utils.h"
#import "CloudAccountMO.h"
#import "NeroAPI.h"
#import "CompletionWaiter.h"

#define EntityName_Account @"Account"
#define EntityName_CloudAccount @"CloudAccount"

@interface AccountManager ()
{
    NSMutableDictionary *_accountsByIdentifier;
}
@property (nonatomic,readonly) NSManagedObjectContext *context;
@end

@interface Account ()
@property (nonatomic,readonly) AccountMO *mo;
- (id)initWithMO:(AccountMO *)mo;
@end

@interface AuthorizableAccount ()
@property (nonatomic) AccountState state;
@end

@interface CloudAccount ()
@property (nonatomic,readonly) NeroAPI *api;
@end

@implementation AccountManager

+ (AccountManager *)sharedAccountManager
{
    static AccountManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AccountManager alloc] initSharedAccountManager];
    });
    return manager;
}

- (id)init
{
    NSAssert(0, @"[AccountManager init] not implement!");
    return nil;
}

- (id)initSharedAccountManager
{
    if (self = [super init]) {
        _context = [NSManagedObjectContext contextWithModelName:@"AccountManager"];
        _accountsByIdentifier = [NSMutableDictionary dictionary];
        [self loadAccounts];
    }
    return self;
}

- (void)loadAccounts
{
    [self.context performBlock:^{
        NSArray *mos = [self.context fetchObjectsForEntityName:EntityName_Account];
        for (AccountMO *mo in mos) {
            Account *account = [self createAccountWithMO:mo type:mo.type];
            if (account) {
                _accountsByIdentifier[mo.identifier] = mo;
            }
        }
    }];
}

- (NSArray *)accounts
{
    __block NSArray *accounts;
    [self.context performBlockAndWait:^{
        accounts = _accountsByIdentifier.allValues;
    }];
    return accounts;
}

- (NSArray *)accountsWithType:(NSString *)type
{
    NSMutableArray *accounts = [NSMutableArray array];
    [self.context performBlockAndWait:^{
        [_accountsByIdentifier enumerateKeysAndObjectsUsingBlock:^(id key, Account *account, BOOL *stop) {
            if ([account isKindOfClass:Account.class] && [account.type isEqualToString:type]) {
                [accounts addObject:account];
            }
        }];
    }];
    return accounts;
}

- (Account *)accountForIdentifier:(NSString *)identifier
{
    __block Account *account;
    [self.context performBlockAndWait:^{
        account = _accountsByIdentifier[identifier];
    }];
    return account;
}

- (Account *)accountForUsername:(NSString *)username withType:(NSString *)type
{
    __block Account *account;
    [self.context performBlockAndWait:^{
        [_accountsByIdentifier enumerateKeysAndObjectsUsingBlock:^(id key, AuthorizableAccount *account, BOOL *stop) {
            if ([account isKindOfClass:AuthorizableAccount.class] && [account.username isEqualToString:username] && [account.type isEqualToString:type]) {
                account = account;
                *stop = YES;
            }
        }];
    }];
    return account;
}

- (Account *)createAccountWithType:(NSString *)type
{
    NSString *entityName = [self entityNameForAccountType:type];
    if (!entityName) {
        return nil;
    }
    
    NSString *identifier = [[NSUUID UUID] UUIDString];
    NSParameterAssert(identifier);
    
    __block Account *account;
    [self.context performBlockAndWait:^{
        AccountMO *mo = [self.context createObjectForEntityName:entityName];
        mo.type = type;
        mo.identifier = identifier;
        mo.creationDate = NSDate.date;
        [self.context save];
        account = [self createAccountWithMO:mo type:type];
        _accountsByIdentifier[identifier] = account;
    }];
    return account;
}

- (void)removeAccountForIdentifier:(NSString *)identifier
{
    [self.context performBlockAndWait:^{
        Account *account = _accountsByIdentifier[identifier];
        if (account) {
            [self.context deleteObject:account.mo];
            [self.context save];
            [_accountsByIdentifier removeObjectForKey:identifier];
        }
    }];
}

#pragma mark internal

- (NSString *)entityNameForAccountType:(NSString *)type
{
    if ([type isEqualToString:AccountType_Cloud]) {
        return EntityName_CloudAccount;
    }
    return nil;
}

- (Account *)createAccountWithMO:(AccountMO *)mo type:(NSString *)type
{
    if ([type isEqualToString:AccountType_Cloud]) {
        NSParameterAssert([mo isKindOfClass:CloudAccountMO.class]);
        return [[CloudAccount alloc] initWithMO:(CloudAccountMO *)mo];
    }
    return nil;
}

@end

@implementation Account

- (id)initWithMO:(AccountMO *)mo
{
    if (self = [super init]) {
        _mo = mo;
        _type = mo.type;
        _identifier = mo.identifier;
    }
    return self;
}

@end

@implementation AuthorizableAccount

- (id)initWithMO:(AccountMO *)mo
{
    if (self = [super initWithMO:mo]) {
        self.state = AccountState_Unauthorized;
    }
    return self;
}

- (NSString *)username
{
    AuthorizableAccountMO *mo = (AuthorizableAccountMO *)self.mo;
    NSParameterAssert([mo isKindOfClass:AuthorizableAccountMO.class]);
    
    __block NSString *username;
    [mo.managedObjectContext performBlockAndWait:^{
        username = mo.username;
    }];
    return username;
}

- (NSString *)password
{
    AuthorizableAccountMO *mo = (AuthorizableAccountMO *)self.mo;
    NSParameterAssert([mo isKindOfClass:AuthorizableAccountMO.class]);
    
    __block NSString *password;
    [mo.managedObjectContext performBlockAndWait:^{
        password = mo.password;
    }];
    return password;
}

- (void)loginSync:(BOOL)sync username:(NSString *)username password:(NSString *)password completionHandler:(AccountCompletionHandler)handler
{
    AuthorizableAccountMO *mo = (AuthorizableAccountMO *)self.mo;
    NSParameterAssert([mo isKindOfClass:AuthorizableAccountMO.class]);
    
    dispatch_block_t block = ^{
        mo.username = username;
        mo.password = password;
        mo.lastAuthorizedDate = NSDate.date;
        [mo.managedObjectContext save];
        
        self.state = AccountState_Authorized;
        handler(nil);
    };
    
    if (sync) {
        [mo.managedObjectContext performBlockAndWait:block];
    }
    else {
        [mo.managedObjectContext performBlock:block];
    }
}

- (void)logoutSync:(BOOL)sync completionHandler:(AccountCompletionHandler)handler
{
    AuthorizableAccountMO *mo = (AuthorizableAccountMO *)self.mo;
    NSParameterAssert([mo isKindOfClass:AuthorizableAccountMO.class]);
    
    dispatch_block_t block = ^{
        mo.password = nil;
        [mo.managedObjectContext save];
        
        self.state = AccountState_Unauthorized;
        handler(nil);
    };
    
    if (sync) {
        [mo.managedObjectContext performBlockAndWait:block];
    }
    else {
        [mo.managedObjectContext performBlock:block];
    }
}

@end

@implementation CloudAccount

- (id)initWithMO:(AccountMO *)mo
{
    if (self = [super initWithMO:mo]) {
        _api = [[NeroAPI alloc] init];
    }
    return self;
}

- (void)loginSync:(BOOL)sync username:(NSString *)username password:(NSString *)password completionHandler:(AccountCompletionHandler)handler
{
    // TODO
}

- (void)logoutSync:(BOOL)sync completionHandler:(AccountCompletionHandler)handler
{
    // TODO
}

- (void)changePasswordSync:(BOOL)sync oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword completionHandler:(AccountCompletionHandler)handler
{
    // TODO
}

- (void)renewPasswordSync:(BOOL)sync email:(NSString *)email completionHandler:(AccountCompletionHandler)handler
{
    // TODO
}

- (void)acceptTOSSync:(BOOL)sync email:(NSString *)email completionHandler:(AccountCompletionHandler)handler
{
    // TODO
}

#pragma mark internal

@end
