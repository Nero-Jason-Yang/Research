#import "ToManyRelationshipTest.h"
#import "Database.h"
#import "NSManagedObject+Database.h"

#define EntityName_Album @"Album"
#define KEY_Album_Name   @"name"
#define KEY_Album_Photos @"photos"

#define EntityName_Photo @"Photo"
#define KEY_Photo_Name   @"name"
#define KEY_Photo_Album  @"album"

@implementation ToManyRelationshipTest

- (void)test
{
    NSString *modelName = @"ToManyRelationship";
    Database *db = [[Database alloc] initWithModelName:modelName forStoreName:modelName];
    
    NSArray *albums = [db fetchObjectsForEntity:EntityName_Album];
    for (NSManagedObject *album in albums) {
        NSSet *photos = [album relationshipValueForKey:KEY_Album_Photos];
        if ([photos isKindOfClass:NSSet.class]) {
            for (NSManagedObject *photo in photos) {
                NSLog(@"%@", [photo attributes]);
            }
        }
    }
    
    NSManagedObject *album = [db createObjectWithEntityName:EntityName_Album];
    [album setAttributeValue:@"My Album" forKey:KEY_Album_Name];
    NSManagedObject *photo1 = [db createObjectWithEntityName:EntityName_Photo];
    [photo1 setAttributeValue:@"butterfly" forKey:KEY_Photo_Name];
    [photo1 setRelationshipValue:album forKey:KEY_Photo_Album];
    NSManagedObject *photo2 = [db createObjectWithEntityName:EntityName_Photo];
    [photo2 setAttributeValue:@"bear" forKey:KEY_Photo_Name];
    [photo2 setRelationshipValue:album forKey:KEY_Photo_Album];
    [db saveContext];
}

@end
