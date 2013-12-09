#import <Foundation/Foundation.h>

@interface ProjectManager : NSObject

+ (NSDictionary *)projects;

+ (void)registerProject:(NSString *)projectName withClass:(Class)projectClass;

@end
