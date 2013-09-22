//
//  FetchWithPredicateNilTest.m
//  Database
//
//  Created by Jason Yang on 13-8-26.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "FetchWithPredicateNilTest.h"
#import "FetchWithPredicateNilPerson.h"
#import "Database.h"
#import "NSManagedObject+Database.h"

@implementation FetchWithPredicateNilTest

- (void)test
{
    NSString *modelName = @"FetchWithPredicateNil";
    Database *database = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    NSArray *persons = [database fetchObjectsForEntity:@"Person"];
    if (0 == persons.count) {
        FetchWithPredicateNilPerson *person0 = (FetchWithPredicateNilPerson *)[database createObjectWithEntityName:@"Person"];
        person0.name = @"Jason";
        person0.age = [NSNumber numberWithShort:30];
        person0.score = [NSNumber numberWithInteger:300];
        
        FetchWithPredicateNilPerson *person1 = (FetchWithPredicateNilPerson *)[database createObjectWithEntityName:@"Person"];
        person1.name = @"Tom";
        
        FetchWithPredicateNilPerson *person2 = (FetchWithPredicateNilPerson *)[database createObjectWithEntityName:@"Person"];
        person2.name = nil;
        person2.age = nil;
        person2.score = [NSNumber numberWithInteger:200];
        
        persons = [database fetchObjectsForEntity:@"Person"];
    }
    
    [self logPersons:persons withTitle:@"show all"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age > 0"];
    persons = [database fetchObjectsForEntity:@"Person" withPredicate:predicate sortDescriptors:nil fetchLimit:0 fetchOffset:0];
    [self logPersons:persons withTitle:@"age > 0"];
    
    predicate = [NSPredicate predicateWithFormat:@"age == NIL"];
    persons = [database fetchObjectsForEntity:@"Person" withPredicate:predicate sortDescriptors:nil fetchLimit:0 fetchOffset:0];
    [self logPersons:persons withTitle:@"age == nil"];
    
    predicate = [NSPredicate predicateWithFormat:@"age <> NIL"];
    persons = [database fetchObjectsForEntity:@"Person" withPredicate:predicate sortDescriptors:nil fetchLimit:0 fetchOffset:0];
    [self logPersons:persons withTitle:@"age != nil"];
}

- (void)logPersons:(NSArray *)persons withTitle:(NSString *)title
{
    NSLog(@"===== %@", title);
    
    for (FetchWithPredicateNilPerson *person in persons) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (person.name) {
            [dic setObject:person.name forKey:@"name"];
        }
        if (person.age) {
            [dic setObject:person.age forKey:@"age"];
        }
        if (person.score) {
            [dic setObject:person.score forKey:@"score"];
        }
        NSLog(@"%@", dic);
    }
}

@end
