//
//  DerivedManagedObjectTest.m
//  Database
//
//  Created by Jason Yang on 13-9-4.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "DerivedManagedObjectTest.h"
#import "Database.h"
#import "PhotoManagedObject+Derived.h"

@implementation DerivedManagedObjectTest

- (void)test
{
    NSString *modelName = @"DerivedManagedObject";
    Database *db = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    PhotoManagedObject *mo = (PhotoManagedObject *)[db createObjectWithEntityName:@"Photo"];
    mo.m_photoID = @"ABC";
    mo.name = @"test";
    NSLog(@"name:%@", mo.name);
}

@end
