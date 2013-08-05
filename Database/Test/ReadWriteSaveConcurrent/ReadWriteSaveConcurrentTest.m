//
//  ReadWriteSaveConcurrentTest.m
//  Database
//
//  Created by Yang Jason on 13-8-5.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "ReadWriteSaveConcurrentTest.h"
#import "ReadWriteSaveConcurrentItem.h"
#import "Database.h"
#import "NSManagedObject+Database.h"

@implementation ReadWriteSaveConcurrentTest

- (void)test
{
    NSString *modelName = @"ReadWriteSaveConcurrent";
    Database *db = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    ReadWriteSaveConcurrentItem *item = (ReadWriteSaveConcurrentItem *)[db createObjectWithEntityName:@"Item"];
    item.info = @{@"name":@"Jerry"};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"start read");
        NSDictionary *info = item.info;
        NSLog(@"end read");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"start write");
        item.info = @{@"name":@"Tom"};
        NSLog(@"end write");
    });
    [db saveContext];
    [db saveContext];
}

@end
