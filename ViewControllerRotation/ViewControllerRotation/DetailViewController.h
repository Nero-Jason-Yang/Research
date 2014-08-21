//
//  DetailViewController.h
//  ViewControllerRotation
//
//  Created by Jason Yang on 14-8-21.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
