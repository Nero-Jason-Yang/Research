//
//  AutoRotation.m
//  NestedNavViewCtrl
//
//  Created by Jason Yang on 14-8-21.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "AutoRotation.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

@implementation AutoRotation

- (id)initWithClass:(Class)value
{
    if (self = [super init]) {
        _key = [NSNumber numberWithUnsignedInteger:(NSUInteger)value];
        _mask = 0;
    }
    return self;
}

- (void)addOrientation:(UIInterfaceOrientation)orientation
{
    if (0 == _preferredOrientation) {
        _preferredOrientation = orientation;
    }
    _mask |= (1 << orientation);
}

- (void)addOrientationMask:(UIInterfaceOrientationMask)mask
{
    if (0 == _preferredOrientation) {
        _preferredOrientation = UIInterfaceOrientationPortrait;
    }
    _mask |= mask;
}

- (BOOL)isSupportedForOrientation:(UIInterfaceOrientation)orientation
{
    UIInterfaceOrientationMask mask = (1 << orientation);
    return 0 != (_mask & mask);
}

+ (NSDictionary *)rotations
{
    static NSMutableDictionary *dic;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AutoRotation *rotation = nil;
        dic = [NSMutableDictionary dictionary];
        
        rotation = [[AutoRotation alloc] initWithClass:[MasterViewController class]];
        [rotation addOrientation:UIInterfaceOrientationPortrait];
        dic[rotation.key] = rotation;
        
        rotation = [[AutoRotation alloc] initWithClass:[DetailViewController class]];
        [rotation addOrientationMask:UIInterfaceOrientationMaskAllButUpsideDown];
        dic[rotation.key] = rotation;
    });
    
    return dic;
}

+ (AutoRotation *)rotationForViewController:(UIViewController *)viewController
{
    return [self rotations][[NSNumber numberWithUnsignedInteger:(NSUInteger)viewController.class]];
}

@end
