//
//  BackgroundFetch.m
//  Research
//
//  Created by Jason Yang on 13-12-9.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "BackgroundFetch.h"
#import "ProjectManager.h"
#import "AppDelegate.h"

@interface BackgroundFetch () <AppBackgroundFetcher>
{
    
}
@end

@implementation BackgroundFetch

+ (void)load
{
    [ProjectManager registerProject:@"Background Fetch" withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        [self test];
    }
    return self;
}

- (void)test
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:2.0];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    
}

@end
