#import "HTTPResponse.h"

#define KEY_HTTPHeaderField_LastModified @"Last-Modified"
#define KEY_HTTPHeaderField_ETag @"ETag"

@implementation HTTPResponse

- (void)decode
{
    
}

- (BOOL)success
{
    if (self.error) {
        return NO;
    }
    
    if (!self.header) {
        return NO;
    }
    
    NSInteger statusCode = self.header.statusCode;
    if (statusCode >= 400 || statusCode < 200) {
        return NO;
    }
    
    return YES;
}

- (NSString *)lastModified
{
    return [self.header.allHeaderFields objectForKey:KEY_HTTPHeaderField_LastModified];
}

- (NSString *)etag
{
    return [self.header.allHeaderFields objectForKey:KEY_HTTPHeaderField_ETag];
}

@end
