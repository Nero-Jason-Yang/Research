//
//  CategoryPerson+age.m
//  Database
//
//  Created by Jason Yang on 13-8-27.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import "CategoryPerson+age.h"

@interface CategoryPerson ()
@property (nonatomic) NSUInteger coef;
@end

@implementation CategoryPerson (age)

//- (id)init
//{
//    if (self = [super init]) {
//        self.coef = 2;
//    }
//    return self;
//}

- (NSUInteger)score
{
    return self.age * self.coef;
}

@end
