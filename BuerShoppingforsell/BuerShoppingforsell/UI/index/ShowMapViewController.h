//
//  ShowMapViewController.h
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/31.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "BaseNavigationController.h"

@interface ShowMapViewController : BaseNavigationController
@property (nonatomic,strong) NSString * Title;
@property (nonatomic,strong) NSString * address;
@property (nonatomic) CGFloat storelat;
@property (nonatomic) CGFloat storelog;

@end
