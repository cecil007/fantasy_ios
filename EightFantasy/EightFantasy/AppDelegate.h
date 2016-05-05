//
//  AppDelegate.h
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/4.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

enum RootViewControllerType{
    RootViewControllerTypeLogin,
    RootViewControllerTypeTabBar
};
#import "MainTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

///直接切换到登录页面
- (void)tabLoginViewController;
///切换根视图显示页面
- (void)tabMainViewConrtollerType:(enum RootViewControllerType)type;
///新浪微博分享
- (void)sinaShareImage:(UIImage *)image;
@end

