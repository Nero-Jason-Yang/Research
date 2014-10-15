//
//  ViewController.m
//  HorizontalTable
//
//  Created by Jason Yang on 14-10-15.
//  Copyright (c) 2014年 nero. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalTableView.h"

@interface ViewController () <HorizontalTableViewDataSource, HorizontalTableViewDelegate>
@property (nonatomic) HorizontalTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect frame = self.view.frame;
    frame.origin.y = 40;
    frame.size.height = 60;
    self.tableView = [[HorizontalTableView alloc] initWithFrame:frame];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.cellDefaultWidth = 120;
    self.tableView.separatorColor = [UIColor redColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(20, 0, 10, 0);
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableViewNumberOfCells:(HorizontalTableView *)tableView {
    return 6;
}

- (HorizontalTableViewCell *)tableView:(HorizontalTableView *)tableView cellAtIndex:(NSInteger)index {
    static NSString *identifier = @"cell";
    
    HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HorizontalTableViewCell alloc] initWithReuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @(index).description;
    
    return cell;
}

- (CGFloat)tableView:(HorizontalTableView *)tableView widthForCellAtIndex:(NSInteger)index {
    if (index == 2) {
        return 60;
    }
    return tableView.cellDefaultWidth;
}

@end
