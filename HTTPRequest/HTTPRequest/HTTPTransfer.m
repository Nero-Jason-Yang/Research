#import "HTTPTransfer.h"

@interface HTTPTransfer () <NSURLConnectionDelegate>
{
    __weak id<HTTPTransferDelegate> _delegate;
    HTTPTransferCompletion _completion;
    
    NSHTTPURLResponse *_response;
    NSMutableData *_data;
    
    NSURLConnection *_connection;
}
@end

@implementation HTTPTransfer

- (void)sendRequest:(NSURLRequest *)request withDelegate:(id<HTTPTransferDelegate>)delegate
{
    NSParameterAssert(!_connection);
    _delegate = delegate;
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection start];
}

- (void)sendRequest:(NSURLRequest *)request withCompletion:(HTTPTransferCompletion)completion
{
    NSParameterAssert(!_connection);
    _completion = completion;
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection start];
}

- (void)cancel
{
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
    _delegate = nil;
    _completion = nil;
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSParameterAssert(response && [response isKindOfClass:[NSHTTPURLResponse class]]);
    _response = (NSHTTPURLResponse*)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSParameterAssert(data);
    if (!_data) {
        _data = [NSMutableData dataWithData:data];
    }
    else {
        [_data appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSParameterAssert(_response);
    _connection = nil;
    if (_delegate) {
        [_delegate transfer:self didFinishWithHeader:_response body:_data error:nil];
        _delegate = nil;
    }
    if (_completion) {
        _completion(_response, _data, nil);
        _completion = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSParameterAssert(error);
    _connection = nil;
    if (_delegate) {
        [_delegate transfer:self didFinishWithHeader:_response body:_data error:error];
        _delegate = nil;
    }
    if (_completion) {
        _completion(_response, _data, error);
        _completion = nil;
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
