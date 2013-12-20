//
//  Project.m
//  KnowledgeBase
//
//  Created by Jason Yang on 13-12-20.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "Project.h"

@implementation Project

+ (void)load
{
    NSString *projectName = NSStringFromClass(self);
    if ([projectName isEqualToString:@"Project"]) {
        return;
    }
    
    // register project.
    NSMutableDictionary *projectsByName = (NSMutableDictionary *)ProjectManager.projectsByName;
    projectsByName[projectName] = self;
    
    // get inheritance path.
    NSMutableArray *path = [NSMutableArray array];
    Class clazz = self.superclass;
    while (clazz) {
        NSString *name = NSStringFromClass(clazz);
        if ([name isEqualToString:@"Project"]) {
            break;
        }
        [path insertObject:name atIndex:0];
        clazz = clazz.superclass;
    }
    
    // add path to tree.
    NSMutableDictionary *group = (NSMutableDictionary *)ProjectManager.tree;
    for (NSString *name in path) {
        id item = group[name];
        if (!item || ![item isKindOfClass:NSDictionary.class]) {
            item = [NSMutableDictionary dictionary];
            group[name] = item;
        }
        NSParameterAssert([item isKindOfClass:NSDictionary.class]);
        group = item;
    }
    
    // add project to tree.
    group[projectName] = self;
}

+ (NSString *)projectTitle
{
    return [self description];
}

+ (NSString *)projectDetails
{
    return nil;
}

@end

@implementation ProjectManager

+ (NSDictionary *)tree
{
    static NSMutableDictionary *projectsByName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        projectsByName = [NSMutableDictionary dictionary];
    });
    return projectsByName;
}

+ (NSDictionary *)projectsByName;
{
    static NSMutableDictionary *groupsByName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        groupsByName = [NSMutableDictionary dictionary];
    });
    return groupsByName;
}

@end
