//
//  PhotoFileMO.h
//  Research
//
//  Created by Jason Yang on 13-10-16.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FileMO.h"


@interface PhotoFileMO : FileMO

@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;

@end
