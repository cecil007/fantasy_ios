//
//  UpdataPasswordViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "UpdataPasswordViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface UpdataPasswordViewController ()<UITextFieldDelegate>

@end

@implementation UpdataPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    [self creatBackItem];
    self.title = @"修改密码";
    [self rightTitle:@"保存"];
    self.view.backgroundColor = color(0xeeeeee);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textFiled3 resignFirstResponder];
    [self.textFiled2 resignFirstResponder];
    [self.textFiled1 resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.textFiled1) {
        [self.textFiled2 becomeFirstResponder];
    }else if(textField == self.textFiled2){
        [self.textFiled3 becomeFirstResponder];
    }else{
        [self.textFiled3 resignFirstResponder];
    }
    return YES;
}
-(void)rightClick{
    
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
    
    [self.textFiled3 resignFirstResponder];
    [self.textFiled2 resignFirstResponder];
    [self.textFiled1 resignFirstResponder];
    if (isNotEmptyString(self.textFiled1.text)&&isNotEmptyString(self.textFiled2.text)&&isNotEmptyString(self.textFiled3.text)) {
        //        __weak UpdataUsernameViewController * weakself = self;
        if ([self.textFiled2.text isEqual:self.textFiled3.text]) {
            if (self.textFiled2.text.length>=8) {
                NSDictionary * paramDic = [NSUserDefaults userDefaultObjectWithKeys:@"八度幻想",@"user",@"token",@"authorization",nil];
                if ([paramDic[@"pwd"] isEqual:self.textFiled1.text]) {
                    [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
                    [self performSelector:@selector(updataInfo) withObject:nil afterDelay:0.5];
                }else{
                    [LIAlertView alertViewWithTitle:@"原密码不正确" delegate:nil];
                }
            }else{
                [LIAlertView alertViewWithTitle:@"密码必须大于等于8位" delegate:nil];
            }
        }else{
            [LIAlertView alertViewWithTitle:@"二次密码不相同" delegate:nil];
        }
    }
}
- (void)updataInfo{
    NSDictionary * paramDic = [NSUserDefaults userDefaultObjectWithKeys:@"八度幻想",@"user",@"token",@"authorization",nil];
    __weak UpdataPasswordViewController * weakself = self;
    [AppNetWork networkUpdataUserInfoUserName:nil email:nil pwd:self.textFiled2.text finish:^(BOOL finish) {
        [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        if (finish==YES) {
            NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithDictionary:paramDic];
            [param setValue:weakself.textFiled2.text forKey:@"pwd"];
            [NSUserDefaults userDefaultObject:param keys:@"八度幻想",@"user",@"token",@"authorization",nil];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改密码"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改密码"];
}
@end
