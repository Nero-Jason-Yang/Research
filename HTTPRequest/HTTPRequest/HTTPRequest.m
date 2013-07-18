#import "HTTPRequest.h"
#import "HTTPTransfer.h"

@interface HTTPRequest () <HTTPTransferDelegate>

@end

@implementation HTTPRequest
{
    NSMutableURLRequest *_request;
    HTTPTransfer *_transfer;
//    __weak Task *_connTask;
    
    BOOL _cancelling;
}

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

#pragma mark task

- (void)performWithCompletion:(HTTPRequestCompletion)completion
{
    dispatch_block_t block = ^{
        [self performEncodingWithCompletion:completion];
    };
    
    TaskQueue *queue = self.encodingQueue;
    if (queue) {
        [queue addTaskWithBlock:block tags:self.tags];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
    }
}

- (void)performEncodingWithCompletion:(HTTPRequestCompletion)completion
{
    [self encode];
    
    dispatch_block_t block = ^{
        [self performTransferWithCompletion:completion];
    };
    
    TaskQueue *queue = self.transferQueue;
    if (queue) {
        [queue addTaskWithBlock:block tags:self.tags];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
    }
}

- (void)performTransferWithCompletion:(HTTPRequestCompletion)completion
{
    _transfer = [[HTTPTransfer alloc] init];
    [_transfer sendRequest:_request withCompletion:^(NSHTTPURLResponse *header, NSData *body, NSError *error) {
        // TODO
    }];
    
    dispatch_block_t block = ^{
        [self performDecodingWithCompletion:completion];
    };
    
    TaskQueue *queue = self.decodingQueue;
    if (queue) {
        [queue addTaskWithBlock:block tags:self.tags];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
    }
}

- (void)performDecodingWithCompletion:(HTTPRequestCompletion)completion
{
    // TODO
}

- (void)cancel
{
    _cancelling = YES;
    
    HTTPTransfer *transfer = _transfer;
    if (transfer) {
        [transfer cancel];
    }
}

- (void)transfer
{
}

#pragma mark major

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

#pragma mark helper

- (NSString *)contentType
{
    return [_request valueForHTTPHeaderField:@"Content-Type"];
}

- (void)setContentType:(NSString *)contentType
{
    [_request setValue:contentType forHTTPHeaderField:@"Content-Type"];
}

- (NSString *)ifModifiedSince
{
    return [self valueForHeaderField:@"If-Modified-Since"];
}

- (void)setIfModifiedSince:(NSString *)ifModifiedSince
{
    if (ifModifiedSince) {
        [self setValue:ifModifiedSince forHeaderField:@"If-Modified-Since"];
    }
    else {
        if ([self valueForHeaderField:@"If-Modified-Since"]) {
            [self setValue:nil forHeaderField:@"If-Modified-Since"];
        }
    }
}

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
