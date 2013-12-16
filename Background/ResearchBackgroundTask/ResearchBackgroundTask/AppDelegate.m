//
//  AppDelegate.m
//  ResearchBackgroundTask
//
//  Created by Jason Yang on 13-12-13.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    BOOL _isBackground;
    UIBackgroundTaskIdentifier _backgroundTaskID;
    NSLock *_backgroundTaskLock;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; ; i ++) {
            NSLog(@"%d", i);
            [NSThread sleepForTimeInterval:1.0];
        }
    });
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _locationManager.distanceFilter = 1;
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager stopMonitoringSignificantLocationChanges];
    
    _isBackground = NO;
    _backgroundTaskID = UIBackgroundTaskInvalid;
    _backgroundTaskLock = [[NSLock alloc] init];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _isBackground = YES;
    NSLog(@"applicationDidEnterBackground");
    
    [_locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    _isBackground = NO;
    NSLog(@"applicationWillEnterForeground");
    
    [_locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations");
    if (_isBackground) {
        [self startBackgroundTask];
    }
}

- (void)startBackgroundTask
{
    if (_backgroundTaskID == UIBackgroundTaskInvalid) {
        @synchronized(_backgroundTaskLock) {
            if (_backgroundTaskID == UIBackgroundTaskInvalid) {
                NSDate *date = [NSDate date];
                _backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                    NSLog(@"beginBackgroundTaskWithExpirationHandler after time interval: %.2fs", [NSDate.date timeIntervalSinceDate:date]);
                    [self stopBackgroundTask];
                }];
                NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
                if (backgroundTimeRemaining > 3600) {
                    backgroundTimeRemaining = -1;
                }
                NSLog(@"beginBackgroundTask: %u, remain time: %.2fs", _backgroundTaskID, backgroundTimeRemaining);
            }
        }
    }
}

- (void)stopBackgroundTask
{
    if (_backgroundTaskID != UIBackgroundTaskInvalid) {
        @synchronized(_backgroundTaskLock) {
            if (_backgroundTaskID != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskID];
                NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
                if (backgroundTimeRemaining > 3600) {
                    backgroundTimeRemaining = -1;
                }
                NSLog(@"endBackgroundTask: %u, remain time: %.2fs", _backgroundTaskID, backgroundTimeRemaining);
                _backgroundTaskID = UIBackgroundTaskInvalid;
            }
        }
    }
}

@end
