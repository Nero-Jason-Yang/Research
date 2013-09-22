#import <Foundation/Foundation.h>

typedef void(^HTTPConnectionSendRequestCompletion)(NSHTTPURLResponse *response, NSData *data, NSError *error);

@interface HTTPConnection : NSObject

@property (nonatomic) NSOperationQueue *delegateQueue;

- (void)sendRequest:(NSURLRequest *)request withCompletion:(HTTPConnectionSendRequestCompletion)completion;
- (void)sendRequest:(NSURLRequest *)request getResponse:(NSHTTPURLResponse **)response data:(NSData **)data error:(NSError **)error;

@end
