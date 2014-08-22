//
//  UINavigationRotatableController.m
//  ViewControllerRotation
//
//  Created by Jason Yang on 14-8-22.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "UINavigationRotatableController.h"
#import "UIMutableDevice.h"

@interface UINavigationRotatableController () <UINavigationControllerDelegate>
@property (nonatomic) UIInterfaceOrientation currentOrientation;
@end

@implementation UINavigationRotatableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.currentOrientation = [UIDevice currentDevice].interfaceOrientation;
}

#pragma mark UIViewController(UIViewControllerRotation)

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    self.currentOrientation = toInterfaceOrientation;
}

- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation deviceOrientation = [UIDevice currentDevice].interfaceOrientation;
    if (deviceOrientation == self.currentOrientation) {
        return NO;
    }
    
    UIInterfaceOrientationMask deviceOrientationMask = (1 << deviceOrientation);
    if (0 == (self.topViewController.supportedInterfaceOrientations & deviceOrientationMask)) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.topViewController) {
        return self.topViewController.supportedInterfaceOrientations;
    }
    
    return [super supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if (self.topViewController) {
        return self.topViewController.preferredInterfaceOrientationForPresentation;
    }
    
    return [super preferredInterfaceOrientationForPresentation];
}

#pragma mark <UINavigationControllerDelegate>

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIDevice *device = [UIDevice currentDevice];
    UIInterfaceOrientation deviceOrientation = device.interfaceOrientation;
    UIInterfaceOrientationMask deviceOrientationMask = (1 << deviceOrientation);
    
    if (0 == (viewController.supportedInterfaceOrientations & deviceOrientationMask)) {
        device.interfaceOrientation = viewController.preferredInterfaceOrientationForPresentation;
        [self.class attemptRotationToDeviceOrientation];
        device.interfaceOrientation = deviceOrientation;
    }
    else if (deviceOrientation != self.currentOrientation) {
        [self.class attemptRotationToDeviceOrientation];
    }
}

@end
