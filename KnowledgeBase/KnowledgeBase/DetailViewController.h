//
//  DetailViewController.h
//  KnowledgeBase
//
//  Created by Jason Yang on 13-12-20.
//  Copyright (c) 2013年 nero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
