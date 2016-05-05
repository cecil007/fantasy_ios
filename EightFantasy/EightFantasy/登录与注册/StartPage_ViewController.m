//
//  StartPage_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/13.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "StartPage_ViewController.h"
#import "LoginViewController.h"
#import "Register_ViewController.h"
#import "SKSplashIcon.h"
#import "SKSplashView.h"
@interface StartPage_ViewController () <SKSplashDelegate>
@property (strong, nonatomic) SKSplashView *splashView;
@end

@implementation StartPage_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.EmailBtn setRadius:4.0 borderWidth:0.0 borderColor:[UIColor clearColor]];
    [self.LoginBtn setRadius:4.0 borderWidth:0.0 borderColor:[UIColor clearColor]];
    if(INCH3_5)
    {
        self.BgImage.image = [UIImage imageNamed:@"640x960.png"];
    }
    if(INCH4)
    {
        self.BgImage.image = [UIImage imageNamed:@"640x1136.png"];
    }
    if(INCH4_7)
    {
        self.BgImage.image = [UIImage imageNamed:@"750x1334.png"];
    }
    if(INCH5_5)
    {
        self.BgImage.image = [UIImage imageNamed:@"1242x2208.png"];
    }
    
   // [self twitterSplash];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) twitterSplash
{
    
    SKSplashIcon *twitterSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"logo.png"] animationType:SKIconAnimationTypeBounce];
    UIColor *twitterColor = [UIColor colorWithRed:99.0/255.0f green:98.0/255.0f blue:196.0/255.0f alpha:1.0];
    _splashView = [[SKSplashView alloc] initWithSplashIcon:twitterSplashIcon backgroundColor:twitterColor animationType:SKSplashAnimationTypeNone];
    _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
    _splashView.animationDuration = 2; //Optional -> set animation duration. Default: 1s
    [self.view addSubview:_splashView];
    [_splashView startAnimation];
}

- (void) splashView:(SKSplashView *)splashView didBeginAnimatingWithDuration:(float)duration
{
    NSLog(@"Started animating from delegate");
}

- (void) splashViewDidEndAnimating:(SKSplashView *)splashView
{
    NSLog(@"Stopped animating from delegate");
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

- (IBAction)EmailClick:(id)sender {
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:2 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    Register_ViewController * regis =[[Register_ViewController alloc] initWithNibName:@"Register_ViewController" bundle:nil];
    [self.navigationController pushViewController:regis animated:YES];
    
}

- (IBAction)LoginClick:(id)sender {
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:2 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    LoginViewController * login =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
@end
