//
//  MainTabBarViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/4.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "Word_ViewController.h"
#import "WriteDream_ViewController.h"
#import "My_ViewController.h"




#import "LIKITHeader.h"
#import "AppNetWork.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    
        self.delegate=self;
        
        
        Word_ViewController * wordVC = [[Word_ViewController alloc] initWithNibName:@"Word_ViewController" bundle:nil];
        UINavigationController * wordNC = [[UINavigationController alloc] initWithRootViewController:wordVC];
        wordNC.navigationBarHidden = YES;
        wordNC.tabBarItem = [self createBarWithSeledImage:@"word_selected.png" unseledImage:@"word_normal.png" WithTitle:@"世界"];
        wordVC.view.backgroundColor = color(0x83868d);
        
        
        UIViewController * writeDreamVC = [[UIViewController alloc] init];
       // WriteDream_ViewController * writeDreamVC = [[WriteDream_ViewController alloc] initWithNibName:@"WriteDream_ViewController" bundle:nil];
        UINavigationController * writeDreamNC = [[UINavigationController alloc] initWithRootViewController:writeDreamVC];
        writeDreamNC.navigationBarHidden = YES;
        writeDreamNC.tabBarItem = [self createBarWithSeledImage:@"writedream_selected.png" unseledImage:@"writedream_normal.png" WithTitle:@"写梦"];
        
        My_ViewController * myVC = [[My_ViewController alloc] initWithNibName:@"My_ViewController" bundle:nil];
        UINavigationController * myNC = [[UINavigationController alloc] initWithRootViewController:myVC];
        myNC.navigationBarHidden = YES;
        myNC.tabBarItem = [self createBarWithSeledImage:@"my_selected.png" unseledImage:@"my_normal.png" WithTitle:@"我的"];
        
        
        
        
        self.viewControllers = @[wordNC,writeDreamNC,myNC];
        
        
        //设置TabBarItem字体颜色
//        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color(0x8b8a8a), UITextAttributeTextColor, nil] forState:UIControlStateNormal];
//        [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:color(0x6b5acd),UITextAttributeTextColor, nil]forState:UIControlStateSelected];
        
        //不写这句话 第一次载入 tabbar1变蓝色
        // self.tabBar.backgroundImage=[UIImage  imageNamed:@"tab_bg.png"];
        self.tabBar.tintColor=color(0x6b5acd);
        
        
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"首页tab条"]];
        
        
        
    }
    
    return self;
}
-(UITabBarItem*)createBarWithSeledImage:(NSString*)seledImage unseledImage:(NSString*)unseledImage WithTitle:(NSString* )title
{
    
    UITabBarItem* barItem=nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIImage * UnSeledImage = [UIImage imageNamed:unseledImage];
        [UnSeledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *SeledImage=[UIImage imageNamed:seledImage];
        [SeledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        barItem = [[UITabBarItem alloc] initWithTitle:title image:UnSeledImage selectedImage:SeledImage];
    }else
    {
        barItem=[[UITabBarItem alloc] init];
        [barItem setFinishedSelectedImage:[UIImage imageNamed:seledImage]
              withFinishedUnselectedImage:[UIImage imageNamed:unseledImage]];
    }
    
    //移动title，使其隐藏。因为如果bar的title是nil或空字符串，title默认会设为nav bar的title。
   // barItem.titlePositionAdjustment = UIOffsetMake(0, 20.0);
        barItem.title = title;
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color(0x8b8a8a)} forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]} forState:UIControlStateNormal];
    
    //向下移动图标
    float downMove =0;
    barItem.imageInsets = UIEdgeInsetsMake(downMove,0, -1*downMove, 0);
    
    return barItem;
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    

        NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
        if (index == 1) {
                UINavigationController *nc = [tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
            
                WriteDream_ViewController * writeDreamVC = [[WriteDream_ViewController alloc] init];
                writeDreamVC.hidesBottomBarWhenPushed = YES;
                [nc pushViewController:writeDreamVC animated:YES];
                return NO;
            } else {
                return YES;
            }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view from its nib.
    /*
    [Post(nil, @{@"apiVersion":@"V2.0",
                 @"cmdid":@"10004",
                 @"uid":@(0),
                 @"timestamp":@([[NSDate date] timeIntervalSince1970]),
                 @"eid":@(0),
                 @"oamid":@(0),
                 @"token":@"",
                 @"params" : @{
        @"userName":@"cecil2",
        @"email":@"aaa111@qq.com",
        @"type":@(1)
    }}) connection:^(LIRequest *request, id response, NSError *error) {
        
    }];
     */
    /*
    [AppNetWork networkRegisterCheckUserName:@"lbti" email:@"lbrt" type:AccountTypeUserName finish:^(BOOL finish) {
        
    }];
     */
    
    /*
    [AppNetWork networkRegisterUserName:@"lbti" email:@"lbti@qq.com" pwd:@"12345678" finish:^(BOOL finish) {
        
    }];
     */
    /*
    [AppNetWork networkLoginUserName:@"lbti" pwd:@"12345678" finish:^(BOOL finish) {
        
    }];
     */
    [AppNetWork networkUserInfoUid:nil finish:^(NSDictionary *info, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
