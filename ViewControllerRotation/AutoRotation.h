//
//  AutoRotation.h
//  NestedNavViewCtrl
//
//  Created by Jason Yang on 14-8-21.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoRotation : NSObject

@property (nonatomic,readonly) NSNumber *key;
@property (nonatomic,readonly) UIInterfaceOrientationMask mask;
@property (nonatomic,readonly) UIInterfaceOrientation preferredOrientation;
- (BOOL)isSupportedForOrientation:(UIInterfaceOrientation)orientation;

+ (AutoRotation *)rotationForViewController:(UIViewController *)viewController;

@end
