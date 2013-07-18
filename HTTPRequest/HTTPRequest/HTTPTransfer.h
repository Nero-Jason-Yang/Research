#import <Foundation/Foundation.h>

@class HTTPTransfer;
@protocol HTTPTransferDelegate <NSObject>
- (void)transfer:(HTTPTransfer *)transfer didFinishWithHeader:(NSHTTPURLResponse *)header body:(NSData *)body error:(NSError *)error;
@end

typedef void(^HTTPTransferCompletion)(NSHTTPURLResponse *header, NSData *body, NSError *error);

@interface HTTPTransfer : NSObject
- (void)sendRequest:(NSURLRequest *)request withDelegate:(id<HTTPTransferDelegate>)delegate;
- (void)sendRequest:(NSURLRequest *)request withCompletion:(HTTPTransferCompletion)completion;
- (void)cancel;
@end
