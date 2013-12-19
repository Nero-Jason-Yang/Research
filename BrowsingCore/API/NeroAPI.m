#import "NeroAPI.h"
#import "NeroAPIError.h"
#import "HTTPError.h"
#import "AFNetworking.h"
#import "CompletionWaiter.h"
#import "NSDictionary+Utils.h"

#define NeroHost @"services.my.nerobackitup.com"

@interface NeroAPI ()
@property (nonatomic,readonly) NSURL *baseURL;
@property (nonatomic,readonly) AFHTTPRequestOperationManager *authManager;
@end

@interface NeroOperationManager : AFHTTPRequestOperationManager
@end

@interface NeroResponseSerializer : AFJSONResponseSerializer
@end

@interface NeroResponseSerializer_AuthLogin : NeroResponseSerializer
@end

@interface NeroResponseSerializer_AuthRegister : NeroResponseSerializer
@end

@interface NeroResponseSerializer_AuthPasswordChange : NeroResponseSerializer
@end

@interface NeroResponseSerializer_AuthPasswordRenew : NeroResponseSerializer
@end

@interface NeroResponseSerializer_UserAcceptTOS : NeroResponseSerializer
@end

@interface NeroResponseSerializer_SubscriptionPogoplugLogin : NeroResponseSerializer
@end

@interface NeroResponseObject : NSObject
- (id)initWithStatusCode:(NSInteger)statusCode dictionary:(NSDictionary *)dictionary;
@property (nonatomic,readonly) NSInteger statusCode;
@property (nonatomic,readonly) NSDictionary *dictionary;
@property (nonatomic,readonly) NSInteger code;
@property (nonatomic,readonly) NSDictionary *data;
@property (nonatomic,readonly) NeroResponseObject_AccountInfo *accountInfo;
@property (nonatomic,readonly) NeroResponseObject_PogoplugInfo *pogoplugLogin;
@end

@interface NeroResponseObject_Data ()
- (id)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic,readonly) NSDictionary *dictionary;
@end

@interface NeroResponseObject_AccountInfo ()
@end

@interface NeroResponseObject_PogoplugInfo ()
@end

@implementation NeroAPI

- (id)init
{
    if (self = [super init]) {
        _baseURL = [[NSURL alloc] initWithScheme:@"http" host:@"services.my.nerobackitup.com" path:@"/api/v1"];
    }
    return self;
}

