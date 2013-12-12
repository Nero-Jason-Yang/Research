//
//  AppDelegate.m
//  ResearchLocationManager
//
//  Created by Jason Yang on 13-12-11.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    BOOL _started;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1;
    
    [_locationManager startMonitoringSignificantLocationChanges];
//    [_locationManager startUpdatingLocation];
//    NSLog(@"startUpdatingLocation");
//    double delayInSeconds = 5.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [_locationManager stopUpdatingLocation];
//        NSLog(@"stopUpdatingLocation");
//        [_locationManager startMonitoringSignificantLocationChanges];
//        NSLog(@"startMonitoringSignificantLocationChanges");
//    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; ; i ++) {
            NSLog(@"%d", i);
            NSTimeInterval remaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
            if (remaining < 20 * 60) {
                NSLog(@"backgroundTimeRemaining: %.2f", remaining);
            }
            [NSThread sleepForTimeInterval:1];
        }
    });
    
//    [self next];
    return YES;
}

- (void)next
{
    UIBackgroundTaskIdentifier taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"background task expirate");
    }];
    NSLog(@"background task begin with identifier: %u", taskID);
    
    double delayInSeconds = 180.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self next];
        [[UIApplication sharedApplication] endBackgroundTask:taskID];
        NSLog(@"background task end with identifier: %u", taskID);
    });
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSDate *date = [NSDate date];
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        NSLog(@"background task expiration after seconds: %.2f", [NSDate.date timeIntervalSinceDate:date]);
//    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark responding to location events

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations: %@", locations);
    
    static int n = 0;
    if (n ++ == 1) {
        [_locationManager stopMonitoringSignificantLocationChanges];
        NSLog(@"stopMonitoringSignificantLocationChanges");
        [_locationManager startUpdatingLocation];
        NSLog(@"startUpdatingLocation");
        
        
//        UIBackgroundTaskIdentifier taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//            NSLog(@"background task expirate");
//        }];
//        NSLog(@"beginBackgroundTaskWithExpirationHandler");
//        
//        double delayInSeconds = 20.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [[UIApplication sharedApplication] endBackgroundTask:taskID];
//            NSLog(@"endBackgroundTask");
//        });
    }

//    UIBackgroundTaskIdentifier bgtaskid = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        NSLog(@"background task expirate");
//    }];
//    
//    for (int i = 0; i < 300; i ++) {
//        [NSThread sleepForTimeInterval:1];
//    }
//    
//    [[UIApplication sharedApplication] endBackgroundTask:bgtaskid];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    NSLog(@"didFinishDeferredUpdatesWithError: %@", error);
}

#pragma mark pausing location updates

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"locationManagerDidPauseLocationUpdates:");
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"locationManagerDidResumeLocationUpdates:");
}

#pragma mark responding to heading events

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"didUpdateHeading: %@", newHeading);
}

#pragma mark responding to region events

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion: %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"didDetermineState: %d forRegion: %@", (int)state, region);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion: %@ withError: %@", region, error);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"didStartMonitoringForRegion");
}

#pragma mark responding to ranging events

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"didRangeBeacons: %@ inRegion: %@", beacons, region);
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"rangingBeaconsDidFailForRegion: %@ withError: %@", region, error);
}

#pragma mark responding to authorization changes

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus: %d", (int)status);
}

@end
