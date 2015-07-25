//
//  OrderCellTableViewCell.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/14.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_log;
@property (weak, nonatomic) IBOutlet UILabel *lbl_orderTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_price;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num;
@property (weak, nonatomic) IBOutlet UILabel *lbl_guige;

@end
