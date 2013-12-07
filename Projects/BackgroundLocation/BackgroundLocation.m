#import "BackgroundLocation.h"
#import "ProjectManager.h"
#import <CoreLocation/CoreLocation.h>

@interface BackgroundLocation ()  <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@end

@implementation BackgroundLocation

+ (void)load
{
    [ProjectManager registerProject:@"Background Location" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        //_locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 1;
        [_locationManager startUpdatingLocation];
        
        double delayInSeconds = 10.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_locationManager stopUpdatingLocation];
            NBLog(@"[_locationManager stopUpdatingLocation]");
        });
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(applicationDidBecomeActiveNotification:)
                       name:UIApplicationDidBecomeActiveNotification object:nil];
        [center addObserver:self selector:@selector(applicationWillResignActiveNotification:)
                       name:UIApplicationWillResignActiveNotification object:nil];
        [center addObserver:self selector:@selector(applicationWillEnterForegroundNotification:)
                       name:UIApplicationWillEnterForegroundNotification object:nil];
        [center addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:)
                       name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block int counter = 0;
            while (YES) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"%d", counter++);
                });
                [NSThread sleepForTimeInterval:0.1];
            }
        });
    }
    return self;
}

#pragma mark bundle info

- (NSDictionary *)bundleInfo
{
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFBundleRef bundle = CFBundleGetMainBundle();
        CFDictionaryRef info = CFBundleGetInfoDictionary(bundle);
        dic = (__bridge NSDictionary *)info;
    });
    return dic;
}

- (NSString *)bundleIdentifier
{
    NSDictionary *info = [self bundleInfo];
    NSString *identifier = info[(__bridge NSString *)kCFBundleIdentifierKey];
    NSParameterAssert([identifier isKindOfClass:NSString.class]);
    return identifier;
}

- (NSSet *)bundleBackgroundModes
{
    NSMutableSet *set = [NSMutableSet set];
    NSDictionary *info = [self bundleInfo];
    NSArray *modes = info[@"UIBackgroundModes"];
    if ([modes isKindOfClass:NSArray.class]) {
        for (NSString *mode in modes) {
            if ([mode isKindOfClass:NSString.class]) {
                [set addObject:mode];
            }
        }
    }
    return set;
}

- (BOOL)bundleBackgroundModeLocationEnabled
{
    return [[self bundleBackgroundModes] containsObject:@"location"];
}

#pragma mark notifications

- (void)applicationDidBecomeActiveNotification:(id)object
{
    NBLog(@"applicationDidBecomeActiveNotification");
    
//    if ([self bundleBackgroundModeLocationEnabled]) {
//        [_locationManager stopUpdatingLocation];
//        NBLog(@"locationManager stopUpdatingLocation");
//    }
}

- (void)applicationWillResignActiveNotification:(id)object
{
    NBLog(@"applicationWillResignActiveNotification");
    
//    if ([self bundleBackgroundModeLocationEnabled]) {
//        [_locationManager startUpdatingLocation];
//        NBLog(@"locationManager startUpdatingLocation");
//    }
}

- (void)applicationWillEnterForegroundNotification:(id)object
{
    NBLog(@"applicationWillEnterForegroundNotification");
    
//    if ([self bundleBackgroundModeLocationEnabled]) {
//        [_locationManager stopUpdatingLocation];
//        NBLog(@"locationManager stopUpdatingLocation");
//    }
}

- (void)applicationDidEnterBackgroundNotification:(id)object
{
    NBLog(@"applicationDidEnterBackgroundNotification");
    
//    if ([self bundleBackgroundModeLocationEnabled]) {
//        [_locationManager startUpdatingLocation];
//        NBLog(@"locationManager startUpdatingLocation");
//    }
}

#pragma mark <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"locationManager didUpdateToLocation start");
    [NSThread sleepForTimeInterval:3];
    NSLog(@"locationManager didUpdateToLocation end");
}

@end
