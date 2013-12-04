#import "BackgroundUploading.h"
#import "ProjectManager.h"
#import "PogoplugAPI.h"
#import "AssetUploadSource.h"
#import "AFNetworking.h"
#import "ALAssetsLibrary+Utils.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface BackgroundUploading () <CLLocationManagerDelegate>
@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) PogoplugAPI *api;
@property (nonatomic) NSMutableArray *sources;
@property (nonatomic) NSThread *thread;
@property (nonatomic) NSUInteger notifies;
@property (nonatomic) NSCondition *condition;
@property (nonatomic) NSURLSessionTask *task;
@property (nonatomic) NSLock *preparing;
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation BackgroundUploading

+ (void)load
{
    [ProjectManager registerProject:@"Background Uploading with Pogoplug" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.appDelegate = appDelegate;
        self.api = [[PogoplugAPI alloc] init];
        self.sources = [NSMutableArray array];
        self.preparing = [[NSLock alloc] init];
        self.condition = [[NSCondition alloc] init];
        appDelegate.didEnterBackgroundHandler = ^() {
            [self didEnterBackground];
        };
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self test];
        });
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.distanceFilter = 1;
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)test
{
    NSError *e;
    if (![self.api loginWithUsername:@"ja2yang@nero.com" password:@"123456" error:&e]) {
        NSLog(@"login failed, error: %@", e);
        return;
    }
    
    NSLog(@"login success");
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    for (ALAssetsGroup *group in library.groups) {
        [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            if (asset) {
                AssetUploadSource *source = [[AssetUploadSource alloc] initWithAsset:asset library:library];
                [self.sources addObject:source];
            }
        }];
    }
    
    NSLog(@"index success");
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadProc:) object:nil];
    self.notifies = 1;
    [self.thread start];
}

- (void)didEnterBackground
{
    NSLog(@"didEnterBackground begin");
    [self trySomeTask];
//    [self.preparing lock];
//    [self.preparing unlock];
    NSLog(@"didEnterBackground end");
}

- (void)applicationDidBecomeActive:(id)object
{
    [self notifyThread];
}

- (void)threadProc:(id)object
{
    NSLog(@"begin thread");
    
    while (TRUE) {
        [self threadWait];
        
        [self trySomeTask];
    }
    
    NSLog(@"end thread");
}

- (void)threadWait
{
    [self.condition lock];
    while (0 == self.notifies) {
        [self.condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    }
    [self.condition unlock];
    self.notifies = 0;
}

- (void)notifyThread
{
    @synchronized(self) {
        self.notifies ++;
        [self.condition signal];
    }
}

- (void)onCompleteTask
{
    @synchronized(self) {
        self.task = nil;
        [self notifyThread];
    }
}

- (void)runSomeTask
{
    @synchronized(self) {
        AssetUploadSource *source = [self sourceNeedUploading];
        NSURLSessionTask *task = [self uploadTaskWithSource:source];
        if (task.state == NSURLSessionTaskStateSuspended) {
            [task resume];
        }
    }
}

- (void)trySomeTask
{
    @synchronized(self) {
        if (self.appDelegate.isBackground) {
            return;
        }
        
        NSLog(@"trySomeTask begin");
        [self.preparing lock];
        while (TRUE) {
            AssetUploadSource *source = [self sourceNeedUploading];
            if (!source) {
                NSLog(@"all sources are completed!");
                break;
            }
            NSURLSessionTask *task = [self uploadTaskWithSource:source];
            if (task && task.state == NSURLSessionTaskStateSuspended) {
                NSLog(@"start upload file: %@", source.fileName);
                [task resume];
                break;
            }
        }
        [self.preparing unlock];
        NSLog(@"trySomeTask end");
    }
}

- (NSURLSessionTask *)uploadTaskWithSource:(AssetUploadSource *)source
{
    if (self.task) {
        return self.task;
    }
    
    NSLog(@"start file: %@", source.fileName);
    [source saveToLocalFilesystem];
    NSURL *localFileURL = source.localFileURL;
    if (!localFileURL) {
        NSLog(@"failed to save file: %@", source.fileName);
        source.completed = YES;
        source.error = [NSError errorWithDomain:@"internal" code:0 userInfo:nil];
        return nil;
    }
    
    NSError *error;
    NSString *fileID = [self.api createFileWithParentID:nil fileName:source.fileName error:&error];
    if (!fileID) {
        NSLog(@"%@", error);
        source.completed = YES;
        source.error = error;
        return nil;
    }
    
    NSString *path = [self.api filePathWithID:fileID flag:nil name:nil];
    NSParameterAssert(self.api.baseURL);
    NSURL *cloudFileURL = [NSURL URLWithString:path relativeToURL:self.api.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:cloudFileURL];
    request.HTTPMethod = @"PUT";
    
    AFHTTPSessionManager *manager = [self manager];
    NSProgress *progress;
    NSURLSessionUploadTask *task = [manager uploadTaskWithRequest:request fromFile:localFileURL progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        source.completed = YES;
        source.error = error;
        NSLog(@"complete file: %@, error: %@", source.fileName, error);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self onCompleteTask];
        });
    }];
    source.progress = progress;
    
    self.task = task;
    return task;
}

- (AFHTTPSessionManager *)manager
{
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.nero.biu.background"];
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        if (!manager.securityPolicy) {
            manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        }
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        [manager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (appDelegate.backgroundSessionCompletionHandler) {
                NSLog(@"manager didFinishEventsForBackgroundURLSession");
                dispatch_block_t block = appDelegate.backgroundSessionCompletionHandler;
                appDelegate.backgroundSessionCompletionHandler = nil;
                [self trySomeTask];
                block();
            }
        }];
    });
    return manager;
}

- (AssetUploadSource *)sourceNeedUploading
{
    for (AssetUploadSource *source in self.sources) {
        if (!source.completed) {
            return source;
        }
    }
    return nil;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location update");
    BOOL isBackground = self.appDelegate.isBackground;
    self.appDelegate.isBackground = NO;
    [self trySomeTask];
    self.appDelegate.isBackground = isBackground;
}

@end
