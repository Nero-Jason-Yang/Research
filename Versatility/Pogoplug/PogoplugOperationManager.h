#import "AFHTTPRequestOperationManager.h"
#import "PogoplugJSONResponseSerializer.h"

@interface PogoplugOperationManager : AFHTTPRequestOperationManager

@property (nonatomic) dispatch_queue_t completionQueue;

+ (id)managerWithBaseURL:(NSURL *)baseURL;

- (id)POST:(NSString *)URLString parameters:(NSDictionary *)parameters operation:(AFHTTPRequestOperation **)operation error:(NSError **)error;
- (id) GET:(NSString *)URLString parameters:(NSDictionary *)parameters operation:(AFHTTPRequestOperation **)operation error:(NSError **)error;

- (BOOL)uploadData:(NSData *)data withPath:(NSString *)path parameters:(NSDictionary *)parameters error:(NSError **)error;
- (UIImage *)imageWithPath:(NSString *)path parameters:(NSDictionary *)parameters operation:(AFHTTPRequestOperation **)operation error:(NSError **)error;

@end
