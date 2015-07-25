//
//  ShopDetialViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/1.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface ShopDetialViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableVeiw;
@end
