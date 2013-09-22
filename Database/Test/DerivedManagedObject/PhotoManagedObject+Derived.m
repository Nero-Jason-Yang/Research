//
//  PhotoManagedObject+Derived.m
//  Database
//
//  Created by Jason Yang on 13-9-4.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "PhotoManagedObject+Derived.h"

@implementation PhotoManagedObject (Derived)

- (void)setName:(NSString *)name
{
    [_changeSet setObject:name forKey:@"name"];
}

- (NSString *)name
{
    return [_changeSet objectForKey:@"name"];
}

@end
