#import <Foundation/Foundation.h>
#import "HTTPResponse.h"
#import "TaskQueue.h"

typedef void(^HTTPRequestCompletion)(HTTPResponse *response);

@interface HTTPRequest : NSObject
@property (nonatomic,readonly) Class responseClass;
// task
@property (nonatomic) NSUInteger tags;
@property (nonatomic) TaskQueue *encodingQueue;
@property (nonatomic) TaskQueue *decodingQueue;
@property (nonatomic) TaskQueue *transferQueue;
@property (nonatomic,readonly) HTTPResponse *response;
- (void)performWithCompletion:(HTTPRequestCompletion)completion;
- (void)cancel;
// major
@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *method;
@property (nonatomic) NSData *body;
@property (nonatomic) NSTimeInterval timeoutInterval;
- (NSString *)valueForHeaderField:(NSString *)field;
- (void)setValue:(NSString *)value forHeaderField:(NSString *)field;
- (void)encode;
// helper
@property (nonatomic) NSString *contentType;
@property (nonatomic) NSString *ifModifiedSince;
@end
