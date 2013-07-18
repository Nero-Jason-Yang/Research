#import <Foundation/Foundation.h>
@class HTTPRequest;

@interface HTTPResponse : NSObject
@property (nonatomic,weak) HTTPRequest *request;
@property (nonatomic) NSHTTPURLResponse *header;
@property (nonatomic) NSData *body;
@property (nonatomic) NSError *error;
- (void)decode;
@end
