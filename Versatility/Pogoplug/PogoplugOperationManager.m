#import "PogoplugOperationManager.h"
#import "NSError+Core.h"
#import "NSError+Pogoplug.h"

@implementation PogoplugOperationManager

+ (id)managerWithBaseURL:(NSURL *)baseURL
{
    PogoplugOperationManager *manager = [[PogoplugOperationManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [PogoplugJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    return manager;
}

- (id)POST:(NSString *)URLString parameters:(NSDictionary *)parameters operation:(AFHTTPRequestOperation **)operation error:(NSError **)error
{
    return [self send:URLString method:@"POST" parameters:parameters data:nil serializer:nil operation:operation error:error];
}

- (id) GET:(NSString *)URLString parameters:(NSDictionary *)parameters operation:(AFHTTPRequestOperation **)operation error:(NSError **)error
{
    return [self send:URLString method:@"GET" parameters:parameters data:nil serializer:nil operation:operation error:error];
}

- (id) PUT:(NSString *)URLString parameters:(NSDictionary *)parameters data:(NSData *)data operation:(AFHTTPRequestOperation **)operation error:(NSError **)error
{
    return [self send:URLString method:@"PUT" parameters:parameters data:data serializer:nil operation:operation error:error];
}

- (BOOL)uploadData:(NSData *)data withPath:(NSString *)path parameters:(NSDictionary *)parameters error:(NSError **)error
{
    NSError *responseError;
    AFHTTPRequestOperation *operation;
    [self send:path method:@"PUT" parameters:parameters data:data serializer:nil operation:&operation error:&responseError];
    if (responseError) {
        *error = responseError;
        return NO;
    }
    if (operation.response.statusCode != 200) {
        // TODO
        return NO;
    }
    return YES;
}

- (UIImage *)imageWithPath:(NSString *)path parameters:(NSDictionary *)parameters operation:(AFHTTPRequestOperation **)operation error:(NSError **)error
{
    AFImageResponseSerializer *serializer = [AFImageResponseSerializer serializer];
    return [self send:path method:@"GET" parameters:parameters data:nil serializer:serializer operation:operation error:error];
}

#pragma mark internal

- (id)send:(NSString *)URLString method:(NSString *)method parameters:(NSDictionary *)parameters data:(NSData *)data serializer:(AFHTTPResponseSerializer *)serializer operation:(AFHTTPRequestOperation **)operation error:(NSError **)error
{
    __block AFHTTPRequestOperation *block_operation;
    __block id block_object;
    __block NSError *block_error;
    __block BOOL completed = NO;
    NSCondition *condition = [[NSCondition alloc] init];
    
    id success = ^(AFHTTPRequestOperation *requestOperation, id responseObject) {
        block_operation = requestOperation;
        block_object = responseObject;
        completed = YES;
        [condition signal];
    };
    
    id failure = ^(AFHTTPRequestOperation *requestOperation, NSError *responseError) {
        block_operation = requestOperation;
        NSParameterAssert(responseError);
        block_error = responseError;
        completed = YES;
        [condition signal];
    };
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters];
    if (data) {
        [request setHTTPBody:data];
    }
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    if (serializer) {
        requestOperation.responseSerializer = serializer;
    }
    [self.operationQueue addOperation:requestOperation];
    
    [condition lock];
    while (!completed) {
        [condition wait];
    }
    [condition unlock];
    
    NSParameterAssert(block_operation == requestOperation);
    if (block_object) {
        block_object = [self checkPogoplugExceptionWithObject:block_object operation:block_operation error:&block_error];
    }
    
    if (operation) {
        *operation = block_operation;
    }
    if (error) {
        *error = block_error;
    }
    return block_object;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:request success:success failure:failure];
    operation.completionQueue = self.completionQueue;
    return operation;
}

- (id)checkPogoplugExceptionWithObject:(id)object operation:(AFHTTPRequestOperation *)operation error:(NSError **)error
{
    if ([object isKindOfClass:NSDictionary.class]) {
        NSDictionary *dic = object;
        NSDictionary *exception = [dic objectForKey:@"HB-EXCEPTION"];
        if ([exception isKindOfClass:NSDictionary.class]) {
            NSString *ecode = [exception objectForKey:@"ecode"];
            NSString *message = [exception objectForKey:@"message"];
            if (error) {
                *error = [NSError pogoplugErrorWithCode:ecode.integerValue message:message];
            }
            return nil;
        }
    }
    
    if (operation.response.statusCode >= 500) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: %@ (%d)", @"AFNetworking", nil), [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode], operation.response.statusCode], NSURLErrorFailingURLErrorKey:[operation.response URL], AFNetworkingOperationFailingURLResponseErrorKey: operation.response};
        if (error) {
            *error = [[NSError alloc] initWithDomain:AFNetworkingErrorDomain code:NSURLErrorBadServerResponse userInfo:userInfo];
        }
        return nil;
    }
    
    return object;
}

@end
