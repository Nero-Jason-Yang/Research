#import "Database.h"
#import "NSURL+Utils.h"

@implementation Database

- (NSManagedObjectContext *)contextWithModelName:(NSString *)modelName forStoreURL:(NSURL *)storeURL
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSError *error = nil;
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if (![store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, at file:%s(%d)", error, __FILE__, __LINE__);
        abort();
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:store];
    return context;
}

- (id)initWithModelName:(NSString *)modelName
{
    if (self = [super init]) {
        NSURL *storeURL = [NSURL.applicationDocumentsDirectory URLByAppendingPathComponent:[modelName stringByAppendingString:@".sqlite"]];
        _context = [self contextWithModelName:modelName forStoreURL:storeURL];
        [self onInit];
    }
    return self;
}

- (id)initWithModelName:(NSString *)modelName forStoreName:(NSString *)storeName
{
    if (self = [super init]) {
        NSURL *storeURL = [NSURL.applicationDocumentsDirectory URLByAppendingPathComponent:[storeName stringByAppendingString:@".sqlite"]];
        _context = [self contextWithModelName:modelName forStoreURL:storeURL];
        [self onInit];
    }
    return self;
}

- (id)initWithModelName:(NSString *)modelName forStoreURL:(NSURL *)storeURL
{
    if (self = [super init]) {
        _context = [self contextWithModelName:modelName forStoreURL:storeURL];
        [self onInit];
    }
    return self;
}

- (void)onInit
{
    
}

- (void)save
{
    NSError *error = nil;
    if (![self save:&error]) {
        NSLog(@"Unresolved error %@, at file:%s(%d)", error, __FILE__, __LINE__);
        abort();
    }
}

- (BOOL)save:(NSError **)error
{
    NSManagedObjectContext *context = self.context;
    if (!context) {
        return YES;
    }
    
    if (![context hasChanges]) {
        return YES;
    }
    
    if ([context save:error]) {
        return YES;
    }
    
    return NO;
}

- (NSArray *)fetchObjectsForEntity:(NSString *)entityName
{
    NSManagedObjectContext *context = self.context;
    if (!context) {
        return nil;
    }
    
    if (![context.persistentStoreCoordinator.managedObjectModel.entitiesByName objectForKey:entityName]) {
        return nil; // entity not found in database
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Database fetch error %@, %@, at file:%s(%d)", error, [error userInfo], __FILE__, __LINE__);
    }
    
    return results;
}

- (NSArray *)fetchObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchLimit:(NSUInteger)maxCount fetchOffset:(NSUInteger)offset
{
    NSManagedObjectContext *context = self.context;
    if (!context) {
        return nil;
    }
    
    if (![context.persistentStoreCoordinator.managedObjectModel.entitiesByName objectForKey:entityName]) {
        return nil; // entity not found in database
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    if (maxCount > 0) {
        [fetchRequest setFetchLimit:maxCount];
    }
    
    if (offset > 0) {
        [fetchRequest setFetchOffset:offset];
    }
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Database fetch error %@, %@, at file:%s(%d)", error, [error userInfo], __FILE__, __LINE__);
    }
    
    return results;
}

- (id)createObjectForEntity:(NSString *)entityName
{
    NSManagedObjectContext *context = _context;
    if (!context) {
        return nil;
    }
    
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    
    return mo;
}

- (void)deleteObject:(NSManagedObject *)object
{
    NSManagedObjectContext *context = _context;
    if (!context) {
        return;
    }
    
    [context deleteObject:object];
}

@end
