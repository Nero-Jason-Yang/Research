#import "UMManager.h"
#import "AFNetworking.h"
#import "ALAssetInputStream.h"
#import "ALAsset+Utils.h"
#import <CoreLocation/CoreLocation.h>

@interface UMManager () <CLLocationManagerDelegate>
{
    AFHTTPSessionManager *_backgroundSession;
    AFHTTPSessionManager *_foregroundSession;
    CLLocationManager *_locationManager;
    BOOL _isBackground;
    BOOL _isInactive;
}
@end

@interface UMTask ()
@property (nonatomic) UMSource *source;
@property (nonatomic) NSProgress *progress;
@property (nonatomic) NSError *error;
- (id)initWithSource:(UMSource *)source;
- (void)didComplete:(NSError *)error;
@end

@implementation UMManager

+ (UMManager *)sharedManager
{
    static UMManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UMManager alloc] init];
    });
    return manager;
}

+ (void)applicationHandleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    AFHTTPSessionManager *session = [UMManager backgroundSessionForIdentifier:identifier];
    [session setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        NBLog(@"applicationHandleEventsForBackgroundURLSession: %@", identifier);
        completionHandler();
    }];
}

+ (AFHTTPSessionManager *)backgroundSessionForIdentifier:(NSString *)identifier
{
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary dictionary];
    });
    
    @synchronized(dic) {
        AFHTTPSessionManager *session = dic[identifier];
        if (!session) {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
            session = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
            if (!session.securityPolicy) {
                session.securityPolicy = [AFSecurityPolicy defaultPolicy];
            }
            session.securityPolicy.allowInvalidCertificates = YES;
            session.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dic[identifier] = session;
        }
        return session;
    }
}

+ (AFHTTPSessionManager *)foregroundSession
{
    static AFHTTPSessionManager *session;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [AFHTTPSessionManager manager];
        if (!session.securityPolicy) {
            session.securityPolicy = [AFSecurityPolicy defaultPolicy];
        }
        session.securityPolicy.allowInvalidCertificates = YES;
        session.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    return session;
}

- (id)init
{
    if (self = [super init]) {
        _backgroundSession = [UMManager backgroundSessionForIdentifier:self.bundleIdentifier];
        _foregroundSession = [UMManager foregroundSession];
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 1;
        
        _isBackground = NO;
        _isInactive = NO;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(applicationDidBecomeActiveNotification:)
                       name:UIApplicationDidBecomeActiveNotification object:nil];
        [center addObserver:self selector:@selector(applicationWillResignActiveNotification:)
                       name:UIApplicationWillResignActiveNotification object:nil];
        [center addObserver:self selector:@selector(applicationWillEnterForegroundNotification:)
                       name:UIApplicationWillEnterForegroundNotification object:nil];
        [center addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:)
                       name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (UMTask *)upload:(UMSource *)source toURL:(NSURL *)url
{
    if (_isBackground) {
        return [self backgroundUpload:source toURL:url];
    }
    else {
        return [self foregroundUpload:source toURL:url];
    }
}

- (UMTask *)backgroundUpload:(UMSource *)source toURL:(NSURL *)url
{
//    AFHTTPSessionManager *session = _backgroundSession;
    if (source.asset) {
//        source.asset save
    }
    return nil;
}

- (UMTask *)foregroundUpload:(UMSource *)source toURL:(NSURL *)url
{
    AFHTTPSessionManager *session = _foregroundSession;
    if (source.asset) {
        NSInputStream *stream = [[ALAssetInputStream alloc] initWithAsset:source.asset library:source.library];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPBodyStream = stream;
        request.HTTPMethod = @"PUT";
        UMTask *umtask = [[UMTask alloc] init];
        NSProgress *progress;
        NSURLSessionUploadTask *task = [session uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [umtask didComplete:error];
        }];
        umtask.progress = progress;
        [task resume];
    }
    return nil;
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
    _isInactive = NO;
}

- (void)applicationWillResignActiveNotification:(id)object
{
    _isInactive = YES;
}

- (void)applicationWillEnterForegroundNotification:(id)object
{
    _isBackground = NO;
    NBLog(@"applicationWillEnterForegroundNotification");
    
    if ([self bundleBackgroundModeLocationEnabled]) {
        [_locationManager stopUpdatingLocation];
        NBLog(@"locationManager stopUpdatingLocation");
    }
}

- (void)applicationDidEnterBackgroundNotification:(id)object
{
    _isBackground = YES;
    NBLog(@"applicationDidEnterBackgroundNotification");
    
    if ([self bundleBackgroundModeLocationEnabled]) {
        [_locationManager startUpdatingLocation];
        NBLog(@"locationManager startUpdatingLocation");
    }
}

#pragma mark <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"locationManager didUpdateToLocation");
    // TODO
}

@end

@implementation UMTask

- (id)initWithSource:(UMSource *)source
{
    if (self = [super init]) {
        self.source = source;
    }
    return self;
}

- (void)didComplete:(NSError *)error
{
    // TODO
    self.error = error;
}

@end