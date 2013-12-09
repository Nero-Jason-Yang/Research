#import <UIKit/UIKit.h>


@protocol AppBackgroundFetcher <NSObject>
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) dispatch_block_t backgroundSessionCompletionHandler;
@property (strong, nonatomic) dispatch_block_t didEnterBackgroundHandler;
@property (nonatomic) BOOL isBackground;

@property (nonatomic) id<AppBackgroundFetcher> backgroundFetcher;

@end
