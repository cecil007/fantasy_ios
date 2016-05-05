//
//  LoginViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/4.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LIKITHeader.h"
#import "FindPassword_ViewController.h"
#import "Register_ViewController.h"



@interface LoginViewController ()<UIActionSheetDelegate,UITextFieldDelegate>
{
  
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    if (self.notShouldPop==nil) {
         if (self.navigationController.viewControllers.count>1) {
             [self creatBackItem];
         }
    }
    self.title = @"登录";
    [self rightTitle:@"注册"];
    [self.LoginBtn setRadius:4.0 borderWidth:1.0 borderColor:[UIColor clearColor]];
    [self.EmailView setRadius:4.0 borderWidth:1.0 borderColor:color(0x999999)];
    [self.PasswordView setRadius:4.0 borderWidth:1.0 borderColor:color(0x999999)];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.usernameText) {
        [self.passwordText becomeFirstResponder];
    }else if(textField == self.passwordText){
        [self.passwordText resignFirstResponder];
    }
    return YES;
}
-(void)leftButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightClick
{
//    static NSString * isDoubleShould = nil;
//    if (isDoubleShould!=nil) {
//        return;
//    }else{
//        isDoubleShould = @"YES";
//        [LITimerLoop loopWithTimeInterval:0.3 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
//            isDoubleShould = nil;
//            return NO;
//        }];
//    }
    Register_ViewController * regis =[[Register_ViewController alloc] initWithNibName:@"Register_ViewController" bundle:nil];
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [array replaceObjectAtIndex:array.count-1 withObject:regis];
    self.navigationController.viewControllers=array;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:@"登录"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录"];
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
///登录
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
    [self.usernameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self performSelector:@selector(startLogin) withObject:nil afterDelay:0.5];
}
- (void)startLogin{
    if (isNotEmptyString(self.usernameText.text)&&isNotEmptyString(self.passwordText.text)) {
        if (isValidateEmail(self.usernameText.text)) {
            if (self.passwordText.text.length>=8) {
                [AppNetWork networkLoginUserName:self.usernameText.text pwd:self.passwordText.text finish:^(BOOL finish) {
                    if (finish==YES) {
                        [((AppDelegate *)[UIApplication sharedApplication].delegate) tabMainViewConrtollerType:RootViewControllerTypeTabBar];
                    }
                }];
            }else{
                [LIAlertView alertViewWithTitle:@"密码必须大于等于8位" delegate:nil];
            }
        }else{
            [LIAlertView alertViewWithTitle:@"邮箱格式不正确" delegate:nil];
        }
    }else{
        [LIAlertView alertViewWithTitle:@"请完整填入信息" delegate:nil];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
  
}
///找回密码
- (IBAction)ForgetClick:(id)sender {
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
    FindPassword_ViewController * VC = [[FindPassword_ViewController alloc] initWithNibName:@"FindPassword_ViewController" bundle:nil];
    [self.navigationController pushViewController:VC animated:YES];
}
@end
