#import <Foundation/Foundation.h>

typedef enum : uint8_t {
    UMBlockType_NetworkNotAvailable,
} UMBlockType;

@class UMTask;
@class UMManager;

@protocol UMItem <NSObject>
@property (nonatomic,readonly) ALAsset *asset;
@end

@protocol UMDataSource <NSObject>
@property (nonatomic,readonly) NSUInteger numberOfItems;
- (id<UMItem>)anyItem;
@end

@protocol UMDelegate <NSObject>
- (void)uploadManager:(UMManager *)manager didStartTask:(UMTask *)task;
- (void)uploadManager:(UMManager *)manager didFinishTask:(UMTask *)task;
- (void)uploadManager:(UMManager *)manager didBlockWithType:(UMBlockType)type;
@end

@interface UMTask : NSObject
@property (nonatomic,readonly) id<UMItem> item;
@property (nonatomic,readonly) NSProgress *progress;
@property (nonatomic,readonly) NSError *error;
@end

@interface UMManager : NSObject
+ (UMManager *)sharedManager;
+ (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler;
@property (nonatomic,weak) id<UMDataSource> dataSource;
@property (nonatomic,weak) id<UMDelegate> delegate;
- (void)start;
@end
