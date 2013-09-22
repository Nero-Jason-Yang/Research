//
//  CategoryPerson.m
//  Database
//
//  Created by Jason Yang on 13-8-27.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "CategoryPerson.h"

@interface CategoryPerson ()
{
    NSString *_uuid;
}
@end

@implementation CategoryPerson

- (id)init
{
    if (self = [super init]) {
        _uuid = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (NSString *)uuid
{
    return _uuid;
}

@end
