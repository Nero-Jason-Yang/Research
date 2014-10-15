//
//  UIDevice+Orientation.m
//  ViewControllerRotation
//
//  Created by Jason Yang on 14-10-15.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "UIDevice+Orientation.h"

@interface _UIMutableDevice : UIDevice
@property(nonatomic) UIDeviceOrientation orientation;
@end

@implementation _UIMutableDevice
@dynamic orientation;
@end

@implementation UIDevice (Orientation)
- (UIInterfaceOrientation)interfaceOrientation {
    return (UIInterfaceOrientation)self.orientation;
}
- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    self.orientation = (UIDeviceOrientation)interfaceOrientation;
}
- (void)setOrientation:(UIDeviceOrientation)orientation {
    ((_UIMutableDevice *)self).orientation = orientation;
}
@end
