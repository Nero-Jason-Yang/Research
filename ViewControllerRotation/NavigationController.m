//
//  NavigationController.m
//  NestedNavViewCtrl
//
//  Created by Jason Yang on 14-8-21.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "NavigationController.h"
#import "AutoRotation.h"

@interface MyDevice : UIDevice
@property(nonatomic) UIDeviceOrientation orientation;
@end
@implementation MyDevice
@dynamic orientation;
@end

@interface NavigationController () <UINavigationControllerDelegate>

@end

@implementation NavigationController
{
    UIInterfaceOrientation _currentOrientation;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    _currentOrientation = toInterfaceOrientation;
}

- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation deviceOrientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    UIInterfaceOrientation currentOrientation = _currentOrientation;
    if (currentOrientation == deviceOrientation) {
        return NO;
    }
    
    UIInterfaceOrientationMask deviceOrientationMask = (1 << [UIDevice currentDevice].orientation);
    AutoRotation *rotation = [AutoRotation rotationForViewController:self.topViewController];
    if (0 == (rotation.mask | deviceOrientationMask)) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger mask = [AutoRotation rotationForViewController:self.topViewController].mask;
    return mask ? mask : UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    MyDevice *device = (MyDevice *)[UIDevice currentDevice];
    AutoRotation *rotation = [AutoRotation rotationForViewController:viewController];
    if (![rotation isSupportedForOrientation:(UIInterfaceOrientation)device.orientation]) {
        UIDeviceOrientation orientation = device.orientation;
        device.orientation = UIInterfaceOrientationPortrait;
        
        [self.class attemptRotationToDeviceOrientation];
        
        device.orientation = orientation;
    } else if ((UIInterfaceOrientation)device.orientation != _currentOrientation) {
        [self.class attemptRotationToDeviceOrientation];
    }
}

@end
