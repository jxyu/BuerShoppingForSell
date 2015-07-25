//
//  SetViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/12.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface SetViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *my_tableView;

@end
