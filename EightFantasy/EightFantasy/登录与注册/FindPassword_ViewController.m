//
//  FindPassword_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/16.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "FindPassword_ViewController.h"
#import "LoginViewController.h"

@interface FindPassword_ViewController ()

@end

@implementation FindPassword_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self creatBackItem];
    self.EmailLab.hidden = YES;
    
    [self.InputBtn setRadius:4.0 borderWidth:1.0 borderColor:[UIColor clearColor]];
    [self.EmailView setRadius:4.0 borderWidth:1.0 borderColor:color(0x999999)];
    // Do any additional setup after loading the view from its nib.
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.emailText resignFirstResponder];
}

- (IBAction)InputClick:(id)sender {
    
    [self.emailText resignFirstResponder];
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
    NSLog(@"finish");
    [AppNetWork networkResetPasswordEmail:self.emailText.text finish:^(BOOL finish) {
        if(finish)
        {
            self.EmailView.hidden = YES;
            self.InputBtn.hidden = YES;
            
             self.EmailLab.hidden = NO;
            self.EmailLab.text =[NSString stringWithFormat:@"找回密码邮件已发送至邮箱\n%@\n请去邮箱验证!",self.emailText.text];
//            LoginViewController * login =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//            [self.navigationController pushViewController:login animated:YES];
        }
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"找回密码"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"找回密码"];
}
@end
