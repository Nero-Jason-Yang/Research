#import "AppDelegate.h"

#import "MainViewController.h"

@interface AppDelegate ()
{
    NSMutableArray *_subDelegates;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _subDelegates = [NSMutableArray array];
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    MainViewController *mainView = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigator = [[UINavigationController alloc] initWithRootViewController:mainView];
    _window.rootViewController = navigator;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.isBackground = YES;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (self.didEnterBackgroundHandler) {
        self.didEnterBackgroundHandler();
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    self.isBackground = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    NSLog(@"app handleEventsForBackgroundURLSession");
    self.backgroundSessionCompletionHandler = completionHandler;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    id<AppBackgroundFetcher> fetcher = self.backgroundFetcher;
    if (fetcher) {
        [fetcher application:application performFetchWithCompletionHandler:completionHandler];
    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
    
//    NBLog(@"application:performFetchWithCompletionHandler:");
//    completionHandler(UIBackgroundFetchResultNoData);
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.alertBody = @"application:performFetchWithCompletionHandler:";
//    notification.hasAction = NO;
//    [application presentLocalNotificationNow:notification];
}

@end
