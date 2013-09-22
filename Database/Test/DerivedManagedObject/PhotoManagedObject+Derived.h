//
//  PhotoManagedObject+Derived.h
//  Database
//
//  Created by Jason Yang on 13-9-4.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "PhotoManagedObject.h"

@interface PhotoManagedObject ()
{
    NSMutableDictionary *_changeSet;
}
@end

@interface PhotoManagedObject (Derived)

@property (nonatomic) NSString *name;

@end
