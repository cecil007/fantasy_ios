//
//  UpdataEmailViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "UpdataEmailViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface UpdataEmailViewController ()<UITextFieldDelegate>

@end

@implementation UpdataEmailViewController{
    NSString * _MemailField;
}
- (void)edit:(NSString *)email block:(void(^)(NSString * name))block{
    _MemailField = FORMAT(@"当前邮箱为%@",email);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatBackItem];
    self.title = @"修改邮箱";
    [self rightTitle:@"保存"];
    self.view.backgroundColor = color(0xeeeeee);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self.textFeild resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
    
    [self.textFeild resignFirstResponder];
    if (isNotEmptyString(self.textFeild.text)) {
        //        __weak UpdataUsernameViewController * weakself = self;
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        [self performSelector:@selector(updataInfo) withObject:nil afterDelay:0.5];
    }
}
- (void)updataInfo{
    __weak UpdataEmailViewController * weakself = self;
    [AppNetWork networkUpdataUserInfoUserName:nil email:self.textFeild.text pwd:nil finish:^(BOOL finish) {
        [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        if (finish==YES) {
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.emailField.text = _MemailField;
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改邮箱"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改邮箱"];
}
@end
