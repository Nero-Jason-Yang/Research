//
//  UIMutableDevice.h
//  ViewControllerRotation
//
//  Created by Jason Yang on 14-8-22.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMutableDevice : UIDevice

+ (UIMutableDevice *)currentDevice;

@property(nonatomic) UIDeviceOrientation orientation;

@end

@interface UIDevice (UIInterfaceOrientation)

@property UIInterfaceOrientation interfaceOrientation;

@end
