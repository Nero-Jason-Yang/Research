//
//  UIMutableDevice.m
//  ViewControllerRotation
//
//  Created by Jason Yang on 14-8-22.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "UIMutableDevice.h"

@implementation UIMutableDevice

@dynamic orientation;

+ (UIMutableDevice *)currentDevice
{
    return (UIMutableDevice *)[super currentDevice];
}

@end

@implementation UIDevice (UIInterfaceOrientation)

- (UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientation)self.orientation;
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    ((UIMutableDevice *)self).orientation = (UIDeviceOrientation)interfaceOrientation;
}

@end
