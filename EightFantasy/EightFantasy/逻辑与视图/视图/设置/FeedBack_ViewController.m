//
//  FeedBack_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "FeedBack_ViewController.h"

@interface FeedBack_ViewController ()<UITextViewDelegate>
{
    //输入框
    UITextView* helpTextView;
    
    UILabel* helpLabel;
    
}
@end

@implementation FeedBack_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = color(0xe7e7e7);
    
    self.title = @"意见反馈";
    
    [self creatBackItem];
    
    [self rightTitle:@"发送"];
    
    [self loadAllControls];
    
   
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 所有的代理
#pragma mark textView 的代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location==0&&[text isEqualToString:@""]&&range.length<=1) {
        helpLabel.hidden=NO;
    }else{
        helpLabel.hidden=YES;
    }
    
    if (range.location>99&&range.length==0) {
        return NO;
    }else{
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] > 0)
    {
        helpLabel.hidden=YES;
    }
    else
    {
        helpLabel.hidden=NO;
    }
}


#pragma mark  settter 和 getter
//加载控件
-(void) loadAllControls
{
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.automaticallyAdjustsScrollViewInsets = NO; // Avoid the top UITextView space, iOS7 (~bug?)
    }
    
    helpTextView=[[UITextView alloc]initWithFrame:CGRectMake(15, 13 + 64, LI_SCREEN_WIDTH - 30, 137)];
    helpTextView.textAlignment = NSTextAlignmentLeft;
    [helpTextView.layer setMasksToBounds:YES];
    [helpTextView.layer setCornerRadius:5];
    [helpTextView setFont:[UIFont systemFontOfSize:15]];
    helpTextView.layer.borderColor=[color(0x999999) CGColor];
    helpTextView.layer.borderWidth=0.5f;
    helpTextView.delegate=self;
    helpTextView.textColor = color(0x999999);
    
    
    helpLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 8.5, helpTextView.bounds.size.width-10, 13)];
    [helpLabel setBackgroundColor:[UIColor clearColor]];
    [helpLabel setText:@"感谢反馈,写下您的意见..."];
    [helpLabel setTextColor:color(0x999999)];
    [helpLabel setFont:[UIFont systemFontOfSize:15]];
    
    [helpTextView addSubview:helpLabel];
    
    
    [self.view addSubview:helpTextView];
 
}
-(void)rightClick
{
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
    __weak FeedBack_ViewController * weakself = self;
    [helpTextView resignFirstResponder];
    if (helpTextView.text.length>100) {
        [LIAlertView alertViewWithTitle:@"请您稍微精简下" delegate:nil];
    }
    else if(helpTextView.text.length==0)
    {
        [LIAlertView alertViewWithTitle:@"无法提交,请您输入反馈意见" delegate:nil];
        
    }
    else
    {
                //意见反馈接口
        [AppNetWork networkFeedbackContent:helpLabel.text finish:^(BOOL finish) {
            if (finish) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        }];
    }

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [helpTextView resignFirstResponder];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context
{
    UITextView *tv = object;
    // Center vertical alignment
    //    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    //    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    //    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
    // // Bottom vertical alignment
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height);
    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
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
    [MobClick beginLogPageView:@"意见反馈"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"意见反馈"];
}
@end
