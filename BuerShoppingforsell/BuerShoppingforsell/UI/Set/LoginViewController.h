//
//  LoginViewController.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/11.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface LoginViewController : BaseNavigationController
@property (weak, nonatomic) IBOutlet UIView *BackView_username;
@property (weak, nonatomic) IBOutlet UITextField *txt_username;
@property (weak, nonatomic) IBOutlet UIView *BackView_pwd;
@property (weak, nonatomic) IBOutlet UITextField *txt_pwd;
@property (weak, nonatomic) IBOutlet UIButton *Btn_Login;

@end
