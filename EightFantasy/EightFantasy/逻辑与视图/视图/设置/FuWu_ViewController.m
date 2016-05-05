//
//  FuWu_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "FuWu_ViewController.h"

@interface FuWu_ViewController ()
{
    UIWebView * webview;
}
@end

@implementation FuWu_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"软件许可及服务协议";
    [self creatBackItem];
     webview = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,LI_SCREEN_WIDTH, LI_SCREEN_HEIGHT)];
    
    [self.view addSubview:webview];
    
    
    [AppNetWork networkUrl:^(NSDictionary *info, NSError *error) {
        
        if(info)
        {
            NSString * data = info[@"software_lincense"];
            NSString *dataUTF8 = [data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataUTF8]]];
        }
        
    }];
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"软件许可及服务协议"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"软件许可及服务协议"];
}
@end
