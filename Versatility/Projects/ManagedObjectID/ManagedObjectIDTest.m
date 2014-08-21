//
//  ManagedObjectIDTest.m
//  Research
//
//  Created by Jason Yang on 14-2-13.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "ManagedObjectIDTest.h"
#import "ProjectManager.h"
#import "NSManagedObjectContext+Utils.h"
#import "MOITestItem.h"

#define EntityName_MOITestItem @"MOITestItem"

@implementation ManagedObjectIDTest

+ (void)load
{
    [ProjectManager registerProject:@"ManagedObjectIDTest" withClass:self.class];
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
    NSManagedObjectContext *context = [NSManagedObjectContext contextWithModelName:@"ManagedObjectIDTest"];
    NSArray *mos = [context fetchObjectsForEntityName:EntityName_MOITestItem];
    if (mos.count > 0) {
        for (MOITestItem *mo in mos) {
            [context deleteObject:mo];
        }
        [context save];
    }
    
    for (int i = 0; i < 10; i ++) {
        MOITestItem *mo = [context createObjectForEntityName:EntityName_MOITestItem];
        mo.value = [[NSUUID UUID] UUIDString];
    }
    [context save];
    mos = [context fetchObjectsForEntityName:EntityName_MOITestItem];
    if (mos.count > 5) {
        [context deleteObject:mos[3]];
        [context deleteObject:mos[4]];
        [context save];
    }
    for (int i = 0; i < 5; i ++) {
        MOITestItem *mo = [context createObjectForEntityName:EntityName_MOITestItem];
        mo.value = [[NSUUID UUID] UUIDString];
    }
    [context save];
    mos = [context fetchObjectsForEntityName:EntityName_MOITestItem];
    for (MOITestItem *mo in mos) {
        NSLog(@"%@", mo.objectID.URIRepresentation);
    }
}

@end
