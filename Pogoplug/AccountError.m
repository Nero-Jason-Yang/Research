#import "AccountError.h"

@implementation AccountError

+ (NSString *)descriptionForCode:(AccountErrorCode)code
{
    switch (code) {
        case AccountError_NetworkNotAvailable:
            return @"Network not available. Please turn on Wi-Fi or enable your mobile data connection.";
            
        case AccountError_Login_DataMissing: // data:1
            return @"The request data is missing.";
        case AccountError_Login_NicknameMissing: // login:1
            return @"Nickname is required but not given.";
        case AccountError_Login_PasswordMissing: // login:2
            return @"Password is required but not given.";
        case AccountError_Login_AccountInactived: // login:3
            return @"User account is not activated.";
        case AccountError_Login_EmailPasswordMismatched: // login:4
            return @"E-mail address and password do not match.";
        case AccountError_Login_TOSChanged: // login:6
            return @"Terms of use changed, need to agree to new terms of use.";
        case AccountError_Login_NotFound: // login:7
            return @"A user with the given email address wasn't found.";
            
        case AccountError_Register_NicknameMissing: // register:1
            return @"Nickname is required but not given.";
        case AccountError_Register_EmailMissing: // register:3
            return @"Email address is required but not given.";
        case AccountError_Register_CountryMissing: // register:4
            return @"Country is required but not given.";
        case AccountError_Register_SecurityCodeMissing: // register:5
            return @"Security code required but not given.";
        case AccountError_Register_PasswordMissing: // register:6
            return @"New password is required but not given.";
        case AccountError_Register_ChecksumMissing: // register:7
            return @"Checksum is required but not given.";
        case AccountError_Register_ActivateFailed: // register 8
            return @"Failed to activate account - most likely because the checksum was wrong.";
        case AccountError_Register_AlreadyExisted: // invalid:email:String:1202
            return @"A user with the given email already exists.";
            
        case AccountError_PasswordChange_OldPasswordMissing: // password:1
            return @"The current password is required but not given.";
        case AccountError_PasswordChange_NewPasswordMissing: // password:2
            return @"A new password is required but not given.";
        case AccountError_PasswordChange_NewPasswordTooShort: // password:3
            return @"The new password is too short. Password requires at least 6 characters";
        case AccountError_PasswordChange_InvalidCharacters: // password:4
            return @"The new password contains invalid character(s)";
        case AccountError_PasswordChange_EmailMissing: // invalid:email:String:1
            return @"Missing required element \"email\".";
        case AccountError_PasswordChange_NotFound: // user:passwordchange:1
            return @"A user with the given email wasn\'t found.";

        case AccountError_PasswordRenew_EmailMissing: // invalid:email:String:1
            return @"Missing required element \"email\".";
        case AccountError_PasswordRenew_SendFailed: // user:passwordrenew:1
            return @"E-mail couldn't be send (e.g. no matching username or email address was found).";
            
        case AccountError_AcceptTOS_EmailMissing: // 400 email:missing
            return @"The email field is missing or empty.";
        case AccountError_AcceptTOS_TOSMissing: // 400 tos:missing
            return @"The tos field is missing or empty.";
        case AccountError_AcceptTOS_TOSInvalid: // 400 ots:invalid
            return @"The given tos value isn't a valid date.";
        case AccountError_AcceptTOS_TOSDateOld: // 403
            return @"The given tos date is older than the current TOS date";
        case AccountError_AcceptTOS_NotFound: // 404
            return @"A user with the given email wasn't found.";
            
        case AccountError_Unknown:
        default: return @"Unknown error.";
    }
}

+ (NSError *)errorWithCode:(AccountErrorCode)code description:(NSString *)description
{
    if (0 == description.length) {
        description = [self descriptionForCode:code];
    }
    NSDictionary *info = @{NSLocalizedDescriptionKey:description};
    return [NSError errorWithDomain:ErrorDomain_Account code:code userInfo:info];
}

@end
