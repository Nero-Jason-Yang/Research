//
//  OverrideWithDifferentReturnTypesTest.m
//  Database
//
//  Created by Jason Yang on 13-8-6.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "OverrideWithDifferentReturnTypesTest.h"

@interface SuperClass : NSObject
@property (nonatomic) NSDictionary *dic;
@end

@implementation SuperClass
@end

@interface DerivedClass : SuperClass
- (NSMutableDictionary *)dic;
@end

@implementation DerivedClass
- (NSMutableDictionary *)dic {
    return (NSMutableDictionary *)[super dic];
}
@end

@implementation OverrideWithDifferentReturnTypesTest

- (void)test
{
    NSMutableDictionary *sample = @{@"name":@"jason"}.mutableCopy;
    
    SuperClass *ss = [[SuperClass alloc] init];
    ss.dic = sample;
    NSDictionary *dic = ss.dic;
    NSLog(@"%@", dic);
    
    DerivedClass *ds = [[DerivedClass alloc] init];
    ds.dic = sample;
    NSMutableDictionary *mdic = [ds dic];
    [mdic setObject:@"20" forKey:@"age"];
    NSLog(@"%@", mdic);
}

@end
