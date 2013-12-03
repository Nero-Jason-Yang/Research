#import "NeroJSONResponseSerializer.h"
#import "AccountError.h"

@implementation NeroJSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id json = [self jsonForData:data withResponse:response];
    if (!json) {
        return [super responseObjectForResponse:response data:data error:error];
    }
    
    NSString *message;
    NSString *code = [self exceptionCodeFromDictionary:json exceptionMessage:&message];
    if (code) {
        NSInteger statusCode = 200;
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            statusCode = ((NSHTTPURLResponse *)response).statusCode;
        }
        *error = [self errorWithStatusCode:statusCode exceptionCode:code message:message];
        return nil;
    }
    
    return json;
}

- (id)jsonForData:(NSData *)data withResponse:(NSURLResponse *)response
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

- (NSString *)exceptionCodeFromDictionary:(id)dic exceptionMessage:(NSString **)exceptionMessage
{
    if (![dic isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    NSDictionary *details = [dic objectForKey:@"details"];
    if (![details isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    NSArray *exceptionDetails = [details objectForKey:@"exception_details"];
    if (![exceptionDetails isKindOfClass:NSArray.class]) {
        return nil;
    }
    
    for (NSDictionary *exceptionDetail in exceptionDetails) {
        if ([exceptionDetail isKindOfClass:NSDictionary.class]) {
            NSString *exceptionCode = [exceptionDetail objectForKey:@"code"];
            if ([exceptionCode isKindOfClass:NSString.class] && exceptionCode.length > 0) {
                if (exceptionMessage) {
                    NSString *message = [exceptionDetail objectForKey:@"message"];
                    if (![message isKindOfClass:NSString.class]) {
                        message = @"";
                    }
                    *exceptionMessage = message;
                }
                return exceptionCode;
            }
        }
    }
    return nil;
}

- (NSError *)errorWithStatusCode:(NSInteger)statusCode exceptionCode:(NSString *)code message:(NSString *)message
{
    return [AccountError errorWithCode:AccountError_Unknown description:message];
}

@end

@implementation NeroLoginResponseSerializer

- (NSError *)errorWithStatusCode:(NSInteger)statusCode exceptionCode:(NSString *)code message:(NSString *)message
{
    if ([code isEqualToString:@"data:1"]) {
        return [AccountError errorWithCode:AccountError_Login_DataMissing description:message];
    }
    if ([code isEqualToString:@"login:1"]) {
        return [AccountError errorWithCode:AccountError_Login_NicknameMissing description:message];
    }
    if ([code isEqualToString:@"login:2"]) {
        return [AccountError errorWithCode:AccountError_Login_PasswordMissing description:message];
    }
    if ([code isEqualToString:@"login:3"]) {
        return [AccountError errorWithCode:AccountError_Login_AccountInactived description:message];
    }
    if ([code isEqualToString:@"login:4"]) {
        return [AccountError errorWithCode:AccountError_Login_EmailPasswordMismatched description:message];
    }
    if ([code isEqualToString:@"login:6"]) {
        return [AccountError errorWithCode:AccountError_Login_TOSChanged description:message];
    }
    if ([code isEqualToString:@"login:7"]) {
        return [AccountError errorWithCode:AccountError_Login_NotFound description:message];
    }
    
    return [AccountError errorWithCode:AccountError_Unknown description:message];
}

@end

@implementation NeroRegisterResponseSerializer

- (NSError *)errorWithStatusCode:(NSInteger)statusCode exceptionCode:(NSString *)code message:(NSString *)message
{
    if ([code isEqualToString:@"register:1"]) {
        return [AccountError errorWithCode:AccountError_Register_NicknameMissing description:message];
    }
    if ([code isEqualToString:@"register:3"]) {
        return [AccountError errorWithCode:AccountError_Register_EmailMissing description:message];
    }
    if ([code isEqualToString:@"register:4"]) {
        return [AccountError errorWithCode:AccountError_Register_CountryMissing description:message];
    }
    if ([code isEqualToString:@"register:5"]) {
        return [AccountError errorWithCode:AccountError_Register_SecurityCodeMissing description:message];
    }
    if ([code isEqualToString:@"register:6"]) {
        return [AccountError errorWithCode:AccountError_Register_PasswordMissing description:message];
    }
    if ([code isEqualToString:@"register:7"]) {
        return [AccountError errorWithCode:AccountError_Register_ChecksumMissing description:message];
    }
    if ([code isEqualToString:@"register:8"]) {
        return [AccountError errorWithCode:AccountError_Register_ActivateFailed description:message];
    }
    if ([code isEqualToString:@"invalid:email:String:1202"]) {
        return [AccountError errorWithCode:AccountError_Register_AlreadyExisted description:message];
    }
    
    return [AccountError errorWithCode:AccountError_Unknown description:message];
}

@end

@implementation NeroPasswordChangeResponseSerializer

- (NSError *)errorWithStatusCode:(NSInteger)statusCode exceptionCode:(NSString *)code message:(NSString *)message
{
    if ([code isEqualToString:@"password:1"]) {
        return [AccountError errorWithCode:AccountError_PasswordChange_OldPasswordMissing description:message];
    }
    if ([code isEqualToString:@"password:2"]) {
        return [AccountError errorWithCode:AccountError_PasswordChange_NewPasswordMissing description:message];
    }
    if ([code isEqualToString:@"password:3"]) {
        return [AccountError errorWithCode:AccountError_PasswordChange_NewPasswordTooShort description:message];
    }
    if ([code isEqualToString:@"password:4"]) {
        return [AccountError errorWithCode:AccountError_PasswordChange_InvalidCharacters description:message];
    }
    if ([code isEqualToString:@"invalid:email:String:1"]) {
        return [AccountError errorWithCode:AccountError_PasswordChange_EmailMissing description:message];
    }
    if ([code isEqualToString:@"user:passwordchange:1"]) {
        return [AccountError errorWithCode:AccountError_PasswordChange_NotFound description:message];
    }
    
    return [AccountError errorWithCode:AccountError_Unknown description:message];
}

@end

@implementation NeroPasswordRenewResponseSerializer

- (NSError *)errorWithStatusCode:(NSInteger)statusCode exceptionCode:(NSString *)code message:(NSString *)message
{
    if ([code isEqualToString:@"invalid:email:String:1"]) {
        return [AccountError errorWithCode:AccountError_PasswordRenew_EmailMissing description:message];
    }
    if ([code isEqualToString:@"user:passwordrenew:1"]) {
        return [AccountError errorWithCode:AccountError_PasswordRenew_SendFailed description:message];
    }
    
    return [AccountError errorWithCode:AccountError_Unknown description:message];
}

@end

@implementation NeroAcceptTOSResponseSerializer

- (NSError *)errorWithStatusCode:(NSInteger)statusCode exceptionCode:(NSString *)code message:(NSString *)message
{
    if ([code isEqualToString:@"email:missing"]) {
        return [AccountError errorWithCode:AccountError_AcceptTOS_EmailMissing description:message];
    }
    if ([code isEqualToString:@"tos:missing"]) {
        return [AccountError errorWithCode:AccountError_AcceptTOS_TOSMissing description:message];
    }
    if ([code isEqualToString:@"ots:invalid"]) {
        return [AccountError errorWithCode:AccountError_AcceptTOS_TOSInvalid description:message];
    }
    if (statusCode == 403) {
        return [AccountError errorWithCode:AccountError_AcceptTOS_TOSDateOld description:nil];
    }
    if (statusCode == 404) {
        return [AccountError errorWithCode:AccountError_AcceptTOS_NotFound description:nil];
    }
    
    return [AccountError errorWithCode:AccountError_Unknown description:message];
}

@end
