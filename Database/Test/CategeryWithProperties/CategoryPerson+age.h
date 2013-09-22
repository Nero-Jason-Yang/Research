//
//  CategoryPerson+age.h
//  Database
//
//  Created by Jason Yang on 13-8-27.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "CategoryPerson.h"

@interface CategoryPerson ()
@property (nonatomic) NSUInteger age;
@end

@interface CategoryPerson (age)
- (NSUInteger)score;
@end
