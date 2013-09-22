//
//  CategoryWithPropertiesTest.m
//  Database
//
//  Created by Jason Yang on 13-8-27.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "CategoryWithPropertiesTest.h"
#import "CategoryPerson+age.h"

@implementation CategoryWithPropertiesTest

- (void)test
{
    CategoryPerson *person = [[CategoryPerson alloc] init];
    person.name = @"Tom";
    person.age = 32;
    NSLog(@"name : %@", person.name);
    NSLog(@"uuid : %@", person.uuid);
    NSLog(@"age  : %d", person.age);
    NSLog(@"score: %d", person.score);
}

@end
