//
//  Project.h
//  KnowledgeBase
//
//  Created by Jason Yang on 13-12-20.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REGISTERPROJECT + (void)load { [super load]; }

@interface Project : NSObject
+ (NSString *)projectTitle;
+ (NSString *)projectDetails;
@end

@interface ProjectManager : NSObject
+ (NSDictionary *)tree;
+ (NSDictionary *)projectsByName;
@end
