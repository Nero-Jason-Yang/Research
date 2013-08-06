//
//  SameAttributesForDifferentEntitiesTest.m
//  Database
//
//  Created by Jason Yang on 13-8-2.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "SameAttributesForDifferentEntitiesTest.h"
#import "SameManagedObject.h"
#import "Database.h"
#import "NSManagedObject+Database.h"

@implementation SameAttributesForDifferentEntitiesTest

- (void)test
{
    NSString *modelName = @"SameAttributesForDifferentEntities";
    Database *db = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    {
        NSArray *array = [db fetchObjectsForEntity:@"Object"];
        for (SameManagedObject *object in array) {
            NSDictionary *cmetadata = object.cmetadata;
            NSString *objectid = [object attributeValueForKey:@"cmetadata"];
            NSArray *instances = [object relationshipValueForKey:@"instances"];
            for (SameManagedObject *instance in instances) {
                cmetadata = instance.cmetadata;
                NSString *instanceid = [instance attributeValueForKey:@"instanceid"];
            }
        }
        
        array = [db fetchObjectsForEntity:@"Instance"];
        for (SameManagedObject *instance in array) {
            NSDictionary *cmetadata = instance.cmetadata;
            NSString *instanceid = [instance attributeValueForKey:@"cmetadata"];
            SameManagedObject *object = [instance relationshipValueForKey:@"instances"];
            cmetadata = object.cmetadata;
            NSString *objectid = [object attributeValueForKey:@"objectid"];
        }
    }
    
    SameManagedObject *object = (SameManagedObject *)[db createObjectWithEntityName:@"Object"];
    object.cmetadata = @{@"ctype":@"object"};
    [object setAttributeValue:@"object-id-01" forKey:@"objectid"];
    SameManagedObject *instance = (SameManagedObject *)[db createObjectWithEntityName:@"Instance"];
    instance.cmetadata = @{@"ctype":@"instance"};
    [instance setAttributeValue:@"instance-id-01" forKey:@"instanceid"];
    [instance setRelationshipValue:object forKey:@"referencedObject"];
    [db saveContext];
}

@end
