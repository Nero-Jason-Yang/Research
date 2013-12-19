#import "AppDelegate.h"
#import "NeroAPI.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NeroAPI *api = [[NeroAPI alloc] init];
    [api authLoginSync:YES email:@"ja2yang@nero.com" password:@"123456" completionHandler:^(NeroResponseObject_AccountInfo *accountInfo, NSError *error) {
        NSLog(@"accountInfo.email=%@, error=%@", accountInfo.email, error);
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
