//
//  OrderListViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/13.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface OrderListViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSString *OrderStatus;
@end
