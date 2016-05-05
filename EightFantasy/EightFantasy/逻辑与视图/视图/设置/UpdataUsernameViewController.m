//
//  UpdataUsernameViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "UpdataUsernameViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface UpdataUsernameViewController ()<UITextFieldDelegate>

@end

@implementation UpdataUsernameViewController{
    NSString * usernameField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatBackItem];
    self.title = @"修改昵称";
    [self rightTitle:@"保存"];
    self.view.backgroundColor = color(0xeeeeee);
}
- (void)edit:(NSString *)username block:(void(^)(NSString * name))block{
   usernameField = username;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.myTextFiled resignFirstResponder];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.myTextFiled.text = usernameField;
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
    
    [self.myTextFiled resignFirstResponder];
    if (isNotEmptyString(self.myTextFiled.text)) {
        
        if(isValidateCharacters( LIEffectiveCharacterSetTypeAlphabet|
                                LIEffectiveCharacterSetTypeChinese|
                                LIEffectiveCharacterSetTypeDigital|
                                LIEffectiveCharacterSetTypeUnderline,self.myTextFiled.text))
        {
//        __weak UpdataUsernameViewController * weakself = self;
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        [self performSelector:@selector(updataInfo) withObject:nil afterDelay:0.5];
        }else
        {
            [OMGToast showWithText:@"昵称格式不正确"];
        }
    }
}
- (void)updataInfo{
    NSDictionary * paramDic = [NSUserDefaults userDefaultObjectWithKeys:@"八度幻想",@"user",@"token",@"authorization",nil];
    __weak UpdataUsernameViewController * weakself = self;
    [AppNetWork networkUpdataUserInfoUserName:self.myTextFiled.text email:nil pwd:nil finish:^(BOOL finish) {
        [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        NSMutableDictionary * param = [[NSMutableDictionary alloc] initWithDictionary:paramDic];
        if (finish==YES) {
            [param setValue:weakself.myTextFiled.text forKey:@"userName"];
            [NSUserDefaults userDefaultObject:param keys:@"八度幻想",@"user",@"token",@"authorization",nil];
            [weakself.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"修改昵称"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改昵称"];
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
