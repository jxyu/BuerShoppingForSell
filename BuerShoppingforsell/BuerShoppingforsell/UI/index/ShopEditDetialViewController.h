//
//  ShopEditDetialViewController.h
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/31.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface ShopEditDetialViewController : BaseNavigationController
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic,strong) NSDictionary * StoreInfo;
@property (nonatomic,strong) NSString * key;

@end
