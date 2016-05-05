//
//  AppDelegate.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/4.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "LoginViewController.h"
#import "StartPage_ViewController.h"


#import "UMSocial.h"//友盟相关的
#import "MobClick.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import "DropRefreshShareOject.h"
#import "WeiboSDK.h"




#define  UmengAppkey @"571e21f8e0f55afba60001fa"
//微信的appid
#define WeiXinAppId @"wxae31ede65f71ea8f"
//微信的AppSecret
#define WeiXinSecret @"0d191b20f8147a926724614890b78039"


@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setUMAppkeys];
    UIWindow * windows =[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    windows.backgroundColor =[UIColor whiteColor];
    self.window = windows;
    if (isNotEmptyObject([AppNetWork userId])) {
        [self tabMainViewConrtollerType:RootViewControllerTypeTabBar];
    }else{
        [self tabMainViewConrtollerType:RootViewControllerTypeLogin];
    }
    [windows makeKeyAndVisible];
    

    
    
    return YES;
}


///直接切换到登录页面
- (void)tabLoginViewController{
    LoginViewController * login =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    login.notShouldPop = @"YES";
    login.view.frame = self.window.bounds;
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:login];
    nc.navigationBar.hidden = NO;
    self.window.rootViewController = nc;
    [self.window  makeKeyAndVisible];
    nc.navigationBarHidden = NO;
    nc.navigationBar.barTintColor = color(0x6b5acd);
    nc.view.backgroundColor = [UIColor whiteColor];
}
///切换
- (void)tabMainViewConrtollerType:(enum RootViewControllerType)type{
    [DropRefreshShareOject sharedInstance];
    if (type == RootViewControllerTypeLogin) {
        StartPage_ViewController * login =[[StartPage_ViewController alloc] initWithNibName:@"StartPage_ViewController" bundle:nil];
        login.view.frame = self.window.bounds;
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:login];
        nc.navigationBar.hidden = YES;
        self.window.rootViewController = nc;
        [self.window  makeKeyAndVisible];
    }else if (type == RootViewControllerTypeTabBar) {
        MainTabBarViewController * main =[[MainTabBarViewController alloc] initWithNibName:@"MainTabBarViewController" bundle:nil];
        main.view.frame = self.window.bounds;
        self.window.rootViewController = main;
        [self.window makeKeyAndVisible];
    }
}
#pragma mark 友盟的相关的key
-(void) setUMAppkeys
{
    
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialWechatHandler setWXAppId:WeiXinAppId appSecret:WeiXinSecret url:@"http://www.umeng.com/social"];
    
    if([WeiboSDK isWeiboAppInstalled])
    {
        [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1848803250"
                        RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    }else
    {
         [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    }
   
    
    [MobClick startWithAppkey:UmengAppkey reportPolicy:BATCH   channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
}
/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    if ([url.absoluteString hasPrefix:@"wb1848803250://"]) {
//        return [WeiboSDK handleOpenURL:url delegate:self];
//    }else
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark 新浪分享
- (void)sinaShareImage:(UIImage *)image{
    [WeiboSDK registerApp:@"1848803250"];
    WBMessageObject *message = [WBMessageObject message];
    message.text = @"";
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 0.5f);
    message.imageObject = imageObject;
    WBSendMessageToWeiboRequest *requ = [[WBSendMessageToWeiboRequest alloc] init];
    requ.userInfo = @{@"type":@"postImageAndText"};
    requ.message = message;
    [WeiboSDK sendRequest:requ];
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{

}
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
    switch (response.statusCode) {
        case WeiboSDKResponseStatusCodeUserCancel:
            [LIAlertView alertViewWithTitle:@"取消分享" delegate:nil];
            break;
        case WeiboSDKResponseStatusCodeSuccess:
            [LIAlertView alertViewWithTitle:@"分享成功" delegate:nil];
            break;
        case WeiboSDKResponseStatusCodeSentFail:
        case WeiboSDKResponseStatusCodeAuthDeny:
        case WeiboSDKResponseStatusCodeUserCancelInstall:
        case WeiboSDKResponseStatusCodeUnsupport:
        case WeiboSDKResponseStatusCodeUnknown:
        default:

            [LIAlertView alertViewWithTitle:@"分享失败" delegate:nil];
            break;
    }
}
@end
