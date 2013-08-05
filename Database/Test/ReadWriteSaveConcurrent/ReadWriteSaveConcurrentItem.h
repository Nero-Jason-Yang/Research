//
//  ReadWriteSaveConcurrentItem.h
//  Database
//
//  Created by Yang Jason on 13-8-5.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReadWriteSaveConcurrentItem : NSManagedObject

@property (nonatomic, retain) NSDictionary * info;

@end
