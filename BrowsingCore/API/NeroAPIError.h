#import <Foundation/Foundation.h>

#define NeroAPIErrorDomain @"NeroAPI"

typedef enum : int32_t {
    NeroAPIError_Unknown = 0,
    NeroAPIError_NetworkNotAvailable,
    NeroAPIError_ServiceUnavailable,
    
    NeroAPIError_Login_DataMissing,
    NeroAPIError_Login_NicknameMissing,
    NeroAPIError_Login_PasswordMissing,
    NeroAPIError_Login_AccountInactived,
    NeroAPIError_Login_EmailPasswordMismatched,
    NeroAPIError_Login_TOSChanged,
    NeroAPIError_Login_NotFound,
    
    NeroAPIError_Register_NicknameMissing,
    NeroAPIError_Register_EmailMissing,
    NeroAPIError_Register_CountryMissing,
    NeroAPIError_Register_SecurityCodeMissing,
    NeroAPIError_Register_PasswordMissing,
    NeroAPIError_Register_ChecksumMissing,
    NeroAPIError_Register_ActivateFailed,
    NeroAPIError_Register_AlreadyExisted,
    
    NeroAPIError_PasswordChange_OldPasswordMissing,
    NeroAPIError_PasswordChange_NewPasswordMissing,
    NeroAPIError_PasswordChange_NewPasswordTooShort,
    NeroAPIError_PasswordChange_InvalidCharacters,
    NeroAPIError_PasswordChange_EmailMissing,
    NeroAPIError_PasswordChange_NotFound,
    
    NeroAPIError_PasswordRenew_EmailMissing,
    NeroAPIError_PasswordRenew_SendFailed,
    
    NeroAPIError_AcceptTOS_EmailMissing,
    NeroAPIError_AcceptTOS_TOSMissing,
    NeroAPIError_AcceptTOS_TOSInvalid,
    NeroAPIError_AcceptTOS_TOSDateOld,
    NeroAPIError_AcceptTOS_NotFound,
    
    NeroAPIError_UserHasNoPogoplugSubscription,
} NeroAPIErrorCode;

@interface NeroAPIError : NSError
+ (NSError *)errorWithCode:(NeroAPIErrorCode)code;
+ (NSError *)errorWithCode:(NeroAPIErrorCode)code description:(NSString *)description;
+ (NSError *)errorWithCode:(NeroAPIErrorCode)code description:(NSString *)description info:(NSDictionary *)info;
@end
