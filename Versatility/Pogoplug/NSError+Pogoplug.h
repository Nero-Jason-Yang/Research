#import <Foundation/Foundation.h>

#define ErrorDomain_Pogoplug @"Pogoplug"

@interface NSError (Pogoplug)

+ (id)pogoplugErrorWithCode:(NSInteger)code message:(NSString *)message;

@end
