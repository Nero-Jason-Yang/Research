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
        NSLog(@"Unresolved error %@, %@, at file:%s(%d)", error, [error userInfo], __FILE__, __LINE__);
        abort();
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:store];
    return context;
}

- (id)initWithModelName:(NSString *)modelName forStoreName:(NSString *)storeName
{
    if (self = [super init]) {
        NSURL *storeURL = [NSURL.applicationDocumentsDirectory URLByAppendingPathComponent:[storeName stringByAppendingString:@".sqlite"]];
        _context = [self contextWithModelName:modelName forStoreURL:storeURL];
    }
    return self;
}

- (id)initWithModelName:(NSString *)modelName forStoreURL:(NSURL *)storeURL
{
    if (self = [super init]) {
        _context = [self contextWithModelName:modelName forStoreURL:storeURL];
    }
    return self;
}

- (void)saveContext
{
    NSManagedObjectContext *context = _context;
    if (context) {
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application,
            // although it may be useful during development.
            NSLog(@"Unresolved error %@, %@, at file:%s(%d)", error, [error userInfo], __FILE__, __LINE__);
            abort();
        }
    }
}

- (BOOL)saveContext:(NSError **)error
{
    NSManagedObjectContext *context = _context;
    if (context) {
        if ([context hasChanges] && ![context save:error]) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)fetchObjectsForEntity:(NSString *)entityName
{
    if (![_context.persistentStoreCoordinator.managedObjectModel.entitiesByName objectForKey:entityName]) {
        return nil; // entity not found in database
    }
    NSError *error = nil;
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:entityName];
    NSArray *results = [_context executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Database fetch error %@, %@, at file:%s(%d)", error, [error userInfo], __FILE__, __LINE__);
    }
    return results;
}

- (NSManagedObject *)createObjectWithEntityName:(NSString *)entityName
{
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:_context];
    return mo;
}

- (void)deleteObject:(NSManagedObject *)object
{
    [_context deleteObject:object];
}

@end
