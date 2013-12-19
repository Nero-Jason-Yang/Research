#import "NeroAPIError.h"

@implementation NeroAPIError

+ (NSString *)descriptionForCode:(NeroAPIErrorCode)code
{
    switch (code) {
        case NeroAPIError_NetworkNotAvailable:
            return @"Network not available. Please turn on Wi-Fi or enable your mobile data connection.";
        case NeroAPIError_ServiceUnavailable:
            return @"The service is temporarily unavailable due to maintenance.";
            
        case NeroAPIError_Login_DataMissing: // data:1
            return @"The request data is missing.";
        case NeroAPIError_Login_NicknameMissing: // login:1
            return @"Nickname is required but not given.";
        case NeroAPIError_Login_PasswordMissing: // login:2
            return @"Password is required but not given.";
        case NeroAPIError_Login_AccountInactived: // login:3
            return @"User account is not activated.";
        case NeroAPIError_Login_EmailPasswordMismatched: // login:4
            return @"E-mail address and password do not match.";
        case NeroAPIError_Login_TOSChanged: // login:6
            return @"Terms of use changed, need to agree to new terms of use.";
        case NeroAPIError_Login_NotFound: // login:7
            return @"A user with the given email address wasn't found.";
            
        case NeroAPIError_Register_NicknameMissing: // register:1
            return @"Nickname is required but not given.";
        case NeroAPIError_Register_EmailMissing: // register:3
            return @"Email address is required but not given.";
        case NeroAPIError_Register_CountryMissing: // register:4
            return @"Country is required but not given.";
        case NeroAPIError_Register_SecurityCodeMissing: // register:5
            return @"Security code required but not given.";
        case NeroAPIError_Register_PasswordMissing: // register:6
            return @"New password is required but not given.";
        case NeroAPIError_Register_ChecksumMissing: // register:7
            return @"Checksum is required but not given.";
        case NeroAPIError_Register_ActivateFailed: // register 8
            return @"Failed to activate account - most likely because the checksum was wrong.";
        case NeroAPIError_Register_AlreadyExisted: // invalid:email:String:1202
            return @"A user with the given email already exists.";
            
        case NeroAPIError_PasswordChange_OldPasswordMissing: // password:1
            return @"The current password is required but not given.";
        case NeroAPIError_PasswordChange_NewPasswordMissing: // password:2
            return @"A new password is required but not given.";
        case NeroAPIError_PasswordChange_NewPasswordTooShort: // password:3
            return @"The new password is too short. Password requires at least 6 characters";
        case NeroAPIError_PasswordChange_InvalidCharacters: // password:4
            return @"The new password contains invalid character(s)";
        case NeroAPIError_PasswordChange_EmailMissing: // invalid:email:String:1
            return @"Missing required element \"email\".";
        case NeroAPIError_PasswordChange_NotFound: // user:passwordchange:1
            return @"A user with the given email wasn\'t found.";
            
        case NeroAPIError_PasswordRenew_EmailMissing: // invalid:email:String:1
            return @"Missing required element \"email\".";
        case NeroAPIError_PasswordRenew_SendFailed: // user:passwordrenew:1
            return @"E-mail couldn't be send (e.g. no matching username or email address was found).";
            
        case NeroAPIError_AcceptTOS_EmailMissing: // 400 email:missing
            return @"The email field is missing or empty.";
        case NeroAPIError_AcceptTOS_TOSMissing: // 400 tos:missing
            return @"The tos field is missing or empty.";
        case NeroAPIError_AcceptTOS_TOSInvalid: // 400 ots:invalid
            return @"The given tos value isn't a valid date.";
        case NeroAPIError_AcceptTOS_TOSDateOld: // 403
            return @"The given tos date is older than the current TOS date";
        case NeroAPIError_AcceptTOS_NotFound: // 404
            return @"A user with the given email wasn't found.";
            
        case NeroAPIError_UserHasNoPogoplugSubscription:
            return @"User has no Pogoplug subscription yes.";
            
        case NeroAPIError_Unknown:
        default: return @"Unknown error.";
    }
}

+ (NSError *)errorWithCode:(NeroAPIErrorCode)code
{
    return [self errorWithCode:code description:nil info:nil];
}

+ (NSError *)errorWithCode:(NeroAPIErrorCode)code description:(NSString *)description
{
    return [self errorWithCode:code description:description info:nil];
}

+ (NSError *)errorWithCode:(NeroAPIErrorCode)code description:(NSString *)description info:(NSDictionary *)info
{
    if (0 == description.length) {
        description = [self descriptionForCode:code];
    }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:description};
    if (info) {
        NSMutableDictionary *mdic = userInfo.mutableCopy;
        [mdic addEntriesFromDictionary:info];
        userInfo = mdic;
    }
    return [NSError errorWithDomain:NeroAPIErrorDomain code:code userInfo:userInfo];
}

@end
