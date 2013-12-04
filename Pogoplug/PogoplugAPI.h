#import <Foundation/Foundation.h>

@interface PogoplugAPI : NSObject

@property (nonatomic) NSURL *baseURL;
@property (nonatomic) NSString *token;

- (BOOL)loginWithUsername:(NSString *)username password:(NSString *)password error:(NSError **)error;
- (NSString *)createFileWithParentID:(NSString *)parentID fileName:(NSString *)fileName error:(NSError **)error;
- (BOOL)uploadFileWithFileID:(NSString *)fileID fromContentOfFile:(NSURL *)localFileURL error:(NSError **)error;
- (NSString *)filePathWithID:(NSString *)fileID flag:(NSString *)flag name:(NSString *)name;

@end
