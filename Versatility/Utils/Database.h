#import <Foundation/Foundation.h>

@interface Database : NSObject

@property (nonatomic,readonly) NSManagedObjectContext *context;

- (id)initWithModelName:(NSString *)modelName;
- (id)initWithModelName:(NSString *)modelName forStoreName:(NSString *)storeName;
- (id)initWithModelName:(NSString *)modelName forStoreURL:(NSURL *)storeURL;

- (void)onInit;

- (void)save;
- (BOOL)save:(NSError **)error;

- (NSArray *)fetchObjectsForEntity:(NSString *)entityName;
- (NSArray *)fetchObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)maxCount fetchOffset:(NSUInteger)offset;
- (id)createObjectForEntity:(NSString *)entityName;
- (void)deleteObject:(NSManagedObject *)object;

@end
