//
//  AppDelegate.h
//  BuerShoppingforsell
//
//  Created by 于金祥 on 15/7/25.
//  Copyright (c) 2015年 zykj.BuerShoppingforsell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
#import "FirstScrollController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CustomTabBarViewController *_tabBarViewCol;
    FirstScrollController *firstCol;
}

- (void)showTabBar;
- (void)hiddenTabBar;
- (void)selectTableBarIndex:(NSInteger)index;
-(CustomTabBarViewController *)getTabBar;
@property (strong, nonatomic) UIWindow *window;



@end

