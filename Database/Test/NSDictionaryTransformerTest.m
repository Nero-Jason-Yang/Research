#import "NSDictionaryTransformerTest.h"
#import "Database.h"
#import "NSManagedObject+Database.h"

#define EntityName_Record @"Record"
#define KEY_Record_Info   @"info"

@implementation NSDictionaryTransformerTest

- (void)test
{
    NSString *modelName = @"NSDictionaryTransformer";
    Database *database = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    // fetch all records
    NSLog(@"Fetching records ...");
    NSArray *array = [database fetchObjectsForEntity:EntityName_Record];
    for (NSManagedObject *object in array) {
        NSDictionary *dic = [object attributeValueForKey:KEY_Record_Info];
        if ([dic isKindOfClass:NSDictionary.class]) {
            NSLog(@"%@", dic);
        }
    }
    NSLog(@"Fetching end.");
    
    // delete records
    NSLog(@"Deleting records ...");
    for (NSManagedObject *object in array) {
        [database deleteObject:object];
    }
    [database saveContext];
    array = [database fetchObjectsForEntity:EntityName_Record];
    NSLog(@"Deleting records end, remain count:%d", array.count);
    
    // create records
    NSManagedObject *object1, *object2, *object3;
    NSDictionary *info1;
    {
        NSDate *date = [NSDate date];
        info1 = @{ @"name":@"info1", @"date":date.description };
        object1 = [database createObjectWithEntityName:EntityName_Record];
        [object1 setAttributeValue:info1 forKey:KEY_Record_Info];
        [object1 save];
    }
    [NSThread sleepForTimeInterval:2.0f];
    {
        NSDate *date = [NSDate date];
        NSDictionary *info2 = @{ @"name":@"info2", @"date":date.description };
        object2 = [database createObjectWithEntityName:EntityName_Record];
        [object2 setAttributeValue:info2 forKey:KEY_Record_Info];
    }
    [NSThread sleepForTimeInterval:3.0f];
    {
        NSDate *date = [NSDate date];
        NSDictionary *info3 = @{ @"name":@"info3", @"date":date.description };
        object3 = [database createObjectWithEntityName:EntityName_Record];
        [object3 setAttributeValue:info3 forKey:KEY_Record_Info];
    }
    [database saveContext];
    NSLog(@"After creating records ...");
    array = [database fetchObjectsForEntity:EntityName_Record];
    for (NSManagedObject *object in array) {
        NSDictionary *dic = [object attributeValueForKey:KEY_Record_Info];
        if ([dic isKindOfClass:NSDictionary.class]) {
            NSLog(@"%@", dic);
        }
    }
    NSLog(@"After creating end.");
    
    // modify record
    NSMutableDictionary *minfo = info1.mutableCopy;
    [minfo setObject:[NSNumber numberWithBool:YES] forKey:@"modified"];
    [minfo setObject:[NSNumber numberWithFloat:3.1415926f] forKey:@"pi"];
    [minfo setObject:@[@"a", @"b", [NSNumber numberWithInt:108]] forKey:@"array"];
    [object1 setAttributeValue:minfo forKey:KEY_Record_Info];
    [object1 save];
    NSLog(@"After modifying records ...");
    array = [database fetchObjectsForEntity:EntityName_Record];
    for (NSManagedObject *object in array) {
        NSDictionary *dic = [object attributeValueForKey:KEY_Record_Info];
        if ([dic isKindOfClass:NSDictionary.class]) {
            NSLog(@"%@", dic);
        }
    }
    NSLog(@"After modifying end.");
    
    // delete record
    [database deleteObject:object2];
    [database saveContext];
    NSLog(@"After deleting records ...");
    array = [database fetchObjectsForEntity:EntityName_Record];
    for (NSManagedObject *object in array) {
        NSDictionary *dic = [object attributeValueForKey:KEY_Record_Info];
        if ([dic isKindOfClass:NSDictionary.class]) {
            NSLog(@"%@", dic);
        }
    }
    NSLog(@"After deleting end.");
}

@end
