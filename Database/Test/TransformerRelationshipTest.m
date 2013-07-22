#import "TransformerRelationshipTest.h"
#import "Database.h"
#import "NSManagedObject+Database.h"

@implementation TransformerRelationshipTest
- (void)test
{
    NSString *modelName = @"TransformerRelationship";
    Database *db = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    NSArray *photos = [db fetchObjectsForEntity:@"Photo"];
    for (NSManagedObject *photo in photos) {
        NSLog(@"photo name:%@", [photo attributeValueForKey:@"name"]);
        NSManagedObject *thumbnail = [photo relationshipValueForKey:@"thumbnail"];
        if (thumbnail) {
            NSDictionary *info = [thumbnail attributeValueForKey:@"info"];
            if ([info isKindOfClass:NSDictionary.class]) {
                NSLog(@"thumbnail info:%@", info);
            }
        }
    }
    
    {
        NSManagedObject *photo = [db createObjectWithEntityName:@"Photo"];
        [photo setAttributeValue:@"butterfly" forKey:@"name"];
        NSManagedObject *thumb = [db createObjectWithEntityName:@"Thumbnail"];
        [thumb setAttributeValue:@{@"size":@"1024"} forKey:@"info"];
        [thumb setRelationshipValue:photo forKey:@"photo"];
    }
    
    {
        NSManagedObject *photo = [db createObjectWithEntityName:@"Photo"];
        [photo setAttributeValue:@"bear" forKey:@"name"];
        NSManagedObject *thumb = [db createObjectWithEntityName:@"Thumbnail"];
        [thumb setAttributeValue:@{@"size":@"512"} forKey:@"info"];
        [thumb setRelationshipValue:photo forKey:@"photo"];
    }
    [db saveContext];
}
@end
