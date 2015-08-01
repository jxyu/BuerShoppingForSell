//
//  RealNameViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/7/21.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface RealNameViewController : BaseNavigationController
@property (nonatomic,strong) NSString *key;
@property (weak, nonatomic) IBOutlet UITextField *txt_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_borndate;
- (IBAction)Btn_Borndate:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_address;
@property (weak, nonatomic) IBOutlet UIButton *btn_imgupload1;
@property (weak, nonatomic) IBOutlet UIButton *btn_imgupload2;
@property (weak, nonatomic) IBOutlet UIButton *btn_Submit;
@property (weak, nonatomic) IBOutlet UIButton *btn_imageupload3;
@property (weak, nonatomic) IBOutlet UIButton *btn_imgupload4;

@end
