//
//  ViewController.m
//  RemoteVideoPlayback
//
//  Created by Jason Yang on 14-9-11.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"www.baidu.com"]];
    [self presentViewController:player animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
