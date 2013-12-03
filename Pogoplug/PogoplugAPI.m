#import "PogoplugAPI.h"
#import "PogoplugOperationManager.h"
#import "PogoplugResponse.h"
#import "AFNetworking.h"

@interface PogoplugAPI ()
@property (nonatomic) NSString *deviceID;
@property (nonatomic) NSString *serviceID;
@end

@implementation PogoplugAPI

- (NSString *)host
{
    return @"services.my.nerobackitup.com";
}

- (BOOL)loginWithUsername:(NSString *)username password:(NSString *)password error:(NSError **)error
{
    if (![self loginNeroWithUsername:username password:password error:error]) {
        return NO;
    }
    
    if (![self loginPogoWithError:error]) {
        return NO;
    }
    
    if (![self prepare:error]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)loginNeroWithUsername:(NSString *)username password:(NSString *)password error:(NSError **)error
{
    NSParameterAssert(username && password && error);
    NSDictionary *loginParameters = @{@"email":username, @"password":password};
    NSURL *baseURL = [[NSURL alloc] initWithScheme:@"http" host:self.host path:@"/"];
    PogoplugOperationManager *manager = [PogoplugOperationManager managerWithBaseURL:baseURL];
    NSDictionary *json = [manager POST:@"/api/v1/auth/ncs/login" parameters:loginParameters operation:nil error:error];
    if (!json) {
        return NO;
    }
    
    if ([json isKindOfClass:NSDictionary.class]) {
        NSString *code = [json objectForKey:@"code"];
        NSParameterAssert(code.integerValue == 200);
        NSDictionary *data = [json objectForKey:@"data"];
        if ([data isKindOfClass:NSDictionary.class]) {
            
        }
    }
    
    return YES;
}

- (BOOL)loginPogoWithError:(NSError **)error
{
    NSParameterAssert(error);
    NSURL *baseURL = [[NSURL alloc] initWithScheme:@"http" host:self.host path:@"/"];
    PogoplugOperationManager *manager = [PogoplugOperationManager managerWithBaseURL:baseURL];
    NSDictionary *json = [manager POST:@"/api/v1/subscriptions/pogoplug/login" parameters:nil operation:nil error:error];
    if (!json) {
        return NO;
    }
    
    if ([json isKindOfClass:NSDictionary.class]) {
        NSString *code = [json objectForKey:@"code"];
        NSParameterAssert(code.integerValue == 200);
        NSDictionary *data = [json objectForKey:@"data"];
        if ([data isKindOfClass:NSDictionary.class]) {
            NSString *apiHost = [data objectForKey:@"api_host"];
            NSParameterAssert([apiHost isKindOfClass:NSString.class]);
            NSString *token = [data objectForKey:@"token"];
            NSParameterAssert([token isKindOfClass:NSString.class]);
            NSString *webClientURL = [data objectForKey:@"webclient_url"];
            NSParameterAssert([webClientURL isKindOfClass:NSString.class]);
            
            self.baseURL = [NSURL URLWithString:apiHost];
            self.token = token;
        }
    }
    
    return YES;
}

- (BOOL)prepare:(NSError **)error
{
    NSParameterAssert(error);
    PogoplugOperationManager *manager = [PogoplugOperationManager managerWithBaseURL:self.baseURL];
    NSDictionary *json = [manager GET:@"/svc/api/listDevices" parameters:@{@"valtoken":self.token} operation:nil error:error];
    if (!json) {
        return NO;
    }
    
    if ([json isKindOfClass:NSDictionary.class]) {
        NSArray *devices = [json objectForKey:@"devices"];
        if ([devices isKindOfClass:NSArray.class]) {
            for (NSDictionary *device in devices) {
                if ([device isKindOfClass:NSDictionary.class]) {
                    NSString *deviceID = [device objectForKey:@"deviceid"];
                    if (deviceID) {
                        NSArray *services = [device objectForKey:@"services"];
                        if ([services isKindOfClass:NSArray.class]) {
                            for (NSDictionary *service in services) {
                                if ([service isKindOfClass:NSDictionary.class]) {
                                    NSString *serviceID = [service objectForKey:@"serviceid"];
                                    if (serviceID) {
                                        self.serviceID = serviceID;
                                        break;
                                    }
                                }
                            }
                        }
                        self.deviceID = deviceID;
                        break;
                    }
                }
            }
        }
    }
    
    return YES;
}

- (NSString *)createFileWithParentID:(NSString *)parentID fileName:(NSString *)fileName error:(NSError **)error
{
    NSParameterAssert(error);
    
    NSParameterAssert(self.token && self.deviceID && self.serviceID);
    NSMutableDictionary *parameters = @{@"valtoken":self.token, @"deviceid":self.deviceID, @"serviceid":self.serviceID}.mutableCopy;
    
    NSParameterAssert(fileName);
    if (0 == fileName.length) {
        return nil;
    }
    
    [parameters setObject:fileName forKey:@"filename"];
    [parameters setObject:@"0" forKey:@"type"];
    
    NSParameterAssert(self.baseURL);
    PogoplugOperationManager *manager = [PogoplugOperationManager managerWithBaseURL:self.baseURL];
    NSDictionary *json = [manager GET:@"/svc/api/json/createFile" parameters:parameters operation:nil error:error];
    if (!json) {
        return nil;
    }
    
    if (![json isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    PogoplugResponse *response = [[PogoplugResponse alloc] initWithDictionary:json];
    return response.file.fileID;
}

- (BOOL)uploadFileWithFileID:(NSString *)fileID fromContentOfFile:(NSURL *)localFileURL error:(NSError **)error
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.nero.biu.background"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    if (!manager.securityPolicy) {
        manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    NSString *path = [self filePathWithID:fileID flag:nil name:nil];
    NSParameterAssert(self.baseURL);
    NSURL *cloudFileURL = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:cloudFileURL];
    request.HTTPMethod = @"PUT";
    
    __block NSError *blockError;
    __block BOOL completed = NO;
    NSCondition *condition = [[NSCondition alloc] init];
    NSProgress *progress;
    NSURLSessionUploadTask *task = [manager uploadTaskWithRequest:request fromFile:localFileURL progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        blockError = error;
        completed = YES;
        [condition signal];
    }];
    [task resume];
    
    [condition lock];
    while (!completed) {
        [condition wait];
    }
    [condition unlock];
    
    if (blockError) {
        *error = blockError;
        return NO;
    }
    
    return YES;

}

- (NSString *)filePathWithID:(NSString *)fileID flag:(NSString *)flag name:(NSString *)name
{
    NSParameterAssert(fileID);
    NSParameterAssert(_token && _deviceID && _serviceID);
    NSMutableString *path = [NSMutableString stringWithFormat:@"/svc/files/%@/%@/%@/%@", _token, _deviceID, _serviceID, fileID];
    if (flag.length > 0) {
        [path appendFormat:@"/%@", flag];
    }
    if (name.length > 0) {
        [path appendFormat:@"/%@", name];
    }
    return path;
}

@end
