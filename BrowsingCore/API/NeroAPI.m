#import "NeroAPI.h"
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

@interface NeroResponseObject ()
- (id)initWithDictionary:(NSDictionary *)dictionary;
@end

@interface NeroResponseObject_AccountInfo ()
@end

@implementation NeroAPI

- (id)init
{
    if (self = [super init]) {
        _baseURL = [[NSURL alloc] initWithScheme:@"http" host:@"services.my.nerobackitup.com" path:@"/api/vi"];
    }
    return self;
}

- (void)authLoginSync:(BOOL)sync email:(NSString *)email password:(NSString *)password completionHandler:(NeroAuthLoginCompletionHandler)handler
{
    NSParameterAssert(email && password && handler);
    
    NSDictionary *parameters = @{@"email":email, @"password":password};
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"auth/ncs/login"];
    CompletionWaiter *cw = [[CompletionWaiter alloc] init];
    
    NeroOperationManager *manager = [NeroOperationManager manager];
    [manager POST:url.absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // TODO
        handler(responseObject, nil);
        [cw complete];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error);
        [cw complete];
    }];
    
    if (sync) {
        [cw wait];
    }
}

- (void)subscriptionPogoplugLoginSync:(BOOL)sync completionHandler:(NeroSubscriptionPogoplugLoginCompletionHandler)handler
{
    
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
    
    // no error.
    return json;
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
    return nil;
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
        // TODO
        // return [AccountError errorWithCode:AccountError_ServiceUnavailable description:message];
        return nil;
    }
    
    // TODO
    return nil;
}

@end

@implementation NeroResponseSerializer_AuthLogin

- (NSError *)customErrorWithExceptionCode:(NSString *)code message:(NSString *)message statusCode:(NSInteger)statusCode
{
//    if ([code isEqualToString:@"data:1"]) {
//        return [AccountError errorWithCode:AccountError_Login_DataMissing description:message];
//    }
//    if ([code isEqualToString:@"login:1"]) {
//        return [AccountError errorWithCode:AccountError_Login_NicknameMissing description:message];
//    }
//    if ([code isEqualToString:@"login:2"]) {
//        return [AccountError errorWithCode:AccountError_Login_PasswordMissing description:message];
//    }
//    if ([code isEqualToString:@"login:3"]) {
//        return [AccountError errorWithCode:AccountError_Login_AccountInactived description:message];
//    }
//    if ([code isEqualToString:@"login:4"]) {
//        return [AccountError errorWithCode:AccountError_Login_EmailPasswordMismatched description:message];
//    }
//    if ([code isEqualToString:@"login:6"]) {
//        return [AccountError errorWithCode:AccountError_Login_TOSChanged description:message];
//    }
//    if ([code isEqualToString:@"login:7"]) {
//        return [AccountError errorWithCode:AccountError_Login_NotFound description:message];
//    }
//    
//    return [AccountError errorWithCode:AccountError_Unknown description:message];
    return nil;
}

@end

@implementation NeroResponseObject

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
