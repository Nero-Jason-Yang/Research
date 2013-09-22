//
//  KeyedArchiverTest.m
//  Database
//
//  Created by Jason Yang on 13-8-18.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "KeyedArchiverTest.h"

@implementation KeyedArchiverTest

- (void)test
{
    [self testAsset];
    
    NSDictionary *src = @{ @"strValue":@"Jason", @"intValue":[NSNumber numberWithInt:128], @"arrValue":@[@"first", @"second"], @"dicValue":@{@"aKey":@"aValue"}};
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:src];
    NSDictionary *dst = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"%@", dst);
}

- (void)testAsset
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    __block BOOL completed = NO;
    NSMutableArray *groups = [NSMutableArray array];
    
    ALAssetsGroupType types = ALAssetsGroupSavedPhotos|ALAssetsGroupLibrary;
    [library enumerateGroupsWithTypes:types usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [groups addObject:group];
        }
        else {
            completed = YES;
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"File:%s Line:%d error:%@", __FILE__, __LINE__, error);
    }];
    
    while (!completed) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    for (ALAssetsGroup *group in groups) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            NSDate *dateStart, *dateEnd;
            
            dateStart = [NSDate date];
            @autoreleasepool {
                ALAssetRepresentation *representation = result.defaultRepresentation;
                CGSize dimensions = representation.dimensions;
                
            }
            dateEnd = [NSDate date];
            NSLog(@"time cost %f", [dateEnd timeIntervalSinceDate:dateStart]);
            
            dateStart = [NSDate date];
            @autoreleasepool {
                ALAssetRepresentation *representation = result.defaultRepresentation;
                CGSize dimensions = representation.dimensions;
            }
            dateEnd = [NSDate date];
            NSLog(@"time cost %f", [dateEnd timeIntervalSinceDate:dateStart]);
        }];
    }
}
@end
