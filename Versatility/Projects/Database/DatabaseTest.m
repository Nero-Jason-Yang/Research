#import "DatabaseTest.h"
#import "ProjectManager.h"
#import "DatabaseTestMO.h"
#import "NSManagedObjectContext+Utils.h"

@implementation DatabaseTest

+ (void)load
{
    NSMutableArray *array = [NSMutableArray array];
    Class clazz = NSManagedObjectContext.class;
    while (clazz) {
        NSString *name = NSStringFromClass(clazz);
        [array insertObject:name atIndex:0];
        clazz = clazz.superclass;
    }
    NSLog(@"%@", array);
    
    NSString *des = [self description];
    NSString *superName = NSStringFromClass(self.superclass);
    NSString *className = NSStringFromClass(self.class);
    [ProjectManager registerProject:className withClass:self.class];
}

- (id)init
{
    if (self = [super init]) {
        [self test];
    }
    return self;
}

- (void)test
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextWithModelName:@"DatabaseTest"];
    DatabaseTestMO *mo = [context createObjectForEntityName:@"DatabaseTestMO"];
    if (mo) {
        NSManagedObjectContext *c1 = mo.managedObjectContext;
        NSParameterAssert(c1);
        [context deleteObject:mo];
        [context save];
        NSManagedObjectContext *c2 = mo.managedObjectContext;
        NSParameterAssert(!c2);
    }
}

@end
