#import "HTTPConnection.h"

@interface HTTPConnection () <NSURLConnectionDelegate>
{
    HTTPConnectionSendRequestCompletion _completion;
    NSURLConnection *_connection;
    NSHTTPURLResponse *_response;
    NSData *_data;
}
@end

@implementation HTTPConnection

- (NSOperationQueue *)defaultDelegateQueue
{
    static NSOperationQueue *queue;
    if (!queue) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            queue = [[NSOperationQueue alloc] init];
        });
    }
    return queue;
}

- (void)sendRequest:(NSURLRequest *)request withCompletion:(HTTPConnectionSendRequestCompletion)completion
{
    NSParameterAssert(completion);
    NSParameterAssert(!_connection);
    _completion = completion;
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection setDelegateQueue:self.delegateQueue ? self.delegateQueue : self.defaultDelegateQueue];
    [_connection start];
}

- (void)sendRequest:(NSURLRequest *)request getResponse:(NSHTTPURLResponse **)response data:(NSData **)data error:(NSError **)error
{
    __block BOOL completed = NO;
    HTTPConnectionSendRequestCompletion completion = ^(NSHTTPURLResponse *r, NSData *d, NSError *e) {
        *response = r;
        *data = d;
        *error = e;
        completed = YES;
    };
    
    [self sendRequest:request withCompletion:completion];
    
    while (!completed) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

#pragma mark <NSURLConnectionDelegate>

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSParameterAssert(response && [response isKindOfClass:[NSHTTPURLResponse class]]);
    _response = (NSHTTPURLResponse*)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSParameterAssert(data);
    if (_data) {
        NSMutableData *mdata = [_data isKindOfClass:NSMutableData.class] ? ((NSMutableData *)_data) : [NSMutableData dataWithData:_data];
        [mdata appendData:data];
        _data = mdata;
    }
    else {
        _data = data;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSParameterAssert(_response);
    _connection = nil;
    
    if (_completion) {
        _completion(_response, _data, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSParameterAssert(error);
    _connection = nil;
    
    if (_completion) {
        _completion(_response, _data, error);
    }
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}

@end
