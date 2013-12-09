#import "ProjectManager.h"

@implementation ProjectManager

+ (NSDictionary *)projects
{
    static NSMutableDictionary *projects;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        projects = [NSMutableDictionary dictionary];
    });
    return projects;
}

+ (void)registerProject:(NSString *)projectName withClass:(Class)projectClass
{
    NSMutableDictionary *dic = (NSMutableDictionary *)self.projects;
    [dic setObject:projectClass forKey:projectName];
}

@end
