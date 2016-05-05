//
//  Register_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/13.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "Register_ViewController.h"
#import "LIKeyboard.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "FuWu_ViewController.h"
#import "LoginViewController.h"

@interface Register_ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField * fromTextfield;
@end

@implementation Register_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    if (self.navigationController.viewControllers.count>1) {
        [self creatBackItem];
    }
    [self rightTitle:@"登录"];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.RegisterBtn setRadius:4.0 borderWidth:1.0 borderColor:[UIColor clearColor]];
    [self.EmailView setRadius:4.0 borderWidth:1.0 borderColor:color(0x999999)];
    [self.NameView setRadius:4.0 borderWidth:1.0 borderColor:color(0x999999)];
    [self.PasswordView1 setRadius:4.0 borderWidth:1.0 borderColor:color(0x999999)];
    [self.PasswordView2 setRadius:4.0 borderWidth:1.0 borderColor:color(0x999999)];

    // Do any additional setup after loading the view from its nib.
}
-(void)leftButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.fromTextfield = textField;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.inputEmailText) {
        [self.inputNickNameText becomeFirstResponder];
    }else if(textField == self.inputNickNameText){
        [self.inputPassword1Text becomeFirstResponder];
    }else if(textField == self.inputPassword1Text){
        [self.inputPassword2Text becomeFirstResponder];
    }else{
        [self.inputPassword2Text resignFirstResponder];
    }
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    __weak Register_ViewController * weakself = self;
    [LIKeyboard keyboard:self frame:^(BOOL isOpen, CGRect frame, NSObject *object) {
        float height;
        if (isOpen==YES) {
            height = frame.size.height;
        }else{
            height = 0;
        }
        BOOL isChange = NO;
        if([weakself.fromTextfield superview].frame.origin.y+[weakself.fromTextfield superview].frame.size.height+80>LI_SCREEN_HEIGHT-height){
            float top = -([weakself.fromTextfield superview].frame.origin.y+[weakself.fromTextfield superview].frame.size.height+80-(LI_SCREEN_HEIGHT-height));
            if (weakself.top_view.constant!=top) {
                weakself.top_view.constant = top;
                isChange = YES;
            }
        }else{
            if (weakself.top_view.constant!=0.0) {
                weakself.top_view.constant = 0.0;
                isChange = YES;
            }
        }
        if (isChange == YES) {
            [weakself.view layoutIfNeeded];
        }
    }];
    [MobClick beginLogPageView:@"注册"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [LIKeyboard keyboardStopBlockObject:self];
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
///开始注册
- (IBAction)RegisterBtn:(id)sender {
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:0.3 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    
    [self.inputNickNameText resignFirstResponder];
    [self.inputEmailText resignFirstResponder];
    [self.inputPassword1Text resignFirstResponder];
    [self.inputPassword2Text resignFirstResponder];
     [self performSelector:@selector(startRegister) withObject:nil afterDelay:0.5];
}
- (void)startRegister{
    __weak Register_ViewController * weakself = self;
    if (isNotEmptyString(self.inputEmailText.text)&&isNotEmptyString(self.inputNickNameText.text)&&isNotEmptyString(self.inputPassword1Text.text)&&isNotEmptyString(self.inputPassword2Text.text)) {
        if (isValidateCharacters(LIEffectiveCharacterSetTypeAlphabet|LIEffectiveCharacterSetTypeChinese|LIEffectiveCharacterSetTypeDigital|LIEffectiveCharacterSetTypeUnderline, self.inputNickNameText.text)) {
            if (isValidateEmail(self.inputEmailText.text)) {
                if ([self.inputPassword1Text.text isEqual:self.inputPassword2Text.text]) {
                    if (self.inputPassword1Text.text.length>=8) {
                    [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
                    [AppNetWork networkRegisterCheckUserName:nil email:weakself.inputEmailText.text type:AccountTypeEmail finish:^(BOOL finish) {
                        if (finish==YES) {
                                [AppNetWork networkRegisterCheckUserName:self.inputNickNameText.text email:nil type:AccountTypeUserName finish:^(BOOL finish2) {
                                if (finish2==YES) {
                                    [AppNetWork networkRegisterUserName:self.inputNickNameText.text email:self.inputEmailText.text pwd:self.inputPassword1Text.text finish:^(BOOL finish3) {
                                        if (finish3==YES) {
                                            [weakself startLoginUsername:self.inputEmailText.text password:self.inputPassword1Text.text];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                    }else{
                         [LIAlertView alertViewWithTitle:@"密码必须大于等于8位" delegate:nil];
                    }
                }else{
                    [LIAlertView alertViewWithTitle:@"两次密码不相同" delegate:nil];
                }
            }else{
                [LIAlertView alertViewWithTitle:@"无效的邮箱" delegate:nil];
            }
        }else{
            [LIAlertView alertViewWithTitle:@"昵称只能使用汉字、字母、数字、下划线" delegate:nil];
        }
    }else{
        [LIAlertView alertViewWithTitle:@"请完整填入信息" delegate:nil];
    }
}

- (void)startLoginUsername:(NSString *)username password:(NSString *)pwd{
    if (isNotEmptyString(username)&&isNotEmptyString(pwd)) {
        if (isValidateEmail(username)) {
            [AppNetWork networkLoginUserName:username pwd:pwd finish:^(BOOL finish) {
                if (finish==YES) {
                    [((AppDelegate *)[UIApplication sharedApplication].delegate) tabMainViewConrtollerType:RootViewControllerTypeTabBar];
                }
            }];
        }else{
            [LIAlertView alertViewWithTitle:@"邮箱格式不正确" delegate:nil];
        }
    }else{
        [LIAlertView alertViewWithTitle:@"请完整填入信息" delegate:nil];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputNickNameText resignFirstResponder];
    [self.inputEmailText resignFirstResponder];
    [self.inputPassword1Text resignFirstResponder];
    [self.inputPassword2Text resignFirstResponder];
}
///用户协议
- (IBAction)XieYiBtn:(id)sender {
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
    
    FuWu_ViewController * vc = [[FuWu_ViewController alloc] initWithNibName:@"FuWu_ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:nil];
}
///登录
- (void)rightClick{
//    static NSString * isDoubleShould = nil;
//    if (isDoubleShould!=nil) {
//        return;
//    }else{
//        isDoubleShould = @"YES";
//        [LITimerLoop loopWithTimeInterval:2 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
//            isDoubleShould = nil;
//            return NO;
//        }];
//    }
    
    LoginViewController * login =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [array replaceObjectAtIndex:array.count-1 withObject:login];
    self.navigationController.viewControllers=array;;
}

@end
