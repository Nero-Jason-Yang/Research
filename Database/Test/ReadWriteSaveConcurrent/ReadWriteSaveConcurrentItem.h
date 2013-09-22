//
//  ReadWriteSaveConcurrentItem.h
//  Database
//
//  Created by Jason Yang on 13-8-16.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReadWriteSaveConcurrentItem : NSManagedObject

@property (nonatomic, retain) id info;
@property (nonatomic, retain) NSNumber * num;

@end
