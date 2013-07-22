#import <Foundation/Foundation.h>

@interface Database : NSObject

- (id)initWithModelName:(NSString *)modelName forStoreName:(NSString *)storeName;
- (id)initWithModelName:(NSString *)modelName forStoreURL:(NSURL *)storeURL;

@property (nonatomic,readonly) NSManagedObjectContext *context;

- (void)saveContext;
- (BOOL)saveContext:(NSError **)error;

- (NSArray *)fetchObjectsForEntity:(NSString *)entityName;
- (NSManagedObject *)createObjectWithEntityName:(NSString *)entityName;
- (void)deleteObject:(NSManagedObject *)object;

@end
