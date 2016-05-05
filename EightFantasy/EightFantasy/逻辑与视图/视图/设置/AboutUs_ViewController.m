//
//  AboutUs_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "AboutUs_ViewController.h"
#import "FuWu_ViewController.h"

@interface AboutUs_ViewController ()

@end

@implementation AboutUs_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于八度幻想";
    [self creatBackItem];
    LIRichTextString * rich = [LIRichTextString string:@"梦境中有个更真实的你\n你的愿望，你的担心\n你的邪恶，你的天真\n在这里保存它\n某一天重现它"];
    [rich addItemRangeValues:@[[NSValue valueWithRange:NSMakeRange(0, rich.sourceString.length)]] style:^(LIRichTextAttributedItem *item) {
        [item addAttribute:NSForegroundColorAttributeName value:color(0x333333)];
        if (LI_SCREEN_HEIGHT<=480.0) {
            [item addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0]];
        }else
            [item addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [item addAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
    }];
    [rich editFinish];
    LIRichTextString * rich2 = [LIRichTextString string:@"纷纷扰扰的世界中\n我们只想做些直指人心的事\n真实的\n不虚伪的\n不矫作的\n以及\n不必小心的"];
    [rich2 addItemRangeValues:@[[NSValue valueWithRange:NSMakeRange(0, rich2.sourceString.length)]] style:^(LIRichTextAttributedItem *item) {
        [item addAttribute:NSForegroundColorAttributeName value:color(0x333333)];
        if (LI_SCREEN_HEIGHT<=480.0) {
            [item addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0]];
        }else
            [item addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [item addAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
    }];
    [rich2 editFinish];
    [self.messageLabel1 setRichTextdString:rich];
    [self.messageLabel2 setRichTextdString:rich2];
    if (LI_SCREEN_HEIGHT<=480.0) {
        self.label1_layout_top.constant = 5;
        self.label2_layout_top.constant = 10;
    }
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

- (IBAction)FuWuClick:(id)sender {
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"关于八度幻想"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"关于八度幻想"];
}
@end
