#import "HTTPRequest.h"
#import "HTTPTransfer.h"

#define KEY_HTTPHeaderField_ContentType @"Content-Type"
#define KEY_HTTPHeaderField_IfModifiedSince @"If-Modified-Since"
#define KEY_HTTPHeaderField_IfNoneMatch @"If-None-Match"

@interface HTTPRequest () <HTTPTransferDelegate>
{
    NSMutableURLRequest *_request;
    HTTPRequestCompletion _completion;
    HTTPTransfer *_transfer;
    BOOL _cancelling;
}
@end

@implementation HTTPRequest

// the global performing request list
+ (NSMutableSet *)requests
{
    static NSMutableSet *set = nil;
    if (!set) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            set = [NSMutableSet set];
        });
    }
    return set;
}

// sub-classes derived from HTTPRequest should override this method to specify correct response-class
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

- (NSOperationQueue *)connectionQueue
{
    if (_connectionQueue) {
        return _connectionQueue;
    }
    return [HTTPTransfer connectionQueue];
}

- (void)performWithCompletion:(HTTPRequestCompletion)completion
{
    NSParameterAssert(completion);
    
    // start performing
    NSMutableSet *requests = [HTTPRequest requests];
    @synchronized(requests) {
        if ([requests containsObject:self]) {
            NSAssert(0, @"request is still under performing");
            completion(self.responseForCancelling); // cancelled
            return;
        }
        [requests addObject:self];
    }
    
    // prepare
    _completion = completion;
    _cancelling = NO;
    _transfer = nil;
    _response = nil;
    
    // perform now
    
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
    if ([self checkCancelling]) {
        return;
    }
    
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
        if (transferCompletion) {
            transferCompletion();
        }
        return;
    }
    
    _transfer = [[HTTPTransfer alloc] init];
    _transfer.connectionQueue = self.connectionQueue;
    [_transfer sendRequest:_request withCompletion:^(NSHTTPURLResponse *header, NSData *body, NSError *error) {
        if (transferCompletion) {
            transferCompletion();
        }
        
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
    
    if ([self checkCancelling]) {
        return;
    }
    
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
    
    [self didFinishPerformWithResponse:response];
}

- (void)didFinishPerformWithResponse:(HTTPResponse *)response
{
    // complete performing
    NSParameterAssert(_completion);
    _response = response;
    if (_completion) {
        _completion(response);
        _completion = nil;
    }
    _cancelling = NO;
    
    // end performing
    NSMutableSet *requests = [HTTPRequest requests];
    @synchronized(requests) {
        NSAssert([requests containsObject:self], @"the finished request must exist in the global list before end it");
        [requests removeObject:self];
    }
}

- (void)cancel
{
    _cancelling = YES;
    
    HTTPTransfer *transfer = _transfer;
    if (transfer) {
        [transfer cancel];
    }
}

- (BOOL)checkCancelling
{
    if (_cancelling) {
        [self didFinishPerformWithResponse:self.responseForCancelling];
        return YES;
    }
    
    return NO;
}

- (HTTPResponse *)responseForCancelling
{
    HTTPResponse *response = [[self.responseClass alloc] init];
    response.error = [NSError errorWithDomain:HTTPRequestErrorDomain code:HTTPRequestErrorCode_Cancelling userInfo:nil];
    return response;
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

- (NSString *)ifNoneMatch
{
    return [self valueForHeaderField:KEY_HTTPHeaderField_IfNoneMatch];
}

- (void)setIfNoneMatch:(NSString *)ifNoneMatch
{
    if (ifNoneMatch) {
        [self setValue:ifNoneMatch forHeaderField:KEY_HTTPHeaderField_IfNoneMatch];
    }
    else {
        if ([self valueForHeaderField:KEY_HTTPHeaderField_IfNoneMatch]) {
            [self setValue:nil forHeaderField:KEY_HTTPHeaderField_IfNoneMatch];
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
