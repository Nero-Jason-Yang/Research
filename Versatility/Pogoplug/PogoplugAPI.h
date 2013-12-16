#import <Foundation/Foundation.h>

@interface PogoplugAPI : NSObject

@property (nonatomic) NSURL *baseURL;
@property (nonatomic) NSString *token;

- (BOOL)loginWithUsername:(NSString *)username password:(NSString *)password error:(NSError **)error;
- (NSString *)createFileWithParentID:(NSString *)parentID fileName:(NSString *)fileName error:(NSError **)error;
- (BOOL)uploadFileWithFileID:(NSString *)fileID fromContentOfFile:(NSURL *)localFileURL error:(NSError **)error;
- (BOOL)uploadFileWithFileID:(NSString *)fileID fromContentOfFile:(NSURL *)localFileURL sectionSize:(NSUInteger)sectionSize error:(NSError **)error;

- (BOOL)uploadFileForFileID:(NSString *)fileID withData:(NSData *)data error:(NSError **)error;
- (BOOL)uploadFileForFileID:(NSString *)fileID withFileURL:(NSURL *)fileURL error:(NSError **)error;
- (BOOL)uploadFileForFileID:(NSString *)fileID withInputStream:(NSInputStream *)inputStream error:(NSError **)error;

- (NSString *)filePathWithID:(NSString *)fileID flag:(NSString *)flag name:(NSString *)name;

@end
