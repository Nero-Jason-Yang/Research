#import "NSManagedObjectContext+Utils.h"

@implementation NSManagedObjectContext (Utils)

+ (id)contextWithModelName:(NSString *)modelName storeURL:(NSURL *)storeURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:[NSNumber numberWithBool:YES]};
    if (![store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NBLog(@"Unresolved error %@, at file:%s(%d)", error, __FILE__, __LINE__);
        abort();
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setPersistentStoreCoordinator:store];
    return context;
}

+ (id)contextWithModelName:(NSString *)modelName storeName:(NSString *)storeName
{
    NSURL *storeURL = [NSManagedObjectContext storeURLWithStorename:storeName];
    return [NSManagedObjectContext contextWithModelName:modelName storeURL:storeURL];
}

+ (id)contextWithModelName:(NSString *)modelName
{
    return [NSManagedObjectContext contextWithModelName:modelName storeName:modelName];
}

+ (NSURL *)storeURLWithStorename:(NSString *)storeName
{
    NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:[storeName stringByAppendingString:@".sqlite"]];
    return storeURL;
}

- (void)save
{
    NSError *error;
    if ([self hasChanges] && ![self save:&error]) {
#ifdef DEBUG
        NBLog(@"Database save error %@, at file:%s(%d)", error, __FILE__, __LINE__);
        abort();
#endif
    }
}

- (void)checkEntityName:(NSString *)entityName
{
    if (![self.persistentStoreCoordinator.managedObjectModel.entitiesByName objectForKey:entityName]) {
#ifdef DEBUG
        NBLog(@"Database entity was not defined for name: %@", entityName);
#endif
        abort();
    }
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
{
    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    NSParameterAssert(array);
#ifdef DEBUG
    if (error) {
        NBLog(@"Database fetch error: %@", error);
    }
#endif
    return array;
}

- (NSUInteger)fetchCountForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    [self checkEntityName:entityName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setReturnsObjectsAsFaults:YES];
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSUInteger count = [self countForFetchRequest:request error:&error];
#ifdef DEBUG
    if (error) {
        NBLog(@"Database count error: %@", error);
    }
#endif
    if (count == NSNotFound) {
        count = 0;
    }
    
    return count;
}

- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName
{
    [self checkEntityName:entityName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    return [self executeFetchRequest:request];
}

- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    [self checkEntityName:entityName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    return [self executeFetchRequest:request];
}

- (NSArray *)fetchObjectsForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)limit fetchOffset:(NSUInteger)offset
{
    [self checkEntityName:entityName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    if (limit > 0) {
        [request setFetchLimit:limit];
    }
    if (offset > 0) {
        [request setFetchOffset:offset];
    }
    
    return [self executeFetchRequest:request];
}

- (id)fetchOneObjectForEntityName:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    [self checkEntityName:entityName];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    [request setFetchLimit:1];
    
    NSArray *array = [self executeFetchRequest:request];
    return array.count > 0 ? array[0] : nil;
}

- (id)createObjectForEntityName:(NSString *)entityName
{
    [self checkEntityName:entityName];
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

@end