- (void)subscriptionPogoplugLoginSync:(BOOL)sync completionHandler:(NeroAPISubscriptionPogoplugLoginCompletionHandler)handler
{
    NSParameterAssert(handler);
    
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"subscriptions/pogoplug/login"];
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    manager.responseSerializer = [NeroResponseSerializer_SubscriptionPogoplugLogin serializer];
    [manager POST:url.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, NeroResponseObject *object) {
        NSParameterAssert([object isKindOfClass:NeroResponseObject.class]);
        handler(object.pogoplugLogin, nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

- (void)authLoginSync:(BOOL)sync email:(NSString *)email password:(NSString *)password completionHandler:(NeroAPIAuthLoginCompletionHandler)handler
{
    NSParameterAssert(email && password && handler);
    
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"auth/ncs/login"];
    NSDictionary *parameters = @{@"email":email, @"password":password};
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    manager.responseSerializer = [NeroResponseSerializer_AuthLogin serializer];
    [manager POST:url.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, NeroResponseObject *object) {
        NSParameterAssert([object isKindOfClass:NeroResponseObject.class]);
        handler(object.accountInfo, nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

- (void)authLogoutSync:(BOOL)sync completionHandler:(NeroAPICompletionHandler)handler
{
    NSParameterAssert(handler);
    
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"auth/ncs/logout"];
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    [manager POST:url.absoluteString parameters:nil success:^(AFHTTPRequestOperation *operation, NeroResponseObject *object) {
        handler(nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

- (void)authRegisterSync:(BOOL)sync email:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName language:(NSString *)language country:(NSString *)country completionHandler:(NeroAPIAuthRegisterCompletionHandler)handler
{
    NSParameterAssert(email && password && handler);
    
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"auth/ncs/register"];
    
    NSMutableDictionary *parameters = @{@"email":email, @"password":password}.mutableCopy;
    if (firstName) {
        parameters[@"firstname"] = firstName;
    }
    if (lastName) {
        parameters[@"lastname"] = lastName;
    }
    if (language) {
        parameters[@"lang"] = language;
    }
    if (country) {
        parameters[@"country"] = country;
    }
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    manager.responseSerializer = [NeroResponseSerializer_AuthRegister serializer];
    [manager POST:url.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, NeroResponseObject *object) {
        NSParameterAssert([object isKindOfClass:NeroResponseObject.class]);
        handler(object.accountInfo, nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

- (void)authPasswordChangeSync:(BOOL)sync email:(NSString *)email passwordold:(NSString *)passwordold passwordnew:(NSString *)passwordnew completionHandler:(NeroAPICompletionHandler)handler
{
    NSParameterAssert(email && passwordold && passwordnew && handler);
    
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"auth/ncs/passwordchange"];
    NSDictionary *parameters = @{@"email":email, @"passwordold":passwordold, @"passwordnew":passwordnew};
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    manager.responseSerializer = [NeroResponseSerializer_AuthPasswordChange serializer];
    [manager POST:url.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, NeroResponseObject *object) {
        handler(nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

- (void)authPasswordRenewSync:(BOOL)sync email:(NSString *)email completionHandler:(NeroAPICompletionHandler)handler
{
    NSParameterAssert(email && handler);
    
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"auth/ncs/passwordrenew"];
    NSDictionary *parameters = @{@"email":email};
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    manager.responseSerializer = [NeroResponseSerializer_AuthPasswordRenew serializer];
    [manager POST:url.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, NeroResponseObject *object) {
        handler(nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

- (void)userAcceptTOSSync:(BOOL)sync email:(NSString *)email completionHandler:(NeroAPICompletionHandler)handler
{
    NSParameterAssert(email && handler);
    
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"user/accepttos"];
    NSDictionary *parameters = @{@"email":email, @"tos":NSDate.date};
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    manager.responseSerializer = [NeroResponseSerializer_UserAcceptTOS serializer];
    [manager POST:url.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, NeroResponseObject *object) {
        handler(nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

@end

@implementation NeroOperationManager

+ (instancetype)manager
{
    NeroOperationManager *manager = [[NeroOperationManager alloc] initWithBaseURL:nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [NeroResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    return manager;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:request success:success failure:failure];
    operation.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    return operation;
}

@end

@implementation NeroResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError **)error
{
    // http status code
    NSInteger statusCode = 200;
    if ([response isKindOfClass:NSHTTPURLResponse.class]) {
        statusCode = ((NSHTTPURLResponse *)response).statusCode;
    }
    
    // try to parse json object from response data.
    id json = [self jsonObjectFromData:data withResponse:response];
    if (json) {
        // try to find custom error from json object with status code.
        NSError *customError = [self customErrorFromJsonObject:json withStatusCode:statusCode];
        if (customError) {
            if (error) {
                *error = customError;
            }
            return nil; // custom error.
        }
    }
    
    // check http status code for server error.
    NSError *httpError = [self httpErrorForStatusCode:statusCode withJsonObject:json];
    if (httpError) {
        if (error) {
            *error = httpError;
        }
        return nil; // http error.
    }
    
    // nero api response data must be a dictionary json object.
    if (![json isKindOfClass:NSDictionary.class]) {
        // TODO
        // to create an error.
        return nil; // invalid response data.
    }
    
    return [[NeroResponseObject alloc] initWithStatusCode:statusCode dictionary:json];
}

- (id)jsonObjectFromData:(NSData *)data withResponse:(NSURLResponse *)response
{
    if (!data) {
        return nil;
    }
    
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
    if (responseString.length > 0) {
        // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
        // See http://stackoverflow.com/a/12843465/157142
        NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (responseData.length > 0) {
            NSError *e;
            id json = [NSJSONSerialization JSONObjectWithData:responseData options:self.readingOptions error:&e];
            if (!e) {
                return json;
            }
        }
    }
    
    return nil;
}

- (NSError *)customErrorFromJsonObject:(id)json withStatusCode:(NSInteger)statusCode
{
    NSDictionary *dic = (NSDictionary *)json;
    if ([dic isKindOfClass:NSDictionary.class]) {
        NSDictionary *details = [dic dictionaryObjectForKey:@"details"];
        if (details) {
            NSArray *exceptionDetails = [details arrayObjectForKey:@"exception_details"];
            if (exceptionDetails) {
                for (NSDictionary *exceptionDetail in exceptionDetails) {
                    if ([exceptionDetail isKindOfClass:NSDictionary.class]) {
                        NSError *error = [self customErrorWithExceptionDetail:exceptionDetail statusCode:statusCode];
                        if (error) {
                            return error;
                        }
                    }
                }
            }
            
            NSDictionary *exceptionDetail = [details dictionaryObjectForKey:@"exception_detail"];
            if (exceptionDetail) {
                NSError *error = [self customErrorWithExceptionDetail:exceptionDetail statusCode:statusCode];
                if (error) {
                    return error;
                }
            }
        }
    }
    
    return nil;
}

- (NSError *)customErrorWithExceptionDetail:(NSDictionary *)detail statusCode:(NSInteger)statusCode
{
    NSString *code = [detail stringObjectForKey:@"code"];
    if (code.length > 0) {
        NSString *message = [detail stringObjectForKey:@"message"];
        return [self customErrorWithExceptionCode:code message:message statusCode:statusCode];
    }
    return nil;
}

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
    // TODO
    
    return [NeroAPIError errorWithCode:NeroAPIError_Unknown description:message];
}

- (NSError *)httpErrorForStatusCode:(NSInteger)statusCode withJsonObject:(id)json
{
    if (statusCode == 503) {
        NSString *message;
        if ([json isKindOfClass:NSDictionary.class]) {
            NSDictionary *details = [((NSDictionary *)json) dictionaryObjectForKey:@"details"];
            if (details) {
                message = [details stringObjectForKey:@"message"];
            }
        }
        
        return [NeroAPIError errorWithCode:NeroAPIError_ServiceUnavailable description:message];
    }
    
    if (statusCode >= 400) {
        return [HTTPError errorWithCode:statusCode];
    }
    
    return nil;
}

@end

@implementation NeroResponseSerializer_AuthLogin

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
    if ([code isEqualToString:@"data:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Login_DataMissing description:message];
    }
    if ([code isEqualToString:@"login:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Login_NicknameMissing description:message];
    }
    if ([code isEqualToString:@"login:2"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Login_PasswordMissing description:message];
    }
    if ([code isEqualToString:@"login:3"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Login_AccountInactived description:message];
    }
    if ([code isEqualToString:@"login:4"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Login_EmailPasswordMismatched description:message];
    }
    if ([code isEqualToString:@"login:6"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Login_TOSChanged description:message];
    }
    if ([code isEqualToString:@"login:7"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Login_NotFound description:message];
    }
    
    return [super customErrorWithExceptionCode:code message:message statusCode:statusCode];
}

@end

@implementation NeroResponseSerializer_AuthRegister

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
    if ([code isEqualToString:@"register:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_NicknameMissing description:message];
    }
    if ([code isEqualToString:@"register:3"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_EmailMissing description:message];
    }
    if ([code isEqualToString:@"register:4"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_CountryMissing description:message];
    }
    if ([code isEqualToString:@"register:5"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_SecurityCodeMissing description:message];
    }
    if ([code isEqualToString:@"register:6"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_PasswordMissing description:message];
    }
    if ([code isEqualToString:@"register:7"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_ChecksumMissing description:message];
    }
    if ([code isEqualToString:@"register:8"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_ActivateFailed description:message];
    }
    if ([code isEqualToString:@"invalid:email:String:1202"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_Register_AlreadyExisted description:message];
    }
    
    return [super customErrorWithExceptionCode:code message:message statusCode:statusCode];
}

@end

@implementation NeroResponseSerializer_AuthPasswordChange

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
    if ([code isEqualToString:@"password:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordChange_OldPasswordMissing description:message];
    }
    if ([code isEqualToString:@"password:2"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordChange_NewPasswordMissing description:message];
    }
    if ([code isEqualToString:@"password:3"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordChange_NewPasswordTooShort description:message];
    }
    if ([code isEqualToString:@"password:4"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordChange_InvalidCharacters description:message];
    }
    if ([code isEqualToString:@"invalid:email:String:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordChange_EmailMissing description:message];
    }
    if ([code isEqualToString:@"user:passwordchange:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordChange_NotFound description:message];
    }
    
    return [super customErrorWithExceptionCode:code message:message statusCode:statusCode];
}

@end

@implementation NeroResponseSerializer_AuthPasswordRenew

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
    if ([code isEqualToString:@"invalid:email:String:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordRenew_EmailMissing description:message];
    }
    if ([code isEqualToString:@"user:passwordrenew:1"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_PasswordRenew_SendFailed description:message];
    }
    
    return [super customErrorWithExceptionCode:code message:message statusCode:statusCode];
}

@end

@implementation NeroResponseSerializer_UserAcceptTOS

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
    if ([code isEqualToString:@"email:missing"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_AcceptTOS_EmailMissing description:message];
    }
    if ([code isEqualToString:@"tos:missing"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_AcceptTOS_TOSMissing description:message];
    }
    if ([code isEqualToString:@"ots:invalid"]) {
        return [NeroAPIError errorWithCode:NeroAPIError_AcceptTOS_TOSInvalid description:message];
    }
    if (statusCode == 403) {
        return [NeroAPIError errorWithCode:NeroAPIError_AcceptTOS_TOSDateOld description:nil];
    }
    if (statusCode == 404) {
        return [NeroAPIError errorWithCode:NeroAPIError_AcceptTOS_NotFound description:nil];
    }
    
    return [super customErrorWithExceptionCode:code message:message statusCode:statusCode];
}

@end

@implementation NeroResponseSerializer_SubscriptionPogoplugLogin

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
    if (statusCode == 404) {
        return [NeroAPIError errorWithCode:NeroAPIError_UserHasNoPogoplugSubscription description:nil];
    }
    
    return [super customErrorWithExceptionCode:code message:message statusCode:statusCode];
}

@end

@implementation NeroResponseObject

- (id)initWithStatusCode:(NSInteger)statusCode dictionary:(NSDictionary *)dictionary;
{
    if (self = [super init]) {
        _statusCode = statusCode;
        _dictionary = dictionary;
    }
    return self;
}

- (NSInteger)code
{
    NSString *value = [self.dictionary stringObjectForKey:@"code"];
    return value.integerValue;
}

- (NSDictionary *)data
{
    return [self.dictionary dictionaryObjectForKey:@"data"];
}

- (NeroResponseObject_AccountInfo *)accountInfo
{
    NSDictionary *data = self.data;
    if (!data) {
        return nil;
    }
    
    return [[NeroResponseObject_AccountInfo alloc] initWithDictionary:data];
}

- (NeroResponseObject_PogoplugInfo *)pogoplugLoginResult
{
    NSDictionary *data = self.data;
    if (!data) {
        return nil;
    }
    
    return [[NeroResponseObject_PogoplugInfo alloc] initWithDictionary:data];
}

@end

@implementation NeroResponseObject_Data

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _dictionary = dictionary;
    }
    return self;
}

@end

@implementation NeroResponseObject_AccountInfo

- (NSString *)email
{
    return [self.dictionary stringObjectForKey:@"email"];
}

- (NSString *)firstName
{
    return [self.dictionary stringObjectForKey:@"firstname"];
}

- (NSString *)lastName
{
    return [self.dictionary stringObjectForKey:@"lastname"];
}

- (NSString *)language
{
    return [self.dictionary stringObjectForKey:@"lang"];
}

- (NSString *)country
{
    return [self.dictionary stringObjectForKey:@"country"];
}

- (NSDate *)creationDate
{
    NSString *value = [self.dictionary stringObjectForKey:@"created"];
    if (value) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+00:00"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *date = [formatter dateFromString:value];
        return date;
    }
    return nil;
}

- (NSString *)sessionID
{
    NSString *value = [self.dictionary stringObjectForKey:@"session_id"];
    if (value) {
        NSArray *components = [value componentsSeparatedByString:@"="];
        if (components.count == 2) {
            return components[1];
        }
        return value;
    }
    return nil;
}

@end

@implementation NeroResponseObject_PogoplugInfo

- (NSString *)token
{
    return [self.dictionary stringObjectForKey:@"token"];
}

- (NSString *)api_host
{
    return [self.dictionary stringObjectForKey:@"api_host"];
}

- (NSString *)webclient_url
{
    return [self.dictionary stringObjectForKey:@"webclient_url"];
}

@end
