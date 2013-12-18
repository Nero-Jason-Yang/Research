#import <Foundation/Foundation.h>

@protocol BrowsingFile;
@protocol BrowsingFolder;
@protocol BrowsingService;

typedef enum : uint8_t {
    BrowsingFileType_Folder,
    BrowsingFileType_Photo,
    BrowsingFileType_Video,
    BrowsingFileType_Music,
    BrowsingFileType_Other,
} BrowsingFileType;

typedef void (^BrowsingServiceCompletionHandler)(NSError *error);
typedef void (^BrowsingServiceDataCompletionHandler)(NSData *data, NSError *error);
typedef void (^BrowsingServiceListCompletionHandler)(NSArray *files, NSError *error);
typedef void (^BrowsingServiceImageCompletionHandler)(UIImage *image, NSError *error);

@protocol BrowsingService <NSObject>
- (id<BrowsingFolder>)root;
@end

@protocol BrowsingFile <NSObject>
@property (nonatomic,weak,readonly) id<BrowsingFolder> parent;
@property (nonatomic,weak,readonly) id<BrowsingService> service;
#pragma mark attributes
@property (nonatomic,readonly) BrowsingFileType type;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSInteger size;
@property (nonatomic,readonly) NSString *mimeType;
@property (nonatomic,readonly) NSDate *creationDate;
@property (nonatomic,readonly) NSDate *modificationDate;
#pragma mark actions
- (void)removeFileSync:(BOOL)sync completionHandler:(BrowsingServiceCompletionHandler)handler;
- (void)renameFileSync:(BOOL)sync newName:(NSString *)newName completionHandler:(BrowsingServiceCompletionHandler)handler;
- (void)downloadDataSync:(BOOL)sync completionHandler:(BrowsingServiceDataCompletionHandler)handler;
#pragma mark photo/video
- (void)downloadThumbnailImageSync:(BOOL)sync completionHandler:(BrowsingServiceImageCompletionHandler)handler;
- (void)downloadPreviewImageSync:(BOOL)sync completionHandler:(BrowsingServiceImageCompletionHandler)handler;
- (void)downloadFullImageSync:(BOOL)sync completionHandler:(BrowsingServiceImageCompletionHandler)handler;
#pragma mark video/music
- (NSURL *)streamURL;
@end

@protocol BrowsingFolder <BrowsingFile>
@property (nonatomic,readonly) NSNumber *total; // NSUInteger, children count for cloud, nil means unknown.
@property (nonatomic,readonly) NSUInteger count; // count that listed from cloud.
@property (nonatomic,readonly) NSDate *lastRefreshDate; // last refresh date.
- (void)listFirstPageSync:(BOOL)sync refresh:(BOOL)refresh completionHandler:(BrowsingServiceListCompletionHandler)handler;
- (void)listNextPageSync:(BOOL)sync completionHandler:(BrowsingServiceListCompletionHandler)handler;
- (void)removeFolderSync:(BOOL)sync recurve:(BOOL)recurve completionHandler:(BrowsingServiceCompletionHandler)handler;
@end
