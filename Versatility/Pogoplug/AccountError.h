#import <Foundation/Foundation.h>

#define ErrorDomain_Account @"Account"

typedef enum : int32_t {
    AccountError_Unknown = 0,
    AccountError_NetworkNotAvailable,
    
    AccountError_Login_DataMissing,
    AccountError_Login_NicknameMissing,
    AccountError_Login_PasswordMissing,
    AccountError_Login_AccountInactived,
    AccountError_Login_EmailPasswordMismatched,
    AccountError_Login_TOSChanged,
    AccountError_Login_NotFound,
    
    AccountError_Register_NicknameMissing,
    AccountError_Register_EmailMissing,
    AccountError_Register_CountryMissing,
    AccountError_Register_SecurityCodeMissing,
    AccountError_Register_PasswordMissing,
    AccountError_Register_ChecksumMissing,
    AccountError_Register_ActivateFailed,
    AccountError_Register_AlreadyExisted,
    
    AccountError_PasswordChange_OldPasswordMissing,
    AccountError_PasswordChange_NewPasswordMissing,
    AccountError_PasswordChange_NewPasswordTooShort,
    AccountError_PasswordChange_InvalidCharacters,
    AccountError_PasswordChange_EmailMissing,
    AccountError_PasswordChange_NotFound,
    
    AccountError_PasswordRenew_EmailMissing,
    AccountError_PasswordRenew_SendFailed,
    
    AccountError_AcceptTOS_EmailMissing,
    AccountError_AcceptTOS_TOSMissing,
    AccountError_AcceptTOS_TOSInvalid,
    AccountError_AcceptTOS_TOSDateOld,
    AccountError_AcceptTOS_NotFound,
    
} AccountErrorCode;

@interface AccountError : NSError

+ (NSError *)errorWithCode:(AccountErrorCode)code description:(NSString *)description;

@end
