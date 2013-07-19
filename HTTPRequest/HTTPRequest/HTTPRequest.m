#import "HTTPRequest.h"
#import "HTTPTransfer.h"

#define KEY_HTTPHeaderField_ContentType @"Content-Type"
#define KEY_HTTPHeaderField_IfModifiedSince @"If-Modified-Since"

@interface HTTPRequest () <HTTPTransferDelegate>
{
    NSMutableURLRequest *_request;
    HTTPRequestCompletion _completion;
    HTTPTransfer *_transfer;
    BOOL _cancelled;
}
@end

@implementation HTTPRequest

- (Class)responseClass
{
    return HTTPResponse.class;
}

- (id)init
{
    if (self = [super init]) {
        _request = [[NSMutableURLRequest alloc] init];
    }
    return self;
}

#pragma mark - task

- (void)performWithCompletion:(HTTPRequestCompletion)completion
{
    NSParameterAssert(completion);
    NSParameterAssert(!_completion);
    _completion = completion;
    _cancelled = NO;
    _response = nil;
    
    dispatch_block_t block = ^{
        [self performEncoding];
    };
    
    TaskQueue *queue = self.encodingQueue;
    if (queue) {
        [queue addTaskWithBlock:block tags:self.tags];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
    }
}

- (void)performEncoding
{
    if ([self checkCancelling]) {
        return;
    }
    
    [self encode];
    
    [self didFinishPerformEncoding];
}

- (void)didFinishPerformEncoding
{
    AsyncBlock block = ^(dispatch_block_t completion){
        [self performTransferWithCompletion:completion];
    };
    
    TaskQueue *queue = self.transferQueue;
    if (queue) {
        [queue addTaskWithAsyncBlock:block tags:self.tags];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            block(nil);
        });
    }
}

- (void)performTransferWithCompletion:(dispatch_block_t)transferCompletion
{
    if ([self checkCancelling]) {
        transferCompletion();
        return;
    }
    
    _transfer = [[HTTPTransfer alloc] init];
    [_transfer sendRequest:_request withCompletion:^(NSHTTPURLResponse *header, NSData *body, NSError *error) {
        transferCompletion();
        
        HTTPResponse *response = [[self.responseClass alloc] init];
        response.request = self;
        response.header = header;
        response.body = body;
        response.error = error;
        
        [self didFinishPerformTransferWithResponse:response];
    }];
}

- (void)didFinishPerformTransferWithResponse:(HTTPResponse *)response
{
    _transfer = nil;
    
    dispatch_block_t block = ^{
        [self performDecodingWithResponse:response];
    };
    
    TaskQueue *queue = self.decodingQueue;
    if (queue) {
        [queue addTaskWithBlock:block tags:self.tags];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
    }
}

- (void)performDecodingWithResponse:(HTTPResponse *)response
{
    if ([self checkCancelling]) {
        return;
    }
    
    [response decode];
    
    _response = response;
    _completion(response);
}

- (void)cancel
{
    _cancelled = YES;
    
    HTTPTransfer *transfer = _transfer;
    if (transfer) {
        [transfer cancel];
    }
}

- (BOOL)checkCancelling
{
    if (_cancelled) {
        HTTPResponse *response = [[self.responseClass alloc] init];
        response.error = nil;
        
        NSParameterAssert(_completion);
        _completion(response);
        return YES;
    }
    
    return NO;
}

#pragma mark - major

- (NSURL *)url
{
    return _request.URL;
}

- (void)setUrl:(NSURL *)url
{
    _request.URL = url;
}

- (NSString *)method
{
    return _request.HTTPMethod;
}

- (void)setMethod:(NSString *)method
{
    _request.HTTPMethod = method;
}

- (NSData *)body
{
    return _request.HTTPBody;
}

- (void)setBody:(NSData *)body
{
    _request.HTTPBody = body;
}

- (NSTimeInterval)timeoutInterval
{
    return _request.timeoutInterval;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    [_request setTimeoutInterval:timeoutInterval];
}

- (NSString *)valueForHeaderField:(NSString *)field
{
    return [_request valueForHTTPHeaderField:field];
}

- (void)setValue:(NSString *)value forHeaderField:(NSString *)field
{
    [_request setValue:value forHTTPHeaderField:field];
}

- (void)encode
{
    // should be override
}

#pragma mark - helper

- (NSString *)stringBody
{
    NSData *data = self.body;
    return data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
}

- (void)setStringBody:(NSString *)stringBody
{
    NSData *data = stringBody ? [stringBody dataUsingEncoding:NSUTF8StringEncoding] : nil;
    self.body = data;
}

- (NSString *)contentType
{
    return [_request valueForHTTPHeaderField:KEY_HTTPHeaderField_ContentType];
}

- (void)setContentType:(NSString *)contentType
{
    [_request setValue:contentType forHTTPHeaderField:KEY_HTTPHeaderField_ContentType];
}

- (NSString *)ifModifiedSince
{
    return [self valueForHeaderField:KEY_HTTPHeaderField_IfModifiedSince];
}

- (void)setIfModifiedSince:(NSString *)ifModifiedSince
{
    if (ifModifiedSince) {
        [self setValue:ifModifiedSince forHeaderField:KEY_HTTPHeaderField_IfModifiedSince];
    }
    else {
        if ([self valueForHeaderField:KEY_HTTPHeaderField_IfModifiedSince]) {
            [self setValue:nil forHeaderField:KEY_HTTPHeaderField_IfModifiedSince];
        }
    }
}

#pragma mark -

#pragma mark <HTTPConnectionDelegate>

- (void)transfer:(HTTPTransfer *)transfer didFinishWithHeader:(NSHTTPURLResponse *)header body:(NSData *)body error:(NSError *)error
{
    _transfer = nil;
    
    HTTPResponse *response = [[self.responseClass alloc] init];
    response.request = self;
    response.header = header;
    response.body = body;
    response.error = error;
    
    // TODO
}

@end
