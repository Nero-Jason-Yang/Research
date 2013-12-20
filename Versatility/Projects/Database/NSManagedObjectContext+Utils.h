#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Utils)

+ (id)contextWithModelName:(NSString *)modelName storeURL:(NSURL *)storeURL;
+ (id)contextWithModelName:(NSString *)modelName storeName:(NSString *)storeName;
+ (id)contextWithModelName:(NSString *)modelName;
+ (NSURL *)storeURLWithStorename:(NSString *)storeName;

- (void)save;
- (NSUInteger)fetchCountForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)limit fetchOffset:(NSUInteger)offset;
- (id)fetchOneObjectForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (id)createObjectForEntityName:(NSString *)entityName;

@end
