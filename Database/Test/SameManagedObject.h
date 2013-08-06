//
//  SameManagedObject.h
//  Database
//
//  Created by Jason Yang on 13-8-2.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SameManagedObject;

@interface SameManagedObject : NSManagedObject

@property (nonatomic, retain) id cmetadata;
@property (nonatomic, retain) id lmetadata;
@property (nonatomic, retain) NSNumber * loperation;
@property (nonatomic, retain) id umetadata;
@property (nonatomic, retain) NSNumber * uoperation;

@end
