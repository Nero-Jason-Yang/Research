//
//  UIDevice+Orientation.h
//  ViewControllerRotation
//
//  Created by Jason Yang on 14-10-15.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Orientation)
@property UIInterfaceOrientation interfaceOrientation;
- (void)setOrientation:(UIDeviceOrientation)orientation;
@end
