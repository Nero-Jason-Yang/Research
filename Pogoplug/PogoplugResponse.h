#import <Foundation/Foundation.h>

@class PogoplugResponse_User;
@class PogoplugResponse_Device;
@class PogoplugResponse_Service;
@class PogoplugResponse_File;

@interface PogoplugResponse : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;
#pragma mark getUser
@property (nonatomic,readonly) PogoplugResponse_User *user;
#pragma mark listDevices
@property (nonatomic,readonly) NSArray *devices; // [PogoplugResponse_Device]
#pragma mark listFeatures
@property (nonatomic,readonly) NSArray *features; // [NSArray]
#pragma mark listServices
@property (nonatomic,readonly) NSArray *services; // [PogoplugResponse_Service]
#pragma mark getFile, createFile
@property (nonatomic,readonly) PogoplugResponse_File *file;
#pragma mark listFiles
@property (nonatomic,readonly) NSNumber *pageOffset; // integer
@property (nonatomic,readonly) NSNumber *count; // integer
@property (nonatomic,readonly) NSNumber *totalCount; // integer
@property (nonatomic,readonly) NSArray *files; // [PogoplugResponse_File]
@end

@interface PogoplugResponse_User : NSObject
@property (nonatomic,readonly) NSString *userID;
@property (nonatomic,readonly) NSString *screenName;
@property (nonatomic,readonly) NSString *email;
@property (nonatomic,readonly) NSArray *emails;
@property (nonatomic,readonly) NSString *flags;
@property (nonatomic,readonly) NSString *locale;
@property (nonatomic,readonly) NSDictionary *options;
@end

@interface PogoplugResponse_Device : NSObject
@property (nonatomic,readonly) NSString *deviceID;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *version;
@property (nonatomic,readonly) NSString *flags;
@property (nonatomic,readonly) NSString *ownerID;
@property (nonatomic,readonly) PogoplugResponse_User *owner;
@property (nonatomic,readonly) NSNumber *provisionFlags; // integer
@property (nonatomic,readonly) NSArray *services; // [PogoplugResponse_Service]
@end

@interface PogoplugResponse_Service : NSObject
@property (nonatomic,readonly) NSString *deviceID;
@property (nonatomic,readonly) NSString *serviceID;
@property (nonatomic,readonly) NSString *sclass;
@property (nonatomic,readonly) NSString *type;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *version;
@property (nonatomic,readonly) NSString *apiurl;
@property (nonatomic,readonly) NSNumber *online; // BOOL
@property (nonatomic,readonly) PogoplugResponse_Device *device;
@end

@interface PogoplugResponse_File : NSObject
@property (nonatomic,readonly) NSString *fileID;
@property (nonatomic,readonly) NSString *spaceID;
@property (nonatomic,readonly) NSString *parentID;
@property (nonatomic,readonly) NSString *ownerID;
@property (nonatomic,readonly) NSNumber *type; // enum, integer
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *mimeType;
@property (nonatomic,readonly) NSNumber *size; // longlong
@property (nonatomic,readonly) NSDate *ctime;
@property (nonatomic,readonly) NSDate *mtime;
@property (nonatomic,readonly) NSString *thumbnail;
@property (nonatomic,readonly) NSString *preview;
@property (nonatomic,readonly) NSString *stream;
@property (nonatomic,readonly) NSString *streamType;
@end
