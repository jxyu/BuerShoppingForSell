//
//  AddGoodsViewController.h
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/25.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface AddGoodsViewController : BaseNavigationController
@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (nonatomic,strong) NSString * commonid;
@property (nonatomic) BOOL isEdit;
@end
