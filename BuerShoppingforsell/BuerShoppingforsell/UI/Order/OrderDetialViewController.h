//
//  OrderDetialViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/22.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface OrderDetialViewController : BaseNavigationController
@property (weak, nonatomic) IBOutlet UITableView *myTableVeiw;
@property (weak, nonatomic) IBOutlet UIView *bottomVeiw;
@property (nonatomic ,strong) NSString * orderid;
@property (nonatomic,strong) NSString * key;


@end
