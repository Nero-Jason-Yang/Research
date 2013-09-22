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
    
    @autoreleasepool {
        NSArray *itemArray = [db fetchObjectsForEntity:@"Item"];
        NSLog(@"read begin");
        for (NSInteger i = 0; i < itemArray.count; i ++) {
            ReadWriteSaveConcurrentItem *item = itemArray[i];
            NSDictionary *info = item.info;
            NSInteger value = item.num.integerValue;
            NSLog(@"item[%d] info:%@ value:%d", i, info, value);
        }
        NSLog(@"read end");
    }
    
    @autoreleasepool {
        ReadWriteSaveConcurrentItem *item = (ReadWriteSaveConcurrentItem *)[db createObjectWithEntityName:@"Item"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            item.info = @{@"name":@"Tom"};
            item.num = [NSNumber numberWithInteger:1];
            [db saveContext];
        });
        
        [NSThread sleepForTimeInterval:1];
        item.num = [NSNumber numberWithInteger:2];
        NSInteger a = item.num.integerValue;
        [db saveContext];
        NSInteger b = item.num.integerValue;
        
    }
    
    [db saveContext];
}

@end
